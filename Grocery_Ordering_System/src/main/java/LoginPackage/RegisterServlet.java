package LoginPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import Grocery_Ordering_System.DBconnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = "customer"; // Default role for registered users
        
        try {
            Connection con = DBconnection.getConnection();
            
            // Check if username already exists
            String checkSql = "SELECT * FROM user WHERE username=?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, username);
            ResultSet rs = checkPs.executeQuery();
            
            if (rs.next()) {
                response.sendRedirect("login.jsp?registerError=" + java.net.URLEncoder.encode("Username already exists", "UTF-8"));
                return;
            }
            
            // Insert new user
            String insertSql = "INSERT INTO user (username, email, password, role, registration_date) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement insertPs = con.prepareStatement(insertSql);
            insertPs.setString(1, username);
            insertPs.setString(2, email);
            insertPs.setString(3, password);
            insertPs.setString(4, role);
            insertPs.setTimestamp(5, new Timestamp(new Date().getTime()));
            
            int rowsAffected = insertPs.executeUpdate();
            
            if (rowsAffected > 0) {
                response.sendRedirect("login.jsp?registerSuccess=true");
            } else {
                response.sendRedirect("login.jsp?registerError=" + java.net.URLEncoder.encode("Registration failed", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?registerError=" + java.net.URLEncoder.encode("Database error occurred", "UTF-8"));
        }
    }
}