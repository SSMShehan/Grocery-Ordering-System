// PaymentControl.java
package PaymentPackage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import CustomerPackage.CustomerModel;
import Grocery_Ordering_System.DBconnection;
import OrderPackage.OrderModel;

public class PaymentControl {
    // Insert payment data
    public static boolean insertPayment(int orderID, int cusID, String amount, String paydate, String paymethod, String payment_status) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "INSERT INTO payment (orderID, cusID, amount, paydate, paymethod, payment_status) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, orderID);
            ps.setInt(2, cusID);
            ps.setString(3, amount);
            ps.setDate(4, Date.valueOf(paydate));
            ps.setString(5, paymethod);
            ps.setString(6, payment_status);
            
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

    // Get all payments with customer and order information
    public static List<PaymentModel> getAllPayments() {
        List<PaymentModel> payments = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            String sql = "SELECT p.*, c.name as customerName, CONCAT('Order #', o.orderID, ' - $', o.amount) as orderDetails " +
                         "FROM payment p " +
                         "JOIN customer c ON p.cusID = c.cusID " +
                         "JOIN `order` o ON p.orderID = o.orderID";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                int paymentID = rs.getInt("paymentID");
                int orderID = rs.getInt("orderID");
                int cusID = rs.getInt("cusID");
                String amount = rs.getString("amount");
                Date paydate = rs.getDate("paydate");
                String paymethod = rs.getString("paymethod");
                String payment_status = rs.getString("payment_status");
                String customerName = rs.getString("customerName");
                String orderDetails = rs.getString("orderDetails");
                
                PaymentModel payment = new PaymentModel(paymentID, orderID, cusID, amount, paydate, paymethod, payment_status);
                payment.setCustomerName(customerName);
                payment.setOrderDetails(orderDetails);
                payments.add(payment);
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
        return payments;
    }

    // Update payment
    public static boolean updatePayment(String paymentID, String orderID, String cusID, String amount, String paydate, String paymethod, String payment_status) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "UPDATE payment SET orderID=?, cusID=?, amount=?, paydate=?, paymethod=?, payment_status=? WHERE paymentID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(orderID));
            ps.setInt(2, Integer.parseInt(cusID));
            ps.setString(3, amount);
            ps.setDate(4, Date.valueOf(paydate));
            ps.setString(5, paymethod);
            ps.setString(6, payment_status);
            ps.setInt(7, Integer.parseInt(paymentID));
            
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

    // Delete payment
    public static boolean deletePayment(String paymentID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "DELETE FROM payment WHERE paymentID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(paymentID));
            
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
    
    // Get all orders for dropdown
    public static List<OrderModel> getAllOrders() {
        return OrderPackage.OrderControl.getAllOrders();
    }
}