<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="javax.servlet.http.HttpSession" %>

    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grocery Store Authentication</title>
    <style>
        :root {
            --primary: #FFD600;
            --primary-dark: #FFC400;
            --primary-light: #FFECB3;
            --white: #FFFFFF;
            --gray-light: #F5F5F5;
            --gray: #E0E0E0;
            --text: #333333;
            --success: #4CAF50;
            --danger: #F44336;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: var(--gray-light);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .container {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }
        
        .auth-container {
            background-color: var(--white);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .tabs {
            display: flex;
            background-color: var(--primary);
        }
        
        .tab {
            flex: 1;
            padding: 15px;
            text-align: center;
            cursor: pointer;
            font-weight: 600;
            color: var(--text);
            transition: all 0.3s ease;
        }
        
        .tab.active {
            background-color: var(--white);
        }
        
        .tab:not(.active):hover {
            background-color: var(--primary-dark);
        }
        
        .form-container {
            padding: 30px;
        }
        
        .form {
            display: none;
        }
        
        .form.active {
            display: block;
        }
        
        .form-title {
            text-align: center;
            margin-bottom: 20px;
            color: var(--text);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: var(--text);
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--gray);
            border-radius: 5px;
            font-size: 14px;
            transition: border 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary);
        }
        
        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            background-color: var(--primary);
            color: var(--text);
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .btn:hover {
            background-color: var(--primary-dark);
        }
        
        .form-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--text);
        }
        
        .form-footer a {
            color: var(--primary-dark);
            text-decoration: none;
            font-weight: 500;
        }
        
        .form-footer a:hover {
            text-decoration: underline;
        }
        
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .logo-icon {
            width: 60px;
            height: 60px;
            background-color: var(--primary);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: bold;
            color: var(--white);
        }
        
        .alert {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            color: var(--white);
            display: none;
        }
        
        .alert-danger {
            background-color: var(--danger);
        }
        
        .alert-success {
            background-color: var(--success);
        }
        
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        .password-strength {
            height: 5px;
            width: 100%;
            margin-top: 5px;
            background-color: #eee;
            border-radius: 3px;
            position: relative;
        }
        
        .password-strength-bar {
            height: 100%;
            border-radius: 3px;
            width: 0%;
            transition: all 0.3s;
        }
    </style>
</head>
<body>

<%
    HttpSession userSession = request.getSession(false);
    if (userSession != null && userSession.getAttribute("username") != null) {
        String role = (String) userSession.getAttribute("role");
        if ("admin".equals(role)) {
            response.sendRedirect("admin_dashboard.jsp");
            return;
        } else if ("customer".equals(role)) {
            response.sendRedirect("index.jsp");
            return;
        }  else if ("delivery".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/DeliveryPerson/DeliveryServlet");
            return;
        }
         else {
            response.sendRedirect("index.jsp");
            return;
        }
    }
