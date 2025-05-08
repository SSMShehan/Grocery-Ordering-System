// UserUpdateServlet.java
package UserPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String userID = request.getParameter("userID");
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
            
            // Update the user
            boolean isUpdated = UserControl.updateUser(userID, username, password, email, phone, register_date, status, role);
            
            if(isUpdated) {
                response.getWriter().println("<script>alert('User updated successfully'); window.location.href='UserServlet'</script>");
            } else {
                request.setAttribute("errorMessage", "Failed to update user. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("user.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating user: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("user.jsp");
            dispatcher.forward(request, response);
        }
    }
}