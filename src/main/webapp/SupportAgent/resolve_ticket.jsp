<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="support_navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Resolved Tickets</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* Copy all the CSS styles from new_tickets.jsp */
        :root {
            --primary: #ffcc00;
            --primary-dark: #e6b800;
            --danger: #dc3545;
            --success: #28a745;
            --text: #333;
            --light-gray: #f8f9fa;
            --white: #ffffff;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .content {
            padding: 20px;
            max-width: 1200px;
            margin-left: 0;
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--text);
        }
        
        .filters {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .search-box {
            position: relative;
            width: 300px;
        }
        
        .search-box input {
            width: 100%;
            padding: 8px 15px 8px 35px;
            border: 1px solid #ddd;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .search-box input:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 2px rgba(255, 204, 0, 0.2);
        }
        
        .search-box i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
        }
        
        .filter-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-left: 10px;
            cursor: pointer;
        }
        
        .filter-select:focus {
            border-color: var(--primary);
            outline: none;
        }
        
        .tickets-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .ticket-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            transition: all 0.3s;
        }
        
        .ticket-item:hover {
            background-color: var(--light-gray);
        }
        
        .ticket-item:last-child {
            border-bottom: none;
        }
        
        .ticket-info {
            display: flex;
            align-items: center;
            flex: 1;
        }
        
        .ticket-priority {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 15px;
            display: inline-block;
        }
        
        .priority-high {
            background-color: var(--danger);
        }
        
        .priority-medium {
            background-color: var(--primary-dark);
        }
        
        .priority-low {
            background-color: var(--success);
        }
        
        .ticket-id {
            font-weight: bold;
            color: var(--primary);
            margin-right: 15px;
            min-width: 90px;
        }
        
        .ticket-details {
            display: flex;
            flex-direction: column;
        }
        
        .ticket-subject {
            color: var(--text);
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .ticket-customer {
            color: #666;
            font-size: 14px;
        }
        
        .ticket-date {
            color: #999;
            font-size: 13px;
            min-width: 120px;
            text-align: right;
        }
        
        .ticket-actions {
            display: flex;
            min-width: 80px;
            justify-content: flex-end;
        }
        
        .action-btn {
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            margin-left: 15px;
            font-size: 16px;
            transition: all 0.2s;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
        }
        
        .action-btn:hover {
            color: var(--primary);
            background-color: rgba(255, 204, 0, 0.1);
        }
        
        /* Modal Styles */
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
        
        .ticket-details-container {
            margin-top: 20px;
        }
        
        .ticket-detail-row {
            display: flex;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .ticket-detail-label {
            font-weight: 600;
            min-width: 120px;
            color: var(--text);
        }
        
        .ticket-detail-value {
            flex: 1;
            color: #555;
        }
        
        .ticket-message {
            background-color: var(--light-gray);
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            white-space: pre-wrap;
        }
        
        .ticket-reply {
            background-color: #e6f7ff;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            white-space: pre-wrap;
        }
        
        .no-reply {
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="content">
        <div class="content-header">
            <h1 class="page-title">Resolved Tickets</h1>
            <!-- Removed the "New Ticket" button -->
        </div>
        
        <div class="filters">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search tickets..." id="searchInput" onkeyup="filterTickets()">
            </div>
            
            <div class="filter-group">
                <select class="filter-select" id="priorityFilter" onchange="filterTickets()">
                    <option value="">All Priority</option>
                    <option value="High">High</option>
                    <option value="Medium">Medium</option>
                    <option value="Low">Low</option>
                </select>
                
                <select class="filter-select" id="agentFilter" onchange="filterTickets()">
                    <option value="">All Agents</option>
                    <option value="Me">Me</option>
                    <option value="Unassigned">Unassigned</option>
                </select>
            </div>
        </div>
        
        <div class="tickets-container">
            <c:forEach var="ticket" items="${resolvedTickets}">
                <div class="ticket-item" data-status="${ticket.status}" data-priority="${ticket.priority}">
                    <div class="ticket-info">
                        <div class="ticket-priority priority-${fn:toLowerCase(ticket.priority)}"></div>
                        <span class="ticket-id">#TKT-${ticket.ticketID}</span>
                        <div class="ticket-details">
                            <div class="ticket-subject">${fn:escapeXml(ticket.subject)}</div>
                            <div class="ticket-customer">${fn:escapeXml(ticket.customerName)}</div>
                        </div>
                    </div>
                    <div class="ticket-date">
                        <fmt:formatDate value="${ticket.createdAt}" pattern="MMM d, h:mm a"/>
                    </div>
                    
                    <div class="ticket-actions">
                        <button class="action-btn" title="View" onclick="openViewModal({
                            ticketID: ${ticket.ticketID},
                            customerName: '${fn:escapeXml(ticket.customerName)}',
                            createdAt: '<fmt:formatDate value="${ticket.createdAt}" pattern="yyyy-MM-dd\'T\'HH:mm:ss"/>',
                            status: '${fn:escapeXml(ticket.status)}',
                            priority: '${fn:escapeXml(ticket.priority)}',
                            subject: '${fn:escapeXml(ticket.subject)}',
                            message: '${fn:escapeXml(ticket.message)}',
                            reply: '${fn:escapeXml(ticket.reply)}'
                        })">
                            <i class="fas fa-eye"></i>
                        </button>
                        <!-- Removed the Delete button -->
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty resolvedTickets}">
                <div class="no-tickets" style="text-align: center; padding: 40px; color: #999;">
                    <i class="fas fa-ticket-alt" style="font-size: 48px; margin-bottom: 15px;"></i>
                    <h3>No resolved tickets found</h3>
                    <p>There are currently no resolved tickets to display</p>
                </div>
            </c:if>
        </div>
    </div>
    
    <!-- View Ticket Modal -->
    <div id="viewTicketModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('viewTicketModal')">&times;</span>
            <h3>Ticket Details</h3>
            <div class="ticket-details-container">
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Ticket ID:</span>
                    <span class="ticket-detail-value" id="view_ticketID"></span>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Customer:</span>
                    <span class="ticket-detail-value" id="view_customer"></span>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Date:</span>
                    <span class="ticket-detail-value" id="view_date"></span>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Status:</span>
                    <span class="ticket-detail-value" id="view_status"></span>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Priority:</span>
                    <span class="ticket-detail-value" id="view_priority"></span>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Subject:</span>
                    <span class="ticket-detail-value" id="view_subject"></span>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Message:</span>
                    <div class="ticket-detail-value">
                        <div class="ticket-message" id="view_message"></div>
                    </div>
                </div>
                <div class="ticket-detail-row">
                    <span class="ticket-detail-label">Reply:</span>
                    <div class="ticket-detail-value">
                        <div class="ticket-reply" id="view_reply"></div>
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('viewTicketModal')">Close</button>
            </div>
        </div>
    </div>

    <script>
        // Function to format date
        function formatDate(date) {
            const options = { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
            return date.toLocaleDateString('en-US', options);
        }

        // Function to open view modal with ticket details
        function openViewModal(ticket) {
            document.getElementById('view_ticketID').textContent = '#TKT-' + ticket.ticketID;
            document.getElementById('view_customer').textContent = ticket.customerName;
            document.getElementById('view_date').textContent = formatDate(new Date(ticket.createdAt));
            document.getElementById('view_status').textContent = ticket.status;
            document.getElementById('view_priority').textContent = ticket.priority;
            document.getElementById('view_subject').textContent = ticket.subject;
            document.getElementById('view_message').textContent = ticket.message;
            
            if (ticket.reply && ticket.reply.trim() !== '') {
                document.getElementById('view_reply').textContent = ticket.reply;
                document.getElementById('view_reply').className = 'ticket-reply';
            } else {
                document.getElementById('view_reply').textContent = 'No reply yet';
                document.getElementById('view_reply').className = 'ticket-reply no-reply';
            }
            
            document.getElementById('viewTicketModal').style.display = 'flex';
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
        
        // Main filtering function
        function filterTickets() {
            const searchInput = document.getElementById('searchInput').value.toLowerCase();
            const priorityFilter = document.getElementById('priorityFilter').value;
            const agentFilter = document.getElementById('agentFilter').value;
            
            const tickets = document.querySelectorAll('.ticket-item');
            
            tickets.forEach(ticket => {
                const subject = ticket.querySelector('.ticket-subject').textContent.toLowerCase();
                const customer = ticket.querySelector('.ticket-customer').textContent.toLowerCase();
                const ticketId = ticket.querySelector('.ticket-id').textContent.toLowerCase();
                const priority = ticket.getAttribute('data-priority');
                const agent = ticket.getAttribute('data-agent') || '';
                
                // Check all filter conditions
                const matchesSearch = searchInput === '' || 
                                   subject.includes(searchInput) || 
                                   customer.includes(searchInput) || 
                                   ticketId.includes(searchInput);
                
                const matchesPriority = priorityFilter === '' || priority === priorityFilter;
                const matchesAgent = agentFilter === '' || agent === agentFilter;
                
                // Show or hide based on all conditions
                if (matchesSearch && matchesPriority && matchesAgent) {
                    ticket.style.display = '';
                } else {
                    ticket.style.display = 'none';
                }
            });
        }
        
        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {
            // Set up event listeners
            document.getElementById('searchInput').addEventListener('input', filterTickets);
            document.getElementById('priorityFilter').addEventListener('change', filterTickets);
            document.getElementById('agentFilter').addEventListener('change', filterTickets);
            
            // Apply initial filters
            filterTickets();
        });
    </script>
</body>
</html>