%>

    <div class="container">
        <div class="logo">
            <div class="logo-icon">GS</div>
        </div>
        
        <div class="auth-container">
            <div class="tabs">
                <div class="tab active" onclick="showForm('login')">Login</div>
                <div class="tab" onclick="showForm('register')">Register</div>
            </div>
            
            <div class="form-container">
                <!-- Login Form -->
                <div class="form active" id="login-form">
                    <h2 class="form-title">Welcome Back</h2>
                    <div id="login-alert" class="alert"></div>
                    <form action="LoginServlet" method="post" id="loginForm">
                        <div class="form-group">
                            <label for="login-username">Username</label>
                            <input type="text" id="login-username" name="username" class="form-control" placeholder="Enter your username" required>
                        </div>
                        <div class="form-group">
                            <label for="login-password">Password</label>
                            <input type="password" id="login-password" name="password" class="form-control" placeholder="Enter your password" required>
                        </div>
                        <button type="submit" class="btn">Login</button>
                        <div class="form-footer">
                            Don't have an account? <a href="RegisterServlet" onclick="showForm('register')">Register</a>
                        </div>
                    </form>
                </div>
                
                <!-- Register Form -->
                <div class="form" id="register-form">
                    <h2 class="form-title">Create Account</h2>
                    <div id="register-alert" class="alert"></div>
                    <form action="RegisterServlet" method="post" id="registerForm">
                        <div class="form-group">
                            <label for="register-username">Username</label>
                            <input type="text" id="register-username" name="username" class="form-control" placeholder="Choose a username" required minlength="4">
                            <div class="password-requirements">Username must be at least 4 characters long</div>
                        </div>
                        <div class="form-group">
                            <label for="register-email">Email</label>
                            <input type="email" id="register-email" name="email" class="form-control" placeholder="Enter your email" required>
                        </div>
                        <div class="form-group">
                            <label for="register-password">Password</label>
                            <input type="password" id="register-password" name="password" class="form-control" placeholder="Create a password" required minlength="6" onkeyup="checkPasswordStrength()">
                            <div class="password-strength">
                                <div class="password-strength-bar" id="strength-bar"></div>
                            </div>
                            <div class="password-requirements">Password must be at least 6 characters long</div>
                        </div>
                        <div class="form-group">
                            <label for="register-confirm">Confirm Password</label>
                            <input type="password" id="register-confirm" name="confirm-password" class="form-control" placeholder="Confirm your password" required>
                        </div>
                        <input type="hidden" name="role" value="customer">
                        <button type="submit" class="btn">Register</button>
                        <div class="form-footer">
                            Already have an account? <a href="LoginServlet" onclick="showForm('login')">Login</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function showForm(formId) {
            // Hide all forms
            document.querySelectorAll('.form').forEach(form => {
                form.classList.remove('active');
            });
            
            // Deactivate all tabs
            document.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Show selected form
            document.getElementById(formId + '-form').classList.add('active');
            
            // Activate selected tab 
            if (formId === 'login' || formId === 'register') {
                document.querySelectorAll('.tab').forEach(tab => {
                    if (tab.textContent.toLowerCase() === formId) {
                        tab.classList.add('active');
                    }
                });
            }
        }
        
        // Password strength meter
        function checkPasswordStrength() {
            const password = document.getElementById('register-password').value;
            const strengthBar = document.getElementById('strength-bar');
            
            // Simple strength calculation
            let strength = 0;
            
            // Length check
            if (password.length >= 6) strength += 20;
            if (password.length >= 8) strength += 10;
            
            // Character type checks
            if (/[A-Z]/.test(password)) strength += 20; // Has uppercase
            if (/[a-z]/.test(password)) strength += 20; // Has lowercase
            if (/[0-9]/.test(password)) strength += 20; // Has number
            if (/[^A-Za-z0-9]/.test(password)) strength += 20; // Has special char
            
            // Update strength bar
            strengthBar.style.width = strength + '%';
            
            // Color based on strength
            if (strength < 40) {
                strengthBar.style.backgroundColor = '#F44336'; // Weak
            } else if (strength < 70) {
                strengthBar.style.backgroundColor = '#FFC107'; // Medium
            } else {
                strengthBar.style.backgroundColor = '#4CAF50'; // Strong
            }
        }
        
        // Form validation for register
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('register-password').value;
            const confirmPassword = document.getElementById('register-confirm').value;
            const alert = document.getElementById('register-alert');
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert.textContent = "Passwords do not match!";
                alert.className = "alert alert-danger";
                alert.style.display = "block";
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert.textContent = "Password must be at least 6 characters long!";
                alert.className = "alert alert-danger";
                alert.style.display = "block";
                return false;
            }
            
            return true;
        });
        
        // Check URL parameter for error messages
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const loginError = urlParams.get('loginError');
            const registerSuccess = urlParams.get('registerSuccess');
            const registerError = urlParams.get('registerError');
            
            if (loginError) {
                const loginAlert = document.getElementById('login-alert');
                loginAlert.textContent = decodeURIComponent(loginError);
                loginAlert.className = "alert alert-danger";
                loginAlert.style.display = "block";
            }
            
            if (registerSuccess) {
                showForm('login');
                const loginAlert = document.getElementById('login-alert');
                loginAlert.textContent = "Registration successful! Please login.";
                loginAlert.className = "alert alert-success";
                loginAlert.style.display = "block";
            }
            
            if (registerError) {
                showForm('register');
                const registerAlert = document.getElementById('register-alert');
                registerAlert.textContent = decodeURIComponent(registerError);
                registerAlert.className = "alert alert-danger";
                registerAlert.style.display = "block";
            }
        };
    </script>
</body>
</html>