<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Security Check
    HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/customer/login.jsp");
        return;
    }
%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Farmart Admin Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin_styles.css?v=2">
</head>
<body>

    <!-- Sidebar -->
    <aside class="admin-sidebar">
        <div class="sidebar-logo">
            <i class="fas fa-leaf"></i>
            Farmart Admin
        </div>
        
        <nav class="sidebar-menu">
            <a href="admin_dashboard.jsp" class="nav-item" id="nav-dashboard">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <a href="order.jsp" class="nav-item" id="nav-orders">
                <i class="fas fa-shopping-cart"></i> Orders
            </a>
            <a href="item.jsp" class="nav-item" id="nav-products">
                <i class="fas fa-box"></i> Products
            </a>
            <a href="category.jsp" class="nav-item" id="nav-categories">
                <i class="fas fa-tags"></i> Categories
            </a>
            <a href="customer.jsp" class="nav-item" id="nav-customers">
                <i class="fas fa-users"></i>
                <span>Customers</span>
            </a>
            <a href="offers.jsp" class="nav-item" id="nav-offers">
                <i class="fas fa-tags"></i>
                <span>Offers</span>
            </a>
        </nav>

        <div class="logout-wrapper">
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">
                <i class="fas fa-sign-out-alt" style="margin-right:8px;"></i> Logout
            </a>
        </div>
    </aside>
    
    <!-- Main Content wrapper -->
    <main class="admin-main">
        <!-- Top Header -->
        <header class="admin-header">
            <div class="admin-profile">
                <div style="text-align: right;">
                    <div style="font-weight:600; font-size:0.9rem;"><%= username %></div>
                    <div style="color:var(--text-muted); font-size:0.75rem;">Super Admin</div>
                </div>
                <div class="admin-avatar">
                    <%= username.substring(0, 1).toUpperCase() %>
                </div>
            </div>
        </header>
        
        <!-- Content Area -->
        <div class="admin-content">
            <!-- PAGE CONTENT BEGINS HERE -->