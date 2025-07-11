<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý danh mục - Plant Care System</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/common/dashboard/dashboard-style.css" rel="stylesheet">
        </head>
        <body>
            <div class="container-fluid">
                <div class="row">
                    <!-- Sidebar -->
                    <div class="col-md-3 col-lg-2 px-0">
                        <%@ include file="../../common/dashboard/sidebar.jsp" %>
                    </div>
                    <!-- Main content -->
                    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                        <div
                            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <c:choose>
                                <c:when test="${action == 'view'}">
                                    <h1 class="h2">Chi tiết danh mục</h1>
                                    <div class="btn-toolbar mb-2 mb-md-0">
                                        <a href="${pageContext.request.contextPath}/dashboard/manage-categories"
                                            class="btn btn-secondary">
                                            <i class="fas fa-arrow-left"></i> Quay lại
                                        </a>
                                    </div>
                                </c:when>
                                <c:when test="${action == 'edit'}">
                                    <h1 class="h2">Chỉnh sửa danh mục</h1>
                                    <div class="btn-toolbar mb-2 mb-md-0">
                                        <a href="${pageContext.request.contextPath}/dashboard/manage-categories"
                                            class="btn btn-secondary">
                                            <i class="fas fa-arrow-left"></i> Quay lại
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <h1 class="h2">Quản lý danh mục</h1>
                                    <div class="btn-toolbar mb-2 mb-md-0">
                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#addCategoryModal">
                                            <i class="fas fa-plus"></i> Thêm danh mục
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Alert messages -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Categories Table -->
                        <c:if test="${action != 'view' && action != 'edit'}">
                            <!-- Search and Filter Section -->
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <form method="get"
                                        action="${pageContext.request.contextPath}/dashboard/manage-categories"
                                        class="d-flex">
                                        <input type="text" class="form-control me-2" name="search"
                                            placeholder="Tìm kiếm theo tên hoặc mô tả..." value="${searchKeyword}">
                                        <button type="submit" class="btn btn-outline-primary">
                                            <i class="fas fa-search"></i> Tìm kiếm
                                        </button>
                                        <c:if test="${not empty searchKeyword}">
                                            <a href="${pageContext.request.contextPath}/dashboard/manage-categories"
                                                class="btn btn-outline-secondary ms-2">
                                                <i class="fas fa-times"></i> Xóa
                                            </a>
                                        </c:if>
                                    </form>
                                </div>
                                <div class="col-md-6 text-end">
                                    <div class="d-flex justify-content-end align-items-center">
                                        <label class="me-2">Hiển thị:</label>
                                        <select class="form-select" style="width: auto;"
                                            onchange="changePageSize(this.value)">
                                            <option value="5" ${pageSize==5 ? 'selected' : '' }>5</option>
                                            <option value="10" ${pageSize==10 ? 'selected' : '' }>10</option>
                                            <option value="20" ${pageSize==20 ? 'selected' : '' }>20</option>
                                            <option value="50" ${pageSize==50 ? 'selected' : '' }>50</option>
                                        </select>
                                        <span class="ms-2 text-muted">mục/trang</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Results Info -->
                            <div class="row mb-2">
                                <div class="col-12">
                                    <p class="text-muted mb-0">
                                        Hiển thị ${(currentPage - 1) * pageSize + 1} -
                                        ${currentPage * pageSize > totalCategories ? totalCategories : currentPage *
                                        pageSize}
                                        trong tổng số ${totalCategories} danh mục
                                        <c:if test="${not empty searchKeyword}">
                                            (tìm kiếm: "${searchKeyword}")
                                        </c:if>
                                    </p>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên danh mục</th>
                                            <th>Mô tả</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty categories}">
                                                <tr>
                                                    <td colspan="4" class="text-center py-4">
                                                        <div class="text-muted">
                                                            <i class="fas fa-folder-open fa-3x mb-3"></i>
                                                            <p class="mb-0">
                                                                <c:choose>
                                                                    <c:when test="${not empty searchKeyword}">
                                                                        Không tìm thấy danh mục nào với từ khóa
                                                                        "${searchKeyword}"
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Chưa có danh mục nào được tạo
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="category" items="${categories}">
                                                    <tr>
                                                        <td>${category.categoryId}</td>
                                                        <td>${category.name}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${category.description.length() > 50}">
                                                                    ${category.description.substring(0, 50)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${category.description}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-info btn-sm"
                                                                onclick="viewCategory(${category.categoryId})">
                                                                <i class="fas fa-eye"></i> Xem
                                                            </button>
                                                            <button class="btn btn-warning btn-sm"
                                                                onclick="editCategory(${category.categoryId})">
                                                                <i class="fas fa-edit"></i> Sửa
                                                            </button>
                                                            <button class="btn btn-danger btn-sm"
                                                                onclick="deleteCategory(${category.categoryId}, '${category.name}')">
                                                                <i class="fas fa-trash"></i> Xóa
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Phân trang danh mục">
                                    <ul class="pagination justify-content-center mt-4">
                                        <!-- Previous button -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage > 1}">
                                                    <a class="page-link" href="javascript:void(0)"
                                                        onclick="goToPage(${currentPage - 1})">
                                                        <i class="fas fa-chevron-left"></i> Trước
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="page-link">
                                                        <i class="fas fa-chevron-left"></i> Trước
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>

                                        <!-- First page -->
                                        <c:if test="${startPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="javascript:void(0)"
                                                    onclick="goToPage(1)">1</a>
                                            </li>
                                            <c:if test="${startPage > 2}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:if>
                                        </c:if>

                                        <!-- Page numbers -->
                                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <c:choose>
                                                    <c:when test="${i == currentPage}">
                                                        <span class="page-link">${i}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="page-link" href="javascript:void(0)"
                                                            onclick="goToPage(${i})">${i}</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </li>
                                        </c:forEach>

                                        <!-- Last page -->
                                        <c:if test="${endPage < totalPages}">
                                            <c:if test="${endPage < totalPages - 1}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:if>
                                            <li class="page-item">
                                                <a class="page-link" href="javascript:void(0)"
                                                    onclick="goToPage(${totalPages})">${totalPages}</a>
                                            </li>
                                        </c:if>

                                        <!-- Next button -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <a class="page-link" href="javascript:void(0)"
                                                        onclick="goToPage(${currentPage + 1})">
                                                        Sau <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="page-link">
                                                        Sau <i class="fas fa-chevron-right"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:if>

                        <!-- Category Detail View -->
                        <c:if test="${action == 'view'}">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Thông tin danh mục</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>ID:</strong> ${viewCategory.categoryId}</p>
                                            <p><strong>Tên danh mục:</strong> ${viewCategory.name}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Mô tả:</strong></p>
                                            <p class="text-muted">${viewCategory.description}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <a href="${pageContext.request.contextPath}/dashboard/manage-categories?action=edit&categoryId=${viewCategory.categoryId}"
                                        class="btn btn-warning">
                                        <i class="fas fa-edit"></i> Chỉnh sửa
                                    </a>
                                </div>
                            </div>
                        </c:if>

                        <!-- Edit Category Form -->
                        <c:if test="${action == 'edit'}">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Chỉnh sửa danh mục</h5>
                                </div>
                                <div class="card-body">
                                    <form id="editCategoryForm"
                                        action="${pageContext.request.contextPath}/dashboard/manage-categories"
                                        method="post">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="categoryId" value="${editCategory.categoryId}">

                                        <div class="mb-3">
                                            <label for="editName" class="form-label">Tên danh mục <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="editName" name="name"
                                                value="${editCategory.name}" required>
                                            <div class="invalid-feedback" id="editNameError"></div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="editDescription" class="form-label">Mô tả</label>
                                            <textarea class="form-control" id="editDescription" name="description"
                                                rows="4">${editCategory.description}</textarea>
                                            <div class="invalid-feedback" id="editDescriptionError"></div>
                                        </div>

                                        <div class="d-flex justify-content-end">
                                            <a href="${pageContext.request.contextPath}/dashboard/manage-categories"
                                                class="btn btn-secondary me-2">Hủy</a>
                                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </main>
                </div>
            </div>

            <!-- Add Category Modal -->
            <div class="modal fade" id="addCategoryModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm danh mục mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <form id="addCategoryForm"
                            action="${pageContext.request.contextPath}/dashboard/manage-categories" method="post">
                            <div class="modal-body">
                                <input type="hidden" name="action" value="add">

                                <div class="mb-3">
                                    <label for="name" class="form-label">Tên danh mục <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="name" name="name" required>
                                    <div class="invalid-feedback" id="nameError"></div>
                                </div>

                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description"
                                        rows="4"></textarea>
                                    <div class="invalid-feedback" id="descriptionError"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">Thêm danh mục</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function viewCategory(categoryId) {
                    // Redirect to view category detail page
                    window.location.href = '${pageContext.request.contextPath}/dashboard/manage-categories?action=view&categoryId=' + categoryId;
                }

                function editCategory(categoryId) {
                    // Redirect to edit category page
                    window.location.href = '${pageContext.request.contextPath}/dashboard/manage-categories?action=edit&categoryId=' + categoryId;
                }

                function deleteCategory(categoryId, categoryName) {
                    if (confirm('Bạn có chắc chắn muốn xóa danh mục "' + categoryName + '"?\nLưu ý: Không thể xóa danh mục nếu còn có cây cảnh thuộc danh mục này.')) {
                        // Create form and submit
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '${pageContext.request.contextPath}/dashboard/manage-categories';

                        const actionInput = document.createElement('input');
                        actionInput.type = 'hidden';
                        actionInput.name = 'action';
                        actionInput.value = 'delete';

                        const categoryIdInput = document.createElement('input');
                        categoryIdInput.type = 'hidden';
                        categoryIdInput.name = 'categoryId';
                        categoryIdInput.value = categoryId;

                        form.appendChild(actionInput);
                        form.appendChild(categoryIdInput);
                        document.body.appendChild(form);
                        form.submit();
                    }
                }

                // Validate add category form
                function validateAddCategoryForm() {
                    const name = document.getElementById('name').value.trim();
                    const description = document.getElementById('description').value.trim();

                    // Clear previous errors
                    clearAddCategoryErrors();

                    let isValid = true;

                    // Validate name
                    if (name === '') {
                        showAddCategoryError('nameError', 'Vui lòng nhập tên danh mục');
                        isValid = false;
                    } else if (name.length < 2) {
                        showAddCategoryError('nameError', 'Tên danh mục phải có ít nhất 2 ký tự');
                        isValid = false;
                    }

                    return isValid;
                }

                // Validate edit category form
                function validateEditCategoryForm() {
                    const name = document.getElementById('editName').value.trim();
                    const description = document.getElementById('editDescription').value.trim();

                    // Clear previous errors
                    clearEditCategoryErrors();

                    let isValid = true;

                    // Validate name
                    if (name === '') {
                        showEditCategoryError('editNameError', 'Vui lòng nhập tên danh mục');
                        isValid = false;
                    } else if (name.length < 2) {
                        showEditCategoryError('editNameError', 'Tên danh mục phải có ít nhất 2 ký tự');
                        isValid = false;
                    }

                    return isValid;
                }

                function showAddCategoryError(elementId, message) {
                    const errorElement = document.getElementById(elementId);
                    if (errorElement) {
                        errorElement.textContent = message;
                        errorElement.style.display = 'block';
                        errorElement.parentElement.querySelector('input, textarea').classList.add('is-invalid');
                    }
                }

                function showEditCategoryError(elementId, message) {
                    const errorElement = document.getElementById(elementId);
                    if (errorElement) {
                        errorElement.textContent = message;
                        errorElement.style.display = 'block';
                        errorElement.parentElement.querySelector('input, textarea').classList.add('is-invalid');
                    }
                }

                function clearAddCategoryErrors() {
                    const errorElements = ['nameError', 'descriptionError'];
                    errorElements.forEach(id => {
                        const element = document.getElementById(id);
                        if (element) {
                            element.style.display = 'none';
                            element.textContent = '';
                            const input = element.parentElement.querySelector('input, textarea');
                            if (input) {
                                input.classList.remove('is-invalid');
                            }
                        }
                    });
                }

                function clearEditCategoryErrors() {
                    const errorElements = ['editNameError', 'editDescriptionError'];
                    errorElements.forEach(id => {
                        const element = document.getElementById(id);
                        if (element) {
                            element.style.display = 'none';
                            element.textContent = '';
                            const input = element.parentElement.querySelector('input, textarea');
                            if (input) {
                                input.classList.remove('is-invalid');
                            }
                        }
                    });
                }

                // Pagination and page size functions
                function changePageSize(newPageSize) {
                    const urlParams = new URLSearchParams(window.location.search);
                    urlParams.set('pageSize', newPageSize);
                    urlParams.set('page', '1'); // Reset to first page when changing page size
                    window.location.href = '${pageContext.request.contextPath}/dashboard/manage-categories?' + urlParams.toString();
                }

                function goToPage(page) {
                    const urlParams = new URLSearchParams(window.location.search);
                    urlParams.set('page', page);
                    window.location.href = '${pageContext.request.contextPath}/dashboard/manage-categories?' + urlParams.toString();
                }

                // Handle form submissions
                document.addEventListener('DOMContentLoaded', function () {
                    const addCategoryForm = document.getElementById('addCategoryForm');
                    if (addCategoryForm) {
                        addCategoryForm.addEventListener('submit', function (e) {
                            if (!validateAddCategoryForm()) {
                                e.preventDefault();
                                return false;
                            }
                        });
                    }

                    const editCategoryForm = document.getElementById('editCategoryForm');
                    if (editCategoryForm) {
                        editCategoryForm.addEventListener('submit', function (e) {
                            if (!validateEditCategoryForm()) {
                                e.preventDefault();
                                return false;
                            }
                        });
                    }

                    // Clear errors when modal is closed
                    const addCategoryModal = document.getElementById('addCategoryModal');
                    if (addCategoryModal) {
                        addCategoryModal.addEventListener('hidden.bs.modal', function () {
                            clearAddCategoryErrors();
                            addCategoryForm.reset();
                        });
                    }
                });
            </script>
        </body>

        </html>