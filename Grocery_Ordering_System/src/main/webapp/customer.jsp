<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Use the same styles as item.jsp since they're already well designed */
        :root {
            --primary: #FFD700;
            --primary-light: #FFEB99;
            --primary-dark: #B39700;
            --white: #FFFFFF;
            --light-gray: #F0F0F0;
            --text: #333333;
            --danger: #FF6B6B;
            --success: #4CAF50;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        html, body {
            height: 100%;
            width: 100%;
            overflow: hidden;
        }
        
        body {
            background-color: var(--light-gray);
            color: var(--text);
        }
        
        /* Layout Structure */
        .container {
            display: flex;
            height: 100vh;
            width: 100%;
            overflow: hidden;
        }
        
        /* Sidebar */
        .sidebar {
            width: 250px;
            height: 100%;
            background-color: var(--white);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            z-index: 10;
            flex-shrink: 0;
        }
        
        .logo {
            display: flex;
            align-items: center;
            padding: 20px;
            background-color: var(--primary);
            color: var(--text);
            font-weight: bold;
        }
        
        .logo svg {
            margin-right: 10px;
        }
        
        .nav-menu {
            padding: 20px 0;
            height: calc(100% - 60px);
            overflow-y: auto;
        }
        
        .nav-item {
            padding: 12px 20px;
            display: flex;
            align-items: center;
            color: var(--text);
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .nav-item:hover, .nav-item.active {
            background-color: var(--primary-light);
            border-left: 4px solid var(--primary-dark);
        }
        
        .nav-item svg {
            margin-right: 10px;
        }
        
        /* Main Content */
        .main {
            flex: 1;
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 10px;
            border-bottom: 1px solid #eee;
            background-color: var(--white);
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            width: 100%;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: var(--primary);
            color: var(--white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        /* Customer Management Specific Styles */
        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            gap: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .btn-create {
            background-color: var(--primary);
            color: var(--text);
        }
        
        .btn-create:hover {
            background-color: var(--primary-dark);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .btn-submit {
            background-color: var(--primary);
            color: var(--text);
            min-width: 120px;
        }
        
        .btn-submit:hover {
            background-color: var(--primary-dark);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .btn-cancel {
            background-color: var(--light-gray);
            color: var(--text);
            min-width: 120px;
        }
        
        .btn-cancel:hover {
            background-color: #e0e0e0;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        /* Form Styles */
        .form-group {
            margin-bottom: 22px;
            position: relative;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text);
            font-size: 14px;
            letter-spacing: 0.5px;
        }
        
        input, select, textarea {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: var(--white);
        }
        
        input:focus, select:focus, textarea:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px var(--primary-light);
        }
        
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .content-container {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }
        
        .content-card {
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 30px;
            overflow: auto;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        @media (max-width: 768px) {
            .card-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
        
        .search-input {
            display: flex;
            background-color: var(--light-gray);
            padding: 8px 15px;
            border-radius: 30px;
            align-items: center;
        }
        
        .search-input input {
            border: none;
            background: transparent;
            margin-left: 8px;
            outline: none;
            width: 200px;
        }
        
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead th {
            background-color: var(--primary-light);
            text-align: left;
            padding: 12px 15px;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1;
        }
        
        tbody tr {
            border-bottom: 1px solid var(--light-gray);
            transition: background 0.3s;
        }
        
        tbody tr:hover {
            background-color: var(--light-gray);
        }
        
        tbody td {
            padding: 12px 15px;
        }
        
        /* Action button styles */
        .action-btn {
            display: flex;
            gap: 8px;
        }
        
        .edit-btn:hover {
            color: var(--primary-dark);
        }
        
        .delete-btn:hover {
            color: var(--danger);
        }
        
        .btn-edit, .btn-delete {
            padding: 8px 12px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.2s;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }
        
        .btn-edit {
            color: var(--text);
            background-color: var(--primary-light);
        }
        
        .btn-edit:hover {
            background-color: var(--primary);
            transform: translateY(-2px);
        }
        
        .btn-delete {
            color: white;
            background-color: var(--danger);
        }
        
        .btn-delete:hover {
            background-color: #d63031;
            transform: translateY(-2px);
        }
        
        /* Form action buttons */
        .form-actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }
        
        /* Message styles */
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 8px;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Modal/Popup Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.6);
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }
        
        .modal-content {
            background-color: #fff;
            width: 90%;
            max-width: 550px;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            position: relative;
            max-height: 90vh;
            overflow-y: auto;
            animation: modalFadeIn 0.3s ease-out;
        }
        
        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .modal-content h3 {
            color: var(--text);
            font-size: 24px;
            margin-bottom: 25px;
            font-weight: 700;
            position: relative;
            padding-bottom: 12px;
        }
        
        .modal-content h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 4px;
            background-color: var(--primary);
            border-radius: 2px;
        }
        
        .close-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 28px;
            cursor: pointer;
            color: #aaa;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s;
        }
        
        .close-btn:hover {
            color: var(--text);
            background-color: var(--light-gray);
            transform: rotate(90deg);
        }
        
        /* Input icon styles */
        .form-group i.form-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }
        
        .form-group.has-icon input {
            padding-right: 40px;
        }
        
        /* Status badge styles */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-weight: 600;
            text-align: center;
            min-width: 100px;
            color: black;
        }
        
        .status-Active {
            background-color: #90EE90;
        }
        
        .status-Inactive {
            background-color: #FF7F7F;
        }
        
        .status-Suspended {
            background-color: #D8BFD8;
        }
    </style>
