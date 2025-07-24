package test;

import dal.CareCartDAO;

public class UpdateCartStatusExample {
    public static void main(String[] args) {
        CareCartDAO dao = new CareCartDAO();

        // 📝 Nhập giá trị bạn muốn test
        int cartId = 11; // ID của đơn trong CareCart bạn muốn cập nhật
        String newStatus = "completed"; // Có thể là: pending, approved, rejected, in_progress, completed

        try {
            boolean updated = dao.updateCartStatus(cartId, newStatus);
            if (updated) {
                System.out.println("✅ Trạng thái đơn #" + cartId + " đã được cập nhật thành: " + newStatus);
            } else {
                System.out.println("❌ Không thể cập nhật đơn #" + cartId + ". Kiểm tra lại cartId hoặc lỗi DB.");
            }
        } catch (Exception e) {
            System.err.println("💥 Lỗi khi cập nhật trạng thái: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
