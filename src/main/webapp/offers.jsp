<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="admin_navbar.jsp" %>

<div class="header-container" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
    <h1 class="page-title" style="margin:0;">Offers Management</h1>
</div>

<%
    String msg = request.getParameter("msg");
    if(msg != null) {
        out.print("<div style='background:rgba(16,185,129,0.1); color:#10B981; padding:10px 20px; border-radius:8px; margin-bottom:20px; font-weight:600;'>" + msg + "</div>");
    }
    String error = request.getParameter("error");
    if(error != null) {
        out.print("<div style='background:rgba(239,68,68,0.1); color:#EF4444; padding:10px 20px; border-radius:8px; margin-bottom:20px; font-weight:600;'>" + error + "</div>");
    }
%>

<!-- Active Offers Table -->
<div class="admin-table-container">
    <div class="admin-table-header" style="display:flex; justify-content:space-between; align-items:center;">
        <h2 style="color:var(--success);"><i class="fas fa-bolt"></i> Active Offers</h2>
    </div>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Regular Price</th>
                <th>Offer Price</th>
                <th>Discount (%)</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection con = null;
    PreparedStatement pst1 = null;
    PreparedStatement pst2 = null;
    ResultSet rs1 = null;
    ResultSet rs2 = null;
    String searchParam = request.getParameter("search");

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        // --- ACTIVE OFFERS ---
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            pst1 = con.prepareStatement("SELECT * FROM item WHERE name ILIKE ? AND discount_percentage > 0 ORDER BY \"itemID\" DESC");
            pst1.setString(1, "%" + searchParam.trim() + "%");
        } else {
            pst1 = con.prepareStatement("SELECT * FROM item WHERE discount_percentage > 0 ORDER BY \"itemID\" DESC");
        }
        rs1 = pst1.executeQuery();
        boolean hasActive = false;
        while(rs1.next()) {
            hasActive = true;
            int id = rs1.getInt("itemID");
            String name = rs1.getString("name");
            double price = Double.parseDouble(rs1.getString("price"));
            int discount = rs1.getInt("discount_percentage");
            double offerPrice = price - (price * discount / 100.0);
            String imgSrc = "customer/image/item" + id + ".jpg";
%>
            <tr style="background-color: rgba(16, 185, 129, 0.05);">
                <td style="font-weight:600; color:var(--text-muted);">#<%= id %></td>
                <td><img src="<%= imgSrc %>" style="width:40px; height:40px; border-radius:8px; object-fit:cover; border:1px solid var(--border-color);" onerror="this.src='customer/image/placeholder.jpg'"></td>
                <td style="font-weight:600; color:white;"><%= name %></td>
                <td><span style="text-decoration: line-through; color: var(--text-muted);">Rs. <%= String.format("%.2f", price) %></span></td>
                <td style="color:var(--success); font-weight:700;">Rs. <%= String.format("%.2f", offerPrice) %></td>
                <td><span class="badge badge-delivered"><%= discount %>% OFF</span></td>
                <td>
                    <button class="btn-edit" onclick="openOfferModal(<%= id %>, '<%= name.replace("'", "\\'") %>', <%= discount %>)" style="background:var(--primary); color:black;">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                </td>
            </tr>
<%      }
        if(!hasActive) {
            out.print("<tr><td colspan='7' style='text-align:center; color:var(--text-muted); padding: 30px;'>No active offers right now.</td></tr>");
        }
%>
        </tbody>
    </table>
</div>

