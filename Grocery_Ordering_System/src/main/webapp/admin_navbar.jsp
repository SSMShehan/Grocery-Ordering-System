<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
        <span>Grocery Admin</span>
    </div>
    
    <nav class="nav-menu">
        <a href="admin_dashboard.jsp" class="nav-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="7" height="7"></rect>
                <rect x="14" y="3" width="7" height="7"></rect>
                <rect x="14" y="14" width="7" height="7"></rect>
                <rect x="3" y="14" width="7" height="7"></rect>
            </svg>
            Dashboard
        </a>
        <a href="OrderServlet" class="nav-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="9" cy="21" r="1"></circle>
                <circle cx="20" cy="21" r="1"></circle>
                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
            </svg>
            Orders
        </a>
        <a href="CustomerServlet" class="nav-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
            </svg>
            Customers
        </a>
        <a href='ItemServlet' class="nav-item active">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                <line x1="3" y1="6" x2="21" y2="6"></line>
                <path d="M16 10a4 4 0 0 1-8 0"></path>
            </svg>
            Products
        </a>
        <a href="PaymentServlet" class="nav-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
            </svg>
            Payments
        </a>
        <a href="#" class="nav-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
                <line x1="8" y1="21" x2="16" y2="21"></line>
                <line x1="12" y1="17" x2="12" y2="21"></line>
            </svg>
            Reports
        </a>
        
        <a href="UserServlet" class="nav-item">
             <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
            </svg>
            Users
        </a>
        
        <a href="#" class="nav-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="3"></circle>
                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
            </svg>
            Settings
        </a>
        
        <!-- Logout Button -->
        <a href="LogoutServlet" class="nav-item logout-btn">
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
                    <div class="user-avatar">A</div>
                    <div>
                        <div>Admin User</div>
                        <small>Super Admin</small>
                    </div>
                </div>
            </div>
          
           <script>
        // Function to set active menu item based on current URL
        document.addEventListener('DOMContentLoaded', function() {
            // Get current page URL path
            const currentPath = window.location.pathname;
            
            // Find all navigation items
            const navItems = document.querySelectorAll('.nav-item');
            
            // Remove any existing active classes
            navItems.forEach(item => {
                item.classList.remove('active');
            });
            
            // Set active class based on URL matching
            navItems.forEach(item => {
                const href = item.getAttribute('href');
                if (currentPath.includes(href) || 
                    (currentPath.includes(item.getAttribute('data-page'))) ||
                    (currentPath.endsWith('/') && item.getAttribute('data-page') === 'dashboard')) {
                    item.classList.add('active');
                }
            });
            
            // If no match was found and we're on the index/home page, set dashboard as active
            if (currentPath === '/' || currentPath.endsWith('index.jsp') || currentPath.endsWith('/')) {
                const dashboardLink = document.querySelector('[data-page="dashboard"]');
                if (dashboardLink) {
                    dashboardLink.classList.add('active');
                }
            }
        });
    </script>
            
</body>
</html>