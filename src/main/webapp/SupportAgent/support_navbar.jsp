<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>


    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Navigation</title>
    <style>
        :root {
            --primary: #FFD700;
            --primary-light: #FFEB99;
            --primary-dark: #B39700;
            --white: #FFFFFF;
            --light-gray: #F0F0F0;
            --text: #333333;
            --danger: #FF6B6B;
            --success: #4CAF50;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: var(--light-gray);
            color: var(--text);
        }
              
        .main {
            flex: 1;
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .nav_header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            background-color: var(--white);
        }
        
        
        .container {
            display: flex;
            min-height: 100vh;
            
        }
        
        /* Sidebar */
        .sidebar {
            width: 250px;
            background-color: var(--white);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            z-index: 10;
        }
        
        .logo {
            display: flex;
            align-items: center;
            padding: 20px;
            background-color: var(--primary);
            color: var(--text);
            font-weight: bold;
        }
        
        .logo svg {
            margin-right: 10px;
        }
        
        .nav-menu {
            padding: 20px 0;
        }
        
        .nav-item {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            color: var(--text);
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .nav-item:hover, .nav-item.active {
            background-color: var(--primary-light);
            border-left: 4px solid var(--primary-dark);
        }
        
        .nav-item svg {
            margin-right: 10px;
        }
        
        /* Main Content */
        .main {
            flex: 1;
            overflow-y: auto;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: var(--primary);
            color: var(--white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .logout-btn {
            margin-top: 20px;
            border-top: 1px solid var(--gray);
            color: var(--danger) !important;
        }
        
        .logout-btn:hover {
            background-color: rgba(255, 107, 107, 0.1);
            border-left: 4px solid var(--danger);
        }
        
        .nav-menu {
            display: flex;
            flex-direction: column;
            height: calc(100vh - 80px);
        }
        
        .nav-menu a:not(.logout-btn) {
            flex: 0;
        }
        
        .logout-btn {
            margin-top: auto; /* Push to bottom */
        }
      </style>
</head>
<body>

<div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                <polyline points="9 22 9 12 15 12 15 22"></polyline>
            </svg>
            <span>Grocery Support Agent</span>
        </div>
        
        <nav class="nav-menu">
            <a href="support_dashboard.jsp" class="nav-item" data-page="dashboard">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="3" width="7" height="7"></rect>
                    <rect x="14" y="3" width="7" height="7"></rect>
                    <rect x="14" y="14" width="7" height="7"></rect>
                    <rect x="3" y="14" width="7" height="7"></rect>
                </svg>
                Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/SupportAgent/SupportTicketServlet" class="nav-item">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="21" r="1"></circle>
                    <circle cx="20" cy="21" r="1"></circle>
                    <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
                </svg>
                New Tickets
            </a>
            <a href="SupportTicketServlet?action=resolved" class="nav-item">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                Resolved Ticket
            </a>
            <a href='${pageContext.request.contextPath}/SupportAgent/SupportCustomerServlet' class="nav-item">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <path d="M16 10a4 4 0 0 1-8 0"></path>
                </svg>
                Customers
            </a>
            
            <a href='${pageContext.request.contextPath}/SupportAgent/SupportOrderServlet' class="nav-item">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                    <line x1="3" y1="6" x2="21" y2="6"></line>
                    <path d="M16 10a4 4 0 0 1-8 0"></path>
                </svg>
                Orders
            </a>
            
            
            
            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/LogoutServlet"class="nav-item logout-btn">
           
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
                Logout
            </a>
        </nav>
    </aside>
    
     <!-- Main Content -->
        <main class="main">
            <div class="nav_header">
                <h1>Dashboard</h1>
                <div class="user-profile">
                    <div class="user-avatar">CS</div>
                    <div>
                        <div>Customer Support Agent</div>
                      
                    </div>
                </div>
            </div>
        

          
          
           <script>
           document.addEventListener('DOMContentLoaded', function() {
        	    const currentPath = window.location.pathname;
        	    const navItems = document.querySelectorAll('.nav-item');
        	    
        	    navItems.forEach(item => {
        	        item.classList.remove('active');
        	        
        	        const href = item.getAttribute('href');
        	        const relativeHref = href.replace(/.*\/SupportAgent\//, '');
        	        
        	        if (currentPath.includes(relativeHref) {
        	            item.classList.add('active');
        	        }
        	    });
        	    
        	    // Special case for dashboard
        	    if (currentPath.endsWith('/SupportAgent/') || 
        	       currentPath.endsWith('/SupportAgent/support_dashboard.jsp')) {
        	        const dashboardLink = document.querySelector('[data-page="dashboard"]');
        	        if (dashboardLink) {
        	            dashboardLink.classList.add('active');
        	        }
        	    }
        	});
    </script>
            
</body>
</html>










