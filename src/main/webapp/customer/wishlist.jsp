<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<%
    // Fetch real items from Database based on Wishlist Session
    Set<String> wishlistIds = (Set<String>) session.getAttribute("wishlist");
    List<Map<String, String>> wishlistItems = new ArrayList<>();
    
    if (wishlistIds != null && !wishlistIds.isEmpty()) {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            String url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres";
            String user = "postgres";
            String pass = "1syERFX5ObrpQ5qR";
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, user, pass);
            
            // Build the dynamic IN clause
            StringBuilder placeholders = new StringBuilder();
            for(int i = 0; i < wishlistIds.size(); i++) {
                placeholders.append("?");
                if(i < wishlistIds.size() - 1) placeholders.append(",");
            }
            
            String sql = "SELECT * FROM item WHERE itemID IN (" + placeholders.toString() + ")";
            pst = con.prepareStatement(sql);
            
            int index = 1;
            for(String id : wishlistIds) {
                pst.setInt(index++, Integer.parseInt(id));
            }
            
            rs = pst.executeQuery();
            while(rs.next()) {
                Map<String, String> item = new HashMap<>();
                item.put("itemID", rs.getString("itemID"));
                item.put("name", rs.getString("name"));
                item.put("price", rs.getString("price"));
                item.put("description", rs.getString("description"));
                item.put("category", rs.getString("category"));
                item.put("quantity", rs.getString("quantity"));
                wishlistItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e){}
            if(pst != null) try { pst.close(); } catch(Exception e){}
            if(con != null) try { con.close(); } catch(Exception e){}
        }
    }
    
    request.setAttribute("wishlistItems", wishlistItems);
%>

<!-- Include Navbar -->
<jsp:include page="index_navbar.jsp" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | Farmart</title>

    <!-- Fonts & Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/index_navbar_nextgen.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/home_ultra.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/wishlist_modern.css">
</head>

