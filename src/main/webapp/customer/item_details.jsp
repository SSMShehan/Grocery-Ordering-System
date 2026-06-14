<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
    String itemId = request.getParameter("id");
    Map<String, String> currentItem = null;
    List<Map<String, String>> relatedItems = new ArrayList<>();
    String dbError = "";
    
    if (itemId != null && !itemId.trim().isEmpty()) {
        Connection con = null; 
        PreparedStatement pst = null;
        PreparedStatement pstRelated = null;
        ResultSet rs = null; 
        ResultSet rsRelated = null;
        
        try { 
            String url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres"; 
            String user = "postgres";
            String pass = "1syERFX5ObrpQ5qR"; 
            Class.forName("org.postgresql.Driver"); 
            con = DriverManager.getConnection(url, user, pass); 
            
            // 1. Fetch the main item
            String query = "SELECT * FROM item WHERE \"itemID\" = ?";
            pst = con.prepareStatement(query); 
            pst.setInt(1, Integer.parseInt(itemId));
            rs = pst.executeQuery(); 
            
            if (rs.next()) { 
                currentItem = new HashMap<>(); 
                currentItem.put("itemID", String.valueOf(rs.getInt("itemID"))); 
                currentItem.put("name", rs.getString("name")); 
                currentItem.put("price", rs.getString("price")); 
                currentItem.put("category", rs.getString("category")); 
                currentItem.put("quantity", rs.getString("quantity"));
                currentItem.put("description", rs.getString("description")); 
                int discount = rs.getInt("discount_percentage");
                currentItem.put("discount", String.valueOf(discount));
                
                try {
                    double p = Double.parseDouble(rs.getString("price")); 
                    double disc = p - (p * discount / 100.0);
                    currentItem.put("dealPrice", String.format("%.2f", disc)); 
                } catch(Exception e) {
                    currentItem.put("dealPrice", rs.getString("price")); 
                }
                
                // 2. Fetch related items from the same category
                String queryRelated = "SELECT * FROM item WHERE category = ? AND \"itemID\" != ? AND quantity > '0' ORDER BY RANDOM() LIMIT 4";
                pstRelated = con.prepareStatement(queryRelated);
                pstRelated.setString(1, rs.getString("category"));
                pstRelated.setInt(2, rs.getInt("itemID"));
                rsRelated = pstRelated.executeQuery();
                
                while(rsRelated.next()) {
                    Map<String, String> rItem = new HashMap<>();
                    rItem.put("itemID", String.valueOf(rsRelated.getInt("itemID"))); 
                    rItem.put("name", rsRelated.getString("name")); 
                    rItem.put("price", rsRelated.getString("price")); 
                    int rDiscount = rsRelated.getInt("discount_percentage");
                    rItem.put("discount", String.valueOf(rDiscount));
                    
                    try {
                        double rp = Double.parseDouble(rsRelated.getString("price")); 
                        double rdisc = rp - (rp * rDiscount / 100.0);
                        rItem.put("dealPrice", String.format("%.2f", rdisc)); 
                    } catch(Exception e) {
                        rItem.put("dealPrice", rsRelated.getString("price")); 
                    }
                    relatedItems.add(rItem);
                }
            } 
        } catch (Exception e) { 
            dbError = e.getMessage(); 
            e.printStackTrace(); 
        } finally { 
            if(rs != null) try { rs.close(); } catch(Exception e){} 
            if(rsRelated != null) try { rsRelated.close(); } catch(Exception e){} 
            if(pst != null) try { pst.close(); } catch(Exception e){}
            if(pstRelated != null) try { pstRelated.close(); } catch(Exception e){}
            if(con != null) try { con.close(); } catch(Exception e){} 
        }
    }
    
    request.setAttribute("item", currentItem);
    request.setAttribute("relatedItems", relatedItems);
    request.setAttribute("error", dbError);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${item != null ? item.name : 'Item Details'} - Farmart</title>

    <!-- External Libs -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Modern Styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/index_navbar_nextgen.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/home_ultra.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/customer/styles/item_details_ultra.css">
</head>

