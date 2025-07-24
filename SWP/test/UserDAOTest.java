
import dal.UserDAO;
import java.util.List;
import model.User;

public class UserDAOTest {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        int offset = 0;
        int limit = 10;
        String searchKeyword = "";
        String roleFilter = "";
        String statusFilter = "";

        List<User> users = dao.getUsersWithPagination(offset, limit, searchKeyword, roleFilter, statusFilter);
        System.out.println(">>> Total users fetched: " + users.size());
        for (User u : users) {
            System.out.println(u.getUserId() + " | " + u.getFullName() + " | " + u.getEmail() + " | " + u.getRole());
        }

        int total = dao.getTotalUsersCount(searchKeyword, roleFilter, statusFilter);
        System.out.println(">>> Total users count: " + total);
    }
}
