package controller;

import config.VNPAYCareConfig; // ✅ Đổi sang config riêng cho dịch vụ chăm sóc
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "AjaxCarePaymentServlet", urlPatterns = {"/ajax-care-payment"})
public class AjaxCarePaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String amountParam = req.getParameter("amount");
            String cartId = req.getParameter("cartId");

            if (amountParam == null || amountParam.isEmpty() || cartId == null || cartId.isEmpty()) {
                req.getSession().setAttribute("message", "❌ Thiếu thông tin thanh toán.");
                resp.sendRedirect(req.getContextPath() + "/care-cart");
                return;
            }

            long amount = (long) (Double.parseDouble(amountParam) * 100); // VNPAY yêu cầu x100
            String txnRef = VNPAYCareConfig.getRandomNumber(8); // ✅ Dùng VNPAYCareConfig
            String ipAddr = VNPAYCareConfig.getIpAddress(req);

            // ✅ Dùng returnUrl riêng cho đơn chăm sóc
            String returnUrl = VNPAYCareConfig.vnp_ReturnUrl + "&cartId=" + URLEncoder.encode(cartId, StandardCharsets.UTF_8);

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", "2.1.0");
            vnp_Params.put("vnp_Command", "pay");
            vnp_Params.put("vnp_TmnCode", VNPAYCareConfig.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", txnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toán đơn chăm sóc cây #" + cartId);
            vnp_Params.put("vnp_OrderType", "other");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", returnUrl);
            vnp_Params.put("vnp_IpAddr", ipAddr);

            // Ngày tạo & hết hạn
            Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            vnp_Params.put("vnp_CreateDate", formatter.format(cal.getTime()));
            cal.add(Calendar.MINUTE, 15);
            vnp_Params.put("vnp_ExpireDate", formatter.format(cal.getTime()));

            // Sắp xếp tham số
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            for (int i = 0; i < fieldNames.size(); i++) {
                String name = fieldNames.get(i);
                String value = vnp_Params.get(name);
                hashData.append(name).append("=").append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                query.append(URLEncoder.encode(name, StandardCharsets.US_ASCII))
                        .append("=")
                        .append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                if (i < fieldNames.size() - 1) {
                    hashData.append("&");
                    query.append("&");
                }
            }

            String secureHash = VNPAYCareConfig.hmacSHA512(VNPAYCareConfig.secretKey, hashData.toString());
            query.append("&vnp_SecureHash=").append(secureHash);

            String paymentUrl = VNPAYCareConfig.vnp_PayUrl + "?" + query.toString();

            // Lưu session nếu cần
            HttpSession session = req.getSession();
            session.setAttribute("vnp_TxnRef", txnRef);
            session.setAttribute("checkoutCartId", cartId);

            resp.sendRedirect(paymentUrl);

        } catch (Exception e) {
            req.getSession().setAttribute("message", "❌ Lỗi xử lý thanh toán: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/care-cart");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
}
