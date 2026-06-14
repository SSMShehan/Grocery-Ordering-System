<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Security Check
    HttpSession userSession = request.getSession(false);
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String orderID = request.getParameter("orderID");
    String status = request.getParameter("status");

    if (orderID == null || status == null) {
        response.sendRedirect("order.jsp?error=Missing parameters");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;
    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        pst = con.prepareStatement("UPDATE \"order\" SET order_status = ? WHERE \"orderID\" = ?");
        pst.setString(1, status);
        pst.setInt(2, Integer.parseInt(orderID));
        
        int row = pst.executeUpdate();
        if (row > 0) {
            response.sendRedirect("order.jsp?msg=Order #" + orderID + " status updated to " + status + "!");
        } else {
            response.sendRedirect("order.jsp?error=Order not found");
        }
    } catch(Exception e) {
        response.sendRedirect("order.jsp?error=" + e.getMessage());
    } finally {
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
