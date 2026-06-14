<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <title>Secure Payment - Farmart</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Modern Style -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/payment_modern.css">
        <style>
          *, *::before, *::after {
            box-sizing: border-box;
          }
        </style>
      </head>

      <body>

        <div class="payment-container">

          <!-- Left Column: Payment Form -->
          <div class="glass-panel">
            <div class="header-row">
              <h2 style="margin:0; font-weight:800; font-size:1.5rem;">Payment Details</h2>
              <div class="secure-badge">
                <i class="fas fa-lock"></i> SSL Secured
              </div>
            </div>

            <!-- Live Virtual Card -->
            <div class="credit-card">
              <div class="chip"></div>
              <div class="card-number-display" id="cardNumDisplay">#### #### #### ####</div>
              <div class="card-details-row">
                <div>
                  <div class="card-label">Card Holder</div>
                  <div id="cardNameDisplay">YOUR NAME</div>
                </div>
                <div>
                  <div class="card-label">Expires</div>
                  <div id="cardExpDisplay">MM/YY</div>
                </div>
              </div>
              <i class="fab fa-cc-visa"
                style="position: absolute; bottom: 25px; right: 25px; font-size: 2.5rem; opacity: 0.8;"></i>
            </div>

            <form action="api_complete_order.jsp" method="post" id="paymentForm">

              <!-- Pass-through Data -->
              <input type="hidden" name="name" value="${requestScope.name}">
              <input type="hidden" name="phone" value="${requestScope.phone}">
              <input type="hidden" name="email" value="${requestScope.email}">
              <input type="hidden" name="address" value="${requestScope.address}">
              <input type="hidden" name="city" value="${requestScope.city}">
              <input type="hidden" name="province" value="${requestScope.province}">
              <input type="hidden" name="zipcode" value="${requestScope.zipcode}">
              <input type="hidden" name="paymentMethod" value="${requestScope.paymentMethod}">
              <input type="hidden" name="subtotal" value="${requestScope.subtotal}">
              <input type="hidden" name="tax" value="${requestScope.tax}">
              <input type="hidden" name="deliveryFee" value="${requestScope.deliveryFee}">
              <input type="hidden" name="total" value="${requestScope.total}">

              <div class="form-grid">
                <div class="form-field">
                  <label class="field-label">Card Number</label>
                  <div class="input-wrapper">
                    <i class="far fa-credit-card input-icon"></i>
                    <input type="text" class="modern-input" id="cardNumInput" placeholder="0000 0000 0000 0000"
                      maxlength="19" required>
                  </div>
                </div>

                <div class="form-field">
                  <label class="field-label">Cardholder Name</label>
                  <div class="input-wrapper">
                    <i class="far fa-user input-icon"></i>
                    <input type="text" class="modern-input" id="cardNameInput" placeholder="JOHN DOE" required>
                  </div>
                </div>

                <div class="row-inputs">
                  <div class="form-field">
                    <label class="field-label">Expiry Date</label>
                    <div class="input-wrapper">
                      <i class="far fa-calendar-alt input-icon"></i>
                      <input type="text" class="modern-input" id="cardExpInput" placeholder="MM/YY" maxlength="5"
                        required>
                    </div>
                  </div>
                  <div class="form-field">
                    <label class="field-label">CVC / CVV</label>
                    <div class="input-wrapper">
                      <i class="fas fa-key input-icon"></i>
                      <input type="password" class="modern-input" placeholder="123" maxlength="3" required>
                    </div>
                  </div>
                </div>
              </div>

              <button type="submit" class="pay-btn">
                Pay Rs. ${param.total} <i class="fas fa-arrow-right"></i>
              </button>

            </form>
          </div>

          <!-- Right Column: Summary -->
          <div class="summary-panel">
            <div class="summary-title">Order Summary</div>

            <div class="bill-row">
              <span>Subtotal</span>
              <span>Rs. ${param.subtotal}</span>
            </div>
            <div class="bill-row">
              <span>Tax (10%)</span>
              <span>Rs. ${param.tax}</span>
            </div>
            <div class="bill-row">
              <span>Shipping</span>
              <span>Rs. ${param.deliveryFee}</span>
            </div>

            <div class="total-row">
              <span>Total Amount</span>
              <span>Rs. ${param.total}</span>
            </div>

            <div class="timer-badge">
              <i class="far fa-clock"></i> Session expires in <span id="timer">05:00</span>
            </div>

            <div style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
              <div style="font-size: 0.85rem; color: #6B7280; line-height: 1.5;">
                <p><strong>Safe & Secure Payment per industry standards.</strong></p>
                Payments are processed by SecurePay. We do not store your full card details.
              </div>
              <div style="margin-top: 15px; display: flex; gap: 10px; opacity: 0.6;">
                <i class="fab fa-cc-visa fa-2x"></i>
                <i class="fab fa-cc-mastercard fa-2x"></i>
                <i class="fab fa-cc-amex fa-2x"></i>
              </div>
            </div>
          </div>

        </div>

        <script>
          // Live Card Update Script
          const cardNumInput = document.getElementById('cardNumInput');
          const cardNumDisplay = document.getElementById('cardNumDisplay');
          const cardNameInput = document.getElementById('cardNameInput');
          const cardNameDisplay = document.getElementById('cardNameDisplay');
          const cardExpInput = document.getElementById('cardExpInput');
          const cardExpDisplay = document.getElementById('cardExpDisplay');

          cardNumInput.addEventListener('input', (e) => {
            let val = e.target.value.replace(/\D/g, '').substring(0, 16);
            val = val.match(/.{1,4}/g)?.join(' ') || val;
            e.target.value = val;
            cardNumDisplay.textContent = val || '#### #### #### ####';
          });

          cardNameInput.addEventListener('input', (e) => {
            cardNameDisplay.textContent = e.target.value.toUpperCase() || 'YOUR NAME';
          });

          cardExpInput.addEventListener('input', (e) => {
            let val = e.target.value.replace(/\D/g, '').substring(0, 4);
            if (val.length >= 2) val = val.substring(0, 2) + '/' + val.substring(2);
            e.target.value = val;
            cardExpDisplay.textContent = val || 'MM/YY';
          });

          // Simple Countdown
          let time = 300; // 5 minutes
          setInterval(() => {
            if (time <= 0) return;
            time--;
            const min = Math.floor(time / 60);
            const sec = time % 60;
            document.getElementById('timer').textContent = `0${min}:${sec < 10 ? '0' + sec : sec}`;
          }, 1000);
        </script>

      </body>

      </html>