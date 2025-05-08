<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Use the same styles as customer.jsp */
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
        
        /* Order Management Specific Styles */
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
        
        .status-InProgress {
            background-color: #FFD700;
        }
        
        .status-Completed {
            background-color: #90EE90;
        }
        
        .status-Cancelled {
            background-color: #FF7F7F;
        }
        
        .status-Delivered {
            background-color: #ADD8E6;
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
                    <h2>Order Management</h2>
                    <button class="btn btn-create" onclick="openCreateModal()">
                        <i class="fas fa-plus"></i> Create New Order
                    </button>
                </div>
            </div>
            
            <!-- Order List -->
            <div class="content-card">
                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Amount</th>
                            <th>Order Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${allOrders}">
                            <tr>
                                <td>${order.orderID}</td>
                                <td>${order.customerName}</td>
                                <td>$${order.amount}</td>
                                <td>${order.order_date}</td>
                                <td><span class="status-badge status-${order.order_status}">${order.order_status}</span></td>
                                <td class="action-btn">
                                    <a href="#" class="btn btn-edit" onclick="openEditModal(${order.orderID}, ${order.cusID}, '${order.amount}', '${order.order_date}', '${order.order_status}')">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <a href="OrderServlet?action=delete&orderID=${order.orderID}" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this order?')">
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

<!-- Create Order Modal -->
<div id="createOrderModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('createOrderModal')">&times;</span>
        <h3>Create New Order</h3>
        <form method="POST" action="OrderInsertServlet">
            <div class="form-group">
                <label for="create_cusID">Customer</label>
                <select id="create_cusID" name="cusID" required>
                    <option value="">Select Customer</option>
                    <c:forEach var="customer" items="${allCustomers}">
                        <option value="${customer.cusID}">${customer.name} (${customer.phone})</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group has-icon">
                <label for="create_amount">Amount ($)</label>
                <input type="number" id="create_amount" name="amount" placeholder="Enter order amount" step="0.01" min="0" required>
                <i class="fas fa-dollar-sign form-icon"></i>
            </div>
            
            <div class="form-group has-icon">
                <label for="create_order_date">Order Date</label>
                <input type="date" id="create_order_date" name="order_date" required>
                <i class="fas fa-calendar form-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="create_order_status">Status</label>
                <select id="create_order_status" name="order_status" required>
                    <option value="In Progress" selected>In Progress</option>
                    <option value="Completed">Completed</option>
                    <option value="Cancelled">Cancelled</option>
                    <option value="Delivered">Delivered</option>
                </select>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('createOrderModal')">Cancel</button>
                <button type="submit" class="btn btn-submit"><i class="fas fa-save"></i> Save Order</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Order Modal -->
<div id="editOrderModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('editOrderModal')">&times;</span>
        <h3>Edit Order</h3>
        <form method="POST" action="OrderUpdateServlet">
            <input type="hidden" id="edit_orderID" name="orderID">
            
            <div class="form-group">
                <label for="edit_cusID">Customer</label>
                <select id="edit_cusID" name="cusID" required>
                    <option value="">Select Customer</option>
                    <c:forEach var="customer" items="${allCustomers}">
                        <option value="${customer.cusID}">${customer.name} (${customer.phone})</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group has-icon">
                <label for="edit_amount">Amount ($)</label>
                <input type="number" id="edit_amount" name="amount" placeholder="Enter order amount" step="0.01" min="0" required>
                <i class="fas fa-dollar-sign form-icon"></i>
            </div>
            
            <div class="form-group has-icon">
                <label for="edit_order_date">Order Date</label>
                <input type="date" id="edit_order_date" name="order_date" required>
                <i class="fas fa-calendar form-icon"></i>
            </div>
            
            <div class="form-group">
                <label for="edit_order_status">Status</label>
                <select id="edit_order_status" name="order_status" required>
                    <option value="In Progress">In Progress</option>
                    <option value="Completed">Completed</option>
                    <option value="Cancelled">Cancelled</option>
                    <option value="Delivered">Delivered</option>
                </select>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('editOrderModal')">Cancel</button>
                <button type="submit" class="btn btn-submit"><i class="fas fa-save"></i> Update Order</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Function to open create modal
    function openCreateModal() {
        document.getElementById('createOrderModal').style.display = 'flex';
        // Set default order date to today
        document.getElementById('create_order_date').valueAsDate = new Date();
    }
    
    // Function to open edit modal with order data
    function openEditModal(orderID, cusID, amount, order_date, order_status) {
        document.getElementById('edit_orderID').value = orderID;
        document.getElementById('edit_cusID').value = cusID;
        document.getElementById('edit_amount').value = amount;
        document.getElementById('edit_order_date').value = order_date;
        document.getElementById('edit_order_status').value = order_status;
        document.getElementById('editOrderModal').style.display = 'flex';
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