<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <!DOCTYPE html>
      <html>

      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart - Online Grocery Store</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/cart_modern.css">
      </head>

      <body>
        <jsp:include page="index_navbar.jsp" />

        <div class="cart-perspective">
          <div class="page-header">
            <h1 class="page-title">Shopping Cart</h1>
            <div class="breadcrumb">
              <a href="${pageContext.request.contextPath}/customer/index.jsp">Home</a> / <span>Your Cart</span>
            </div>
          </div>

          <c:choose>
            <c:when test="${empty sessionScope.cart}">
              <div class="empty-cart-container">
                <div class="empty-icon-3d">🛒</div>
                <h2 class="empty-title">Your cart is feeling light</h2>
                <p style="color: var(--text-medium); margin-bottom: 2rem; font-size: 1.1rem;">
                  Looks like you haven't added anything yet.<br>Explorer our fresh products and find something you love!
                </p>
                <a href="${pageContext.request.contextPath}/customer/ItemCategoryServlet" class="continue-btn">
                  Start Shopping <i class="fas fa-arrow-right" style="margin-left: 8px;"></i>
                </a>
              </div>
            </c:when>
            <c:otherwise>
              <div class="cart-layout">
                <!-- Cart Items Grid -->
                <div class="cart-items-container">
                  <c:set var="subtotal" value="0" />

                  <c:forEach items="${sessionScope.cart}" var="item">
                    <div class="cart-item-card" data-price="${item.itemPrice}">
                      <div class="item-visual">
                        <img src="${pageContext.request.contextPath}/customer/image/item${item.itemId}.jpg"
                          alt="${item.itemName}" class="item-img"
                          onerror="this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg'">
                      </div>

                      <div class="item-info">
                        <h3>${item.itemName}</h3>
                        <div class="item-desc">${item.itemDescription}</div>
                        <div class="item-meta">
                          <div class="price-tag">
                            Rs.
                            <fmt:formatNumber value="${item.itemPrice}" pattern="#,##0.00" />
                          </div>

                          <!-- Quantity Control Preview -->
                          <div class="qty-control">
                            <button class="qty-btn" onclick="updateQty(this, -1, ${item.itemId})">-</button>
                            <span class="qty-display">${item.quantity}</span>
                            <button class="qty-btn" onclick="updateQty(this, 1, ${item.itemId})">+</button>
                          </div>
                        </div>
                      </div>

                      <div class="item-actions">
                        <form action="${pageContext.request.contextPath}/customer/RemoveCartItemServlet" method="post">
                          <input type="hidden" name="itemId" value="${item.itemId}">
                          <button type="submit" class="remove-btn">
                            <i class="fas fa-trash-alt"></i> Remove
                          </button>
                        </form>
                        <div style="text-align: right; margin-top: 10px; font-weight: 600; color: var(--text-dark);" class="item-total-display">
                          Total: Rs. <fmt:formatNumber value="${item.itemPrice * item.quantity}" pattern="#,##0.00" />
                        </div>
                      </div>
                    </div>
                    <c:set var="subtotal" value="${subtotal + (item.itemPrice * item.quantity)}" />
                  </c:forEach>
                </div>

                <!-- Summary Panel -->
                <div class="summary-panel">
                  <div class="summary-title">
                    <i class="fas fa-receipt" style="color: var(--primary-emerald);"></i> Order Summary
                  </div>

                  <div class="summary-row">
                    <span>Subtotal (<span id="summary-items-count">${sessionScope.cart.size()}</span> items)</span>
                    <span style="font-weight: 600;" id="summary-subtotal">Rs. <fmt:formatNumber value="${subtotal}" pattern="#,##0.00" /></span>
                  </div>

                  <c:set var="tax" value="${subtotal * 0.1}" />
                  <div class="summary-row">
                    <span>Estimated Tax (10%)</span>
                    <span id="summary-tax">Rs. <fmt:formatNumber value="${tax}" pattern="#,##0.00" /></span>
                  </div>

                  <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span style="color: var(--primary-emerald);">Rs. 150.00</span>
                  </div>

                  <c:set var="total" value="${subtotal + tax + 150}" />
                  <div class="summary-row total">
                    <span>Total Amount</span>
                    <span id="summary-total">Rs. <fmt:formatNumber value="${total}" pattern="#,##0.00" /></span>
                  </div>

                  <c:choose>
                    <c:when test="${empty sessionScope.userID}">
                      <form action="login.jsp" method="get">
                        <button type="submit" class="checkout-btn" style="background: #D97706;">
                          Login to Checkout <i class="fas fa-sign-in-alt" style="margin-left: 10px;"></i>
                        </button>
                      </form>
                    </c:when>
                    <c:otherwise>
                      <form action="${pageContext.request.contextPath}/customer/checkout.jsp" method="post">
                        <!-- Forward totals to checkout.jsp -->
                        <input type="hidden" name="subtotal" value="${subtotal}">
                        <input type="hidden" name="tax" value="${tax}">
                        <input type="hidden" name="deliveryFee" value="150.0">
                        <input type="hidden" name="total" value="${total}">
                        <button type="submit" class="checkout-btn">
                          Proceed to Checkout <i class="fas fa-credit-card" style="margin-left: 10px;"></i>
                        </button>
                      </form>
                    </c:otherwise>
                  </c:choose>

                  <div style="text-align: center; margin-top: 1.5rem;">
                    <a href="${pageContext.request.contextPath}/customer/ItemCategoryServlet"
                      style="color: var(--text-medium); text-decoration: none; font-size: 0.9rem;">
                      <i class="fas fa-arrow-left"></i> Continue Shopping
                    </a>
                  </div>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <script>
          function updateQty(btn, change, itemId) {
            const card = btn.closest('.cart-item-card');
            const display = btn.parentElement.querySelector('.qty-display');
            let currentQty = parseInt(display.textContent);
            let newQty = currentQty + change;

            if (newQty >= 1) {
              display.textContent = newQty;
              
              // 1. Update individual item total
              const priceText = card.getAttribute('data-price');
              const price = parseFloat(priceText);
              const itemTotalEl = card.querySelector('.item-total-display');
              itemTotalEl.innerHTML = 'Total: Rs. ' + (price * newQty).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});

              // 2. Update overall totals
              recalculateTotals();

              // 3. Send AJAX request to update session in backend silently
              const formData = new URLSearchParams();
              formData.append('cartItemId', itemId);
              formData.append('quantity', newQty);

              fetch('${pageContext.request.contextPath}/customer/UpdateCartItemServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
              }).then(() => {
                  fetch('${pageContext.request.contextPath}/customer/api_cart_sync.jsp').catch(e => console.log('Cart sync silent fail'));
              }).then(response => {
                console.log('Session cart updated.');
              }).catch(err => console.error('Error updating quantity:', err));
            }
          }

          function recalculateTotals() {
             let subtotal = 0;
             const cards = document.querySelectorAll('.cart-item-card');
             cards.forEach(card => {
                const qty = parseInt(card.querySelector('.qty-display').textContent);
                const price = parseFloat(card.getAttribute('data-price'));
                subtotal += (qty * price);
             });

             const tax = subtotal * 0.1;
             const delivery = 150.0;
             const total = subtotal + tax + delivery;

             document.getElementById('summary-subtotal').textContent = 'Rs. ' + subtotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
             document.getElementById('summary-tax').textContent = 'Rs. ' + tax.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
             document.getElementById('summary-total').textContent = 'Rs. ' + total.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
          }

          // Automatically sync the session cart to Database if the user is logged in
          document.addEventListener('DOMContentLoaded', () => {
              fetch('${pageContext.request.contextPath}/customer/api_cart_sync.jsp').catch(e => console.log('Cart sync silent fail'));
          });
        </script>
        
        <jsp:include page="footer.jsp" />
      </body>

      </html>