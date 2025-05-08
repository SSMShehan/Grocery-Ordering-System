package CustomerPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CustomerInsertServlet")
public class CustomerInsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
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
            
            // Try to insert data
            boolean isTrue = CustomerControl.insertCustomer(name, phone, email, address, register_date, status);
            
            if(isTrue) {
                response.getWriter().println("<script>alert('Customer added successfully'); window.location.href='CustomerServlet'</script>");
            }
            else {
                request.setAttribute("errorMessage", "Failed to insert customer data. Please check database connection.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
                dispatcher.forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Validation error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error inserting data: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
        }
    }
}