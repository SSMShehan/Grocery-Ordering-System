<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <jsp:include page="index_navbar.jsp" />
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Browse by Category - ${selectedCategory != null ? selectedCategory : 'All Categories'}</title>
            <style>
                body {
                    font-family: 'Arial', sans-serif;
                    background-color: #f8f9fa;
                    color: #333;
                    margin: 0;
                    padding: 0;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                }

                .category-header {
                    margin: 20px 0;
                    padding: 15px;
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .category-header h1 {
                    color: #2e7d32;
                    margin: 0;
                    font-size: 24px;
                }

                .category-filter {
                    margin: 20px 0;
                    padding: 15px;
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                }

                .category-filter form {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                }

                .category-filter select {
                    padding: 10px;
                    border-radius: 4px;
                    border: 1px solid #ddd;
                    flex-grow: 1;
                    font-size: 16px;
                }

                .category-filter button {
                    padding: 10px 20px;
                    background-color: #4caf50;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                    transition: background-color 0.3s;
                }

                .category-filter button:hover {
                    background-color: #45a049;
                }

                .product-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                    gap: 20px;
                    margin-top: 20px;
                }

                .product-card {
                    background: #fff;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    transition: transform 0.3s, box-shadow 0.3s;
                }

                .product-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                }

                .product-image {
                    position: relative;
                    overflow: hidden;
                }

                .product-image img {
                    width: 90%;
                    height: 100%;
                    object-fit: cover;
                }

                .product-tag {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                    background: #e53935;
                    color: white;
                    padding: 5px 10px;
                    border-radius: 4px;
                    font-size: 12px;
                    font-weight: bold;
                }

                .product-title {
                    margin: 15px;
                    font-size: 16px;
                }

                .product-title a {
                    color: #333;
                    text-decoration: none;
                }

                .product-title a:hover {
                    color: #fbbf24;
                }


                .product-meta {
                    margin: 10px 15px;
                    color: #757575;
                    font-size: 14px;
                }

                .product-price {
                    margin: 15px;
                    color: #4caf50;
                    font-size: 18px;
                    font-weight: bold;
                }

                .add-to-cart-btn {
                    display: block;
                    width: calc(100% - 30px);
                    margin: 10px 15px 15px;
                    padding: 10px 0;
                    background-color: #feff46;
                    color: black;
                    border: none;
                    border-radius: 4px;
                    text-align: center;
                    font-size: 14px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: background-color 0.3s;
                }

                .add-to-cart-btn:hover {
                    background-color: #fbbf24;

                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="category-header">
                    <h1>${selectedCategory != null ? selectedCategory : 'All Products'}</h1>
                    <span class="item-count">${allItems.size()} items found</span>
                </div>

                <div class="category-filter">
                    <form action="ItemCategoryServlet" method="get">
                        <label for="category">Filter by Category:</label>
                        <select name="category" id="category">
                            <option value="">All Categories</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category}" ${category eq selectedCategory ? 'selected' : '' }>
                                    ${category}</option>
                            </c:forEach>
                        </select>
                        <button type="submit">Filter</button>
                    </form>
                </div>

                <div class="product-grid">
                    <c:forEach items="${allItems}" var="item">

                        <div class="product-card">
                            <div class="product-image">
                                <img src="./image/item${item.itemID}.jpg" alt="${item.name}">
                            </div>
                            <h3 class="product-title">
                                <a href="SelectItemServlet?itemId=${item.itemID}">${item.name}</a>
                            </h3>
                            <div class="product-price">Rs.${item.price}</div>
                            <form action="${pageContext.request.contextPath}/customer/CartServlet" method="post">
                                <input type="hidden" name="itemId" value="${item.itemID}">
                                <input type="hidden" name="quantity" value="1">
                                <input type="hidden" name="itemName" value="${item.name}">
                                <input type="hidden" name="itemPrice" value="${item.price}">
                                <input type="hidden" name="itemDescription" value="${item.description}">
                                <button type="submit" class="add-to-cart-btn">Add To Cart</button>
                            </form>
                        </div>




                    </c:forEach>
                </div>

                <script>
                    // Make stars display properly using Font Awesome
                    document.addEventListener('DOMContentLoaded', function () {
                        const starElements = document.querySelectorAll('.stars i');
                        starElements.forEach(star => {
                            if (star.className.includes('half-alt')) {
                                star.className = 'fas fa-star-half-alt';
                            }
                        });

                        // Add to cart functionality
                        const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
                        addToCartButtons.forEach(button => {
                            button.addEventListener('click', function () {
                                // Get product details from the parent card
                                const card = this.closest('.product-card');
                                const productName = card.querySelector('.product-title a').textContent;

                                alert('Added ' + productName + ' to your cart!');
                                // In a real implementation, you would make an AJAX call to add the item to the cart
                            });
                        });
                    });
                </script>
        </body>

        </html>