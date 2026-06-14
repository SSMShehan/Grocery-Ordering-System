<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Farmart</title>
    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <!-- Styles -->
    <link rel="stylesheet" href="./styles/auth_modern.css">
</head>
<body>

    <div class="auth-container">
        <!-- Decorative Background Blobs -->
        <div class="auth-blob blob-1"></div>
        <div class="auth-blob blob-2"></div>

        <div class="auth-card">
            <div class="auth-header">
                <a href="index.jsp" style="text-decoration:none;"><h1 class="auth-logo">Farmart.</h1></a>
                <p class="auth-subtitle">Welcome back! Please login to your account.</p>
            </div>

            <%
                String error = request.getParameter("error");
                if (error != null) {
            %>
                <div class="error-msg">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= error %></span>
                </div>
            <%
                }
            %>

            <form action="api_auth.jsp" method="POST">
                <input type="hidden" name="action" value="login">
                
                <div class="auth-form-group">
                    <label class="auth-label">Username or Email</label>
                    <div class="auth-input-wrapper">
                        <i class="far fa-user"></i>
                        <input type="text" name="email" class="auth-input" placeholder="Enter your username or email" required>
                    </div>
                </div>

                <div class="auth-form-group">
                    <label class="auth-label">Password</label>
                    <div class="auth-input-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" class="auth-input" placeholder="Enter your password" required>
                    </div>
                </div>

                <button type="submit" class="auth-btn">
                    Login <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="auth-footer">
                Don't have an account? <a href="register.jsp" class="auth-link">Sign Up</a>
            </div>
        </div>
    </div>

</body>
</html>
