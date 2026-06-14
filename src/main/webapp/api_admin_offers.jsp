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

    String action = request.getParameter("action");
    if(action == null) {
        response.sendRedirect("offers.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");

        if("update_offer".equals(action)) {
            int id = Integer.parseInt(request.getParameter("itemID"));
            int discount = Integer.parseInt(request.getParameter("discount"));

            pst = con.prepareStatement("UPDATE item SET discount_percentage=? WHERE \"itemID\"=?");
            pst.setInt(1, discount);
            pst.setInt(2, id);
            
            pst.executeUpdate();
            response.sendRedirect("offers.jsp?msg=Offer updated successfully");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("offers.jsp?error=Operation failed: " + e.getMessage());
    } finally {
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
