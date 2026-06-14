<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Check if user is logged in and is an admin
    HttpSession userSession = request.getSession(false);
    String username = (userSession != null) ? (String) userSession.getAttribute("username") : null;
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;
    
    if (username == null || !"delivery".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f5f7fa;
        }
        
        /* Section 1: Profile Sidebar */
        .sidebar {
            width: 280px;
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            position: fixed;
            height: 100vh;
        }
        
        .profile-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-bottom: 20px;
            border-bottom: 1px solid #3a506b;
        }
        
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #34495e;
            margin-bottom: 15px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 50px;
            color: #ecf0f1;
        }
        
        .profile-image img {
            width: 100%;
            height: auto;
        }
        
        .profile-name {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .profile-id {
            font-size: 14px;
            color: #bdc3c7;
            margin-bottom: 15px;
        }
        
        .profile-status {
            background-color: #27ae60;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .profile-details {
            width: 100%;
            margin-top: 20px;
        }
        
        .detail-item {
            display: flex;
            margin-bottom: 12px;
        }
        
        .detail-label {
            width: 40%;
            color: #bdc3c7;
            font-size: 14px;
        }
        
        .detail-value {
            width: 60%;
            font-size: 14px;
        }
        
        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #2c3e50;
        }
        
        /* Section 2: Available Orders */
        .available-orders {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .orders-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
        }
        
        .order-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #e9ecef;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .order-id {
            font-weight: bold;
            color: #2c3e50;
        }
        
        .order-time {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .order-address {
            margin-bottom: 10px;
            font-size: 14px;
            color: #34495e;
        }
        
        .order-details {
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .order-price {
            font-weight: bold;
            color: #16a085;
            margin-bottom: 10px;
        }
        
        .order-distance {
            font-size: 14px;
            color: #7f8c8d;
            margin-bottom: 15px;
        }
        
        .select-btn {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.2s;
        }
        
        .select-btn:hover {
            background-color: #2980b9;
        }
        
        /* Section 3: Selected Orders */
        .selected-orders {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .no-orders-message {
            text-align: center;
            padding: 20px;
            color: #7f8c8d;
            font-style: italic;
        }
        
        .selected-order-card {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            border: 1px solid #e9ecef;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .selected-order-details {
            flex: 1;
        }
        
        .selected-order-actions {
            display: flex;
            gap: 10px;
        }
        
        .start-btn {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .start-btn:hover {
            background-color: #219653;
        }
        
        .remove-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .remove-btn:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>


    <!-- Section 1: Profile Sidebar -->
    
    <div class="sidebar">
        <div class="profile-section">
            <div class="profile-image">
    <c:choose>
        <c:when test="${not empty deliveryPerson.imageUrl}">
            <img src="${deliveryPerson.imageUrl}" alt="Profile Image">
        </c:when>
        <c:otherwise>
            DP
        </c:otherwise>
    </c:choose>
</div>
            <div class="profile-name">${deliveryPerson.username}</div>
             <div class="profile-id">ID: ${deliveryPerson.userID}</div>
            <div class="profile-status">Available</div>
        </div>
       
        <div class="profile-details">
            <div class="detail-item">
                <div class="detail-label">Name:</div>
                <div class="detail-value">${deliveryPerson.username}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Email:</div>
                <div class="detail-value">${deliveryPerson.email}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Phone:</div>
                <div class="detail-value">${deliveryPerson.phone}</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Vehicle No:</div>
                <div class="detail-value">122345</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Rating:</div>
                <div class="detail-value">4 / 5</div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Completed:</div>
                <div class="detail-value">372 orders</div>
            </div>
        </div>
    </div>
    
    <!-- Main Content -->
    <div class="main-content">
        <!-- Section 2: Available Orders -->
        <div class="available-orders">
            <h2 class="section-title">Available Orders</h2>
            <div class="orders-container">
		<c:forEach var="order" items="${availableOrders}">
    <div class="order-card" id="order-${order.orderID}">
        <div class="order-header">
            <div class="order-id">Order #${order.orderID}</div>
            <div class="order-time">
                <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd"/>
            </div>
        </div>
        <div class="order-address">
            <strong>Customer:</strong> ${order.customerName}<br>
            <strong>Address:</strong> ${order.customerAddress}
        </div>
        <div class="order-details">
            <strong>Email:</strong> ${order.customerEmail}<br>
            <strong>Phone:</strong> ${order.customerPhone}
        </div>
        <div class="order-price">₹${order.amount}</div>
        <button class="select-btn" onclick="selectOrder(${order.orderID})">Select Order</button>
    </div>
</c:forEach>
                
                <!-- Fallback for empty orders list -->
                <c:if test="${empty availableOrders}">
                    <div class="no-orders-message">No available orders at the moment. Please check back later.</div>
                </c:if>
            </div>
        </div>
        
        <!-- Section 3: Selected Orders -->
        <div class="selected-orders">
            <h2 class="section-title">Selected Orders</h2>
            <div id="selected-orders-container">
                <div class="no-orders-message">No orders selected. Select orders from above to deliver.</div>
            </div>
        </div>
    </div>
    
    <script>
    // Array to store selected orders
    let selectedOrders = [];
    
    // Function to select an order
    function selectOrder(orderId) {
        // Check if order is already selected
        if (selectedOrders.includes(orderId)) {
            alert("This order is already selected!");
            return;
        }
        
        // Get order details from the card
        const orderCard = document.getElementById('order-' + orderId);
        const orderIdText = orderCard.querySelector('.order-id').textContent;
        const customerName = orderCard.querySelector('.order-address strong:nth-child(1)').nextSibling.textContent.trim();
        const customerAddress = orderCard.querySelector('.order-address strong:nth-child(3)').nextSibling.textContent.trim();
        const orderPrice = orderCard.querySelector('.order-price').textContent;
        
        // Add order to selected orders array
        selectedOrders.push(orderId);
        
        // Create a selected order element
        const selectedOrdersContainer = document.getElementById('selected-orders-container');
        
        // Clear "no orders" message if this is the first order
        if (selectedOrders.length === 1) {
            selectedOrdersContainer.innerHTML = '';
        }
        
        // Create new selected order card
        const orderCardElement = document.createElement('div');
        orderCardElement.className = 'selected-order-card';
        orderCardElement.id = 'selected-order-' + orderId;
        orderCardElement.innerHTML = `
            <div class="selected-order-details">
                <div class="order-id">${orderIdText}</div>
                <div class="order-address">
                    <strong>Customer:</strong> ${customerName}<br>
                    <strong>Address:</strong> ${customerAddress}
                </div>
                <div class="order-price">${orderPrice}</div>
            </div>
            <div class="selected-order-actions">
                <button class="start-btn" onclick="startDelivery(${orderId})">Start Delivery</button>
                <button class="remove-btn" onclick="removeOrder(${orderId})">Remove</button>
            </div>
        `;
        
        selectedOrdersContainer.appendChild(orderCardElement);
        
        // Optional: Disable select button in available orders section
        const selectBtn = document.querySelector('#order-${orderId} .select-btn');
        if (selectBtn) {
            selectBtn.disabled = true;
            selectBtn.textContent = "Selected";
            selectBtn.style.backgroundColor = "#95a5a6";
        }
    }
    
    // Function to remove an order from selected orders
    function removeOrder(orderId) {
        // Remove from array
        selectedOrders = selectedOrders.filter(id => id !== orderId);
        
        // Remove element from DOM
        const orderElement = document.getElementById('selected-order-' + orderId);
        if (orderElement) {
            orderElement.remove();
        }
        
        // Re-enable select button in available orders section
        const selectBtn = document.querySelector('#order-' + orderId + ' .select-btn');
        if (selectBtn) {
            selectBtn.disabled = false;
            selectBtn.textContent = "Select Order";
            selectBtn.style.backgroundColor = "";
        }
        
        // Show "no orders" message if no orders left
        if (selectedOrders.length === 0) {
            const selectedOrdersContainer = document.getElementById('selected-orders-container');
            selectedOrdersContainer.innerHTML = '<div class="no-orders-message">No orders selected. Select orders from above to deliver.</div>';
        }
    }
    
    // Function to start delivery
    function startDelivery(orderId) {
        // Submit form to assign order
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'DeliveryServlet';
        
        const inputAction = document.createElement('input');
        inputAction.type = 'hidden';
        inputAction.name = 'action';
        inputAction.value = 'assign';
        form.appendChild(inputAction);
        
        const inputOrderId = document.createElement('input');
        inputOrderId.type = 'hidden';
        inputOrderId.name = 'orderID';
        inputOrderId.value = orderId;
        form.appendChild(inputOrderId);
        
        document.body.appendChild(form);
        form.submit();
    }
    
    // Function to mark as delivered (you can add this when implementing delivery tracking)
    function markAsDelivered(orderId) {
        // Submit form to mark as delivered
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'DeliveryServlet';
        
        const inputAction = document.createElement('input');
        inputAction.type = 'hidden';
        inputAction.name = 'action';
        inputAction.value = 'deliver';
        form.appendChild(inputAction);
        
        const inputOrderId = document.createElement('input');
        inputOrderId.type = 'hidden';
        inputOrderId.name = 'orderID';
        inputOrderId.value = orderId;
        form.appendChild(inputOrderId);
        
        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>