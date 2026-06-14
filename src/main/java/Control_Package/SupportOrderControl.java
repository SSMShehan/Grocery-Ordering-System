package Control_Package;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import Util_Package.DBconnection;
import Model_Package.SupportOrderModel;

public class SupportOrderControl {
    // Get all orders with customer names 
    public static List<SupportOrderModel> getAllOrders() {
        List<SupportOrderModel> orders = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            String sql = "SELECT o.*, c.name as customerName FROM \"order\" o JOIN customer c ON o.cusID = c.cusID";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                int orderID = rs.getInt("orderID");
                int cusID = rs.getInt("cusID");
                String amount = rs.getString("amount");
                Date order_date = rs.getDate("order_date");
                String order_status = rs.getString("order_status");
                String customerName = rs.getString("customerName");
                
                SupportOrderModel order = new SupportOrderModel(orderID, cusID, amount, order_date, order_status);
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
    
    // Get order by ID 
    public static SupportOrderModel getOrderById(String orderID) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        SupportOrderModel order = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "SELECT o.*, c.name as customerName FROM \"order\" o JOIN customer c ON o.cusID = c.cusID WHERE o.orderID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(orderID));
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int cusID = rs.getInt("cusID");
                String amount = rs.getString("amount");
                Date order_date = rs.getDate("order_date");
                String order_status = rs.getString("order_status");
                String customerName = rs.getString("customerName");
                
                order = new SupportOrderModel(Integer.parseInt(orderID), cusID, amount, order_date, order_status);
                order.setCustomerName(customerName);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return order;
    }
}