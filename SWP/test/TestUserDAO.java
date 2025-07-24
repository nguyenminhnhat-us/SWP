package test;

import dal.UserDAO;
import model.User;

import java.util.List;

public class TestUserDAO {
    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();

        // Test lấy danh sách user không filter, phân trang 0 - 10
        List<User> users = userDAO.getUsersWithPagination(0, 10, "", "", "");

        System.out.println("Số user lấy được: " + users.size());
        for (User u : users) {
            System.out.println("ID: " + u.getUserId() + ", Email: " + u.getEmail() + ", Tên: " + u.getFullName());
        }
    }
}
