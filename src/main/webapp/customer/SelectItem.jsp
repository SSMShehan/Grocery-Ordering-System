<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <jsp:include page="index_navbar.jsp" />
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${item.name}</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                }

                body {
                    background-color: #f5f5f5;
                    color: #333;
                    line-height: 1.6;
                }

                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                    margin-top: 25px;
                    margin-bottom: 25px;
                }

                .product-container {
                    display: flex;
                    flex-wrap: wrap;
                    background: #fff;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .product-gallery {
                    flex: 1;
                    min-width: 300px;
                    border-right: 1px solid #eee;
                    padding: 20px;
                    display: flex;
                    flex-direction: column;
                }

                .main-image {
                    border: 2px solid #fbbf24;
                    border-radius: 10px;
                    padding: 20px;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    margin-bottom: 20px;
                    overflow: hidden;
                }

                .main-image img {
                    max-width: 100%;
                    height: auto;
                    max-height: 500px;
                    object-fit: contain;
                }

                .product-details {
                    flex: 1;
                    min-width: 300px;
                    padding: 30px;
                }

                .product-title {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 5px;
                    color: #222;
                }

                .product-id {
                    color: #666;
                    margin-bottom: 20px;
                }

                .product-price {
                    font-size: 24px;
                    color: #6cba5a;
                    font-weight: 600;
                    margin-bottom: 25px;
                }

                .unit {
                    font-size: 20px;
                    color: #6cba5a;
                }

                /* Quantity Controls */
                .quantity-container {
                    display: flex;
                    align-items: center;
                    margin-bottom: 25px;
                    gap: 15px;
                }

                .quantity-label {
                    font-weight: 600;
                    color: #555;
                }

                .quantity-controls {
                    display: flex;
                    align-items: center;
                    border: 1px solid #ddd;
                    border-radius: 30px;
                    overflow: hidden;
                }

                .quantity-btn {
                    width: 40px;
                    height: 40px;
                    background-color: #f5f5f5;
                    border: none;
                    font-size: 18px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: background-color 0.3s;
                }

                .quantity-btn:hover {
                    background-color: #e0e0e0;
                }

                .quantity-input {
                    width: 60px;
                    height: 40px;
                    border: none;
                    text-align: center;
                    font-size: 16px;
                    font-weight: 600;
                    -moz-appearance: textfield;
                }

                .quantity-input::-webkit-outer-spin-button,
                .quantity-input::-webkit-inner-spin-button {
                    -webkit-appearance: none;
                    margin: 0;
                }

                .add-to-cart {
                    background-color: #fbbf24;
                    color: white;
                    border: none;
                    border-radius: 30px;
                    padding: 15px 30px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 10px;
                    width: 100%;
                    max-width: 300px;
                    margin-bottom: 30px;
                    transition: background-color 0.3s;
                }

                .add-to-cart:hover {
                    background-color: #FFFF00;
                }

                .cart-icon {
                    font-size: 20px;
                }

                .product-categories {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10px;
                    margin-bottom: 25px;
                }

                .category {
                    background-color: #f0f8eb;
                    color: #6cba5a;
                    padding: 5px 15px;
                    border-radius: 20px;
                    font-size: 14px;
                    font-weight: 500;
                }

                .product-description {
                    margin-top: 30px;
                    border-top: 1px solid #eee;
                    padding-top: 20px;
                }

                .description-title {
                    font-size: 18px;
                    font-weight: 600;
                    margin-bottom: 15px;
                    color: #444;
                }

                .description-text {
                    color: #666;
                    line-height: 1.8;
                }

                @media (max-width: 768px) {
                    .product-container {
                        flex-direction: column;
                    }

                    .product-gallery {
                        border-right: none;
                        border-bottom: 1px solid #eee;
                    }
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="product-container">
                    <div class="product-gallery">
                        <div class="main-image">
                            <img src="./image/item${item.itemID}.jpg" alt="${item.name}">
                        </div>
                    </div>

                    <div class="product-details">
                        <h1 class="product-title">${item.name}</h1>

                        <div class="product-price">
                            Rs ${item.price} <span class="unit">/ Unit</span>
                        </div>

                        <form action="add_cart_handler.jsp" method="post">
                            <input type="hidden" name="itemId" value="${item.itemID}">
                            <!-- Hidden fields to pass item details for session-based cart (No DB) -->
                            <input type="hidden" name="itemName" value="${item.name}">
                            <input type="hidden" name="itemPrice" value="${item.price}">
                            <input type="hidden" name="itemDescription" value="${item.description}">

                            <div class="quantity-container">
                                <span class="quantity-label">Quantity:</span>
                                <div class="quantity-controls">
                                    <button type="button" class="quantity-btn minus-btn">-</button>
                                    <input type="number" name="quantity" class="quantity-input" value="1" min="1"
                                        max="100">
                                    <button type="button" class="quantity-btn plus-btn">+</button>
                                </div>
                            </div>

                            <button type="submit" class="add-to-cart">
                                <span class="cart-icon">🛒</span>Add To Cart
                            </button>
                        </form>

                        <div class="product-description">
                            <h3 class="description-title">Product Description</h3>
                            <p class="description-text">
                                ${item.description}
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const minusBtn = document.querySelector('.minus-btn');
                    const plusBtn = document.querySelector('.plus-btn');
                    const quantityInput = document.querySelector('.quantity-input');

                    // Decrease quantity
                    minusBtn.addEventListener('click', function () {
                        let currentValue = parseInt(quantityInput.value);
                        if (currentValue > 1) {
                            quantityInput.value = currentValue - 1;
                        }
                    });

                    // Increase quantity
                    plusBtn.addEventListener('click', function () {
                        let currentValue = parseInt(quantityInput.value);
                        if (currentValue < 100) {
                            quantityInput.value = currentValue + 1;
                        }
                    });

                    // Validate input
                    quantityInput.addEventListener('change', function () {
                        let value = parseInt(this.value);
                        if (isNaN(value) || value < 1) {
                            this.value = 1;
                        } else if (value > 100) {
                            this.value = 100;
                        }
                    });
                });
            </script>
        </body>

        </html>