<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
    List<Map<String, String>> flashList = new ArrayList<>(); 
    List<Map<String, String>> trendingList = new ArrayList<>(); 
    Connection con = null; 
    PreparedStatement pst1 = null;
    PreparedStatement pst2 = null;
    ResultSet rs1 = null; 
    ResultSet rs2 = null; 
    
    try { 
        String url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres"; 
        String user = "postgres";
        String pass = "1syERFX5ObrpQ5qR"; 
        Class.forName("org.postgresql.Driver"); 
        con = DriverManager.getConnection(url, user, pass); 
        
        // Fetch Flash Items (Items with discount)
        String query1 = "SELECT * FROM item WHERE discount_percentage > 0 AND quantity > '0' ORDER BY RANDOM() LIMIT 4";
        pst1 = con.prepareStatement(query1); 
        rs1 = pst1.executeQuery(); 
        while (rs1.next()) { 
            Map<String, String> item = new HashMap<>(); 
            item.put("itemID", String.valueOf(rs1.getInt("itemID"))); 
            item.put("name", rs1.getString("name")); 
            item.put("price", rs1.getString("price")); 
            item.put("category", rs1.getString("category")); 
            item.put("description", rs1.getString("description"));
            int discount = rs1.getInt("discount_percentage");
            item.put("discount", String.valueOf(discount));
            
            try {
                double p = Double.parseDouble(rs1.getString("price")); 
                double disc = p - (p * discount / 100.0);
                item.put("dealPrice", String.format("%.2f", disc)); 
            } catch(Exception e) {
                item.put("dealPrice", rs1.getString("price")); 
            } 
            flashList.add(item); 
        } 
        
        // Fetch Trending Items 
        String query2 = "SELECT * FROM item WHERE quantity > '0' ORDER BY RANDOM() LIMIT 4";
        pst2 = con.prepareStatement(query2); 
        rs2 = pst2.executeQuery(); 
        while (rs2.next()) { 
            Map<String, String> item = new HashMap<>(); 
            item.put("itemID", String.valueOf(rs2.getInt("itemID"))); 
            item.put("name", rs2.getString("name")); 
            item.put("price", rs2.getString("price")); 
            item.put("category", rs2.getString("category")); 
            item.put("description", rs2.getString("description")); 
            int discount = rs2.getInt("discount_percentage");
            item.put("discount", String.valueOf(discount));
            
            try {
                double p = Double.parseDouble(rs2.getString("price")); 
                double disc = p - (p * discount / 100.0);
                item.put("dealPrice", String.format("%.2f", disc)); 
            } catch(Exception e) {
                item.put("dealPrice", rs2.getString("price")); 
            }
            trendingList.add(item); 
        } 
        
        // Fetch Categories
        List<Map<String, String>> catList = new ArrayList<>();
        String queryCat = "SELECT * FROM category LIMIT 6";
        PreparedStatement pst3 = con.prepareStatement(queryCat);
        ResultSet rs3 = pst3.executeQuery();
        while (rs3.next()) {
            Map<String, String> cat = new HashMap<>();
            cat.put("name", rs3.getString("name"));
            // Map common names to emojis
            String name = rs3.getString("name").toLowerCase();
            String emoji = "📦";
            if (name.contains("veg")) emoji = "🥦";
            else if (name.contains("fruit")) emoji = "🍎";
            else if (name.contains("dair") || name.contains("milk")) emoji = "🥛";
            else if (name.contains("bake")) emoji = "🥖";
            else if (name.contains("meat")) emoji = "🥩";
            else if (name.contains("bev")) emoji = "🥤";
            else if (name.contains("snack")) emoji = "🥨";
            else if (name.contains("baby")) emoji = "👶";
            else if (name.contains("froz")) emoji = "❄️";
            else if (name.contains("house")) emoji = "🏠";
            else if (name.contains("beaut")) emoji = "💄";
            
            cat.put("emoji", emoji);
            catList.add(cat);
        }
        rs3.close(); pst3.close();
        request.setAttribute("catList", catList);
        
    } catch (Exception e) { 
        e.printStackTrace(); 
    } finally { 
        if(rs1 != null) try { rs1.close(); } catch(Exception e){} 
        if(rs2 != null) try { rs2.close(); } catch(Exception e){} 
        if(pst1 != null) try { pst1.close(); } catch(Exception e){}
        if(pst2 != null) try { pst2.close(); } catch(Exception e){}
        if(con != null) try { con.close(); } catch(Exception e){} 
    } 
    
    request.setAttribute("flashList", flashList); 
    request.setAttribute("trendingList", trendingList); 
