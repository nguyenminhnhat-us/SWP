

import dal.CareCartDAO;
import model.CareCart;

import java.util.List;

public class TestCareCartDAO {

    public static void main(String[] args) {
        try {
            CareCartDAO dao = new CareCartDAO();

            int expertId = 4; // Thay b?ng expertId b?n mu?n test

            System.out.println("? L?y danh s?ch ??n ???c giao cho expert_id = " + expertId);
            List<CareCart> carts = dao.getCartsByExpertId(expertId);

            if (carts == null || carts.isEmpty()) {
                System.out.println("?? Kh?ng c? ??n n?o ???c ph?n cho chuy?n gia n?y.");
            } else {
                System.out.println("? S? ??n t?m ???c: " + carts.size());
                for (CareCart cart : carts) {
                    System.out.println("----------------------------------");
                    System.out.println("? ??n ID: " + cart.getCartId());
                    System.out.println("? T?n c?y: " + cart.getPlantName());
                    System.out.println("? Ng?y h?n: " + cart.getDropOffDate());
                    System.out.println("? Gi?: " + cart.getAppointmentTime());
                    System.out.println("? ??a ch?: " + cart.getHomeAddress());
                    System.out.println("? Ghi ch?: " + cart.getNotes());
                    System.out.println("? Gi?: " + cart.getTotalPrice());
                    System.out.println("? Tr?ng th?i: " + cart.getStatus());
                }
            }

        } catch (Exception e) {
            System.out.println("? L?i khi l?y ??n: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
