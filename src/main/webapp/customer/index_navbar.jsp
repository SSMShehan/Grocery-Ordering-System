<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="javax.servlet.http.HttpSession" %>
    <%@ page import="java.sql.*" %>
    <%@ page import="java.util.List" %>
    <%@ page import="java.util.ArrayList" %>
    <%@ page import="java.util.Map" %>
    <%@ page import="java.util.HashMap" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Fetch Categories for Navbar Dropdown
    List<Map<String, String>> navCatList = new ArrayList<>();
    Connection navCon = null;
    PreparedStatement navPst = null;
    ResultSet navRs = null;
    try {
        Class.forName("org.postgresql.Driver");
        navCon = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        navPst = navCon.prepareStatement("SELECT name FROM category ORDER BY name ASC");
        navRs = navPst.executeQuery();
        while (navRs.next()) {
            Map<String, String> cat = new HashMap<>();
            String name = navRs.getString("name");
            cat.put("name", name);
            String nLow = name.toLowerCase();
            String icon = "fa-box";
            if (nLow.contains("veg")) icon = "fa-carrot";
            else if (nLow.contains("fruit")) icon = "fa-apple-alt";
            else if (nLow.contains("dair") || nLow.contains("milk")) icon = "fa-cheese";
            else if (nLow.contains("bake")) icon = "fa-bread-slice";
            else if (nLow.contains("meat")) icon = "fa-drumstick-bite";
            else if (nLow.contains("bev")) icon = "fa-glass-cheers";
            else if (nLow.contains("snack")) icon = "fa-cookie";
            else if (nLow.contains("baby")) icon = "fa-baby";
            else if (nLow.contains("froz")) icon = "fa-snowflake";
            else if (nLow.contains("house")) icon = "fa-home";
            else if (nLow.contains("beaut")) icon = "fa-spa";
            cat.put("icon", icon);
            navCatList.add(cat);
        }
    } catch(Exception e) {} finally {
        if(navRs!=null) try{navRs.close();}catch(Exception e){}
        if(navPst!=null) try{navPst.close();}catch(Exception e){}
        if(navCon!=null) try{navCon.close();}catch(Exception e){}
    }
    request.setAttribute("navCatList", navCatList);
