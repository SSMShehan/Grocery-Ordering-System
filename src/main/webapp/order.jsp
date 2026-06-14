<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="admin_navbar.jsp" %>

<h1 class="page-title">Manage Orders</h1>

<%
    String msg = request.getParameter("msg");
    if(msg != null) {
        out.print("<div style='background:rgba(16,185,129,0.1); color:#10B981; padding:10px 20px; border-radius:8px; margin-bottom:20px;'>" + msg + "</div>");
    }
    String error = request.getParameter("error");
    if(error != null) {
        out.print("<div style='background:rgba(239,68,68,0.1); color:#EF4444; padding:10px 20px; border-radius:8px; margin-bottom:20px;'>" + error + "</div>");
    }
%>

<div class="admin-table-container">
    <div class="admin-table-header" style="display:flex; justify-content:space-between; align-items:center;">
        <h2>Recent Orders</h2>
        <form method="GET" action="order.jsp" style="display:flex; gap:10px;">
            <input type="text" name="search" placeholder="Search customer or order ID..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" style="padding:8px 12px; border-radius:6px; border:1px solid var(--border-color); background:rgba(0,0,0,0.2); color:white;">
            <button type="submit" class="btn-primary" style="padding:8px 15px;">Search</button>
            <% if(request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
                <a href="order.jsp" class="btn-primary" style="background:#4B5563; padding:8px 15px; text-decoration:none;">Clear</a>
            <% } %>
        </form>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Date</th>
                <th>Amount</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    String searchParam = request.getParameter("search");

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        String sql = "SELECT o.\"orderID\", o.order_date, o.amount, o.order_status, u.username " +
                     "FROM \"order\" o " +
                     "LEFT JOIN \"user\" u ON o.\"cusID\" = u.\"userID\" ";
        
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            sql += "WHERE u.username ILIKE ? OR CAST(o.\"orderID\" AS TEXT) ILIKE ? ";
            sql += "ORDER BY o.\"orderID\" DESC";
            pst = con.prepareStatement(sql);
            pst.setString(1, "%" + searchParam.trim() + "%");
            pst.setString(2, "%" + searchParam.trim() + "%");
        } else {
            sql += "ORDER BY o.\"orderID\" DESC";
            pst = con.prepareStatement(sql);
        }
        
        rs = pst.executeQuery();

        while(rs.next()) {
            int orderId = rs.getInt("orderID");
            String customerName = rs.getString("username");
            if(customerName == null) customerName = "Unknown Guest";
            String date = rs.getString("order_date");
            String amount = rs.getString("amount");
            String status = rs.getString("order_status");
            
            // Map status to badge class
            String badgeClass = "badge-pending";
            if(status.equalsIgnoreCase("Delivered")) badgeClass = "badge-delivered";
            else if(!status.equalsIgnoreCase("In Progress")) badgeClass = "badge-processing";
%>
            <tr>
                <td style="font-weight:600;">#<%= orderId %></td>
                <td><%= customerName %></td>
                <td><%= date %></td>
                <td style="color:var(--success); font-weight:600;">Rs. <%= amount %></td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                <td>
                    <form action="api_admin_order_update.jsp" method="post" style="display:flex; gap:10px; align-items:center;">
                        <input type="hidden" name="orderID" value="<%= orderId %>">
                        <select name="status" style="padding:6px; border-radius:6px; border:1px solid var(--border-color); background:var(--bg-dark); color:white;">
                            <option value="In Progress" <%= status.equals("In Progress")?"selected":"" %>>In Progress</option>
                            <option value="Processing" <%= status.equals("Processing")?"selected":"" %>>Processing</option>
                            <option value="Dispatched" <%= status.equals("Dispatched")?"selected":"" %>>Dispatched</option>
                            <option value="Delivered" <%= status.equals("Delivered")?"selected":"" %>>Delivered</option>
                        </select>
                        <button type="submit" class="btn-primary" style="padding:6px 12px; font-size:0.8rem;">Update</button>
                    </form>
                </td>
            </tr>
<%
        }
    } catch(Exception e) {
        out.print("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        if(rs!=null)try{rs.close();}catch(Exception e){}
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
        </tbody>
    </table>
</div>

<script>
    document.getElementById('nav-orders').classList.add('active');
</script>

        </div> <!-- End admin-content -->
    </main> <!-- End admin-main -->
</body>
</html>