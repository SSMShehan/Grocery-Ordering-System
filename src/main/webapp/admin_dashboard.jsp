<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="admin_navbar.jsp" %>

<%
    int totalOrders = 0;
    int totalCustomers = 0;
    int totalProducts = 0;
    double totalRevenue = 0.0;

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        stmt = con.createStatement();

        // 1. Total Orders
        rs = stmt.executeQuery("SELECT COUNT(*) FROM \"order\"");
        if(rs.next()) totalOrders = rs.getInt(1);
        rs.close();

        // 2. Total Customers
        rs = stmt.executeQuery("SELECT COUNT(*) FROM \"user\" WHERE role='customer'");
        if(rs.next()) totalCustomers = rs.getInt(1);
        rs.close();

        // 3. Total Products
        rs = stmt.executeQuery("SELECT COUNT(*) FROM item");
        if(rs.next()) totalProducts = rs.getInt(1);
        rs.close();

        // 4. Total Revenue
        rs = stmt.executeQuery("SELECT SUM(CAST(amount AS FLOAT)) FROM \"order\"");
        if(rs.next()) totalRevenue = rs.getDouble(1);
        rs.close();

        // 5. Top Selling Items
        String topSql = "SELECT i.\"itemID\", i.name, i.price, COALESCE(SUM(CAST(oi.quantity AS INT)), 0) as total_sold " +
                        "FROM item i LEFT JOIN order_item oi ON i.\"itemID\" = oi.\"itemID\" " +
                        "GROUP BY i.\"itemID\", i.name, i.price ORDER BY total_sold DESC LIMIT 5";
        rs = stmt.executeQuery(topSql);
        request.setAttribute("topItems", rs); // We will process this manually below or extract to list
        List<Map<String, String>> topList = new ArrayList<>();
        while(rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("id", rs.getString("itemID"));
            item.put("name", rs.getString("name"));
            item.put("price", rs.getString("price"));
            item.put("sold", rs.getString("total_sold"));
            topList.add(item);
        }
        request.setAttribute("topList", topList);
        rs.close();

        // 6. Slow Moving Items
        String slowSql = "SELECT i.\"itemID\", i.name, i.price, COALESCE(SUM(CAST(oi.quantity AS INT)), 0) as total_sold " +
                         "FROM item i LEFT JOIN order_item oi ON i.\"itemID\" = oi.\"itemID\" " +
                         "GROUP BY i.\"itemID\", i.name, i.price ORDER BY total_sold ASC LIMIT 5";
        rs = stmt.executeQuery(slowSql);
        List<Map<String, String>> slowList = new ArrayList<>();
        while(rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("id", rs.getString("itemID"));
            item.put("name", rs.getString("name"));
            item.put("price", rs.getString("price"));
            item.put("sold", rs.getString("total_sold"));
            slowList.add(item);
        }
        request.setAttribute("slowList", slowList);
        rs.close();

        // 7. Orders Over Time (Last 7 distinct dates)
        String ordersSql = "SELECT order_date, COUNT(*) as count, SUM(CAST(amount AS FLOAT)) as rev FROM \"order\" GROUP BY order_date ORDER BY order_date ASC";
        rs = stmt.executeQuery(ordersSql);
        List<String> orderDates = new ArrayList<>();
        List<Integer> orderCounts = new ArrayList<>();
        List<Double> orderRevs = new ArrayList<>();
        while(rs.next()) {
            orderDates.add("\"" + rs.getString("order_date") + "\"");
            orderCounts.add(rs.getInt("count"));
            orderRevs.add(rs.getDouble("rev"));
        }
        request.setAttribute("orderDates", orderDates);
        request.setAttribute("orderCounts", orderCounts);
        request.setAttribute("orderRevs", orderRevs);
        rs.close();

        // 8. Category Distribution
        String catSql = "SELECT category, COUNT(*) as count FROM item GROUP BY category";
        rs = stmt.executeQuery(catSql);
        List<String> catNames = new ArrayList<>();
        List<Integer> catCounts = new ArrayList<>();
        while(rs.next()) {
            String cName = rs.getString("category");
            if(cName == null || cName.trim().isEmpty()) cName = "Uncategorized";
            catNames.add("\"" + cName + "\"");
            catCounts.add(rs.getInt("count"));
        }
        request.setAttribute("catNames", catNames);
        request.setAttribute("catCounts", catCounts);
        rs.close();

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs!=null)try{rs.close();}catch(Exception e){}
        if(stmt!=null)try{stmt.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>

<h1 class="page-title">Admin Dashboard</h1>

<div class="stats-grid">
    <!-- Revenue -->
    <div class="stat-card">
        <div class="stat-icon icon-blue"><i class="fas fa-dollar-sign"></i></div>
        <div class="stat-info">
            <p>Total Revenue</p>
            <h3>Rs. <%= String.format("%.2f", totalRevenue) %></h3>
        </div>
    </div>
    
    <!-- Orders -->
    <div class="stat-card">
        <div class="stat-icon icon-green"><i class="fas fa-shopping-cart"></i></div>
        <div class="stat-info">
            <p>Total Orders</p>
            <h3><%= totalOrders %></h3>
        </div>
    </div>
    
    <!-- Customers -->
    <div class="stat-card">
        <div class="stat-icon icon-purple"><i class="fas fa-users"></i></div>
        <div class="stat-info">
            <p>Customers</p>
            <h3><%= totalCustomers %></h3>
        </div>
    </div>
    
    <!-- Products -->
    <div class="stat-card">
        <div class="stat-icon icon-orange"><i class="fas fa-box"></i></div>
        <div class="stat-info">
            <p>Active Products</p>
            <h3><%= totalProducts %></h3>
        </div>
    </div>
</div>
<!-- Charts Section -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div style="display: grid; grid-template-columns: 2fr 1fr; gap: 24px; margin-bottom: 40px;">
    <!-- Revenue Chart -->
    <div style="background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid var(--border-color);">
        <h3 style="margin-bottom: 20px; color: var(--text-main); font-weight: 700;">Revenue Over Time</h3>
        <div style="position: relative; height: 300px; width: 100%;">
            <canvas id="revenueChart"></canvas>
        </div>
    </div>
    
    <!-- Category Chart -->
    <div style="background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid var(--border-color);">
        <h3 style="margin-bottom: 20px; color: var(--text-main); font-weight: 700;">Products by Category</h3>
        <div style="position: relative; height: 300px; width: 100%;">
            <canvas id="categoryChart"></canvas>
        </div>
    </div>
</div>

<!-- Sales Analytics Section -->
<h2 class="page-title" style="margin-top: 40px; font-size: 1.5rem; color: #1f2937;">Sales Analytics & Insights</h2>
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 20px; margin-bottom: 40px;">
    
    <!-- Hot Sellers -->
    <div style="background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border-top: 4px solid #10B981;">
        <h3 style="margin-bottom: 20px; color: #10B981; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-fire"></i> Hot Sellers (Top 5)
        </h3>
        <div style="display: flex; flex-direction: column; gap: 15px;">
            <% 
                List<Map<String, String>> topList = (List<Map<String, String>>) request.getAttribute("topList");
                if(topList != null && !topList.isEmpty()) {
                    for(Map<String, String> item : topList) {
            %>
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background: #f9fafb; border-radius: 8px;">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <img src="${pageContext.request.contextPath}/customer/image/item<%= item.get("id") %>.jpg" 
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg';"
                         style="width: 50px; height: 50px; border-radius: 6px; object-fit: cover;">
                    <div>
                        <div style="font-weight: 600; color: #374151;"><%= item.get("name") %></div>
                        <div style="font-size: 0.85rem; color: #6B7280;">Rs. <%= item.get("price") %></div>
                    </div>
                </div>
                <div style="text-align: right;">
                    <div style="font-weight: 700; color: #10B981; font-size: 1.1rem;"><%= item.get("sold") %> Sold</div>
                    <a href="offers.jsp" style="font-size: 0.8rem; color: #3B82F6; text-decoration: none;">View</a>
                </div>
            </div>
            <%      }
                } else { %>
                <p style="color: #6B7280;">No data available.</p>
            <% } %>
        </div>
    </div>

    <!-- Slow Movers -->
    <div style="background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border-top: 4px solid #EF4444;">
        <h3 style="margin-bottom: 20px; color: #EF4444; display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-snail"></i> Slow Movers (Candidates for Offers)
        </h3>
        <div style="display: flex; flex-direction: column; gap: 15px;">
            <% 
                List<Map<String, String>> slowList = (List<Map<String, String>>) request.getAttribute("slowList");
                if(slowList != null && !slowList.isEmpty()) {
                    for(Map<String, String> item : slowList) {
            %>
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 10px; background: #f9fafb; border-radius: 8px; border-left: 3px solid #FCA5A5;">
                <div style="display: flex; align-items: center; gap: 15px;">
                    <img src="${pageContext.request.contextPath}/customer/image/item<%= item.get("id") %>.jpg" 
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/customer/image/placeholder.jpg';"
                         style="width: 50px; height: 50px; border-radius: 6px; object-fit: cover;">
                    <div>
                        <div style="font-weight: 600; color: #374151;"><%= item.get("name") %></div>
                        <div style="font-size: 0.85rem; color: #6B7280;">Rs. <%= item.get("price") %></div>
                    </div>
                </div>
                <div style="text-align: right;">
                    <div style="font-weight: 700; color: #EF4444; font-size: 1.1rem;"><%= item.get("sold") %> Sold</div>
                    <a href="offers.jsp?search=<%= java.net.URLEncoder.encode(item.get("name"), "UTF-8") %>" 
                       style="display: inline-block; background: #EF4444; color: white; padding: 4px 10px; border-radius: 4px; font-size: 0.8rem; text-decoration: none; margin-top: 5px;">Set Offer</a>
                </div>
            </div>
            <%      }
                } else { %>
                <p style="color: #6B7280;">No data available.</p>
            <% } %>
        </div>
    </div>
</div>

<script>
    document.getElementById('nav-dashboard').classList.add('active');

    // Chart.js Configuration
    const revCtx = document.getElementById('revenueChart').getContext('2d');
    const catCtx = document.getElementById('categoryChart').getContext('2d');

    <% 
        List<String> orderDates = (List<String>) request.getAttribute("orderDates");
        List<Double> orderRevs = (List<Double>) request.getAttribute("orderRevs");
        List<String> catNames = (List<String>) request.getAttribute("catNames");
        List<Integer> catCounts = (List<Integer>) request.getAttribute("catCounts");
    %>

    new Chart(revCtx, {
        type: 'line',
        data: {
            labels: <%= orderDates != null ? orderDates : "[]" %>,
            datasets: [{
                label: 'Daily Revenue (Rs.)',
                data: <%= orderRevs != null ? orderRevs : "[]" %>,
                borderColor: '#3B82F6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                borderWidth: 3,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                x: { grid: { display: false } }
            }
        }
    });

    new Chart(catCtx, {
        type: 'doughnut',
        data: {
            labels: <%= catNames != null ? catNames : "[]" %>,
            datasets: [{
                data: <%= catCounts != null ? catCounts : "[]" %>,
                backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#8B5CF6', '#EF4444', '#14B8A6'],
                borderWidth: 0,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' }
            },
            cutout: '70%'
        }
    });
</script>

        </div> <!-- End admin-content -->
    </main> <!-- End admin-main -->
</body>
</html>