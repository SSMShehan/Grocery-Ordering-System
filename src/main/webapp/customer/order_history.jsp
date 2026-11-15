<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    Integer uID = (Integer) session.getAttribute("userID");
    if (uID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<jsp:include page="index_navbar.jsp" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders - Farmart</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <!-- Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/order_history.css">
</head>
<body>

<div class="history-container">
    <div class="history-header">
        <h1>My Orders</h1>
        <a href="index.jsp" style="text-decoration:none; color:var(--primary-mint); font-weight:600;"><i class="fas fa-arrow-left"></i> Continue Shopping</a>
    </div>

    <%
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        boolean hasOrders = false;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
            
            pst = con.prepareStatement("SELECT o.\"orderID\", o.amount, o.order_date, o.order_status, d.delivery_status " +
                                       "FROM \"order\" o LEFT JOIN order_delivery d ON o.\"orderID\" = d.\"orderID\" " +
                                       "WHERE o.\"cusID\" = ? ORDER BY o.\"orderID\" DESC");
            pst.setInt(1, uID);
            rs = pst.executeQuery();

            while (rs.next()) {
                hasOrders = true;
                int orderID = rs.getInt("orderID");
                String date = rs.getString("order_date");
                String amount = rs.getString("amount");
                String status = rs.getString("order_status"); // e.g., "In Progress", "Dispatched", "Delivered"
                
                // Calculate Progress Bar (1: Placed, 2: Processing, 3: Out for Delivery, 4: Delivered)
                int step = 1;
                if ("Processing".equalsIgnoreCase(status)) step = 2;
                else if ("Dispatched".equalsIgnoreCase(status) || "Out for Delivery".equalsIgnoreCase(status)) step = 3;
                else if ("Delivered".equalsIgnoreCase(status)) step = 4;
                
                int progressPercent = (step - 1) * 33;
    %>

    <div class="order-card">
        <div class="order-header">
            <div>
                <div class="order-id">Order #<%= orderID %></div>
                <div class="order-date">Placed on <%= date %></div>
            </div>
            <div class="order-amount">Rs. <%= amount %></div>
        </div>

        <!-- Live Tracking -->
        <div class="tracker-wrapper">
            <div class="track-step-container">
                <div class="track-progress-bar" style="width: <%= progressPercent %>%;"></div>
                
                <div class="track-step <%= step >= 1 ? "active" : "" %>">
                    <div class="track-icon"><i class="fas fa-clipboard-list"></i></div>
                    <div class="track-label">Placed</div>
                </div>
                <div class="track-step <%= step >= 2 ? "active" : "" %>">
                    <div class="track-icon"><i class="fas fa-box-open"></i></div>
                    <div class="track-label">Processing</div>
                </div>
                <div class="track-step <%= step >= 3 ? "active" : "" %>">
                    <div class="track-icon"><i class="fas fa-truck"></i></div>
                    <div class="track-label">Dispatched</div>
                </div>
                <div class="track-step <%= step >= 4 ? "active" : "" %>">
                    <div class="track-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="track-label">Delivered</div>
                </div>
            </div>
        </div>

        <div class="order-actions">
            <button class="btn-view" onclick="toggleDetails(<%= orderID %>)">
                <i class="fas fa-list"></i> View Items
            </button>
        </div>

        <!-- Expandable details container -->
        <div id="details-<%= orderID %>" class="order-details-pane">
            <div style="text-align:center; color:#6B7280;"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
        </div>
    </div>

    <%
            }
            if (!hasOrders) {
    %>
        <div style="text-align: center; padding: 50px; background: white; border-radius: 16px;">
            <i class="fas fa-shopping-bag fa-4x" style="color: #D1D5DB; margin-bottom: 20px;"></i>
            <h2>No Orders Yet</h2>
            <p style="color: #6B7280;">You haven't placed any orders. Start exploring our grocery items!</p>
            <br>
            <a href="index.jsp" style="padding: 12px 24px; background: var(--primary-mint); color: white; border-radius: 8px; text-decoration: none; font-weight: 600;">Shop Now</a>
        </div>
    <%
            }
        } catch(Exception e) {
            out.println("<p style='color:red;'>Error loading orders: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if(rs!=null)try{rs.close();}catch(Exception e){}
            if(pst!=null)try{pst.close();}catch(Exception e){}
            if(con!=null)try{con.close();}catch(Exception e){}
        }
    %>
</div>

<script>
    function toggleDetails(orderID) {
        const pane = document.getElementById('details-' + orderID);
        if (pane.classList.contains('open')) {
            pane.classList.remove('open');
            return;
        }
        
        pane.classList.add('open');
        
        // Fetch items via AJAX
        fetch('api_order_details.jsp?orderID=' + orderID)
            .then(res => res.text())
            .then(html => {
                pane.innerHTML = html;
            })
            .catch(err => {
                pane.innerHTML = '<div style="color:red;">Failed to load items.</div>';
            });
    }
</script>

<jsp:include page="footer.jsp" />

</body>
</html>
