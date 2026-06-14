package Control_Package;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import Model_Package.CartItem;

public class OrderDAO {
    private Connection connection;

    public OrderDAO() {
        this.connection = Util_Package.DBconnection.getConnection();
    }

    // Updated: Save Order linked to User ID
    public boolean saveOrder(int userId, double totalAmount, String address, List<CartItem> cartItems) {
        String orderQuery = "INSERT INTO \"order\" (cusID, amount, address, order_date, order_status) VALUES (?, ?, ?, CURRENT_DATE, 'Completed')";
        String detailQuery = "INSERT INTO order_details (orderID, itemID, quantity, price) VALUES (?, ?, ?, ?)";

        PreparedStatement orderStmt = null;
        PreparedStatement detailStmt = null;
        ResultSet rs = null;

        try {
            // 1. Insert Order
            orderStmt = connection.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setDouble(2, totalAmount);
            orderStmt.setString(3, address);

            int affectedRows = orderStmt.executeUpdate();

            if (affectedRows == 0) {
                return false;
            }

            // 2. Get Generated Order ID
            int orderId = 0;
            rs = orderStmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            } else {
                return false;
            }

            // 3. Insert Order Details (Items)
            detailStmt = connection.prepareStatement(detailQuery);
            for (CartItem item : cartItems) {
                detailStmt.setInt(1, orderId);
                detailStmt.setInt(2, item.getItemId());
                detailStmt.setInt(3, item.getQuantity());
                detailStmt.setDouble(4, item.getItemPrice());
                detailStmt.addBatch();
            }

            detailStmt.executeBatch();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception e) {
            }
            try {
                if (orderStmt != null)
                    orderStmt.close();
            } catch (Exception e) {
            }
            try {
                if (detailStmt != null)
                    detailStmt.close();
            } catch (Exception e) {
            }
        }
    }

    // New: Fetch Orders for Profile
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM \"order\" WHERE cusID = ? ORDER BY order_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("orderID"));
                order.setOrderDate(rs.getDate("order_date"));
                order.setTotalAmount(rs.getDouble("amount"));
                order.setStatus(rs.getString("order_status"));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Internal inner class for Order structure to simplify transport
    public static class Order {
        private int orderId;
        private java.sql.Date orderDate;
        private double totalAmount;
        private String status;

        public int getOrderId() {
            return orderId;
        }

        public void setOrderId(int orderId) {
            this.orderId = orderId;
        }

        public java.sql.Date getOrderDate() {
            return orderDate;
        }

        public void setOrderDate(java.sql.Date orderDate) {
            this.orderDate = orderDate;
        }

        public double getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(double totalAmount) {
            this.totalAmount = totalAmount;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }
}