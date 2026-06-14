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
    if(action == null) action = "";

    Connection con = null;
    PreparedStatement pst = null;
    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        if("create".equals(action)) {
            String name = request.getParameter("name");
            String price = request.getParameter("price");
            String qty = request.getParameter("quantity");
            String cat = request.getParameter("category");
            String desc = request.getParameter("description");
            
            pst = con.prepareStatement("INSERT INTO item (name, price, quantity, category, description) VALUES (?, ?, ?, ?, ?)");
            pst.setString(1, name);
            pst.setString(2, price);
            pst.setString(3, qty);
            pst.setString(4, cat);
            pst.setString(5, desc);
            pst.executeUpdate();
            
            response.sendRedirect("item.jsp?msg=Product added successfully");
            
        } else if("update".equals(action)) {
            String id = request.getParameter("itemID");
            String name = request.getParameter("name");
            String price = request.getParameter("price");
            String qty = request.getParameter("quantity");
            String cat = request.getParameter("category");
            String desc = request.getParameter("description");
            
            pst = con.prepareStatement("UPDATE item SET name=?, price=?, quantity=?, category=?, description=? WHERE \"itemID\"=?");
            pst.setString(1, name);
            pst.setString(2, price);
            pst.setString(3, qty);
            pst.setString(4, cat);
            pst.setString(5, desc);
            pst.setInt(6, Integer.parseInt(id));
            pst.executeUpdate();
            
            response.sendRedirect("item.jsp?msg=Product updated successfully");
            
        } else if("delete".equals(action)) {
            String id = request.getParameter("itemID");
            
            // Note: Cannot delete item if it is in an order (Foreign Key Constraint).
            // Usually, we would set status to inactive instead. Let's try deleting first.
            pst = con.prepareStatement("DELETE FROM item WHERE \"itemID\"=?");
            pst.setInt(1, Integer.parseInt(id));
            pst.executeUpdate();
            
            response.sendRedirect("item.jsp?msg=Product deleted successfully");
        } else {
            response.sendRedirect("item.jsp?error=Invalid action");
        }
    } catch(Exception e) {
        response.sendRedirect("item.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