%>

    <!-- Include Navbar -->
    <jsp:include page="index_navbar.jsp" />

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Farmart - Premium Grocery Store</title>

        <!-- External Libs -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Modern Styles -->
        <link rel="stylesheet" href="./styles/index_navbar_nextgen.css?v=9.0">
        <link rel="stylesheet" href="./styles/home_ultra.css?v=3.0">

        <!-- Vanilla Tilt 3D -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vanilla-tilt/1.8.0/vanilla-tilt.min.js"></script>
    </head>

    <body>

        <!-- Hero Section -->
        <header class="hero-modern">
            <div class="hero-slider">
                <img src="https://images.unsplash.com/photo-1542838132-92c53300491e?w=1920&q=80" alt="Fresh Market 1" class="hero-slide">
                <img src="https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=1920&q=80" alt="Fresh Market 2" class="hero-slide">
                <img src="https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=1920&q=80" alt="Fresh Market 3" class="hero-slide">
            </div>
            <div class="hero-overlay"></div>
            <div class="container hero-content">
                <div>
                    <span class="hero-badge">Original & Organic</span>
                    <h1 class="hero-headline">Freshness <span>Delivered</span> to Your Doorstep.</h1>
                    <p class="hero-desc">Experience the finest selection of hand-picked vegetables, fruits, and daily
                        essentials. Delivered within 24 hours, guaranteed.</p>
                    <a href="#shop" class="btn-cta">
                        Shop Now <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </header>

        <div class="container">
            <!-- Features Banner (Floating) -->
            <div class="features-banner">
                <div class="feature-box">
                    <div class="feature-icon"><i class="fas fa-shipping-fast"></i></div>
                    <div class="feature-text">
                        <h4>Fast Delivery</h4>
                        <p>Within 24 Hours</p>
                    </div>
                </div>
                <div class="feature-box">
                    <div class="feature-icon"><i class="fas fa-leaf"></i></div>
                    <div class="feature-text">
                        <h4>100% Organic</h4>
                        <p>Certified Farmers</p>
                    </div>
                </div>
                <div class="feature-box">
                    <div class="feature-icon"><i class="fas fa-shield-alt"></i></div>
                    <div class="feature-text">
                        <h4>Secure Payment</h4>
                        <p>100% Safe Transactions</p>
                    </div>
                </div>
                <div class="feature-box">
                    <div class="feature-icon"><i class="fas fa-headset"></i></div>
                    <div class="feature-text">
                        <h4>24/7 Support</h4>
                        <p>Dedicated Team</p>
                    </div>
                </div>
            </div>

            <!-- Categories -->
            <section class="categories-section">
                <div class="section-title-box">
                    <h2 class="section-title">Shop by Category</h2>
                    <div class="section-subtitle">Find everything you need for your home</div>
                </div>

                <div class="cat-grid">
                    <c:forEach var="cat" items="${catList}">
                        <a href="ItemCategoryServlet?category=${cat.name}" class="cat-card">
                            <div class="cat-img-box">${cat.emoji}</div>
                            <div class="cat-name">${cat.name}</div>
                        </a>
                    </c:forEach>
                </div>
            </section>
        </div>

        <!-- Flash Sale Section -->
        <section class="flash-section">
            <div class="flash-blob blob-1"></div>
            <div class="flash-blob blob-2"></div>
            <div class="container" style="position: relative; z-index: 1;">
                <div class="flash-header">
                    <div class="flash-title-group">
                        <h2 class="flash-title">Flash Sale ⚡</h2>
                        <div class="timer-box">
                            <!-- JS injected -->
                        </div>
                    </div>
                    <a href="#" class="btn-cta" style="padding: 10px 25px; font-size: 0.9rem;">View All</a>
                </div>

                <div class="flash-grid">
                    <c:forEach items="${flashList}" var="item">
                    <div class="flash-card">
                        <span class="discount-badge">-${item.discount}%</span>
                        <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}" style="text-decoration:none; color:inherit;">
                            <img src="${pageContext.request.contextPath}/customer/image/item${item.itemID}.jpg" 
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/item${item.itemID}.png'; setTimeout(()=>{ if(this.src.endsWith('.png')) { this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg'; } }, 100);"
                                 class="flash-img" alt="${item.name}">
                        </a>
                        <div class="flash-info">
                            <h3 style="margin-top: 0;">
                                <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}" style="text-decoration:none; color:inherit;">
                                    ${item.name}
                                </a>
                            </h3>
                            <div class="price-box">
                                <span class="current-price">Rs. ${item.dealPrice}</span>
                                <span class="old-price">Rs. ${item.price}</span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: 80%"></div>
                            </div>
                            <div class="sold-text">Sold: 80/100</div>
                            <form action="${pageContext.request.contextPath}/customer/CartServlet" method="post" style="width: 100%;">
                                <input type="hidden" name="itemId" value="${item.itemID}">
                                <input type="hidden" name="itemName" value="${item.name}">
                                <input type="hidden" name="itemPrice" value="${item.dealPrice}">
                                <input type="hidden" name="itemDescription" value="${item.description}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn-add-cart-full">Add to Cart</button>
                            </form>
                        </div>
                    </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Special Offer Banner -->
        <div class="container">
            <div class="offer-parallax">
                <div class="offer-card">
                    <span style="color: #EF4444; font-weight: 700; display: block; margin-bottom: 10px;">LIMITED TIME
                        OFFER</span>
                    <h2 style="font-size: 2.5rem; margin-bottom: 15px; line-height: 1.1;">Get 50% Off<br>On All Bakery
                        Items</h2>
                    <p style="margin-bottom: 25px;">Indulge in our freshly baked bread, pastries, and
                        cakes. Baked with love and organic ingredients.</p>
                    <a href="${pageContext.request.contextPath}/customer/ItemCategoryServlet?category=Bakery" class="btn-cta">Grab Offer</a>
                </div>
            </div>
        </div>

        <!-- Trending Products (Best Sellers) -->
        <section class="container" id="shop">
            <div class="section-title-box">
                <h2 class="section-title">Trending Products</h2>
                <div class="section-subtitle">Customer favorites this week</div>
            </div>

            <div class="product-grid-modern">
                <c:forEach items="${trendingList}" var="item">
                <div class="prod-card-modern">
                    <div class="prod-actions">
                        <button class="action-btn" title="Wishlist" onclick="toggleWishlist('${item.itemID}', this)">
                            <i class="${sessionScope.wishlist != null && sessionScope.wishlist.contains(item.itemID.toString()) ? 'fas' : 'far'} fa-heart" 
                               style="${sessionScope.wishlist != null && sessionScope.wishlist.contains(item.itemID.toString()) ? 'color: #EF4444;' : ''}"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}" class="action-btn" title="Quick View"><i class="far fa-eye"></i></a>
                    </div>
                    <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}" style="text-decoration:none; color:inherit; text-align: center; display: block;">
                        <img src="${pageContext.request.contextPath}/customer/image/item${item.itemID}.jpg" 
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/item${item.itemID}.png'; setTimeout(()=>{ if(this.src.endsWith('.png')) { this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg'; } }, 100);"
                             class="prod-img" alt="${item.name}">
                    </a>
                    <div style="text-align: left;">
                        <div style="color: #F59E0B; font-size: 0.8rem; margin-bottom: 5px;">
                            <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i
                                class="fas fa-star"></i><i class="fas fa-star"></i>
                        </div>
                        <h3 style="margin: 0 0 5px; font-size: 1.1rem;">
                            <a href="${pageContext.request.contextPath}/customer/item_details.jsp?id=${item.itemID}" style="text-decoration:none; color:inherit;">
                                ${item.name}
                            </a>
                        </h3>
                        <div style="color: #10B981; font-weight: 800; font-size: 1.2rem;">
                            <c:choose>
                                <c:when test="${item.discount > 0}">
                                    Rs. ${item.dealPrice} <span style="text-decoration:line-through; color:#9CA3AF; font-size:0.9rem; margin-left:5px;">Rs. ${item.price}</span>
                                </c:when>
                                <c:otherwise>
                                    Rs. ${item.price}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/customer/CartServlet" method="post" style="width: 100%;">
                        <input type="hidden" name="itemId" value="${item.itemID}">
                        <input type="hidden" name="itemName" value="${item.name}">
                        <input type="hidden" name="itemPrice" value="${item.dealPrice != null ? item.dealPrice : item.price}">
                        <input type="hidden" name="itemDescription" value="${item.description}">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn-add-cart-full">Add to Cart</button>
                    </form>
                </div>
                </c:forEach>
            </div>
        </section>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />

        <!-- Scripts -->
        <script src="./scripts/home_core.js"></script>

    </body>

    </html>