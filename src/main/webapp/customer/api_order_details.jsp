<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer uID = (Integer) session.getAttribute("userID");
    String oIDStr = request.getParameter("orderID");

    if (uID == null || oIDStr == null) {
        out.print("<div style='color:red;'>Unauthorized</div>");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        pst = con.prepareStatement("SELECT oi.quantity, oi.price, i.name, i.\"itemID\" " +
                                   "FROM order_item oi " +
                                   "JOIN item i ON oi.\"itemID\" = i.\"itemID\" " +
                                   "JOIN \"order\" o ON oi.\"orderID\" = o.\"orderID\" " +
                                   "WHERE oi.\"orderID\" = ? AND o.\"cusID\" = ?");
        pst.setInt(1, Integer.parseInt(oIDStr));
        pst.setInt(2, uID);
        rs = pst.executeQuery();

        boolean hasItems = false;
        while (rs.next()) {
            hasItems = true;
            String name = rs.getString("name");
            String qty = rs.getString("quantity");
            String price = rs.getString("price");
            int itemID = rs.getInt("itemID");
            String imgSrc = "image/item" + itemID + ".jpg";
%>
        <div class="item-row">
            <img src="<%= imgSrc %>" class="item-img" alt="<%= name %>">
            <div class="item-info">
                <h4 class="item-title"><%= name %></h4>
                <div class="item-qty">Qty: <%= qty %></div>
            </div>
            <div class="item-price">Rs. <%= price %></div>
        </div>
<%
        }
        
        if (!hasItems) {
            out.print("<div style='color:#6B7280; font-size:0.9rem;'>No items found for this order.</div>");
        }

    } catch(Exception e) {
        out.print("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
    } finally {
        if(rs!=null)try{rs.close();}catch(Exception e){}
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
