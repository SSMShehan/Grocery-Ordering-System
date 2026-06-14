<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Shop Category - Farmart</title>

            <!-- External Libs -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <!-- Modern Styles -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/index_navbar_nextgen.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/home_ultra.css">

            <style>
                .category-header-banner {
                    background: linear-gradient(135deg, #10B981, #059669);
                    padding: 60px 0;
                    text-align: center;
                    color: white;
                    margin-bottom: 40px;
                }

                .category-title-large {
                    font-size: 2.5rem;
                    font-weight: 800;
                    margin-bottom: 10px;
                }

                .cat-breadcrumb {
                    color: rgba(255, 255, 255, 0.8);
                    font-size: 0.9rem;
                }

                .empty-state {
                    text-align: center;
                    padding: 60px;
                    background: #f9fafb;
                    border-radius: 12px;
                    margin: 20px 0;
                }
            </style>
        </head>

        <body>

            <!-- Include Navbar -->
            <jsp:include page="index_navbar.jsp" />

            <!-- Header -->
            <div class="category-header-banner">
                <div class="container">
                    <h1 class="category-title-large">
                        <c:out value="${categoryName}" default="All Products" />
                    </h1>
                    <div class="cat-breadcrumb">
                        <a href="${pageContext.request.contextPath}/customer/index.jsp"
                            style="color: white; text-decoration: none;">Home</a> / Shop
                    </div>
                </div>
            </div>

            <!-- Product Grid -->
            <div class="container" style="padding-bottom: 60px;">
                <c:choose>
                    <c:when test="${not empty itemList}">
                        <div class="product-grid-modern">
                            <c:forEach items="${itemList}" var="item">
                                <div class="prod-card-modern">
                                    <div class="prod-actions">
                                        <button class="action-btn" title="Wishlist"><i
                                                class="far fa-heart"></i></button>
                                        <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}&name=${item.name}&price=${item.price}&category=${item.category}&quantity=${item.quantity}&desc=${item.description}"
                                            class="action-btn" title="View Details"
                                            style="display:inline-flex; align-items:center; justify-content:center; text-decoration:none; color:inherit;">
                                            <i class="far fa-eye"></i>
                                        </a>
                                    </div>

                                    <!-- Placeholder Image Logic -->
                                    <a
                                        href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}&name=${item.name}&price=${item.price}&category=${item.category}&quantity=${item.quantity}&desc=${item.description}">
                                        <img src="${pageContext.request.contextPath}/customer/image/item${item.itemID}.jpg"
                                            class="prod-img" alt="${item.name}"
                                            onerror="this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg'">
                                    </a>

                                    <div style="text-align: left;">
                                        <div style="color: #F59E0B; font-size: 0.8rem; margin-bottom: 5px;">
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i
                                                class="fas fa-star"></i>
                                            <i class="fas fa-star"></i><i class="fas fa-star"></i>
                                        </div>
                                        <h3 style="margin: 0 0 5px; font-size: 1.1rem;">
                                            <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}"
                                                style="text-decoration: none; color: inherit;">
                                                ${item.name}
                                                <c:if test="${item.discount > 0}">
                                                    <span style="background:var(--primary-emerald); color:white; font-size:0.7rem; padding:2px 6px; border-radius:4px; vertical-align:middle; margin-left:5px;">-${item.discount}%</span>
                                                </c:if>
                                            </a>
                                        </h3>
                                        <div style="color: #10B981; font-weight: 800; font-size: 1.2rem;">
                                            <c:choose>
                                                <c:when test="${item.discount > 0}">
                                                    Rs. ${item.dealPrice} <span style="text-decoration:line-through; color:#9CA3AF; font-size:0.9rem; margin-left:5px;">Rs. ${item.price}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    Rs. ${item.price}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p style="font-size: 0.8rem; color: #666; margin-bottom: 5px;">
                                            ${item.description}</p>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/customer/CartServlet" method="post" style="width: 100%;">
                                        <input type="hidden" name="itemId" value="${item.itemID}">
                                        <input type="hidden" name="itemName" value="${item.name}">
                                        <input type="hidden" name="itemPrice" value="${item.dealPrice != null ? item.dealPrice : item.price}">
                                        <input type="hidden" name="itemDescription" value="${item.description}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn-add-cart-full" style="width:100%; border-radius: 8px; margin-top: 10px;">Add to Cart</button>
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-box-open" style="font-size: 4rem; color: #ccc; margin-bottom: 20px;"></i>
                            <h3>No items found in this category.</h3>
                            <p>Check back later or browse other categories.</p>
                            <a href="${pageContext.request.contextPath}/customer/index.jsp" class="btn-cta"
                                style="display: inline-block; margin-top: 15px;">Go Home</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <jsp:include page="footer.jsp" />

            <!-- Scripts -->
            <script src="${pageContext.request.contextPath}/customer/scripts/home_core.js"></script>

        </body>

        </html>