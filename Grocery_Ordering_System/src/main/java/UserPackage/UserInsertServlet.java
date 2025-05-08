// UserInsertServlet.java
package UserPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserInsertServlet")
public class UserInsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String register_date = request.getParameter("register_date");
        String status = request.getParameter("status");
        String role = request.getParameter("role");
        
        try {
            // Validate input parameters
            if (username == null || username.trim().isEmpty()) {
                throw new IllegalArgumentException("Username cannot be empty");
            }
            
            if (password == null || password.trim().isEmpty()) {
                throw new IllegalArgumentException("Password cannot be empty");
            }
            
            // Try to insert data
            boolean isTrue = UserControl.insertUser(username, password, email, phone, register_date, status, role);
            
            if(isTrue) {
                response.getWriter().println("<script>alert('User added successfully'); window.location.href='UserServlet'</script>");
            }
            else {
                request.setAttribute("errorMessage", "Failed to insert user data. Please check database connection.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("user.jsp");
                dispatcher.forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Validation error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("user.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error inserting data: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("user.jsp");
            dispatcher.forward(request, response);
        }
    }
}