<body>

    <!-- Include Navbar -->
    <jsp:include page="index_navbar.jsp" />

    <div class="main-content">
        <c:choose>
            <c:when test="${not empty item}">
                <!-- Breadcrumbs -->
                <div class="container breadcrumb-nav">
                    <a href="index.jsp">Home</a>
                    <i class="fas fa-chevron-right separator"></i>
                    <a href="ItemCategoryServlet?category=${item.category}">${item.category}</a>
                    <i class="fas fa-chevron-right separator"></i>
                    <span class="current-crumb">${item.name}</span>
                </div>

                <!-- Main Product View -->
                <div class="container product-hero-section">
                    <!-- Left: Image Viewer -->
                    <div class="product-image-col">
                        <div class="image-showcase">
                            <img src="${pageContext.request.contextPath}/customer/image/item${item.itemID}.jpg"
                                alt="${item.name}" class="main-prod-img" id="mainImage"
                                onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg'">
                        </div>
                    </div>

                    <!-- Right: Product Info -->
                    <div class="product-info-col">
                        <span class="stock-badge"><i class="fas fa-check-circle"></i> In Stock</span>
                        <h1 class="product-title">${item.name}</h1>
                        
                        <div class="product-meta">
                            <div class="star-rating">
                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                            </div>
                            <span class="review-count">4.8 (124 reviews)</span>
                            <span class="meta-divider">|</span>
                            <span class="sku-id">SKU: FM-${item.itemID}</span>
                        </div>

                        <div class="price-section">
                            <c:choose>
                                <c:when test="${item.discount > 0}">
                                    <span class="current-price" id="detail-price-display">Rs. ${item.dealPrice}</span>
                                    <span style="text-decoration:line-through; color:#9CA3AF; font-size:1.2rem; margin-left:10px;">Rs. ${item.price}</span>
                                    <span style="background:var(--primary-emerald); color:white; font-size:0.9rem; padding:3px 8px; border-radius:4px; margin-left:10px; font-weight:700;">-${item.discount}% OFF</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="current-price" id="detail-price-display">Rs. ${item.price}</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="unit-info">/ ${item.quantity}</span>
                        </div>

                        <p class="short-description">${item.description}</p>

                        <!-- Add to Cart Form -->
                        <form action="${pageContext.request.contextPath}/customer/CartServlet" method="post" class="purchase-form">
                            <input type="hidden" name="itemId" value="${item.itemID}">
                            <input type="hidden" name="itemName" value="${item.name}">
                            <input type="hidden" name="itemPrice" value="${item.dealPrice != null ? item.dealPrice : item.price}">
                            <input type="hidden" name="itemDescription" value="${item.description}">
                            
                            <div class="purchase-controls">
                                <div class="quantity-selector">
                                    <button type="button" class="qty-btn" onclick="updateQty(-1)"><i class="fas fa-minus"></i></button>
                                    <input type="number" name="quantity" id="qtyInput" value="1" min="1" readonly>
                                    <button type="button" class="qty-btn" onclick="updateQty(1)"><i class="fas fa-plus"></i></button>
                                </div>
                                <button type="submit" class="btn-add-to-cart">
                                    <i class="fas fa-shopping-basket"></i> Add to Cart
                                </button>
                                <button type="button" class="btn-wishlist" onclick="toggleWishlist('${item.itemID}', this)">
                                    <i class="${sessionScope.wishlist != null && sessionScope.wishlist.contains(item.itemID.toString()) ? 'fas' : 'far'} fa-heart"
                                       style="${sessionScope.wishlist != null && sessionScope.wishlist.contains(item.itemID.toString()) ? 'color: #EF4444;' : ''}"></i>
                                </button>
                            </div>
                        </form>

                        <div class="trust-badges">
                            <div class="trust-item">
                                <i class="fas fa-truck"></i>
                                <span>Next Day Delivery</span>
                            </div>
                            <div class="trust-item">
                                <i class="fas fa-leaf"></i>
                                <span>100% Organic</span>
                            </div>
                            <div class="trust-item">
                                <i class="fas fa-undo"></i>
                                <span>Easy Returns</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Product Details Tabs -->
                <div class="container tabs-section">
                    <div class="tab-headers">
                        <button class="tab-btn active" onclick="switchTab(event, 'desc-tab')">Description</button>
                        <button class="tab-btn" onclick="switchTab(event, 'nutrition-tab')">Nutritional Info</button>
                        <button class="tab-btn" onclick="switchTab(event, 'reviews-tab')">Reviews (124)</button>
                    </div>
                    <div class="tab-content-area">
                        <div id="desc-tab" class="tab-pane active">
                            <h3>Product Description</h3>
                            <p>${item.description}</p>
                            <p>Farmart ensures you receive only the highest quality products. Our ${item.name} is carefully sourced and delivered fresh to maintain its natural goodness. Perfect for your daily needs.</p>
                        </div>
                        <div id="nutrition-tab" class="tab-pane">
                            <h3>Nutritional Information</h3>
                            <ul style="line-height: 1.8; color: #4B5563;">
                                <li><strong>Calories:</strong> Varies by serving</li>
                                <li><strong>Total Fat:</strong> Check packaging</li>
                                <li><strong>Sodium:</strong> Check packaging</li>
                                <li><strong>Carbohydrates:</strong> Natural sources</li>
                                <li><strong>Protein:</strong> Essential nutrients included</li>
                            </ul>
                            <p style="font-size: 0.85rem; color: #9CA3AF; margin-top: 15px;">*Percent Daily Values are based on a 2,000 calorie diet.</p>
                        </div>
                        <div id="reviews-tab" class="tab-pane">
                            <h3>Customer Reviews</h3>
                            <div class="mock-review">
                                <div class="review-header">
                                    <strong>Sarah J.</strong>
                                    <div class="star-rating" style="font-size: 0.8rem;"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></div>
                                </div>
                                <p>Absolutely love this! The quality is amazing and delivery was super fast.</p>
                            </div>
                            <div class="mock-review">
                                <div class="review-header">
                                    <strong>David M.</strong>
                                    <div class="star-rating" style="font-size: 0.8rem;"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i></div>
                                </div>
                                <p>Great product for the price. Will definitely order again.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Related Products -->
                <c:if test="${not empty relatedItems}">
                    <div class="container related-products-section">
                        <h2 class="section-title">You Might Also Like</h2>
                        <div class="product-grid-modern">
                            <c:forEach items="${relatedItems}" var="rItem">
                                <div class="prod-card-modern">
                                    <a href="item_details.jsp?id=${rItem.itemID}" style="text-decoration:none; color:inherit;">
                                        <img src="${pageContext.request.contextPath}/customer/image/item${rItem.itemID}.jpg" 
                                             class="prod-img" alt="${rItem.name}"
                                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg'">
                                        <h3 style="margin: 10px 0 5px; font-size: 1.1rem;">
                                            ${rItem.name}
                                            <c:if test="${rItem.discount > 0}">
                                                <span style="background:var(--primary-emerald); color:white; font-size:0.7rem; padding:2px 6px; border-radius:4px; vertical-align:middle; margin-left:5px;">-${rItem.discount}%</span>
                                            </c:if>
                                        </h3>
                                        <div style="color: #10B981; font-weight: 800; font-size: 1.1rem;">
                                            <c:choose>
                                                <c:when test="${rItem.discount > 0}">
                                                    Rs. ${rItem.dealPrice} <span style="text-decoration:line-through; color:#9CA3AF; font-size:0.8rem; margin-left:5px;">Rs. ${rItem.price}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    Rs. ${rItem.price}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

            </c:when>
            <c:otherwise>
                <div class="container error-container">
                    <i class="fas fa-search error-icon"></i>
                    <h2>Product Not Found</h2>
                    <p>We couldn't find the product you're looking for. It may have been removed or is currently unavailable.</p>
                    <a href="index.jsp" class="btn-return">Continue Shopping</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

    <script>
        const basePrice = ${item.price};
        
        function updateQty(change) {
            const input = document.getElementById('qtyInput');
            const priceDisplay = document.getElementById('detail-price-display');
            let val = parseInt(input.value) + change;
            if(val < 1) val = 1;
            input.value = val;
            
            // Real-time price update
            priceDisplay.textContent = 'Rs. ' + (basePrice * val).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        }

        function switchTab(evt, tabId) {
            // Hide all tab panes
            const panes = document.querySelectorAll('.tab-pane');
            panes.forEach(pane => pane.classList.remove('active'));

            // Remove active class from all buttons
            const btns = document.querySelectorAll('.tab-btn');
            btns.forEach(btn => btn.classList.remove('active'));

            // Show current tab and activate button
            document.getElementById(tabId).classList.add('active');
            evt.currentTarget.classList.add('active');
        }
    </script>
    <script src="${pageContext.request.contextPath}/customer/scripts/home_core.js"></script>

</body>
</html>