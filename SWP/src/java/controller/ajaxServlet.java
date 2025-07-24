package controller;

import config.GlobalConfig;
import config.VNPAYConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import jakarta.servlet.annotation.WebServlet;


/**
 *
 * @author CTT VNPAY
 */
@WebServlet(name = "ajaxServlet", urlPatterns = {"/ajaxServlet"})
public class ajaxServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    
    

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        
        try {
            // Check if amount parameter exists
            String amountParam = req.getParameter("amount");
            if (amountParam == null || amountParam.isEmpty()) {
                // Redirect back to cart with error message
                req.getSession().setAttribute("message", "Payment failed: Missing amount parameter");
                req.getSession().setAttribute("messageType", "error");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }
            
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";
            long amount = (long)(Double.parseDouble(amountParam) * 100);
            String bankCode = req.getParameter("bankCode");
            
            String vnp_TxnRef = VNPAYConfig.getRandomNumber(8);
            String vnp_IpAddr = VNPAYConfig.getIpAddress(req);

            String vnp_TmnCode = VNPAYConfig.vnp_TmnCode;
            
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            
            if (bankCode != null && !bankCode.isEmpty()) {
                vnp_Params.put("vnp_BankCode", bankCode);
            }
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + vnp_TxnRef);
            vnp_Params.put("vnp_OrderType", orderType);

            String locate = req.getParameter("language");
            if (locate != null && !locate.isEmpty()) {
                vnp_Params.put("vnp_Locale", locate);
            } else {
                vnp_Params.put("vnp_Locale", "vn");
            }
            vnp_Params.put("vnp_ReturnUrl", VNPAYConfig.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
            
            List fieldNames = new ArrayList(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = (String) vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    //Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    //Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            String queryUrl = query.toString();
            String vnp_SecureHash = VNPAYConfig.hmacSHA512(VNPAYConfig.secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = VNPAYConfig.vnp_PayUrl + "?" + queryUrl;
            
            // Store transaction information in session for verification later
            req.getSession().setAttribute("vnp_TxnRef", vnp_TxnRef);
            req.getSession().setAttribute("vnp_Amount", String.valueOf(amount));
            
            // Redirect to VNPAY payment gateway
            resp.sendRedirect(paymentUrl);
            
        } catch (NumberFormatException e) {
            // Handle number format exception (invalid amount)
            req.getSession().setAttribute("message", "Payment failed: Invalid amount format");
            req.getSession().setAttribute("messageType", "error");
            resp.sendRedirect(req.getContextPath() + "/cart");
        } catch (Exception e) {
            // Handle other exceptions
            req.getSession().setAttribute("message", "Payment failed: " + e.getMessage());
            req.getSession().setAttribute("messageType", "error");
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

}