<!-- Assign Flash Offers Table -->
<div class="admin-table-container">
    <div class="admin-table-header" style="display:flex; justify-content:space-between; align-items:center;">
        <h2>Assign Flash Offers</h2>
        <form method="GET" action="offers.jsp" style="display:flex; gap:10px;">
            <input type="text" name="search" placeholder="Search item..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" style="padding:8px 12px; border-radius:6px; border:1px solid var(--border-color); background:rgba(0,0,0,0.2); color:white;">
            <button type="submit" class="btn-primary" style="padding:8px 15px;">Search</button>
            <% if(request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
                <a href="offers.jsp" class="btn-primary" style="background:#4B5563; padding:8px 15px; text-decoration:none;">Clear</a>
            <% } %>
        </form>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Regular Price</th>
                <th>Offer Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
        // --- REGULAR ITEMS ---
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            pst2 = con.prepareStatement("SELECT * FROM item WHERE name ILIKE ? AND (discount_percentage = 0 OR discount_percentage IS NULL) ORDER BY \"itemID\" DESC");
            pst2.setString(1, "%" + searchParam.trim() + "%");
        } else {
            pst2 = con.prepareStatement("SELECT * FROM item WHERE discount_percentage = 0 OR discount_percentage IS NULL ORDER BY \"itemID\" DESC");
        }
        rs2 = pst2.executeQuery();

        while(rs2.next()) {
            int id = rs2.getInt("itemID");
            String name = rs2.getString("name");
            double price = Double.parseDouble(rs2.getString("price"));
            String imgSrc = "customer/image/item" + id + ".jpg";
%>
            <tr>
                <td style="font-weight:600; color:var(--text-muted);">#<%= id %></td>
                <td><img src="<%= imgSrc %>" style="width:40px; height:40px; border-radius:8px; object-fit:cover; border:1px solid var(--border-color);" onerror="this.src='customer/image/placeholder.jpg'"></td>
                <td style="font-weight:600; color:white;"><%= name %></td>
                <td>Rs. <%= String.format("%.2f", price) %></td>
                <td><span class="badge badge-pending">None</span></td>
                <td>
                    <button class="btn-edit" onclick="openOfferModal(<%= id %>, '<%= name.replace("'", "\\'") %>', 0)" style="background:var(--primary); color:black;">
                        <i class="fas fa-tag"></i> Set Offer
                    </button>
                </td>
            </tr>
<%
        }
    } catch(Exception e) {
        out.print("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        if(rs1!=null)try{rs1.close();}catch(Exception e){}
        if(rs2!=null)try{rs2.close();}catch(Exception e){}
        if(pst1!=null)try{pst1.close();}catch(Exception e){}
        if(pst2!=null)try{pst2.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
        </tbody>
    </table>
</div>

<!-- Modal Styles -->
<style>
.modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.7); align-items:center; justify-content:center; backdrop-filter:blur(5px); }
.modal-content { background:var(--card-bg); width:90%; max-width:400px; padding:30px; border-radius:16px; border:1px solid var(--border-color); box-shadow:0 10px 25px rgba(0,0,0,0.5); }
.modal-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; border-bottom:1px solid var(--border-color); padding-bottom:15px; }
.modal-header h3 { color:white; margin:0; }
.close-btn { color:var(--text-muted); font-size:1.5rem; cursor:pointer; }
.close-btn:hover { color:white; }
.form-group { margin-bottom: 15px; }
.form-group label { display:block; color:var(--text-muted); font-size:0.85rem; margin-bottom:5px; text-transform:uppercase; letter-spacing:0.5px; }
.form-group input { width:100%; padding:10px 14px; background:rgba(0,0,0,0.2); border:1px solid var(--border-color); color:white; border-radius:8px; font-family:'Outfit'; }
.form-group input:focus { border-color:var(--primary-accent); outline:none; }
</style>

<!-- Offer Modal -->
<div id="offerModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="offerModalTitle">Set Offer</h3>
            <span class="close-btn" onclick="closeModal('offerModal')">&times;</span>
        </div>
        <form method="POST" action="api_admin_offers.jsp">
            <input type="hidden" name="action" value="update_offer">
            <input type="hidden" name="itemID" id="offer_item_id">
            
            <div class="form-group">
                <label>Discount Percentage (%)</label>
                <input type="number" name="discount" id="offer_discount" min="0" max="100" required>
                <small style="color:var(--text-muted); margin-top:5px; display:block;">Set to 0 to remove offer.</small>
            </div>
            
            <div style="margin-top:20px; display:flex; gap:10px; justify-content:flex-end;">
                <button type="button" class="btn-primary" style="background:transparent; border:1px solid var(--border-color); color:var(--text-muted);" onclick="closeModal('offerModal')">Cancel</button>
                <button type="submit" class="btn-primary" style="background:var(--primary); color:black;"><i class="fas fa-save"></i> Save Offer</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('nav-offers').classList.add('active');

    function openOfferModal(id, name, currentDiscount) {
        document.getElementById('offerModalTitle').innerText = 'Set Offer for: ' + name;
        document.getElementById('offer_item_id').value = id;
        document.getElementById('offer_discount').value = currentDiscount;
        document.getElementById('offerModal').style.display = 'flex';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }
</script>

        </div> <!-- End admin-content -->
    </main> <!-- End admin-main -->
</body>
</html>
