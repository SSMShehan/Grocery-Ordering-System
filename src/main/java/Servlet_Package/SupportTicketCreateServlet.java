// SupportTicketCreateServlet.java
package Servlet_Package;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.SupportTicketControl;

@WebServlet("/SupportTicketCreateServlet")
public class SupportTicketCreateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String cusID = request.getParameter("cusID");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String priority = request.getParameter("priority");
        
        try {
            // Validate input parameters
            if (subject == null || subject.trim().isEmpty()) {
                throw new IllegalArgumentException("Subject cannot be empty");
            }
            
            if (message == null || message.trim().isEmpty()) {
                throw new IllegalArgumentException("Message cannot be empty");
            }
            
            if (priority == null || priority.trim().isEmpty()) {
                priority = "Medium";
            }
            
            
            boolean isTrue = SupportTicketControl.createTicket(Integer.parseInt(cusID), subject, message, priority);
            
            if(isTrue) {
                response.getWriter().println("<script>alert('Ticket created successfully'); window.location.href='SupportTicketServlet'</script>");
            }
            else {
                request.setAttribute("errorMessage", "Failed to create ticket. Please check database connection.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("new_tickets.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating ticket: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("new_tickets.jsp");
            dispatcher.forward(request, response);
        }
    }
}