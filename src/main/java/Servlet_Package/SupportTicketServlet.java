// SupportTicketServlet.java
package Servlet_Package;

import java.io.IOException;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.Statement;

import Control_Package.SupportTicketControl;
import Util_Package.DBconnection;
import Model_Package.Customer;
import Model_Package.SupportTicketModel;

@WebServlet("/SupportAgent/SupportTicketServlet")
public class SupportTicketServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action != null) {
                switch (action) {
                    case "delete":
                        deleteTicket(request, response);
                        break;
                    case "reply":
                        showReplyForm(request, response);
                        break;
                    default:
                        listTickets(request, response);
                }
            } else {
                listTickets(request, response);
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createTicket(request, response);
            } else if ("update".equals(action)) {
                updateTicket(request, response);
            } else {
                listTickets(request, response);
            }
        } catch (Exception e) {
            handleError(request, response, "Error processing request: " + e.getMessage());
        }
    }

    private void listTickets(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SupportTicketModel> allTickets = SupportTicketControl.getAllTickets();
        List<Customer> allCustomers = getAllCustomers();
        
        request.setAttribute("allTickets", allTickets);
        request.setAttribute("allCustomers", allCustomers); 
        RequestDispatcher dispatcher = request.getRequestDispatcher("new_tickets.jsp");
        dispatcher.forward(request, response);
    }
    
    private void createTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int cusID = Integer.parseInt(request.getParameter("cusID"));
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String priority = request.getParameter("priority");
        
        boolean success = SupportTicketControl.createTicket(cusID, subject, message, priority);
        
        if (success) {
            request.setAttribute("successMessage", "Ticket created successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to create ticket.");
        }
        listTickets(request, response);
    }

    private void updateTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int ticketID = Integer.parseInt(request.getParameter("ticketID"));
        String reply = request.getParameter("reply");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        
        boolean success = SupportTicketControl.updateTicket(ticketID, reply, status, priority);
        
        if (success) {
            request.setAttribute("successMessage", "Ticket updated successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to update ticket.");
        }
        listTickets(request, response);
    }
    
    private void deleteTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int ticketID = Integer.parseInt(request.getParameter("ticketID"));
        boolean success = SupportTicketControl.deleteTicket(ticketID);
        
        if (success) {
            request.setAttribute("successMessage", "Ticket deleted successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to delete ticket.");
        }
        listTickets(request, response);
    }
    
    private void showReplyForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int ticketID = Integer.parseInt(request.getParameter("ticketID"));
        SupportTicketModel ticket = getTicketById(ticketID);
        
        request.setAttribute("ticket", ticket);
        RequestDispatcher dispatcher = request.getRequestDispatcher("reply_ticket.jsp");
        dispatcher.forward(request, response);
    }
    
    private SupportTicketModel getTicketById(int ticketID) {
        return new SupportTicketModel(ticketID, 0, "", "", "", null, "", "", "Medium");
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        listTickets(request, response);
    }
    
    private List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            String sql = "SELECT cusID, name, phone FROM customer";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCusID(rs.getInt("cusID"));
                customer.setName(rs.getString("name"));
                customer.setPhone(rs.getString("phone"));
                customers.add(customer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return customers;
    }

}