<body>

    <!-- Header Section -->
    <header class="wishlist-header">
        <div class="container">
            <h1 class="wishlist-title">My Wishlist <span style="color: #EF4444;">&hearts;</span></h1>
            <p class="wishlist-subtitle">Save your favorite items and buy them when you're ready.</p>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container">

        <c:choose>
            <c:when test="${not empty wishlistItems}">
                <!-- Wishlist Items Grid -->
                <div id="wishlist-container" class="wishlist-grid">
                    <c:forEach items="${wishlistItems}" var="item">
                        <div class="wish-card" id="wish-card-${item.itemID}">
                            <button class="wish-remove-btn" title="Remove" onclick="removeWishlistItem('${item.itemID}')"><i class="fas fa-times"></i></button>
                            <div class="wish-img-box">
                                <a href="item_details.jsp?id=${item.itemID}">
                                    <img src="${pageContext.request.contextPath}/customer/image/item${item.itemID}.jpg" 
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg';"
                                         alt="${item.name}" class="wish-img">
                                </a>
                            </div>
                            <div class="wish-details">
                                <div class="wish-category">${item.category}</div>
                                <h3 class="wish-title">
                                    <a href="item_details.jsp?id=${item.itemID}" style="text-decoration:none; color:inherit;">${item.name}</a>
                                </h3>
                                <div class="wish-stock-status">
                                    <i class="fas fa-check-circle"></i> In Stock
                                </div>
                                <div class="wish-price-row">
                                    <span class="wish-price">Rs. ${item.price}</span>
                                </div>
                            </div>
                            <div class="wish-actions">
                                <form action="${pageContext.request.contextPath}/customer/CartServlet" method="post" style="width: 100%;">
                                    <input type="hidden" name="itemId" value="${item.itemID}">
                                    <input type="hidden" name="itemName" value="${item.name}">
                                    <input type="hidden" name="itemPrice" value="${item.price}">
                                    <input type="hidden" name="itemDescription" value="${item.description}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-move-cart" style="width: 100%;">
                                        <i class="fas fa-shopping-cart"></i> Move to Cart
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Empty State (Hidden initially) -->
                <div id="empty-state" class="empty-state" style="display: none;">
                    <div class="empty-icon"><i class="far fa-heart"></i></div>
                    <h3>Your wishlist is empty</h3>
                    <p class="empty-text">Seems like you haven't found anything you like yet.</p>
                    <a href="index.jsp" class="btn-move-cart" style="max-width: 200px; margin: 0 auto; display:block; text-align:center;">Start Shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State Default -->
                <div id="empty-state" class="empty-state">
                    <div class="empty-icon"><i class="far fa-heart"></i></div>
                    <h3>Your wishlist is empty</h3>
                    <p class="empty-text">Seems like you haven't found anything you like yet.</p>
                    <a href="index.jsp" class="btn-move-cart" style="max-width: 200px; margin: 0 auto; display:block; text-align:center; text-decoration:none;">Start Shopping</a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <!-- Footer Reuse -->
    <div style="margin-top: 80px;">
        <!-- Simply copy footer html to avoid includes breaking layouts -->
        <footer class="footer-modern">
            <div class="container footer-grid">
                <div class="footer-col" style="flex: 2;">
                    <h2 style="color: var(--primary-mint); font-family: 'Outfit', sans-serif; margin-bottom: 20px;">
                        Farmart.</h2>
                    <p style="color: #9CA3AF; line-height: 1.6; max-width: 300px;">Your daily source of fresh, organic,
                        and premium groceries delivered with care.</p>
                    <div style="display: flex; gap: 15px; margin-top: 20px;">
                        <a href="#" style="color: white; font-size: 1.2rem;"><i class="fab fa-facebook"></i></a>
                        <a href="#" style="color: white; font-size: 1.2rem;"><i class="fab fa-instagram"></i></a>
                        <a href="#" style="color: white; font-size: 1.2rem;"><i class="fab fa-twitter"></i></a>
                    </div>
                </div>
                <div class="footer-col">
                    <h4>Quick Links</h4>
                    <a href="#">About Us</a>
                    <a href="#">Shop</a>
                    <a href="#">Contact</a>
                    <a href="#">Track Order</a>
                </div>
                <div class="footer-col">
                    <h4>Categories</h4>
                    <a href="ItemCategoryServlet?category=Baby Product">Baby Care</a>
                    <a href="ItemCategoryServlet?category=Dairy">Dairy & Eggs</a>
                    <a href="ItemCategoryServlet?category=Frozen Food">Frozen Food</a>
                    <a href="ItemCategoryServlet?category=Beverages">Beverages</a>
                </div>
                <div class="footer-col">
                    <h4>Newsletter</h4>
                    <p style="color: #9CA3AF; margin-bottom: 15px;">Subscribe for latest updates and offers.</p>
                    <div style="background: rgba(255,255,255,0.1); padding: 5px; border-radius: 50px; display: flex;">
                        <input type="email" placeholder="Email Address"
                            style="background: transparent; border: none; padding: 10px; color: white; outline: none; flex-grow: 1;">
                        <button
                            style="background: var(--primary-emerald); border: none; color: white; width: 40px; height: 40px; border-radius: 50%; cursor: pointer;"><i
                                class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
            </div>
            <div
                style="text-align: center; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px; color: #6B7280; font-size: 0.9rem;">
                &copy; 2024 Farmart Grocery Store. All rights reserved.
            </div>
        </footer>
    </div>

    <script>
        function removeWishlistItem(itemId) {
            if (confirm('Remove this item from your wishlist?')) {
                // Call API
                fetch(`${pageContext.request.contextPath}/customer/api_wishlist.jsp?action=remove&id=` + itemId)
                    .then(res => res.json())
                    .then(data => {
                        if(data.status === 'success') {
                            const card = document.getElementById('wish-card-' + itemId);
                            if(card) {
                                card.style.transform = 'scale(0.8)';
                                card.style.opacity = '0';
                                setTimeout(() => {
                                    card.remove();
                                    
                                    // Update Navbar
                                    if(window.updateWishlistCount) {
                                        window.updateWishlistCount();
                                    }
                                    
                                    // Check if empty
                                    const container = document.getElementById('wishlist-container');
                                    if (container && container.children.length === 0) {
                                        container.style.display = 'none';
                                        document.getElementById('empty-state').style.display = 'block';
                                    }
                                }, 300);
                            }
                        }
                    })
                    .catch(err => console.error(err));
            }
        }
    </script>

</body>
</html>