</head>
<body>
<c:if test="${not empty errorMessage}">
    <div class="error message">
        ${errorMessage}
    </div>
</c:if>

<div class="container">
    <!-- Include the sidebar navigation -->
    <jsp:include page="admin_navbar.jsp" />
    
    <!-- Main Content -->
    <main class="main">
        <div class="content-container">
            <div class="header">
                <div class="header-container">
                    <h2>Customer Management</h2>
                    <button class="btn btn-create" onclick="openCreateModal()">
                        <i class="fas fa-plus"></i> Create New Customer
                    </button>
                </div>
            </div>
            
            <!-- Customer List -->
            <div class="content-card">
                <table>
                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Register Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="customer" items="${allCustomers}">
                            <tr>
                                <td>${customer.cusID}</td>
                                <td>${customer.name}</td>
                                <td>${customer.phone}</td>
                                <td>${customer.email}</td>
                                <td>${customer.address}</td>
                                <td>${customer.register_date}</td>
                                <td><span class="status-badge status-${customer.status}">${customer.status}</span></td>
                                <td class="action-btn">
                                    <a href="#" class="btn btn-edit" onclick="openEditModal(${customer.cusID}, '${customer.name}', '${customer.phone}', '${customer.email}', '${customer.address}', '${customer.register_date}', '${customer.status}')">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <a href="CustomerServlet?action=delete&cusID=${customer.cusID}" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this customer?')">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- Create Customer Modal -->
<div id="createCustomerModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('createCustomerModal')">&times;</span>
        <h3>Create New Customer</h3>
        <form method="POST" action="CustomerInsertServlet">
            <div class="form-group has-icon">
                <label for="create_name">Full Name</label>
                <input type="text" id="create_name" name="name" placeholder="Enter customer name" required>
                <i class="fas fa-user form-icon"></i>
            </div>
            
            <div class="form-group has-icon">
                <label for="create_phone">Phone Number</label>
                <input type="tel" id="create_phone" name="phone" placeholder="Enter phone number" maxlength="10" required>
                <i class="fas fa-phone form-icon"></i>
            </div>
            
            <div class="form-group has-icon">
                <label for="create_email">Email</label>
                <input type="email" id="create_email" name="email" placeholder="Enter email address">
                <i class="fas fa-envelope form-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="create_address">Address</label>
                <textarea id="create_address" name="address" placeholder="Enter customer address"></textarea>
            </div>
            
            <div class="form-group has-icon">
                <label for="create_register_date">Register Date</label>
                <input type="date" id="create_register_date" name="register_date" required>
                <i class="fas fa-calendar form-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="create_status">Status</label>
                <select id="create_status" name="status" required>
                    <option value="Active" selected>Active</option>
                    <option value="Inactive">Inactive</option>
                    <option value="Suspended">Suspended</option>
                </select>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('createCustomerModal')">Cancel</button>
                <button type="submit" class="btn btn-submit"><i class="fas fa-save"></i> Save Customer</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Customer Modal -->
<div id="editCustomerModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('editCustomerModal')">&times;</span>
        <h3>Edit Customer</h3>
        <form method="POST" action="CustomerUpdateServlet">
            <input type="hidden" id="edit_cusID" name="cusID">
            
            <div class="form-group has-icon">
                <label for="edit_name">Full Name</label>
                <input type="text" id="edit_name" name="name" placeholder="Enter customer name" required>
                <i class="fas fa-user form-icon"></i>
            </div>
            
            <div class="form-group has-icon">
                <label for="edit_phone">Phone Number</label>
                <input type="tel" id="edit_phone" name="phone" placeholder="Enter phone number" maxlength="10" required>
                <i class="fas fa-phone form-icon"></i>
            </div>
            
            <div class="form-group has-icon">
                <label for="edit_email">Email</label>
                <input type="email" id="edit_email" name="email" placeholder="Enter email address">
                <i class="fas fa-envelope form-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="edit_address">Address</label>
                <textarea id="edit_address" name="address" placeholder="Enter customer address"></textarea>
            </div>
            
            <div class="form-group has-icon">
                <label for="edit_register_date">Register Date</label>
                <input type="date" id="edit_register_date" name="register_date" required>
                <i class="fas fa-calendar form-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="edit_status">Status</label>
                <select class="edit_status" id="edit_status" name="status" required>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                    <option value="Suspended">Suspended</option>
                </select>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('editCustomerModal')">Cancel</button>
                <button type="submit" class="btn btn-submit"><i class="fas fa-save"></i> Update Customer</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Function to open create modal
    function openCreateModal() {
        document.getElementById('createCustomerModal').style.display = 'flex';
        // Set default register date to today
        document.getElementById('create_register_date').valueAsDate = new Date();
    }
    
    // Function to open edit modal with customer data
    function openEditModal(cusID, name, phone, email, address, register_date, status) {
        document.getElementById('edit_cusID').value = cusID;
        document.getElementById('edit_name').value = name;
        document.getElementById('edit_phone').value = phone;
        document.getElementById('edit_email').value = email;
        document.getElementById('edit_address').value = address;
        document.getElementById('edit_register_date').value = register_date;
        document.getElementById('edit_status').value = status;
        document.getElementById('editCustomerModal').style.display = 'flex';
    }
    
    // Function to close modal
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = 'none';
    }
    
    // Close modal when clicking outside of it
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>