%>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>NextGen Navbar</title>
            <!-- New Next-Gen Styles -->
            <link rel="stylesheet" href="./styles/index_navbar_nextgen.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                /* Search Dropdown styling */
                .search-dropdown {
                    position: absolute;
                    top: 110%;
                    left: 0;
                    right: 0;
                    background: rgba(255, 255, 255, 0.98);
                    backdrop-filter: blur(20px);
                    border-radius: 15px;
                    box-shadow: 0 15px 35px rgba(0,0,0,0.1);
                    border: 1px solid rgba(0,0,0,0.05);
                    overflow: hidden;
                    z-index: 2000;
                    animation: fadeInDown 0.3s ease;
                }

                @keyframes fadeInDown {
                    from { opacity: 0; transform: translateY(-10px); }
                    to { opacity: 1; transform: translateY(0); }
                }

                .search-result-item {
                    display: flex;
                    align-items: center;
                    padding: 12px 15px;
                    text-decoration: none;
                    color: var(--dark-text);
                    border-bottom: 1px solid #F3F4F6;
                    transition: all 0.2s ease;
                }

                .search-result-item:last-child {
                    border-bottom: none;
                }

                .search-result-item:hover {
                    background: #F0FDF4;
                }

                .search-result-item img {
                    width: 40px;
                    height: 40px;
                    object-fit: cover;
                    border-radius: 8px;
                    margin-right: 15px;
                }

                .search-result-info {
                    display: flex;
                    flex-direction: column;
                }

                .search-result-info h4 {
                    margin: 0 0 3px 0;
                    font-size: 0.95rem;
                    font-weight: 600;
                    color: var(--dark-text);
                }

                .search-result-info span {
                    color: #10B981;
                    font-weight: 700;
                    font-size: 0.85rem;
                }

                .search-no-results {
                    padding: 15px;
                    text-align: center;
                    color: var(--light-text);
                    font-size: 0.95rem;
                }
            </style>
        </head>

        <body>

            <nav class="navbar-nextgen">
                <!-- Top notification bar (optional, kept subtle) -->
                <div class="nav-top-bar">
                    <small>🌿 Fresh products delivered to your doorstep in 24 hours!</small>
                    <div class="top-links">
                        <a href="${pageContext.request.contextPath}/customer/track_order.jsp">Track Order</a>
                        <a href="${pageContext.request.contextPath}/customer/support.jsp">Support</a>
                    </div>
                </div>

                <div class="nav-main">
                    <!-- Logo Section -->
                    <a href="index.jsp" class="logo-container">
                        <div class="logo-box">
                            <img src="${pageContext.request.contextPath}/customer/image/logo.png" alt="Farmart">
                        </div>
                        <div class="logo-text">
                            <span class="brand-name">Farmart</span>
                            <span class="brand-tag">Grocery</span>
                        </div>
                    </a>

                    <!-- Animated Search Bar -->
                    <div class="search-container">
                        <div class="search-wrapper" style="position: relative;">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" placeholder="Search for fresh vegetables, fruits..." id="searchInput" autocomplete="off">
                            <button class="search-btn">Search</button>
                            
                            <!-- Search Results Dropdown -->
                            <div id="searchResults" class="search-dropdown" style="display: none;">
                                <!-- Populated via JS -->
                            </div>
                        </div>
                    </div>

                    <!-- Action Icons -->
                    <div class="nav-actions">
                        <a href="wishlist.jsp" class="action-item" title="Wishlist">
                            <i class="far fa-heart"></i>
                            <span class="action-label">Wishlist</span>
                            <span class="count-badge" id="nav-wishlist-count" style="display: none;">0</span>
                        </a>

                        <c:choose>
                            <c:when test="${not empty sessionScope.userID}">
                                <div class="profile-dropdown-wrapper" style="position: relative; display: inline-block;">
                                    <a href="#" class="action-item" title="Account" onclick="event.preventDefault(); var m = document.getElementById('profile-menu'); m.style.display = m.style.display === 'none' ? 'block' : 'none';">
                                        <i class="far fa-user" style="color: var(--primary-mint);"></i>
                                        <span class="action-label">${sessionScope.username}</span>
                                    </a>
                                    <div id="profile-menu" class="search-dropdown" style="display: none; width: 150px; left: auto; right: 0; top: 110%; padding: 10px;">
                                        <a href="profile.jsp" style="display: block; padding: 10px; text-decoration: none; color: #374151;"><i class="fas fa-id-badge"></i> My Profile</a>
                                        <a href="order_history.jsp" style="display: block; padding: 10px; text-decoration: none; color: #374151;"><i class="fas fa-box"></i> Orders</a>
                                        <div style="border-top: 1px solid #E5E7EB; margin: 5px 0;"></div>
                                        <a href="api_auth.jsp?action=logout" style="display: block; padding: 10px; text-decoration: none; color: #EF4444;"><i class="fas fa-sign-out-alt"></i> Logout</a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="login.jsp" class="action-item" title="Login / Register">
                                    <i class="far fa-user"></i>
                                    <span class="action-label">Login</span>
                                </a>
                            </c:otherwise>
                        </c:choose>

                        <c:set var="cartTotal" value="0" />
                                <c:forEach items="${sessionScope.cart}" var="cartItem">
                                    <c:set var="cartTotal"
                                        value="${cartTotal + (cartItem.itemPrice * cartItem.quantity)}" />
                                </c:forEach>
                                <a href="cart.jsp" class="action-item cart-action" title="Cart">
                                    <div class="cart-icon-box">
                                        <i class="fas fa-shopping-cart"></i>
                                        <span class="cart-count">${sessionScope.cart != null ? sessionScope.cart.size()
                                            : 0}</span>
                                    </div>
                                    <div class="cart-info">
                                        <span class="cart-text">My Cart</span>
                                        <span class="cart-total">Rs.
                                            <fmt:formatNumber value="${cartTotal}" pattern="#,##0.00" />
                                        </span>
                                    </div>
                                </a>
                    </div>
                </div>

                <!-- Navigation Menu with Magic Line -->
                <div class="nav-menu-container">
                    <div class="container-inner">
                        <!-- Categories Dropdown Trigger -->
                        <div class="categories-wrapper">
                            <button class="cat-btn">
                                <i class="fas fa-grid-2"></i>
                                <span>All Categories</span>
                                <i class="fas fa-chevron-down arrow"></i>
                            </button>
                            <!-- Mega Menu / Dropdown -->
                            <div class="categories-dropdown">
                                <c:forEach var="nCat" items="${navCatList}">
                                    <a href="ItemCategoryServlet?category=${nCat.name}">
                                        <i class="fas ${nCat.icon}"></i> ${nCat.name}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Main Links with Lavalamp Effect -->
                        <ul class="nav-links-list" id="navLinks">
                            <li class="nav-item"><a href="index.jsp" class="nav-link"><i class="fas fa-home"></i>
                                    Home</a></li>
                            <li class="nav-item"><a href="offers.jsp" class="nav-link"><i class="fas fa-percent"></i>
                                    Offers</a>
                            </li>
                            <li class="nav-item"><a href="ItemCategoryServlet?category=Baby Product"
                                    class="nav-link">Baby</a></li>
                            <li class="nav-item"><a href="ItemCategoryServlet?category=Dairy"
                                    class="nav-link">Dairy</a>
                            </li>
                            <li class="nav-item"><a href="ItemCategoryServlet?category=Frozen Food"
                                    class="nav-link">Frozen</a></li>
                            <li class="nav-item"><a href="ItemCategoryServlet?category=Beverages"
                                    class="nav-link">Drinks</a></li>

                            <!-- The Magic Line Element -->
                            <div class="magic-line"></div>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- Magic Line Script -->
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    const navList = document.getElementById('navLinks');
                    const links = navList.querySelectorAll('.nav-link');
                    const magicLine = navList.querySelector('.magic-line');

                    function moveLine(target) {
                        if (!target) return;
                        const linkRect = target.getBoundingClientRect();
                        const listRect = navList.getBoundingClientRect();

                        magicLine.style.width = linkRect.width + 'px';
                        magicLine.style.left = (linkRect.left - listRect.left) + 'px';
                        magicLine.style.opacity = '1';
                    }

                    links.forEach(link => {
                        link.addEventListener('mouseenter', (e) => {
                            moveLine(e.currentTarget);
                        });
                    });

                    navList.addEventListener('mouseleave', () => {
                        const active = navList.querySelector('.active');
                        if(active) {
                            moveLine(active);
                        } else {
                            magicLine.style.opacity = '0';
                        }
                    });

                    // Determine Active Link based on URL
                    const currentUrl = decodeURIComponent(window.location.href);
                    let hasActive = false;

                    links.forEach(link => {
                        const href = link.getAttribute('href');
                        if (href && href !== '#' && currentUrl.includes(href)) {
                            link.classList.add('active');
                            hasActive = true;
                        }
                    });

                    // Default to Home if root path
                    if (!hasActive && (currentUrl.endsWith('/customer/') || currentUrl.endsWith('/grocery/'))) {
                        links[0].classList.add('active');
                    }

                    // Initialize position
                    const activeLink = navList.querySelector('.active');
                    if (activeLink) {
                        setTimeout(() => moveLine(activeLink), 100);
                    } else {
                        magicLine.style.opacity = '0';
                    }
                });

                // Sticky Navbar transparency effect
                window.addEventListener('scroll', () => {
                    const nav = document.querySelector('.navbar-nextgen');
                    if (window.scrollY > 50) {
                        nav.classList.add('scrolled');
                    } else {
                        nav.classList.remove('scrolled');
                    }
                });

                // Real-Time Search Logic
                document.addEventListener('DOMContentLoaded', () => {
                    const searchInput = document.getElementById('searchInput');
                    const searchResults = document.getElementById('searchResults');
                    let debounceTimer;

                    searchInput.addEventListener('input', (e) => {
                        const query = e.target.value.trim();
                        
                        clearTimeout(debounceTimer);
                        
                        if (query.length < 2) {
                            searchResults.style.display = 'none';
                            searchResults.innerHTML = '';
                            return;
                        }

                        debounceTimer = setTimeout(() => {
                            fetch(`${pageContext.request.contextPath}/customer/api_search.jsp?q=` + encodeURIComponent(query))
                                .then(response => response.json())
                                .then(data => {
                                    if (data.length === 0) {
                                        searchResults.innerHTML = '<div class="search-no-results">No items found for "' + query + '"</div>';
                                        searchResults.style.display = 'block';
                                    } else {
                                        let html = '';
                                        data.forEach(item => {
                                            const ctx = "${pageContext.request.contextPath}";
                                            html += '<a href="' + ctx + '/customer/item_details.jsp?id=' + item.id + '" class="search-result-item">';
                                            html += '<img src="' + ctx + '/customer/image/item' + item.id + '.jpg" onerror="this.src=this.dataset.fallback" data-fallback="' + ctx + '/customer/image/placeholder.jpg" alt="' + item.name + '">';
                                            html += '<div class="search-result-info">';
                                            html += '<h4>' + item.name + '</h4>';
                                            html += '<span>Rs. ' + item.price + '</span>';
                                            html += '</div></a>';
                                        });
                                        searchResults.innerHTML = html;
                                        searchResults.style.display = 'block';
                                    }
                                })
                                .catch(err => console.error('Error fetching search results:', err));
                        }, 300); // 300ms debounce
                    });

                    // Hide dropdown when clicking outside
                    document.addEventListener('click', (e) => {
                        if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
                            searchResults.style.display = 'none';
                        }
                    });

                    // Show again when clicking on input if there's text
                    searchInput.addEventListener('focus', () => {
                        if (searchInput.value.trim().length >= 2 && searchResults.innerHTML.trim() !== '') {
                            searchResults.style.display = 'block';
                        }
                    });
                });

                // Global function to update Wishlist count in Navbar
                window.updateWishlistCount = function() {
                    fetch("${pageContext.request.contextPath}/customer/api_wishlist.jsp?action=count")
                        .then(response => response.json())
                        .then(data => {
                            const badge = document.getElementById('nav-wishlist-count');
                            if (badge) {
                                if (data.count > 0) {
                                    badge.innerText = data.count;
                                    badge.style.display = 'block';
                                } else {
                                    badge.style.display = 'none';
                                }
                            }
                        })
                        .catch(err => console.error('Error fetching wishlist count:', err));
                };

                // Fetch count on page load
                document.addEventListener('DOMContentLoaded', () => {
                    window.updateWishlistCount();
                });

                // Global function to toggle wishlist (Add/Remove)
                window.toggleWishlist = function(itemId, btnElement) {
                    if (!itemId) return;
                    
                    const icon = btnElement.querySelector('i');
                    const isAdded = icon.classList.contains('fas'); // solid heart means added
                    
                    const action = isAdded ? 'remove' : 'add';
                    
                    // Optimistic UI update
                    if (isAdded) {
                        icon.classList.remove('fas', 'text-red-500');
                        icon.classList.add('far');
                        icon.style.color = '';
                    } else {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                        icon.style.color = '#EF4444'; // Red color
                    }
                    
                    // Add animation pulse
                    icon.style.transform = 'scale(1.3)';
                    setTimeout(() => icon.style.transform = 'scale(1)', 200);

                    // API call
                    fetch(`${pageContext.request.contextPath}/customer/api_wishlist.jsp?action=` + action + `&id=` + itemId)
                        .then(response => response.json())
                        .then(data => {
                            if(data.status === 'success') {
                                window.updateWishlistCount();
                            }
                        })
                        .catch(err => {
                            console.error('Error toggling wishlist:', err);
                            // Revert on error (optional)
                        });
                };
            </script>

        </body>

        </html>