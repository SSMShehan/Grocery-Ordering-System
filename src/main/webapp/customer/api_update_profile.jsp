<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="Util_Package.DBconnection" %>

            <% Integer userID=(Integer) session.getAttribute("userID"); if (userID==null) {
                response.sendRedirect("login.jsp"); return; } String name=request.getParameter("name"); String
                email=request.getParameter("email"); String phone=request.getParameter("phone"); String
                address=request.getParameter("address"); String city=request.getParameter("city"); String
                province=request.getParameter("province"); String zipcode=request.getParameter("zipcode"); if
                (name==null || name.trim().isEmpty() || email==null || email.trim().isEmpty()) {
                response.sendRedirect("profile.jsp?error=Name and Email are required"); return; } Connection con=null;
                PreparedStatement pst=null; try { con=DBconnection.getConnection(); String
                sql="UPDATE customer SET name=?, email=?, phone=?, address=?, city=?, province=?, zipcode=? WHERE \"
                cusID\"=?"; pst=con.prepareStatement(sql); pst.setString(1, name); pst.setString(2, email);
                pst.setString(3, phone); pst.setString(4, address); pst.setString(5, city); pst.setString(6, province);
                pst.setString(7, zipcode); pst.setInt(8, userID); int rows=pst.executeUpdate(); if (rows> 0) {
                // Update session username if name changed
                session.setAttribute("username", name);
                response.sendRedirect("profile.jsp?success=Profile updated successfully!");
                } else {
                response.sendRedirect("profile.jsp?error=Profile update failed");
                }

                } catch(Exception e) {
                e.printStackTrace();
                String errMsg = e.getMessage() != null ? e.getMessage() : "Unknown error";
                response.sendRedirect("profile.jsp?error=" + java.net.URLEncoder.encode("Database error: " + errMsg,
                "UTF-8"));
                } finally {
                if (pst != null) try { pst.close(); } catch(Exception e) {}
                if (con != null) try { con.close(); } catch(Exception e) {}
                }
                %>