

import dal.UserDAO;
import model.User;

import java.util.List;

public class TestUserPagination {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();

        // Th? nghi?m: không truy?n filter, l?y page 1 (offset = 0), limit 10
        int offset = 0;
        int limit = 10;
        String search = "";
        String roleFilter = "";     // th? v?i null c?ng ðý?c
        String statusFilter = "";   // th? v?i null c?ng ðý?c

        List<User> users = dao.getUsersWithPagination(offset, limit, search, roleFilter, statusFilter);

        System.out.println("? T?ng s? user l?y ðý?c: " + users.size());
        for (User user : users) {
            System.out.println("ID: " + user.getUserId() +
                               ", Name: " + user.getFullName() +
                               ", Email: " + user.getEmail() +
                               ", Role: " + user.getRole() +
                               ", Active: " + user.isActive());
        }
    }
}
