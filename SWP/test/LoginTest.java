

import model.User;
import dal.UserDAO;

public class LoginTest {
    public static void main(String[] args) {
        String email = "admin@plant.com";       // ? Thay b?ng email mu?n test
        String password = "admin123";           // ? Thay b?ng m?t kh?u

        UserDAO userDAO = new UserDAO();
        User user = userDAO.checkLogin(email, password);

        if (user != null) {
            System.out.println("? Ðãng nh?p thành công!");
            System.out.println("Tên ngý?i dùng: " + user.getFullName());
            System.out.println("Vai tr?: " + user.getRole());
            System.out.println("Auth type: " + user.getAuthType());
            System.out.println("Active: " + user.isActive());
        } else {
            System.out.println("? Ðãng nh?p th?t b?i. Ki?m tra l?i email/m?t kh?u, ho?c user b? khóa.");
        }
    }
}
