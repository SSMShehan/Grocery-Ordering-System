<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String preEmail = "";
    String prePhone = "";
    Integer uID = (Integer) session.getAttribute("userID");
    
    String preAddress = "";
    String preCity = "";
    String preProvince = "";
    String preZip = "";
    
    // DB Setup for Delivery Slots & User
    Connection con = null; PreparedStatement pstU = null; Statement stmtS = null;
    ResultSet rsU = null; ResultSet rsS = null;
    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        if (uID != null) {
            pstU = con.prepareStatement("SELECT email, phone, address, city, province, zipcode FROM customer WHERE \"cusID\" = ?");
            pstU.setInt(1, uID);
            rsU = pstU.executeQuery();
            if (rsU.next()) {
                preEmail = rsU.getString("email") != null ? rsU.getString("email") : "";
                prePhone = rsU.getString("phone") != null ? rsU.getString("phone") : "";
                preAddress = rsU.getString("address") != null ? rsU.getString("address") : "";
                preCity = rsU.getString("city") != null ? rsU.getString("city") : "";
                preProvince = rsU.getString("province") != null ? rsU.getString("province") : "";
                preZip = rsU.getString("zipcode") != null ? rsU.getString("zipcode") : "";
            }
        }
        stmtS = con.createStatement();
        rsS = stmtS.executeQuery("SELECT * FROM delivery_slot");
        request.setAttribute("rsSlots", rsS); // we will iterate this manually below
    } catch(Exception e) {}
%>

