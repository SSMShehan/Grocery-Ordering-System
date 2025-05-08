package CustomerPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CustomerUpdateServlet")
public class CustomerUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String cusID = request.getParameter("cusID");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String register_date = request.getParameter("register_date");
        String status = request.getParameter("status");
        
        try {
            // Validate input parameters
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Name cannot be empty");
            }
            
            if (phone == null || phone.trim().isEmpty()) {
                throw new IllegalArgumentException("Phone cannot be empty");
            }
            
            // Update the customer
            boolean isUpdated = CustomerControl.updateCustomer(cusID, name, phone, email, address, register_date, status);
            
            if(isUpdated) {
                response.getWriter().println("<script>alert('Customer updated successfully'); window.location.href='CustomerServlet'</script>");
            } else {
                request.setAttribute("errorMessage", "Failed to update customer. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating customer: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
        }
    }
}