package Servlet_Package;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Util_Package.DBconnection;

/**
 * Redesigned RegisterServlet
 * - Validates input strictly strings
 * - Checks duplicates
 * - Inserts new user securely
 */
@WebServlet({ "/RegisterServlet", "/register" })
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== RegisterServlet: Processing Registration ===");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");

        // 1. Validation Logic
        if (hasEmpty(username, email, password, confirmPassword)) {
            redirectWithError(response, "All fields are required");
            return;
        }

        if (!password.equals(confirmPassword)) {
            redirectWithError(response, "Passwords do not match");
            return;
        }

        if (!EMAIL_PATTERN.matcher(email).matches()) {
            redirectWithError(response, "Invalid email format");
            return;
        }

        if (username.length() < 4) {
            redirectWithError(response, "Username must be at least 4 characters");
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

            // 2. Check Duplicates
            String checkSql = "SELECT username, email FROM user WHERE username=? OR email=?";
            ps = con.prepareStatement(checkSql);
            ps.setString(1, username);
            ps.setString(2, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                String existingUser = rs.getString("username");
                if (username.equals(existingUser)) {
                    redirectWithError(response, "Username already exists");
                } else {
                    redirectWithError(response, "Email already in use");
                }
                return;
            }
            rs.close();
            ps.close();

            // 3. Insert User
            String Role = "customer";
            String insertSql = "INSERT INTO user (username, email, password, role, register_date) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(insertSql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, Role);
            ps.setTimestamp(5, new Timestamp(new Date().getTime()));

            int result = ps.executeUpdate();

            if (result > 0) {
                System.out.println("Registration Successful: " + username);
                response.sendRedirect("login.jsp?registerSuccess=true");
            } else {
                redirectWithError(response, "Registration failed");
            }

        } catch (Exception e) {
            System.err.println("Registration Error: " + e.getMessage());
            e.printStackTrace();
            redirectWithError(response, "Server error details: " + e.getMessage());
        } finally {
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
            // Not closing con as per DBconnection design
        }
    }

    private boolean hasEmpty(String... strs) {
        for (String s : strs) {
            if (s == null || s.trim().isEmpty())
                return true;
        }
        return false;
    }

    private void redirectWithError(HttpServletResponse response, String message) throws IOException {
        String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");
        response.sendRedirect("login.jsp?registerError=" + encodedMessage);
    }
}