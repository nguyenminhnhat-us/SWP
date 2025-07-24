
import dal.CareCartDAO;
import java.util.List;
import model.CareCart;

public class TestGetCareCarts {
    public static void main(String[] args) throws Exception {
        CareCartDAO dao = new CareCartDAO();
        List<CareCart> carts = dao.getCartsByExpertId(4);
        System.out.println("? S? ��n: " + carts.size());
        for (CareCart c : carts) {
            System.out.println("? " + c.getCartId() + ": " + c.getPlantName());
        }
    }
}
