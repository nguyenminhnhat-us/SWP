

import model.User;
import dal.UserDAO;

public class LoginTest {
    public static void main(String[] args) {
        String email = "user2@plant.com";       // ? Thay b?ng email mu?n test
        String password = "user456";           // ? Thay b?ng m?t kh?u

        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkLogin(email, password);

        if (user != null) {
            System.out.println("? ��ng nh?p th�nh c�ng!");
            System.out.println("T�n ng�?i d�ng: " + user.getFullName());
            System.out.println("Vai tr?: " + user.getRole());
            System.out.println("Auth type: " + user.getAuthType());
            System.out.println("Active: " + user.isActive());
        } else {
            System.out.println("? ��ng nh?p th?t b?i. Ki?m tra l?i email/m?t kh?u, ho?c user b? kh�a.");
        }
    }
}
