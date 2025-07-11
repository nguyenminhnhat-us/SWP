<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <%
                    // Redirect to HomeController if the plant list is not loaded
                    if (request.getAttribute("plants") == null) {
                        request.getRequestDispatcher("/home").forward(request, response);
                        return;
                    }
                %>
                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <title>Vườn Cây Đà Nẵng - Chuyên Mua Bán Cây Xanh</title>
                        <meta name="viewport" content="width=device-width, initial-scale=1">

                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header-style.css">

                    </head>

                    <body>
                        <jsp:include page="./common/home/header.jsp"></jsp:include>

                        <!-- Hero Section -->
                        <section class="hero-section">
                            <div class="container">
                                <h1 class="display-4">Chào mừng đến với Vườn Cây Đà Nẵng</h1>
                                <p class="lead">Nơi cung cấp các loại cây xanh chất lượng cao cho không gian của bạn</p>
                                <a href="#products" class="btn btn-success btn-lg">Xem sản phẩm</a>
                            </div>
                        </section>

                        <!-- Top 5 sản phẩm bán chạy -->
                        <section class="container mb-5">
                            <h2 class="text-center mb-4">Top 5 Sản phẩm bán chạy</h2>
                            <div class="row justify-content-center">
                                <c:forEach var="plant" items="${topSellingPlants}">
                                    <div class="col-md-2 col-6 mb-3">
                                        <div class="card h-100">
                                            <img src="${plant.imageUrl}" class="card-img-top" alt="${plant.name}">
                                            <div class="card-body p-2">
                                                <h6 class="card-title mb-1">${plant.name}</h6>
                                                <p class="price mb-1">
                                                    <fmt:formatNumber value="${plant.price}" type="currency"
                                                        currencySymbol="₫" />
                                                </p>
                                                <a href="plant-details?id=${plant.plantId}"
                                                    class="btn btn-outline-success btn-sm w-100">Chi tiết</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>

                        <!-- Bài viết mới nhất -->
                        <section class="container mb-5">
                            <h2 class="text-center mb-4">Bài viết mới nhất</h2>
                            <div class="row">
                                <c:forEach var="article" items="${latestArticles}">
                                    <div class="col-md-4 mb-3">
                                        <div class="card h-100">
                                            <div class="card-body">
                                                <h5 class="card-title">${article.title}</h5>
                                                <p class="card-text">
                                                    <c:choose>
                                                        <c:when test="${fn:length(article.content) > 120}">
                                                            ${fn:substring(article.content, 0, 120)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${article.content}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="text-muted small mb-1">Chuyên mục: ${article.category}</p>
                                                <p class="text-muted small">Ngày đăng:
                                                    <fmt:formatDate value='${article.createdAt}' pattern='dd/MM/yyyy' />
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>

                        <!-- Categories Section -->
                        <section class="container mb-5">
                            <h2 class="text-center mb-4">Danh mục sản phẩm</h2>
                            <div class="d-flex align-items-center mb-3">
                                <button class="btn btn-outline-success me-2" id="category-prev"><i
                                        class="fas fa-chevron-left"></i></button>
                                <div id="category-list" class="flex-grow-1 d-flex justify-content-center"
                                    style="overflow: hidden; min-width: 350px;">
                                    <!-- Danh mục sẽ được render bằng JS -->
                                </div>
                                <button class="btn btn-outline-success ms-2" id="category-next"><i
                                        class="fas fa-chevron-right"></i></button>
                            </div>
                        </section>

                        <!-- Featured Products Section -->
                        <section id="products" class="container mb-5">
                            <h2 class="text-center mb-4">Sản phẩm nổi bật</h2>
                            <div class="row">
                                <c:forEach var="plant" items="${plants}">
                                    <div class="col-md-3 col-6 mb-4">
                                        <div class="product-card card h-100">
                                            <img src="${plant.imageUrl}" class="card-img-top" alt="${plant.name}">
                                            <div class="card-body">
                                                <h5 class="card-title">${plant.name}</h5>
                                                <p class="card-text">${plant.description}</p>
                                                <p class="price">
                                                    <fmt:formatNumber value="${plant.price}" type="currency"
                                                        currencySymbol="₫" />
                                                </p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <a href="${pageContext.request.contextPath}//product-detail?id=${plant.plantId}"
                                                        class="btn btn-outline-success">Chi tiết</a>
                                                    <form action="${pageContext.request.contextPath}/cart" method="post"
                                                        class="d-inline">
                                                        <input type="hidden" name="action" value="add">
                                                        <input type="hidden" name="plantId" value="${plant.plantId}">
                                                        <input type="hidden" name="quantity" value="1">
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>
                        <nav>
                            <ul class="pagination justify-content-center">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>

                        <!-- Features Section -->
                        <section class="features-section">
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="feature-item">
                                            <i class="fas fa-truck"></i>
                                            <h4>Giao hàng toàn quốc</h4>
                                            <p>Miễn phí giao hàng cho đơn từ 1 triệu</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="feature-item">
                                            <i class="fas fa-leaf"></i>
                                            <h4>Sản phẩm chất lượng</h4>
                                            <p>Cam kết cây khỏe mạnh 100%</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="feature-item">
                                            <i class="fas fa-sync-alt"></i>
                                            <h4>Đổi trả dễ dàng</h4>
                                            <p>Đổi trả trong vòng 7 ngày</p>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="feature-item">
                                            <i class="fas fa-headset"></i>
                                            <h4>Hỗ trợ 24/7</h4>
                                            <p>Tư vấn chuyên nghiệp</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>


                        <jsp:include page="./common/home/footer.jsp"></jsp:include>

                        <!-- Bootstrap JS -->
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Lấy danh sách category từ JSP sang JS
                            const categories = [
                                <c:forEach var="cat" items="${categories}" varStatus="loop">
                                    "${cat.name}"<c:if test="${!loop.last}">,</c:if>
                                </c:forEach>
                            ];
                        </script>
                        <script>
                            let catStart = 0;
                            const catPerPage = 4;
                            const categoryList = document.getElementById('category-list');
                            const prevBtn = document.getElementById('category-prev');
                            const nextBtn = document.getElementById('category-next');

                            function renderCategories() {
                                categoryList.innerHTML = '';
                                for (let i = catStart; i < Math.min(catStart + catPerPage, categories.length); i++) {
                                    const span = document.createElement('span');
                                    span.className = 'badge bg-success mx-2';
                                    span.textContent = categories[i];
                                    categoryList.appendChild(span);
                                }
                                prevBtn.disabled = catStart === 0;
                                nextBtn.disabled = catStart + catPerPage >= categories.length;
                            }

                            prevBtn.onclick = function () {
                                if (catStart > 0) {
                                    catStart -= catPerPage;
                                    if (catStart < 0) catStart = 0;
                                    renderCategories();
                                }
                            };
                            nextBtn.onclick = function () {
                                if (catStart + catPerPage < categories.length) {
                                    catStart += catPerPage;
                                    renderCategories();
                                }
                            };

                            // Khởi tạo
                            renderCategories();
                        </script>
                    </body>

                    </html>