// SupportTicketUpdateServlet.java
package Servlet_Package;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.SupportTicketControl;

@WebServlet("/SupportAgent/SupportTicketUpdateServlet")
public class SupportTicketUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String ticketID = request.getParameter("ticketID");
        String status = request.getParameter("status");
        String reply = request.getParameter("reply");
        String priority = request.getParameter("priority");
        
        try {
            // Validate input parameters
            if (status == null || status.trim().isEmpty()) {
                throw new IllegalArgumentException("Status cannot be empty");
            }
            
            if (priority == null || priority.trim().isEmpty()) {
                priority = "Medium"; 
            }
            
            // Update the ticket
            boolean isUpdated = SupportTicketControl.updateTicket(
                Integer.parseInt(ticketID), 
                reply, 
                status,
                priority
            );
            
            if(isUpdated) {
                response.getWriter().println("<script>alert('Ticket updated successfully'); window.location.href='SupportTicketServlet'</script>");
            } else {
                request.setAttribute("errorMessage", "Failed to update ticket. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("new_tickets.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating ticket: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("new_tickets.jsp");
            dispatcher.forward(request, response);
        }
    }
}