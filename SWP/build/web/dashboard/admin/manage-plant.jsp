<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý cây cảnh - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .plant-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .badge {
            font-size: 0.75rem;
        }
        
        .table-actions {
            white-space: nowrap;
        }
        
        .search-box {
            max-width: 300px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <%@ include file="../../common/dashboard/sidebar.jsp" %>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="container-fluid py-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fa fa-seedling me-2"></i>Quản lý cây cảnh</h2>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addPlantModal">
                            <i class="fa fa-plus me-2"></i>Thêm cây cảnh
                        </button>
                    </div>
                    
                    <!-- Search and Filter -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/dashboard/manage-plants">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <input type="text" class="form-control" name="search" 
                                               placeholder="Tìm kiếm theo tên cây..." 
                                               value="${param.search}">
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="category">
                                            <option value="">Tất cả danh mục</option>
                                            <c:forEach var="category" items="${categories}">
                                                <option value="${category.categoryId}" ${param.category == category.categoryId ? 'selected' : ''}>${category.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="stock">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="instock" ${param.stock == 'instock' ? 'selected' : ''}>Còn hàng</option>
                                            <option value="outstock" ${param.stock == 'outstock' ? 'selected' : ''}>Hết hàng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="fa fa-search"></i> Tìm kiếm
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Plants Table -->
                    <div class="card">
                        <div class="card-body">
                            <c:if test="${not empty sessionScope.successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${sessionScope.successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="successMessage" scope="session" />
                            </c:if>
                            
                            <c:if test="${not empty sessionScope.errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${sessionScope.errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <c:remove var="errorMessage" scope="session" />
                            </c:if>
                            
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Hình ảnh</th>
                                            <th>Tên cây</th>
                                            <th>Danh mục</th>
                                            <th>Giá</th>
                                            <th>Tồn kho</th>
                                            <th>Ngày tạo</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="plant" items="${plants}">
                                            <tr>
                                                <td>${plant.plantId}</td>
                                                <td>
                                                    <img src="${pageContext.request.contextPath}/${plant.imageUrl}" 
                                                         alt="${plant.name}" class="plant-image">
                                                </td>
                                                <td>${plant.name}</td>
                                                <td>
                                                    <c:forEach var="category" items="${categories}">
                                                        <c:if test="${category.categoryId == plant.categoryId}">
                                                            <span class="badge bg-info">${category.name}</span>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${plant.price}" type="currency" currencySymbol="₫" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${plant.stockQuantity > 10}">
                                                            <span class="badge bg-success">${plant.stockQuantity}</span>
                                                        </c:when>
                                                        <c:when test="${plant.stockQuantity > 0}">
                                                            <span class="badge bg-warning">${plant.stockQuantity}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">Hết hàng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty plant.createdAt}">
                                                        <fmt:formatDate value="${plant.createdAt}" pattern="dd/MM/yyyy" />
                                                    </c:if>
                                                </td>
                                                <td class="table-actions">
                                                    <div class="btn-group" role="group">
                                                        <button class="btn btn-sm btn-outline-primary" 
                                                                onclick="viewPlant(${plant.plantId})" title="Xem chi tiết">
                                                            <i class="fa fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-warning" 
                                                                onclick="editPlant(${plant.plantId}, '${plant.name}', '${plant.description}', ${plant.price}, ${plant.stockQuantity}, ${plant.categoryId}, '${plant.imageUrl}')" 
                                                                title="Chỉnh sửa">
                                                            <i class="fa fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-danger" 
                                                                onclick="deletePlant(${plant.plantId}, '${plant.name}')" 
                                                                title="Xóa cây cảnh">
                                                            <i class="fa fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                
                                <c:if test="${empty plants}">
                                    <div class="text-center py-4">
                                        <i class="fa fa-seedling fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Không tìm thấy cây cảnh nào</p>
                                    </div>
                                </c:if>
                            </div>

                            
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Plant pagination" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <!-- Previous Page -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&category=${param.category}&stock=${param.stock}">
                                                <i class="fa fa-chevron-left"></i> Trước
                                            </a>
                                        </li>
                                        
                                        <!-- Page Numbers -->
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <c:if test="${pageNum <= 5 || pageNum > totalPages - 5 || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="?page=${pageNum}&search=${param.search}&category=${param.category}&stock=${param.stock}">
                                                        ${pageNum}
                                                    </a>
                                                </li>
                                            </c:if>
                                            <c:if test="${pageNum == 6 && totalPages > 10 && currentPage < totalPages - 5}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <!-- Next Page -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&category=${param.category}&stock=${param.stock}">
                                                Sau <i class="fa fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                    
                                    <!-- Page Info -->
                                    <div class="text-center mt-2">
                                        <small class="text-muted">
                                            Hiển thị ${(currentPage - 1) * plantsPerPage + 1} - 
                                            ${currentPage * plantsPerPage > totalPlants ? totalPlants : currentPage * plantsPerPage} 
                                            trong tổng số ${totalPlants} cây cảnh
                                        </small>
                                    </div>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Plant Modal -->
    <div class="modal fade" id="addPlantModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm cây cảnh mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/dashboard/manage-plants" method="post" id="addPlantForm" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addName" class="form-label">Tên Cây <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="addName" name="name" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addCategoryId" class="form-label">Danh Mục <span class="text-danger">*</span></label>
                                    <select class="form-select" id="addCategoryId" name="categoryId" required>
                                        <option value="">Chọn danh mục</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}">${category.name}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addPrice" class="form-label">Giá (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="addPrice" name="price" min="0" step="1000" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="addStockQuantity" class="form-label">Số Lượng Tồn Kho <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="addStockQuantity" name="stockQuantity" min="0" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="addDescription" class="form-label">Mô Tả <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="addDescription" name="description" rows="3" required></textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="mb-3">
                            <label for="addImageFile" class="form-label">Hình Ảnh Cây Cảnh</label>
                            <input type="file" class="form-control" id="addImageFile" name="imageFile" accept="image/*">
                            <div class="form-text">Chọn file ảnh (JPG, PNG, GIF). Để trống sẽ sử dụng hình ảnh mặc định</div>
                            <div class="mt-2">
                                <img id="addImagePreview" src="" alt="Preview" class="img-thumbnail" style="max-width: 200px; display: none;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">Thêm cây cảnh</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Plant Modal -->
    <div class="modal fade" id="editPlantModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa cây cảnh</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/dashboard/manage-plants" method="post" id="editPlantForm" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editPlantId" name="plantId">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editName" class="form-label">Tên Cây <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editName" name="name" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editCategoryId" class="form-label">Danh Mục <span class="text-danger">*</span></label>
                                    <select class="form-select" id="editCategoryId" name="categoryId" required>
                                        <option value="">Chọn danh mục</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}">${category.name}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editPrice" class="form-label">Giá (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="editPrice" name="price" min="0" step="1000" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editStockQuantity" class="form-label">Số Lượng Tồn Kho <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="editStockQuantity" name="stockQuantity" min="0" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Mô Tả <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                            <div class="invalid-feedback"></div>
                        </div>
                        <div class="mb-3">
                            <label for="editImageFile" class="form-label">Hình Ảnh Cây Cảnh</label>
                            <input type="file" class="form-control" id="editImageFile" name="imageFile" accept="image/*">
                            <div class="form-text">Chọn file ảnh mới để thay đổi. Để trống sẽ giữ nguyên ảnh hiện tại</div>
                            <div class="mt-2">
                                <img id="editCurrentImage" src="" alt="Current Image" class="img-thumbnail" style="max-width: 200px;">
                                <img id="editImagePreview" src="" alt="Preview" class="img-thumbnail" style="max-width: 200px; display: none;">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Xem Chi Tiết -->
    <div class="modal fade" id="viewPlantModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-eye me-2"></i>Chi Tiết Cây Cảnh
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="plantDetails">
                    <!-- Nội dung sẽ được load bằng JavaScript -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validation functions
        function showFieldError(fieldId, message) {
            const field = document.getElementById(fieldId);
            field.classList.add('is-invalid');
            field.nextElementSibling.textContent = message;
        }

        function clearValidationErrors(formId) {
            const form = document.getElementById(formId);
            const invalidFields = form.querySelectorAll('.is-invalid');
            invalidFields.forEach(field => {
                field.classList.remove('is-invalid');
                const feedback = field.nextElementSibling;
                if (feedback && feedback.classList.contains('invalid-feedback')) {
                    feedback.textContent = '';
                }
            });
        }

        function validatePlantForm(formId) {
            clearValidationErrors(formId);
            let isValid = true;
            
            const form = document.getElementById(formId);
            const name = form.querySelector('[name="name"]').value.trim();
            const description = form.querySelector('[name="description"]').value.trim();
            const price = parseFloat(form.querySelector('[name="price"]').value);
            const stockQuantity = parseInt(form.querySelector('[name="stockQuantity"]').value);
            const categoryId = form.querySelector('[name="categoryId"]').value;
            
            // Validate name
            if (!name) {
                showFieldError(form.querySelector('[name="name"]').id, 'Tên cây không được để trống');
                isValid = false;
            } else if (name.length < 2) {
                showFieldError(form.querySelector('[name="name"]').id, 'Tên cây phải có ít nhất 2 ký tự');
                isValid = false;
            }
            
            // Validate description
            if (!description) {
                showFieldError(form.querySelector('[name="description"]').id, 'Mô tả không được để trống');
                isValid = false;
            } else if (description.length < 10) {
                showFieldError(form.querySelector('[name="description"]').id, 'Mô tả phải có ít nhất 10 ký tự');
                isValid = false;
            }
            
            // Validate price
            if (isNaN(price) || price <= 0) {
                showFieldError(form.querySelector('[name="price"]').id, 'Giá phải là số dương');
                isValid = false;
            }
            
            // Validate stock quantity
            if (isNaN(stockQuantity) || stockQuantity < 0) {
                showFieldError(form.querySelector('[name="stockQuantity"]').id, 'Số lượng tồn kho không được âm');
                isValid = false;
            }
            
            // Validate category
            if (!categoryId) {
                showFieldError(form.querySelector('[name="categoryId"]').id, 'Vui lòng chọn danh mục');
                isValid = false;
            }
            
            // Validate image file (only for add form)
            if (form.id === 'addPlantForm') {
                const imageFile = form.querySelector('[name="imageFile"]').files[0];
                if (imageFile) {
                    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                    if (!allowedTypes.includes(imageFile.type)) {
                        showFieldError(form.querySelector('[name="imageFile"]').id, 'Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WEBP)');
                        isValid = false;
                    }
                    
                    // Check file size (max 10MB)
                    if (imageFile.size > 10 * 1024 * 1024) {
                        showFieldError(form.querySelector('[name="imageFile"]').id, 'Kích thước file không được vượt quá 10MB');
                        isValid = false;
                    }
                }
            }
            
            // Validate image file for edit form (optional)
            if (form.id === 'editPlantForm') {
                const imageFile = form.querySelector('[name="imageFile"]').files[0];
                if (imageFile) {
                    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                    if (!allowedTypes.includes(imageFile.type)) {
                        showFieldError(form.querySelector('[name="imageFile"]').id, 'Chỉ chấp nhận file ảnh (JPG, PNG, GIF, WEBP)');
                        isValid = false;
                    }
                    
                    // Check file size (max 10MB)
                    if (imageFile.size > 10 * 1024 * 1024) {
                        showFieldError(form.querySelector('[name="imageFile"]').id, 'Kích thước file không được vượt quá 10MB');
                        isValid = false;
                    }
                }
            }
            
            return isValid;
        }

        // Form submission handlers
        document.getElementById('addPlantForm').addEventListener('submit', function(e) {
            if (!validatePlantForm('addPlantForm')) {
                e.preventDefault();
            }
        });

        document.getElementById('editPlantForm').addEventListener('submit', function(e) {
            if (!validatePlantForm('editPlantForm')) {
                e.preventDefault();
            }
        });

        // Clear validation errors when modals are closed
        document.getElementById('addPlantModal').addEventListener('hidden.bs.modal', function() {
            clearValidationErrors('addPlantForm');
            document.getElementById('addPlantForm').reset();
            document.getElementById('addImagePreview').style.display = 'none';
        });

        document.getElementById('editPlantModal').addEventListener('hidden.bs.modal', function() {
            clearValidationErrors('editPlantForm');
            document.getElementById('editImagePreview').style.display = 'none';
            document.getElementById('editCurrentImage').style.display = 'none';
        });

        // Image preview functions
        function setupImagePreview(inputId, previewId) {
            const input = document.getElementById(inputId);
            const preview = document.getElementById(previewId);
            
            input.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                } else {
                    preview.style.display = 'none';
                }
            });
        }
        
        // Setup image previews
        setupImagePreview('addImageFile', 'addImagePreview');
        setupImagePreview('editImageFile', 'editImagePreview');

        // Plant management functions
        function editPlant(plantId, name, description, price, stockQuantity, categoryId, imageUrl) {
            document.getElementById('editPlantId').value = plantId;
            document.getElementById('editName').value = name;
            document.getElementById('editDescription').value = description;
            document.getElementById('editPrice').value = price;
            document.getElementById('editStockQuantity').value = stockQuantity;
            document.getElementById('editCategoryId').value = categoryId;
            
            // Show current image
            const currentImage = document.getElementById('editCurrentImage');
            if (imageUrl && imageUrl.trim() !== '') {
                currentImage.src = '${pageContext.request.contextPath}/' + imageUrl;
                currentImage.style.display = 'block';
            } else {
                currentImage.src = '${pageContext.request.contextPath}/images/default-plant.jpg';
                currentImage.style.display = 'block';
            }
            
            // Hide preview and reset file input
            document.getElementById('editImageFile').value = '';
            document.getElementById('editImagePreview').style.display = 'none';
            
            new bootstrap.Modal(document.getElementById('editPlantModal')).show();
        }

        function deletePlant(plantId, plantName) {
            if (confirm('Bạn có chắc chắn muốn xóa cây "' + plantName + '"?\nHành động này không thể hoàn tác!')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/dashboard/manage-plants';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const plantIdInput = document.createElement('input');
                plantIdInput.type = 'hidden';
                plantIdInput.name = 'plantId';
                plantIdInput.value = plantId;
                
                form.appendChild(actionInput);
                form.appendChild(plantIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function viewPlant(plantId) {
            // Find plant data from the table
            const plants = [
                <c:forEach var="plant" items="${plants}" varStatus="status">
                    {
                        plantId: ${plant.plantId},
                        name: '${plant.name}',
                        description: '${plant.description}',
                        price: ${plant.price},
                        stockQuantity: ${plant.stockQuantity},
                        categoryId: ${plant.categoryId},
                        imageUrl: '${plant.imageUrl}',
                        createdAt: '<c:if test="${not empty plant.createdAt}"><fmt:formatDate value="${plant.createdAt}" pattern="dd/MM/yyyy HH:mm" /></c:if>'
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const categories = [
                <c:forEach var="category" items="${categories}" varStatus="status">
                    {
                        categoryId: ${category.categoryId},
                        name: '${category.name}'
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];
            
            const plant = plants.find(p => p.plantId === plantId);
            const category = categories.find(c => c.categoryId === plant.categoryId);
            
            if (plant) {
                const detailsHtml = 
                    '<div class="row">' +
                        '<div class="col-md-4">' +
                            '<img src="${pageContext.request.contextPath}/' + plant.imageUrl + '" ' +
                                 'alt="' + plant.name + '" class="img-fluid rounded"' +
                                 'onerror="this.src=\'${pageContext.request.contextPath}/images/default-plant.jpg\'">' +
                        '</div>' +
                        '<div class="col-md-8">' +
                            '<h4>' + plant.name + '</h4>' +
                            '<p class="text-muted">' + plant.description + '</p>' +
                            '<table class="table table-borderless">' +
                                '<tr>' +
                                    '<td><strong>ID:</strong></td>' +
                                    '<td>#' + plant.plantId + '</td>' +
                                '</tr>' +
                                '<tr>' +
                                    '<td><strong>Danh mục:</strong></td>' +
                                    '<td><span class="badge bg-info">' + (category ? category.name : 'N/A') + '</span></td>' +
                                '</tr>' +
                                '<tr>' +
                                    '<td><strong>Giá:</strong></td>' +
                                    '<td class="price-text">' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(plant.price) + '</td>' +
                                '</tr>' +
                                '<tr>' +
                                    '<td><strong>Tồn kho:</strong></td>' +
                                    '<td>' +
                                        (plant.stockQuantity > 10 ? 
                                            '<span class="badge bg-success">' + plant.stockQuantity + '</span>' :
                                            plant.stockQuantity > 0 ?
                                            '<span class="badge bg-warning">' + plant.stockQuantity + '</span>' :
                                            '<span class="badge bg-danger">Hết hàng</span>'
                                        ) +
                                    '</td>' +
                                '</tr>' +
                                '<tr>' +
                                    '<td><strong>Ngày tạo:</strong></td>' +
                                    '<td>' + (plant.createdAt || 'N/A') + '</td>' +
                                '</tr>' +
                            '</table>' +
                        '</div>' +
                    '</div>';
                
                document.getElementById('plantDetails').innerHTML = detailsHtml;
                new bootstrap.Modal(document.getElementById('viewPlantModal')).show();
            }
        }
    </script>
</body>
</html>