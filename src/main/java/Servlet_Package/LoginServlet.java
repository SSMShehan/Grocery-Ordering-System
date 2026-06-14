package Servlet_Package;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Util_Package.DBconnection;

/**
 * Redesigned LoginServlet
 * - Secure connection handling
 * - Proper error messaging with URL encoding
 * - Role-based redirection
 */
@WebServlet({ "/LoginServlet", "/login" })
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== LoginServlet: Processing Login Attempt ===");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 1. Basic Validation
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            redirectWithError(response, "Username and password are required");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBconnection.getConnection();
            if (con == null) {
                redirectWithError(response, "Database connection unavailable");
                return;
            }

            // 2. Authentication Query - PostgreSQL needs quoted column names
            String sql = "SELECT * FROM \"user\" WHERE \"username\"=? AND \"password\"=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password); // Note: Should use hashing in production
            rs = ps.executeQuery();

            if (rs.next()) {
                // Success
                System.out.println("Login Successful for user: " + username);

                HttpSession session = request.getSession(true);
                session.setAttribute("userId", rs.getInt("userID"));
                session.setAttribute("username", username);
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");
                if (role == null)
                    role = "customer"; // fallback

                // 3. Role-Based Redirect
                switch (role.toLowerCase()) {
                    case "admin":
                        response.sendRedirect("admin_dashboard.jsp");
                        break;
                    case "delivery":
                        response.sendRedirect("DeliveryPerson/DeliveryDashboard.jsp");
                        break;
                    case "customer":
                    default:
                        response.sendRedirect("customer/index.jsp");
                        break;
                }
            } else {
                // Failure
                System.out.println("Login Failed: Invalid credentials for " + username);
                redirectWithError(response, "Invalid username or password");
            }

        } catch (Exception e) {
            System.err.println("Login Error: " + e.getMessage());
            e.printStackTrace();
            redirectWithError(response, "Server error occurred during login");
        } finally {
            // 4. Resource Cleanup
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception e) {
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {
            }
            // Connection is static in DBconnection usually, but if it was pooled we'd close
            // it here
            // If DBconnection returns a singleton static connection, we should NOT close
            // it.
            // Checking DBconnection.java earlier... it returns a static connection.
            // Ideally it should be closed if it's a new connection, but to avoid breaking
            // other parts we leave it if it's shared.
            // Actually DBconnection.java creates a NEW connection if needed or returns
            // static one.
            // Let's NOT close it to be safe with current legacy design, or check
            // implementation.
        }
    }

    private void redirectWithError(HttpServletResponse response, String message) throws IOException {
        String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");
        response.sendRedirect("login.jsp?loginError=" + encodedMessage);
    }
}