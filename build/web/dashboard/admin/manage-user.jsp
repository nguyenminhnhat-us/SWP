<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .user-avatar {
            width: 40px;
            height: 40px;
            object-fit: cover;
        }
        .status-badge {
            font-size: 0.8rem;
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
                        <h2><i class="fa fa-users me-2"></i>Quản lý người dùng</h2>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="fa fa-plus me-2"></i>Thêm người dùng
                        </button>
                    </div>
                    
                    <!-- Search and Filter -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/dashboard/manage-users">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <input type="text" class="form-control" name="search" 
                                               placeholder="Tìm kiếm theo tên, email..." 
                                               value="${param.search}">
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="role">
                                            <option value="">Tất cả vai trò</option>
                                            <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin</option>
                                            <option value="customer" ${param.role == 'customer' ? 'selected' : ''}>Customer</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-select" name="status">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Bị khóa</option>
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
                    
                    <!-- Users Table -->
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
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Vai trò</th>
                                            <th>Trạng thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
        
                                                <td>${user.fullName}</td>
                                                <td>${user.email}</td>
                                                <td>${user.phone}</td>
                                                <td>
                                                    <span class="badge ${user.role == 'admin' ? 'bg-danger' : 'bg-primary'}">
                                                        ${user.role == 'admin' ? 'Admin' : 'Customer'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge status-badge ${user.isActive ? 'bg-success' : 'bg-secondary'}">
                                                        ${user.isActive ? 'Hoạt động' : 'Bị khóa'}
                                                    </span>
                                                </td>
                                                <td class="table-actions">
                                                    <div class="btn-group" role="group">
                                                        <button class="btn btn-sm btn-outline-primary" 
                                                                onclick="viewUser(${user.userId})" title="Xem chi tiết">
                                                            <i class="fa fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-warning" 
                                                                onclick="editUser(${user.userId})" title="Chỉnh sửa">
                                                            <i class="fa fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-sm ${user.isActive ? 'btn-outline-secondary' : 'btn-outline-success'}" 
                                                                onclick="toggleUserStatus(${user.userId}, ${user.isActive})" 
                                                                title="${user.isActive ? 'Khóa tài khoản' : 'Kích hoạt tài khoản'}">
                                                            <i class="fa ${user.isActive ? 'fa-lock' : 'fa-unlock'}"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-danger" 
                                                                onclick="deleteUser(${user.userId}, '${user.fullName}')" 
                                                                title="Xóa người dùng">
                                                            <i class="fa fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                
                                <c:if test="${empty users}">
                                    <div class="text-center py-4">
                                        <i class="fa fa-users fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Không tìm thấy người dùng nào</p>
                                    </div>
                                </c:if>
                            </div>
                            
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="User pagination" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <!-- Previous Page -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&role=${param.role}&status=${param.status}">
                                                <i class="fa fa-chevron-left"></i> Trước
                                            </a>
                                        </li>
                                        
                                        <!-- Page Numbers -->
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <c:if test="${pageNum <= 5 || pageNum > totalPages - 5 || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="?page=${pageNum}&search=${param.search}&role=${param.role}&status=${param.status}">
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
                                            <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&role=${param.role}&status=${param.status}">
                                                Sau <i class="fa fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                    
                                    <!-- Page Info -->
                                    <div class="text-center mt-2">
                                        <small class="text-muted">
                                            Hiển thị ${(currentPage - 1) * usersPerPage + 1} - 
                                            ${currentPage * usersPerPage > totalUsers ? totalUsers : currentPage * usersPerPage} 
                                            trong tổng số ${totalUsers} người dùng
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
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="addUserForm" method="POST" action="${pageContext.request.contextPath}/dashboard/manage-users">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ tên *</label>
                                <input type="text" class="form-control" name="fullName" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Email *</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mật khẩu *</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" name="phone">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Địa chỉ</label>
                                <textarea class="form-control" name="address" rows="2"></textarea>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Vai trò</label>
                                <select class="form-select" name="role">
                                    <option value="customer">Customer</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" name="isActive">
                                    <option value="1">Hoạt động</option>
                                    <option value="0">Bị khóa</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">Thêm người dùng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation for add user
        document.getElementById('addUserForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Clear previous error messages
            clearValidationErrors();
            
            let isValid = true;
            
            // Get form elements
            const fullName = document.querySelector('input[name="fullName"]');
            const email = document.querySelector('input[name="email"]');
            const password = document.querySelector('input[name="password"]');
            const phone = document.querySelector('input[name="phone"]');
            
            // Validate full name
            if (!fullName.value.trim()) {
                showFieldError(fullName, 'Họ tên không được để trống');
                isValid = false;
            } else if (fullName.value.trim().length < 2) {
                showFieldError(fullName, 'Họ tên phải có ít nhất 2 ký tự');
                isValid = false;
            } else if (!/^[a-zA-ZÀ-ỹ\s]+$/.test(fullName.value.trim())) {
                showFieldError(fullName, 'Họ tên chỉ được chứa chữ cái và khoảng trắng');
                isValid = false;
            }
            
            // Validate email
            if (!email.value.trim()) {
                showFieldError(email, 'Email không được để trống');
                isValid = false;
            } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value.trim())) {
                showFieldError(email, 'Email không đúng định dạng');
                isValid = false;
            }
            
            // Validate password
            if (!password.value) {
                showFieldError(password, 'Mật khẩu không được để trống');
                isValid = false;
            } else if (password.value.length < 6) {
                showFieldError(password, 'Mật khẩu phải có ít nhất 6 ký tự');
                isValid = false;
            } else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(password.value)) {
                showFieldError(password, 'Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 số');
                isValid = false;
            }
            
            // Validate phone (optional but if provided, must be valid)
            if (phone.value.trim() && !/^[0-9]{10,11}$/.test(phone.value.trim())) {
                showFieldError(phone, 'Số điện thoại phải có 10-11 chữ số');
                isValid = false;
            }
            
            if (isValid) {
                // If validation passes, submit the form
                this.submit();
            }
        });
        
        function showFieldError(field, message) {
            field.classList.add('is-invalid');
            
            // Remove existing error message
            const existingError = field.parentNode.querySelector('.invalid-feedback');
            if (existingError) {
                existingError.remove();
            }
            
            // Add new error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'invalid-feedback';
            errorDiv.textContent = message;
            field.parentNode.appendChild(errorDiv);
        }
        
        function clearValidationErrors() {
            // Remove all error classes and messages
            document.querySelectorAll('.is-invalid').forEach(field => {
                field.classList.remove('is-invalid');
            });
            document.querySelectorAll('.invalid-feedback').forEach(error => {
                error.remove();
            });
        }
        
        // Clear errors when modal is closed
        document.getElementById('addUserModal').addEventListener('hidden.bs.modal', function() {
            clearValidationErrors();
            document.getElementById('addUserForm').reset();
        });
        
        function viewUser(userId) {
            window.location.href = '${pageContext.request.contextPath}/dashboard/user-detail?id=' + userId;
        }
        
        function editUser(userId) {
            window.location.href = '${pageContext.request.contextPath}/dashboard/edit-user?id=' + userId;
        }
        
        function toggleUserStatus(userId, currentStatus) {
            const action = currentStatus ? 'khóa' : 'kích hoạt';
            if (confirm(`Bạn có chắc chắn muốn ${action} tài khoản này?`)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/dashboard/manage-users';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'toggle';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function deleteUser(userId, userName) {
            if (confirm(`Bạn có chắc chắn muốn xóa người dùng "${userName}"? Hành động này không thể hoàn tác.`)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/dashboard/manage-users';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>