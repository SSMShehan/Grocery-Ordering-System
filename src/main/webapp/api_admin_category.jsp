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
            String desc = request.getParameter("description");
            String parentStr = request.getParameter("parent_id");
            
            Integer parentId = null;
            if(parentStr != null && !parentStr.isEmpty() && !parentStr.equals("0")) {
                parentId = Integer.parseInt(parentStr);
            }
            
            pst = con.prepareStatement("INSERT INTO category (name, description, parent_categoryID) VALUES (?, ?, ?)");
            pst.setString(1, name);
            pst.setString(2, desc);
            if(parentId == null) {
                pst.setNull(3, java.sql.Types.INTEGER);
            } else {
                pst.setInt(3, parentId);
            }
            pst.executeUpdate();
            
            response.sendRedirect("category.jsp?msg=Category added successfully");
            
        } else if("update".equals(action)) {
            String id = request.getParameter("categoryID");
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            String parentStr = request.getParameter("parent_id");
            
            Integer parentId = null;
            if(parentStr != null && !parentStr.isEmpty() && !parentStr.equals("0")) {
                parentId = Integer.parseInt(parentStr);
            }
            
            pst = con.prepareStatement("UPDATE category SET name=?, description=?, parent_categoryID=? WHERE \"categoryID\"=?");
            pst.setString(1, name);
            pst.setString(2, desc);
            if(parentId == null) {
                pst.setNull(3, java.sql.Types.INTEGER);
            } else {
                pst.setInt(3, parentId);
            }
            pst.setInt(4, Integer.parseInt(id));
            pst.executeUpdate();
            
            response.sendRedirect("category.jsp?msg=Category updated successfully");
            
        } else if("delete".equals(action)) {
            String id = request.getParameter("categoryID");
            
            pst = con.prepareStatement("DELETE FROM category WHERE \"categoryID\"=?");
            pst.setInt(1, Integer.parseInt(id));
            pst.executeUpdate();
            
            response.sendRedirect("category.jsp?msg=Category deleted successfully");
        } else {
            response.sendRedirect("category.jsp?error=Invalid action");
        }
    } catch(Exception e) {
        response.sendRedirect("category.jsp?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
