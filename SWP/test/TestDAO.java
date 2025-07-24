

import dal.CareCartDAO;
import model.CareCart;

import java.sql.SQLException;
import java.util.List;

public class TestDAO {
    public static void main(String[] args) throws Exception {
        CareCartDAO dao = new CareCartDAO();
        List<CareCart> carts = dao.getCartsByExpertId(4);
        for (CareCart c : carts) {
            System.out.println("🟢 Đơn: " + c.getCartId() + " - " + c.getPlantName());
        }
    }
}
