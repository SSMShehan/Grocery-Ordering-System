<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="support_navbar.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Tickets</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
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
        
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: var(--text);
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
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
        
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        
        .pagination-list {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .pagination-item {
            margin: 0 5px;
        }
        
        .pagination-link {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 4px;
            background-color: white;
            color: var(--text);
            text-decoration: none;
            font-weight: 500;
            border: 1px solid #ddd;
            transition: all 0.2s;
        }
        
        .pagination-link:hover {
            background-color: var(--light-gray);
        }
        
        .pagination-link.active {
            background-color: var(--primary);
            color: white;
            border-color: var(--primary);
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
            box-shadow: 0 0 0 2px rgba(255, 204, 0, 0.2);
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .btn-submit {
            background-color: var(--primary);
            color: var(--text);
            min-width: 120px;
        }

        .btn-cancel {
            background-color: var(--light-gray);
            color: var(--text);
            min-width: 120px;
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
            <h1 class="page-title">New Tickets</h1>
            <button class="btn btn-primary" onclick="openCreateModal()">
                <i class="fas fa-plus"></i> New Ticket
            </button>
        </div>
        
        <div class="filters">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Search tickets..." id="searchInput" onkeyup="searchTickets()">
            </div>
            
            <div class="filter-group">
                <select class="filter-select" id="statusFilter" onchange="filterTickets()">
                    <option value="">All Status</option>
                    <option value="Open">Open</option>
                    <option value="Pending">Pending</option>
                    <option value="Closed">Closed</option>
                </select>
                
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
            <c:forEach var="ticket" items="${allTickets}">
                <div class="ticket-item" data-status="${ticket.status}" data-priority="${ticket.priority}">
                    <div class="ticket-info">
                        <div class="ticket-priority priority-${fn:toLowerCase(ticket.priority)}"></div>
                        <span class="ticket-id">#Ticket-${ticket.ticketID}</span>
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
                        <button class="action-btn" title="Delete" onclick="deleteTicket(${ticket.ticketID})">
                            <i class="fas fa-trash"></i>
                        </button>
                        <button class="action-btn" title="Reply" onclick="openReplyModal(${ticket.ticketID})">
                            <i class="fas fa-reply"></i>
                        </button>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty allTickets}">
                <div class="no-tickets" style="text-align: center; padding: 40px; color: #999;">
                    <i class="fas fa-ticket-alt" style="font-size: 48px; margin-bottom: 15px;"></i>
                    <h3>No tickets found</h3>
                    <p>There are currently no tickets to display</p>
                </div>
            </c:if>
        </div>
        
        <div class="pagination">
            <ul class="pagination-list">
                <li class="pagination-item">
                    <a href="#" class="pagination-link"><i class="fas fa-chevron-left"></i></a>
                </li>
                <li class="pagination-item">
                    <a href="#" class="pagination-link active">1</a>
                </li>
                <li class="pagination-item">
                    <a href="#" class="pagination-link">2</a>
                </li>
                <li class="pagination-item">
                    <a href="#" class="pagination-link">3</a>
                </li>
                <li class="pagination-item">
                    <a href="#" class="pagination-link"><i class="fas fa-chevron-right"></i></a>
                </li>
            </ul>
        </div>
    </div>
    
    <!-- Create Ticket Modal -->
    <div id="createTicketModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal('createTicketModal')">&times;</span>
            <h3>Create New Ticket</h3>
            <form method="POST" action="SupportTicketServlet">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
    					<label for="create_cusID">Customer</label>
    					<select id="create_cusID" name="cusID" required>
        				<option value="">Select Customer</option>
        					<c:forEach var="customer" items="${allCustomers}">
            					<option value="${customer.cusID}">${customer.name} (${customer.phone})</option>
        					</c:forEach>
    					</select>
				</div>
                
                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" placeholder="Enter ticket subject" required>
                </div>
                
                <div class="form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" placeholder="Enter your message" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="priority">Priority</label>
                    <select id="priority" name="priority" required>
                        <option value="High">High</option>
                        <option value="Medium" selected>Medium</option>
                        <option value="Low">Low</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeModal('createTicketModal')">Cancel</button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save"></i> Create Ticket
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Reply Ticket Modal -->
    <div id="replyTicketModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal('replyTicketModal')">&times;</span>
        <h3>Reply to Ticket</h3>
        <form method="POST" action="SupportTicketServlet">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="reply_ticketID" name="ticketID">
            
            <div class="form-group">
                <label for="status">Status</label>
                <select id="status" name="status" required>
                    <option value="Open">Open</option>
                    <option value="Pending">Pending</option>
                    <option value="Closed">Closed</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="priority">Priority</label>
                <select id="priority" name="priority" required>
                    <option value="High">High</option>
                    <option value="Medium" selected>Medium</option>
                    <option value="Low">Low</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="reply">Reply</label>
                <textarea id="reply" name="reply" placeholder="Enter your reply" required></textarea>
            </div>
            
            <div class="form-actions">
                <button type="button" class="btn btn-cancel" onclick="closeModal('replyTicketModal')">Cancel</button>
                <button type="submit" class="btn btn-submit">
                    <i class="fas fa-save"></i> Submit Reply
                </button>
            </div>
        </form>
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
    
    // Function to open create modal
    function openCreateModal() {
        document.getElementById('createTicketModal').style.display = 'flex';
    }
    
    // Function to open reply modal
    function openReplyModal(ticketID) {
        document.getElementById('reply_ticketID').value = ticketID;
        document.getElementById('replyTicketModal').style.display = 'flex';
    }
    
    // Function to delete ticket
    function deleteTicket(ticketID) {
        if (confirm('Are you sure you want to delete this ticket?')) {
            window.location.href = 'SupportTicketServlet?action=delete&ticketID=' + ticketID;
        }
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
        const statusFilter = document.getElementById('statusFilter').value;
        const priorityFilter = document.getElementById('priorityFilter').value;
        const agentFilter = document.getElementById('agentFilter').value;
        
        const tickets = document.querySelectorAll('.ticket-item');
        
        tickets.forEach(ticket => {
            const subject = ticket.querySelector('.ticket-subject').textContent.toLowerCase();
            const customer = ticket.querySelector('.ticket-customer').textContent.toLowerCase();
            const ticketId = ticket.querySelector('.ticket-id').textContent.toLowerCase();
            const status = ticket.getAttribute('data-status');
            const priority = ticket.getAttribute('data-priority');
            const agent = ticket.getAttribute('data-agent') || '';
            
            // Check all filter conditions
            const matchesSearch = searchInput === '' || 
                               subject.includes(searchInput) || 
                               customer.includes(searchInput) || 
                               ticketId.includes(searchInput);
            
            const matchesStatus = statusFilter === '' || status === statusFilter;
            const matchesPriority = priorityFilter === '' || priority === priorityFilter;
            const matchesAgent = agentFilter === '' || agent === agentFilter;
            
            // Show or hide based on all conditions
            if (matchesSearch && matchesStatus && matchesPriority && matchesAgent) {
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
        document.getElementById('statusFilter').addEventListener('change', filterTickets);
        document.getElementById('priorityFilter').addEventListener('change', filterTickets);
        document.getElementById('agentFilter').addEventListener('change', filterTickets);
        
        // Apply initial filters
        filterTickets();
    });
</script>
</body>
</html>