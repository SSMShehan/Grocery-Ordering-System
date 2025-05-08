// OrderControl.java
package OrderPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import CustomerPackage.CustomerModel;
import Grocery_Ordering_System.DBconnection;

public class OrderControl {
    // Insert order data
    public static boolean insertOrder(int cusID, String amount, String order_date, String order_status) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "INSERT INTO `order` (cusID, amount, order_date, order_status) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, cusID);
            ps.setString(2, amount);
            ps.setDate(3, Date.valueOf(order_date));
            ps.setString(4, order_status);
            
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

    // Get all orders with customer names
    public static List<OrderModel> getAllOrders() {
        List<OrderModel> orders = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            String sql = "SELECT o.*, c.name as customerName FROM `order` o JOIN customer c ON o.cusID = c.cusID";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                int orderID = rs.getInt("orderID");
                int cusID = rs.getInt("cusID");
                String amount = rs.getString("amount");
                Date order_date = rs.getDate("order_date");
                String order_status = rs.getString("order_status");
                String customerName = rs.getString("customerName");
                
                OrderModel order = new OrderModel(orderID, cusID, amount, order_date, order_status);
                order.setCustomerName(customerName);
                orders.add(order);
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
        return orders;
    }

    // Update order
    public static boolean updateOrder(String orderID, String cusID, String amount, String order_date, String order_status) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "UPDATE `order` SET cusID=?, amount=?, order_date=?, order_status=? WHERE orderID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(cusID));
            ps.setString(2, amount);
            ps.setDate(3, Date.valueOf(order_date));
            ps.setString(4, order_status);
            ps.setInt(5, Integer.parseInt(orderID));
            
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

    // Delete order
    public static boolean deleteOrder(String orderID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "DELETE FROM `order` WHERE orderID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(orderID));
            
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
    
    // Get all customers for dropdown
    public static List<CustomerModel> getAllCustomers() {
        return CustomerPackage.CustomerControl.getAllCustomers();
    }
}