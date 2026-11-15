<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="admin_navbar.jsp" %>

<div class="header-container" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:30px;">
    <h1 class="page-title" style="margin:0;">Customer Management</h1>
    <button class="btn-primary" onclick="openCreateModal()">
        <i class="fas fa-plus"></i> Add New Customer
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
        <h2>Registered Customers</h2>
        <form method="GET" action="customer.jsp" style="display:flex; gap:10px;">
            <input type="text" name="search" placeholder="Search customer username or email..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" style="padding:8px 12px; border-radius:6px; border:1px solid var(--border-color); background:rgba(0,0,0,0.2); color:white;">
            <button type="submit" class="btn-primary" style="padding:8px 15px;">Search</button>
            <% if(request.getParameter("search") != null && !request.getParameter("search").isEmpty()) { %>
                <a href="customer.jsp" class="btn-primary" style="background:#4B5563; padding:8px 15px; text-decoration:none;">Clear</a>
            <% } %>
        </form>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Reg. Date</th>
                <th>Status</th>
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
            pst = con.prepareStatement("SELECT * FROM \"user\" WHERE role = 'customer' AND (username ILIKE ? OR email ILIKE ?) ORDER BY \"userID\" DESC");
            pst.setString(1, "%" + searchParam.trim() + "%");
            pst.setString(2, "%" + searchParam.trim() + "%");
        } else {
            pst = con.prepareStatement("SELECT * FROM \"user\" WHERE role = 'customer' ORDER BY \"userID\" DESC");
        }
        rs = pst.executeQuery();

        while(rs.next()) {
            int id = rs.getInt("userID");
            String c_username = rs.getString("username");
            String email = rs.getString("email");
            String phone = rs.getString("phone");
            String regDate = rs.getString("register_date");
            String status = rs.getString("status");
            
            String safeUsername = c_username != null ? c_username.replace("'", "\\'") : "";
            String safeEmail = email != null ? email.replace("'", "\\'") : "";
            String safePhone = phone != null ? phone.replace("'", "\\'") : "";
            
            String statusClass = "badge-processing";
            if("Active".equalsIgnoreCase(status)) statusClass = "badge-delivered";
            else if("Suspended".equalsIgnoreCase(status)) statusClass = "badge-pending";
            else if("Inactive".equalsIgnoreCase(status)) statusClass = "badge-pending";
%>
            <tr>
                <td style="font-weight:600; color:var(--text-muted);">#<%= id %></td>
                <td style="font-weight:600; color:white;"><%= c_username != null ? c_username : "" %></td>
                <td><%= email != null ? email : "" %></td>
                <td><%= phone != null ? phone : "" %></td>
                <td><%= regDate != null ? regDate : "" %></td>
                <td><span class="badge <%= statusClass %>"><%= status != null ? status : "Active" %></span></td>
                <td>
                    <button class="btn-edit" onclick="openEditModal(<%= id %>, '<%= safeUsername %>', '<%= safeEmail %>', '<%= safePhone %>', '<%= status %>')">
                        <i class="fas fa-edit"></i>
                    </button>
                    <a href="api_admin_customer.jsp?action=delete&userID=<%= id %>" class="btn-delete" onclick="return confirm('Delete this customer?')">
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

<!-- Create Modal -->
<div id="createModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Add Customer</h3>
            <span class="close-btn" onclick="closeModal('createModal')">&times;</span>
        </div>
        <form method="POST" action="api_admin_customer.jsp">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input type="text" name="phone">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                    <option value="Suspended">Suspended</option>
                </select>
            </div>
            <div style="margin-top:20px; display:flex; gap:10px; justify-content:flex-end;">
                <button type="button" class="btn-primary" style="background:transparent; border:1px solid var(--border-color); color:var(--text-muted);" onclick="closeModal('createModal')">Cancel</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save"></i> Save Customer</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Edit Customer</h3>
            <span class="close-btn" onclick="closeModal('editModal')">&times;</span>
        </div>
        <form method="POST" action="api_admin_customer.jsp">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="userID" id="edit_id">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" id="edit_username" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" id="edit_email" required>
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input type="text" name="phone" id="edit_phone">
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="status" id="edit_status">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                    <option value="Suspended">Suspended</option>
                </select>
            </div>
            <div style="margin-top:20px; display:flex; gap:10px; justify-content:flex-end;">
                <button type="button" class="btn-primary" style="background:transparent; border:1px solid var(--border-color); color:var(--text-muted);" onclick="closeModal('editModal')">Cancel</button>
                <button type="submit" class="btn-primary" style="background:var(--warning);"><i class="fas fa-save"></i> Update Customer</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('nav-customers').classList.add('active');

    function openCreateModal() {
        document.getElementById('createModal').style.display = 'flex';
    }

    function openEditModal(id, username, email, phone, status) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_username').value = username;
        document.getElementById('edit_email').value = email;
        document.getElementById('edit_phone').value = phone;
        document.getElementById('edit_status').value = status;
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