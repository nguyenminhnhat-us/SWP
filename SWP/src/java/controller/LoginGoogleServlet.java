package controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.http.HttpSession;
import model.User;
import dal.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

@WebServlet("/login-google")
public class LoginGoogleServlet extends HttpServlet {

    private static final String CLIENT_ID = "877308457870-12adf40qri6e508nsue8s9ipe5ntmhr4.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/SWPcu/login-google"; // Cập nhật context path

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        System.out.println("Received code: " + code);

        if (code == null || code.isEmpty()) {
            System.out.println("No code received, redirecting to login.jsp");
            response.sendRedirect("login.jsp?error=google_fail");
            return;
        }

        try {
            // B1: Đổi code lấy access token
            String tokenEndpoint = "https://oauth2.googleapis.com/token";
            String params = "code=" + URLEncoder.encode(code, "UTF-8")
                    + "&client_id=" + URLEncoder.encode(CLIENT_ID, "UTF-8")
                    + "&client_secret=" + URLEncoder.encode(CLIENT_SECRET, "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                    + "&grant_type=authorization_code";

            HttpURLConnection conn = (HttpURLConnection) new URL(tokenEndpoint).openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes());
            }

            StringBuilder responseStr = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    responseStr.append(line);
                }
            }
            System.out.println("Token response: " + responseStr.toString());

            JsonObject jsonToken = JsonParser.parseString(responseStr.toString()).getAsJsonObject();
            if (jsonToken.has("error")) {
                System.err.println("Google OAuth error: " + jsonToken.get("error_description").getAsString());
                response.sendRedirect("login.jsp?error=oauth2");
                return;
            }
            String accessToken = jsonToken.get("access_token").getAsString();
            System.out.println("Access token retrieved: " + accessToken);

            // B2: Lấy thông tin người dùng
            HttpURLConnection userConn = (HttpURLConnection) new URL(
                    "https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken).openConnection();
            userConn.setRequestMethod("GET");

            StringBuilder userInfoStr = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(userConn.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    userInfoStr.append(line);
                }
            }
            System.out.println("User info response: " + userInfoStr.toString());

            JsonObject userJson = JsonParser.parseString(userInfoStr.toString()).getAsJsonObject();
            String email = userJson.get("email").getAsString();
            String name = userJson.get("name").getAsString();
            String avatar = userJson.get("picture").getAsString();
            System.out.println("User data - Email: " + email + ", Name: " + name + ", Avatar: " + avatar);

            // B3: Kiểm tra người dùng trong DB với auth_type = 'google'
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByEmailAndAuthType(email, "google");
            System.out.println("Existing user found: " + (user != null ? user.getUserId() : "null"));

            if (user == null) {
                // Nếu chưa có thì thêm vào DB với auth_type = 'google'
                User newUser = new User();
                newUser.setEmail(email);
                newUser.setPassword(""); // Không cần mật khẩu cho Google
                newUser.setFullName(name);
                newUser.setPhone("");
                newUser.setAddress("");
                newUser.setRole("customer"); // Mặc định là customer
                newUser.setIsActive(true);
                newUser.setAvatarPath(avatar);
                newUser.setAuthType("google"); // Đặt auth_type là 'google'
                userDAO.insertUser(newUser);
                user = userDAO.getUserByEmailAndAuthType(email, "google"); // Lấy lại user sau khi thêm
                System.out.println("New user inserted with ID: " + (user != null ? user.getUserId() : "failed"));
            }

            // B4: Đăng nhập thành công -> tạo session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            System.out.println("Session created for user ID: " + user.getUserId());

            response.sendRedirect("user.jsp");

        } catch (Exception e) {
            System.err.println("OAuth2 Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=oauth2");
        }
    }
}
