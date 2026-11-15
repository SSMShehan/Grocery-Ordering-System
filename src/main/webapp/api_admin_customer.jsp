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
        response.sendRedirect("customer.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");

        if(action.equals("create")) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String status = request.getParameter("status");

            pst = con.prepareStatement("INSERT INTO \"user\" (username, email, phone, password, status, role, register_date) VALUES (?, ?, ?, ?, ?, 'customer', CURRENT_DATE)");
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, password);
            pst.setString(5, status);
            
            pst.executeUpdate();
            response.sendRedirect("customer.jsp?msg=Customer added successfully");

        } else if(action.equals("update")) {
            int id = Integer.parseInt(request.getParameter("userID"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");

            pst = con.prepareStatement("UPDATE \"user\" SET username=?, email=?, phone=?, status=? WHERE \"userID\"=?");
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, status);
            pst.setInt(5, id);
            
            pst.executeUpdate();
            response.sendRedirect("customer.jsp?msg=Customer updated successfully");

        } else if(action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("userID"));
            pst = con.prepareStatement("DELETE FROM \"user\" WHERE \"userID\"=?");
            pst.setInt(1, id);
            pst.executeUpdate();
            response.sendRedirect("customer.jsp?msg=Customer deleted successfully");
        }
        
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("customer.jsp?error=Operation failed: " + e.getMessage());
    } finally {
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
