<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="admin_navbar.jsp" %>

<div class="header-container" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
    <h1 class="page-title" style="margin:0;">Product Management</h1>
    <button class="btn-primary" onclick="openCreateModal()">
        <i class="fas fa-plus"></i> Add New Product
    </button>
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

<div class="admin-table-container">
    <div class="admin-table-header" style="display:flex; justify-content:space-between; align-items:center;">
        <h2>Inventory</h2>
        <form method="GET" action="item.jsp" style="display:flex; gap:10px;">
            <input type="text" name="search" placeholder="Search product name or category..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" style="padding:8px 12px; border-radius:6px; border:1px solid var(--border-color); background:rgba(0,0,0,0.2); color:white;">
            <button type="submit" class="btn-primary" style="padding:8px 15px;">Search</button>
            <% if(request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
                <a href="item.jsp" class="btn-primary" style="background:#4B5563; padding:8px 15px; text-decoration:none;">Clear</a>
            <% } %>
        </form>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    String searchParam = request.getParameter("search");

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            pst = con.prepareStatement("SELECT * FROM item WHERE name ILIKE ? OR category ILIKE ? ORDER BY \"itemID\" DESC");
            pst.setString(1, "%" + searchParam.trim() + "%");
            pst.setString(2, "%" + searchParam.trim() + "%");
        } else {
            pst = con.prepareStatement("SELECT * FROM item ORDER BY \"itemID\" DESC");
        }
        rs = pst.executeQuery();

        while(rs.next()) {
            int id = rs.getInt("itemID");
            String name = rs.getString("name");
            String cat = rs.getString("category");
            String price = rs.getString("price");
            String qty = rs.getString("quantity");
            String desc = rs.getString("description");
            
            String imgSrc = "customer/image/item" + id + ".jpg"; // default mapping using ID
            
            // Format for JS params
            String safeName = name.replace("'", "\\'");
            String safeCat = cat != null ? cat.replace("'", "\\'") : "";
            String safeDesc = desc != null ? desc.replace("'", "\\'").replace("\n", " ") : "";
%>
            <tr>
                <td style="font-weight:600; color:var(--text-muted);">#<%= id %></td>
                <td><img src="<%= imgSrc %>" style="width:40px; height:40px; border-radius:8px; object-fit:cover; border:1px solid var(--border-color);"></td>
                <td style="font-weight:600; color:white;"><%= name %></td>
                <td><span class="badge" style="background:rgba(255,255,255,0.05); color:var(--text-muted); border:1px solid var(--border-color);"><%= cat %></span></td>
                <td style="color:var(--success); font-weight:600;">Rs. <%= price %></td>
                <td><%= qty %></td>
                <td>
                    <button class="btn-edit" onclick="openEditModal(<%= id %>, '<%= safeName %>', '<%= price %>', '<%= qty %>', '<%= safeCat %>', '<%= safeDesc %>')">
                        <i class="fas fa-edit"></i>
                    </button>
                    <a href="api_admin_item.jsp?action=delete&itemID=<%= id %>" class="btn-delete" onclick="return confirm('Delete this item?')">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>
            </tr>
<%
        }
    } catch(Exception e) {
        out.print("<tr><td colspan='7' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        if(rs!=null)try{rs.close();}catch(Exception e){}
        if(pst!=null)try{pst.close();}catch(Exception e){}
        if(con!=null)try{con.close();}catch(Exception e){}
    }
%>
        </tbody>
    </table>
</div>

<!-- Modal Styles (Embedded for simplicity) -->
<style>
.modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background:rgba(0,0,0,0.7); align-items:center; justify-content:center; backdrop-filter:blur(5px); }
.modal-content { background:var(--card-bg); width:90%; max-width:500px; padding:30px; border-radius:16px; border:1px solid var(--border-color); box-shadow:0 10px 25px rgba(0,0,0,0.5); }
.modal-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; border-bottom:1px solid var(--border-color); padding-bottom:15px; }
.modal-header h3 { color:white; margin:0; }
.close-btn { color:var(--text-muted); font-size:1.5rem; cursor:pointer; }
.close-btn:hover { color:white; }

.form-group { margin-bottom: 15px; }
.form-group label { display:block; color:var(--text-muted); font-size:0.85rem; margin-bottom:5px; text-transform:uppercase; letter-spacing:0.5px; }
.form-group input, .form-group select, .form-group textarea { width:100%; padding:10px 14px; background:rgba(0,0,0,0.2); border:1px solid var(--border-color); color:white; border-radius:8px; font-family:'Outfit'; }
.form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color:var(--primary-accent); outline:none; }
</style>

<!-- Create Item Modal -->
<div id="createModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Add New Product</h3>
            <span class="close-btn" onclick="closeModal('createModal')">&times;</span>
        </div>
        <form method="POST" action="api_admin_item.jsp">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label>Item Name</label>
                <input type="text" name="name" required>
            </div>
            <div style="display:flex; gap:15px;">
                <div class="form-group" style="flex:1;">
                    <label>Price (Rs.)</label>
                    <input type="number" name="price" step="0.01" required>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Stock Qty</label>
                    <input type="number" name="quantity" required>
                </div>
            </div>
            <div class="form-group">
                <label>Category</label>
                <input type="text" name="category" placeholder="e.g. Vegetables">
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" rows="3"></textarea>
            </div>
            <!-- Note: Image upload skipped for brevity, defaults to generic image -->
            <div style="margin-top:20px; display:flex; gap:10px; justify-content:flex-end;">
                <button type="button" class="btn-primary" style="background:transparent; border:1px solid var(--border-color); color:var(--text-muted);" onclick="closeModal('createModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Save Product</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Item Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Edit Product</h3>
            <span class="close-btn" onclick="closeModal('editModal')">&times;</span>
        </div>
        <form method="POST" action="api_admin_item.jsp">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="itemID" id="edit_id">
            <div class="form-group">
                <label>Item Name</label>
                <input type="text" name="name" id="edit_name" required>
            </div>
            <div style="display:flex; gap:15px;">
                <div class="form-group" style="flex:1;">
                    <label>Price (Rs.)</label>
                    <input type="number" name="price" id="edit_price" step="0.01" required>
                </div>
                <div class="form-group" style="flex:1;">
                    <label>Stock Qty</label>
                    <input type="number" name="quantity" id="edit_qty" required>
                </div>
            </div>
            <div class="form-group">
                <label>Category</label>
                <input type="text" name="category" id="edit_cat">
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="edit_desc" rows="3"></textarea>
            </div>
            <div style="margin-top:20px; display:flex; gap:10px; justify-content:flex-end;">
                <button type="button" class="btn-primary" style="background:transparent; border:1px solid var(--border-color); color:var(--text-muted);" onclick="closeModal('editModal')">Cancel</button>
                <button type="submit" class="btn-primary" style="background:var(--warning);"><i class="fas fa-save"></i> Update Product</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('nav-products').classList.add('active');

    function openCreateModal() {
        document.getElementById('createModal').style.display = 'flex';
    }

    function openEditModal(id, name, price, qty, cat, desc) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_name').value = name;
        document.getElementById('edit_price').value = price;
        document.getElementById('edit_qty').value = qty;
        document.getElementById('edit_cat').value = cat;
        document.getElementById('edit_desc').value = desc;
        document.getElementById('editModal').style.display = 'flex';
    }

    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }
</script>

        </div> <!-- End admin-content -->
    </main> <!-- End admin-main -->
</body>
</html>