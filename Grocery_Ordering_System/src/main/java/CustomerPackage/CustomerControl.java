package CustomerPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Grocery_Ordering_System.DBconnection;

public class CustomerControl {
    // Insert customer data
    public static boolean insertCustomer(String name, String phone, String email, String address, String register_date, String status) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "INSERT INTO customer (name, phone, email, address, register_date, status) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setDate(5, Date.valueOf(register_date));
            ps.setString(6, status);
            
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

    // Get all customers
    public static List<CustomerModel> getAllCustomers() {
        List<CustomerModel> customers = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM customer");
            
            while (rs.next()) {
                int cusID = rs.getInt("cusID");
                String name = rs.getString("name");
                String phone = rs.getString("phone");
                String email = rs.getString("email");
                String address = rs.getString("address");
                Date register_date = rs.getDate("register_date");
                String status = rs.getString("status");
                customers.add(new CustomerModel(cusID, name, phone, email, address, register_date, status));
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
        return customers;
    }

    // Update customer
    public static boolean updateCustomer(String cusID, String name, String phone, String email, String address, String register_date, String status) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "UPDATE customer SET name=?, phone=?, email=?, address=?, register_date=?, status=? WHERE cusID=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setDate(5, Date.valueOf(register_date));
            ps.setString(6, status);
            ps.setInt(7, Integer.parseInt(cusID));
            
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

    // Delete customer
    public static boolean deleteCustomer(String cusID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "DELETE FROM customer WHERE cusID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(cusID));
            
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