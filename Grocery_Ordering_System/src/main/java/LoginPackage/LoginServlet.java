package LoginPackage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import Grocery_Ordering_System.DBconnection;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
  
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            Connection con = DBconnection.getConnection();
            String sql = "SELECT * FROM user WHERE username=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String role = rs.getString("role");
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                
                if (role.equals("admin")) {
                    response.sendRedirect("admin_dashboard.jsp");
                } else if (role.equals("customer")) {
                    response.sendRedirect("index.jsp");
                } else {
                    // For other roles (customer support, delivery)
                    response.sendRedirect("index.jsp");
                }
            } else {
                response.sendRedirect("login.jsp?loginError=" + java.net.URLEncoder.encode("Invalid username or password", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?loginError=" + java.net.URLEncoder.encode("Database error occurred", "UTF-8"));
        }
    }
}