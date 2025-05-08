// UserControl.java
package UserPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Grocery_Ordering_System.DBconnection;

public class UserControl {
    // Insert user data
    public static boolean insertUser(String username, String password, String email, 
                                   String phone, String register_date, String status, String role) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "INSERT INTO user (username, password, email, phone, register_date, status, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDate(5, Date.valueOf(register_date));
            ps.setString(6, status);
            ps.setString(7, role);
            
            int rs = ps.executeUpdate();
            isSuccess = rs > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }

    // Get all users
    public static List<UserModel> getAllUsers() {
        List<UserModel> users = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM user");
            
            while (rs.next()) {
                int userID = rs.getInt("userID");
                String username = rs.getString("username");
                String password = rs.getString("password");
                String email = rs.getString("email");
                String phone = rs.getString("phone");
                Date register_date = rs.getDate("register_date");
                String status = rs.getString("status");
                String role = rs.getString("role");
                users.add(new UserModel(userID, username, password, email, phone, register_date, status, role));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return users;
    }

    // Update user
    public static boolean updateUser(String userID, String username, String password, String email, 
                                   String phone, String register_date, String status, String role) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "UPDATE user SET username=?, password=?, email=?, phone=?, register_date=?, status=?, role=? WHERE userID=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDate(5, Date.valueOf(register_date));
            ps.setString(6, status);
            ps.setString(7, role);
            ps.setInt(8, Integer.parseInt(userID));
            
            int result = ps.executeUpdate();
            isSuccess = result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }

    // Delete user
    public static boolean deleteUser(String userID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "DELETE FROM user WHERE userID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(userID));
            
            int result = ps.executeUpdate();
            isSuccess = result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }
}