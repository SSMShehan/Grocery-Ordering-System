<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<% 
    Integer userId = (Integer) session.getAttribute("userID"); 
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String uName = "";
    String uEmail = "";
    String uPhone = "";
    String uAddress = "";
    String uCity = "";
    String uProvince = "";
    String uZipcode = "";
    String uRegDate = "";

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        pst = con.prepareStatement("SELECT name, email, phone, address, city, province, zipcode, register_date FROM customer WHERE \"cusID\" = ?");
        pst.setInt(1, userId);
        rs = pst.executeQuery();
        
        if (rs.next()) {
            uName = rs.getString("name") != null ? rs.getString("name") : "";
            uEmail = rs.getString("email") != null ? rs.getString("email") : "";
            uPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
            uAddress = rs.getString("address") != null ? rs.getString("address") : "";
            uCity = rs.getString("city") != null ? rs.getString("city") : "";
            uProvince = rs.getString("province") != null ? rs.getString("province") : "";
            uZipcode = rs.getString("zipcode") != null ? rs.getString("zipcode") : "";
            uRegDate = rs.getString("register_date") != null ? rs.getString("register_date") : "Recently";
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e){}
        if(pst != null) try { pst.close(); } catch(Exception e){}
        if(con != null) try { con.close(); } catch(Exception e){}
    }
%>

<jsp:include page="index_navbar.jsp" />

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Farmart</title>

    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Styles -->
    <link rel="stylesheet" href="./styles/index_navbar_nextgen.css">
    <link rel="stylesheet" href="./styles/profile_modern.css">
</head>

<body>

    <div class="profile-layout">
        
        <!-- Sidebar -->
        <aside class="profile-sidebar">
            <div class="user-card">
                <div class="avatar-circle">
                    <%= uName.length() > 0 ? uName.substring(0, 1).toUpperCase() : "U" %>
                </div>
                <h3 class="user-name"><%= uName %></h3>
                <p class="user-email"><%= uEmail %></p>
            </div>

            <nav class="profile-nav">
                <a href="#" class="nav-item active" onclick="switchTab('dashboard')">
                    <i class="fas fa-user-circle"></i> Personal Info
                </a>
                <a href="order_history.jsp" class="nav-item">
                    <i class="fas fa-box"></i> My Orders
                </a>
                <a href="wishlist.jsp" class="nav-item">
                    <i class="fas fa-heart"></i> Wishlist
                </a>
                <div class="nav-divider"></div>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-item logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="profile-main">
            
            <% if(request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> <%= request.getParameter("success") %>
                </div>
            <% } %>
            <% if(request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getParameter("error") %>
                </div>
            <% } %>

            <div id="dashboard-tab" class="tab-content active">
                <div class="content-header">
                    <h2>Personal Information</h2>
                    <p>Manage your personal details and contact information.</p>
                </div>

                <div class="glass-card form-card">
                    <form action="api_update_profile.jsp" method="post" class="profile-form">
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label>Full Name</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-user text-muted"></i>
                                    <input type="text" name="name" value="<%= uName %>" required class="modern-input">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-envelope text-muted"></i>
                                    <input type="email" name="email" value="<%= uEmail %>" required class="modern-input">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Phone Number</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-phone text-muted"></i>
                                    <input type="tel" name="phone" value="<%= uPhone %>" class="modern-input">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Member Since</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-calendar-alt text-muted"></i>
                                    <input type="text" value="<%= uRegDate %>" disabled class="modern-input disabled-input">
                                </div>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label>Street Address</label>
                            <div class="input-icon-wrapper align-top">
                                <i class="fas fa-map-marker-alt text-muted" style="top: 15px;"></i>
                                <textarea name="address" rows="2" class="modern-input"><%= uAddress %></textarea>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>City</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-city text-muted"></i>
                                    <input type="text" name="city" value="<%= uCity %>" class="modern-input">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Province</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-map text-muted"></i>
                                    <input type="text" name="province" value="<%= uProvince %>" class="modern-input">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Zip/Postal Code</label>
                                <div class="input-icon-wrapper">
                                    <i class="fas fa-mail-bulk text-muted"></i>
                                    <input type="text" name="zipcode" value="<%= uZipcode %>" class="modern-input">
                                </div>
                            </div>
                            <div class="form-group">
                                <!-- Empty spacer to keep layout balanced -->
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-save">
                                <i class="fas fa-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>