package controller.dashboard;

import dal.PlantDAO;
import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Plant;
import model.Category;
import model.User;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

@WebServlet("/dashboard/manage-plants")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ManagePlantController extends HttpServlet {
    private PlantDAO plantDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        plantDAO = new PlantDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            listPlants(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách cây cảnh: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/admin/manage-plant.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra quyền admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addPlant(request, response);
                    break;
                case "update":
                    updatePlant(request, response);
                    break;
                case "delete":
                    deletePlant(request, response);
                    break;
                default:
                    listPlants(request, response);
                    break;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi xử lý: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
        }
    }

    private void listPlants(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException, ServletException, IOException {
        
        // Lấy các tham số filter từ request
        String searchKeyword = request.getParameter("search");
        String categoryIdParam = request.getParameter("category");
        String stockStatus = request.getParameter("stock");
        
        // Lấy danh sách danh mục cho dropdown
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        
        // Phân trang
        int page = 1;
        int pageSize = 10;
        
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Lấy danh sách cây cảnh với filter
        List<Plant> plants;
        int totalPlants;
        
        // Kiểm tra có filter hay không
        boolean hasFilter = (searchKeyword != null && !searchKeyword.trim().isEmpty()) ||
                           (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) ||
                           (stockStatus != null && !stockStatus.trim().isEmpty());
        
        if (hasFilter) {
            // Áp dụng filter
            Integer categoryId = null;
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdParam);
                } catch (NumberFormatException e) {
                    categoryId = null;
                }
            }
            
            plants = plantDAO.searchPlantsWithFilter(searchKeyword, categoryId, stockStatus, page, pageSize);
            totalPlants = plantDAO.getTotalFilteredPlantCount(searchKeyword, categoryId, stockStatus);
        } else {
            // Không có filter, lấy tất cả
            plants = plantDAO.getPagedPlants(page, pageSize);
            totalPlants = plantDAO.getTotalPlantCount();
        }
        
        int totalPages = (int) Math.ceil((double) totalPlants / pageSize);
        
        request.setAttribute("plants", plants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalPlants", totalPlants);
        request.setAttribute("plantsPerPage", pageSize);
        
        request.getRequestDispatcher("/dashboard/admin/manage-plant.jsp").forward(request, response);
    }
    
    private String saveUploadedFile(Part filePart, HttpServletRequest request) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            return null;
        }
        
        // Kiểm tra định dạng file
        String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        if (!fileExtension.matches("\\.(jpg|jpeg|png|gif|webp)$")) {
            throw new IOException("Chỉ chấp nhận file ảnh (jpg, jpeg, png, gif, webp)");
        }
        
        // Tạo tên file unique
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        
        // Đường dẫn lưu file
        String uploadPath = request.getServletContext().getRealPath("/") + "images" + File.separator + "plants";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Lưu file
        Path filePath = Paths.get(uploadPath, uniqueFileName);
        Files.copy(filePart.getInputStream(), filePath);
        
        // Trả về đường dẫn relative
        return "images/plants/" + uniqueFileName;
    }

    private void addPlant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException, IOException {
        HttpSession session = request.getSession();
        
        // Lấy thông tin từ form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String categoryIdStr = request.getParameter("categoryId");
        
        // Xử lý file upload
        String imageUrl = "images/default-plant.jpg"; // Default image
        try {
            Part imagePart = request.getPart("imageFile");
            String uploadedImageUrl = saveUploadedFile(imagePart, request);
            if (uploadedImageUrl != null) {
                imageUrl = uploadedImageUrl;
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi khi upload ảnh: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
            return;
        }
        
        // Kiểm tra các trường bắt buộc
        if (name == null || name.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            stockQuantityStr == null || stockQuantityStr.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
            return;
        }
        
        try {
            double price = Double.parseDouble(priceStr);
            int stockQuantity = Integer.parseInt(stockQuantityStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // Kiểm tra giá và số lượng hợp lệ
            if (price <= 0) {
                session.setAttribute("errorMessage", "Giá phải lớn hơn 0!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
                return;
            }
            
            if (stockQuantity < 0) {
                session.setAttribute("errorMessage", "Số lượng tồn kho không được âm!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
                return;
            }
            
            // Kiểm tra tên cây đã tồn tại
            if (plantDAO.isPlantNameExists(name.trim())) {
                session.setAttribute("errorMessage", "Tên cây đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
                return;
            }
            
            // Tạo đối tượng Plant mới
            Plant newPlant = new Plant();
            newPlant.setName(name.trim());
            newPlant.setDescription(description.trim());
            newPlant.setPrice(price);
            newPlant.setStockQuantity(stockQuantity);
            newPlant.setCategoryId(categoryId);
            newPlant.setImageUrl(imageUrl);
            
            // Thêm cây vào database
            if (plantDAO.addPlant(newPlant)) {
                session.setAttribute("successMessage", "Thêm cây cảnh thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể thêm cây cảnh. Vui lòng thử lại!");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Giá và số lượng phải là số hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi khi thêm cây cảnh: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
    }

    private void updatePlant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException, IOException {
        HttpSession session = request.getSession();
        
        // Lấy thông tin từ form
        String plantIdStr = request.getParameter("plantId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String categoryIdStr = request.getParameter("categoryId");
        
        // Lấy thông tin cây hiện tại để giữ lại ảnh cũ nếu không upload ảnh mới
        String imageUrl = "images/default-plant.jpg";
        try {
            int plantId = Integer.parseInt(plantIdStr);
            Plant existingPlant = plantDAO.getPlantById(plantId);
            if (existingPlant != null) {
                imageUrl = existingPlant.getImageUrl(); // Giữ ảnh cũ
            }
            
            // Xử lý file upload mới (nếu có)
            Part imagePart = request.getPart("imageFile");
            String uploadedImageUrl = saveUploadedFile(imagePart, request);
            if (uploadedImageUrl != null) {
                imageUrl = uploadedImageUrl;
                
                // Xóa ảnh cũ nếu không phải ảnh mặc định
                if (existingPlant != null && !existingPlant.getImageUrl().equals("images/default-plant.jpg")) {
                    try {
                        String oldImagePath = request.getServletContext().getRealPath("/") + existingPlant.getImageUrl().replace("/", File.separator);
                        File oldImageFile = new File(oldImagePath);
                        if (oldImageFile.exists()) {
                            oldImageFile.delete();
                        }
                    } catch (Exception e) {
                        // Log error but continue
                        System.err.println("Không thể xóa ảnh cũ: " + e.getMessage());
                    }
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi khi xử lý ảnh: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
            return;
        }
        
        // Kiểm tra các trường bắt buộc
        if (plantIdStr == null || plantIdStr.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            stockQuantityStr == null || stockQuantityStr.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
            return;
        }
        
        try {
            int plantId = Integer.parseInt(plantIdStr);
            double price = Double.parseDouble(priceStr);
            int stockQuantity = Integer.parseInt(stockQuantityStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            
            // Kiểm tra giá và số lượng hợp lệ
            if (price <= 0) {
                session.setAttribute("errorMessage", "Giá phải lớn hơn 0!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
                return;
            }
            
            if (stockQuantity < 0) {
                session.setAttribute("errorMessage", "Số lượng tồn kho không được âm!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
                return;
            }
            
            // Kiểm tra tên cây đã tồn tại (trừ chính nó)
            if (plantDAO.isPlantNameExistsExcludeId(name.trim(), plantId)) {
                session.setAttribute("errorMessage", "Tên cây đã tồn tại!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
                return;
            }
            
            // Tạo đối tượng Plant để cập nhật
            Plant plant = new Plant();
            plant.setPlantId(plantId);
            plant.setName(name.trim());
            plant.setDescription(description.trim());
            plant.setPrice(price);
            plant.setStockQuantity(stockQuantity);
            plant.setCategoryId(categoryId);
            plant.setImageUrl(imageUrl);
            
            // Cập nhật cây trong database
            if (plantDAO.updatePlant(plant)) {
                session.setAttribute("successMessage", "Cập nhật cây cảnh thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật cây cảnh. Vui lòng thử lại!");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID, giá và số lượng phải là số hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi khi cập nhật cây cảnh: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
    }

    private void deletePlant(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ClassNotFoundException, IOException {
        HttpSession session = request.getSession();
        
        String plantIdStr = request.getParameter("plantId");
        
        if (plantIdStr == null || plantIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "ID cây cảnh không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
            return;
        }
        
        try {
            int plantId = Integer.parseInt(plantIdStr);
            
            // Xóa cây khỏi database
            if (plantDAO.deletePlant(plantId)) {
                session.setAttribute("successMessage", "Xóa cây cảnh thành công!");
            } else {
                session.setAttribute("errorMessage", "Không thể xóa cây cảnh. Vui lòng thử lại!");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID cây cảnh phải là số hợp lệ!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Lỗi khi xóa cây cảnh: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-plants");
    }
}
