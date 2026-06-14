<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <title>Order Confirmed! - Farmart</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Modern Styles -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/confirmation_modern.css">

        <!-- Canvas Confetti Lib (Lightweight) -->
        <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
      </head>

      <body>

        <!-- Confetti Canvas -->
        <canvas id="confetti-canvas" class="confetti-canvas"></canvas>

        <div class="success-card">
          <div class="check-container">
            <i class="fas fa-check check-icon"></i>
          </div>

          <h1 class="title-large">Thank You!</h1>

          <p class="subtitle">
            Woohoo! Your order has been placed successfully.<br>
            A confirmation email has been sent to <span class="email-highlight">${param.email}</span>
          </p>

          <!-- Receipt Summary -->
          <div class="receipt-box">
            <div class="receipt-row">
              <span>Payment Method</span>
              <span style="text-transform: capitalize; font-weight:600;">
                <i class="far fa-credit-card"></i> ${param.paymentMethod != null ? param.paymentMethod : 'Card'}
              </span>
            </div>
            <div class="receipt-row">
              <span>Date</span>
              <span id="orderDate"></span>
            </div>
            <div class="receipt-total">
              <span>Total Paid</span>
              <span style="color:var(--primary-dark);">Rs. ${param.total}</span>
            </div>
          </div>

          <p style="font-size: 0.9rem; color: #666; margin-bottom: 30px;">
            Order ID: #<span style="font-weight: bold; color: var(--primary-mint);">${param.orderID}</span><br>
            Your items will be delivered to <strong>${param.address}, ${param.city}, ${param.province} ${param.zipcode}</strong> soon.
          </p>

          <div class="btn-group">
            <a href="${pageContext.request.contextPath}/customer/index.jsp" class="btn-outline">
              Home
            </a>
            <a href="${pageContext.request.contextPath}/customer/index.jsp" class="btn-primary">
              Continue Shopping <i class="fas fa-arrow-right"></i>
            </a>
          </div>
        </div>

        <script>
          // 1. Trigger Confetti
          window.addEventListener('load', () => {
            const duration = 3000;
            const animationEnd = Date.now() + duration;
            const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 0 };

            const randomInRange = (min, max) => Math.random() * (max - min) + min;

            const interval = setInterval(function () {
              const timeLeft = animationEnd - Date.now();

              if (timeLeft <= 0) {
                return clearInterval(interval);
              }

              const particleCount = 50 * (timeLeft / duration);

              // multiple origins
              confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 } }));
              confetti(Object.assign({}, defaults, { particleCount, origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 } }));
            }, 250);
          });

          // 2. Set Current Date
          const options = { year: 'numeric', month: 'long', day: 'numeric' };
          document.getElementById('orderDate').textContent = new Date().toLocaleDateString('en-US', options);

          // 3. (Mock generator removed in favor of real DB ID)
        </script>

      </body>

      </html>