<jsp:include page="index_navbar.jsp" />

      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="UTF-8">
        <title>Secure Checkout - Farmart</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Modern Fonts & Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Styles -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/index_navbar_nextgen.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/checkout_modern.css">
      </head>

      <body>

        <div class="checkout-container">
          <h1 class="page-title">Finalize Your Order</h1>

          <div class="checkout-grid">
            <!-- Left Column: User Details Form -->
            <div class="glass-card">
              <div class="card-header">
                <h2><i class="fas fa-user-shield"></i> Shipping & Billing Details</h2>
              </div>

              <div class="card-body">
                <form action="${pageContext.request.contextPath}/customer/PlaceOrderServlet" method="post"
                  id="checkoutForm">
                  <div class="form-group">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" id="name" name="name" class="form-control" placeholder="John Doe" value="${sessionScope.username}" required>
                  </div>

                  <div class="form-group">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                      <div>
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control" placeholder="+94 7X XXX XXXX" value="<%= prePhone %>" required>
                      </div>
                      <div>
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="john@example.com" value="<%= preEmail %>" required>
                      </div>
                    </div>
                  </div>

                  <!-- Delivery Slot Removed -->

                  <div class="form-group">
                    <label for="address" class="form-label">Street Address</label>
                    <textarea id="address" name="address" class="form-control" rows="2"
                      placeholder="No. 123, Street Name" required><%= preAddress %></textarea>
                  </div>
                  
                  <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                      <div>
                        <label for="city" class="form-label">City</label>
                        <input type="text" id="city" name="city" class="form-control" placeholder="Colombo" value="<%= preCity %>" required>
                      </div>
                      <div>
                        <label for="province" class="form-label">Province / State</label>
                        <input type="text" id="province" name="province" class="form-control" placeholder="Western" value="<%= preProvince %>" required>
                      </div>
                  </div>
                  
                  <div class="form-group" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                      <div>
                        <label for="zipcode" class="form-label">Zip/Postal Code</label>
                        <input type="text" id="zipcode" name="zipcode" class="form-control" placeholder="10100" value="<%= preZip %>" required>
                      </div>
                      <div></div>
                  </div>

                  <div class="form-group">
                    <label class="form-label">Payment Method</label>
                    <div class="payment-grid">
                      <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="visa" checked>
                        <div class="payment-card-box">
                          <img src="${pageContext.request.contextPath}/customer/image/visa.png" alt="Visa"
                            class="payment-icon">
                          <span class="payment-name">Visa</span>
                        </div>
                      </label>

                      <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="mastercard">
                        <div class="payment-card-box">
                          <img src="${pageContext.request.contextPath}/customer/image/master.png" alt="MasterCard"
                            class="payment-icon">
                          <span class="payment-name">MasterCard</span>
                        </div>
                      </label>

                      <label class="payment-option">
                        <input type="radio" name="paymentMethod" value="amex">
                        <div class="payment-card-box">
                          <img src="${pageContext.request.contextPath}/customer/image/amex.png" alt="Amex"
                            class="payment-icon">
                          <span class="payment-name">Amex</span>
                        </div>
                      </label>
                    </div>
                  </div>

                  <!-- Hidden Fields for Totals -->
                  <input type="hidden" name="subtotal" value="${param.subtotal}">
                  <input type="hidden" name="tax" value="${param.tax}">
                  <input type="hidden" name="deliveryFee" value="${param.deliveryFee}">
                  <input type="hidden" name="total" value="${param.total}">

                  <!-- Submit Button (Mobile Order: button appears here) -->
                  <button type="submit" class="checkout-btn mobile-only" style="display:none;">
                    Confirm Order <i class="fas fa-arrow-right"></i>
                  </button>

                </form>

                <a href="${pageContext.request.contextPath}/customer/ViewCart" class="back-link">
                  <i class="fas fa-arrow-left"></i> Return to Cart
                </a>
              </div>
            </div>

            <!-- Right Column: Order Summary -->
            <div class="glass-card" style="height: fit-content; position: sticky; top: 20px;">
              <div class="card-header" style="background: linear-gradient(135deg, var(--accent-color), #D97706);">
                <h2><i class="fas fa-receipt"></i> Order Summary</h2>
              </div>

              <div class="card-body">
                <!-- Item Preview Loop -->
                <div style="margin-bottom: 20px; max-height: 200px; overflow-y: auto;">
                  <c:forEach items="${sessionScope.cart}" var="item">
                    <div style="display:flex; justify-content:space-between; font-size: 0.9rem; margin-bottom: 8px;">
                      <span>${item.itemName} <span style="color:#888;">x${item.quantity}</span></span>
                      <span style="font-weight:600;">Rs.
                        <fmt:formatNumber value="${item.itemPrice * item.quantity}" pattern="#,##0.00" />
                      </span>
                    </div>
                  </c:forEach>
                </div>

                <hr style="border: 0; border-top: 1px dashed #ddd; margin-bottom: 15px;">

                <div class="summary-item">
                  <span>Subtotal</span>
                  <span>Rs. ${param.subtotal}</span>
                </div>
                <div class="summary-item">
                  <span>Tax (10%)</span>
                  <span>Rs. ${param.tax}</span>
                </div>
                <div class="summary-item">
                  <span>Delivery Fee</span>
                  <span>Rs. ${param.deliveryFee}</span>
                </div>

                <div class="summary-item total">
                  <span>TOTAL</span>
                  <span style="color: var(--primary-dark);">Rs. ${param.total}</span>
                </div>

                <button type="submit" form="checkoutForm" class="checkout-btn">
                  Place Order <i class="fas fa-check-circle"></i>
                </button>

                <div style="text-align: center; margin-top: 15px; font-size: 0.8rem; color: #888;">
                  <i class="fas fa-lock"></i> Secure 256-bit SSL Encrypted
                </div>
              </div>
            </div>

          </div>
        </div>

        <jsp:include page="footer.jsp" />

      </body>
<%
    // Clean up DB resources
    if(rsU!=null)try{rsU.close();}catch(Exception e){}
    if(rsS!=null)try{rsS.close();}catch(Exception e){}
    if(pstU!=null)try{pstU.close();}catch(Exception e){}
    if(stmtS!=null)try{stmtS.close();}catch(Exception e){}
    if(con!=null)try{con.close();}catch(Exception e){}
%>
      </html>