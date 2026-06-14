package Control_Package;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Util_Package.DBconnection;
import Model_Package.CartItem;

public class CartDAO {
    private Connection connection;
    
    public CartDAO() {
        this.connection = Util_Package.DBconnection.getConnection();
    }
    
    
    public void addToCart(int userId, int itemId, int quantity) throws SQLException {
        String query = "INSERT INTO cart_item (\"userID\", \"itemID\", quantity, added_date) VALUES (?, ?, ?, CURRENT_DATE)";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, itemId);
            pstmt.setInt(3, quantity);
            pstmt.executeUpdate();
        }
    }
    
    public List<CartItem> getCartItems(int userId) throws SQLException {
        System.out.println("DEBUG - Getting cart items for user: " + userId);
        
        String query = "SELECT ci.\"cart_itemID\", ci.\"userID\", ci.\"itemID\", ci.quantity, ci.added_date, " +
                     "i.name, i.price, i.description " +
                     "FROM cart_item ci " +
                     "JOIN item i ON ci.\"itemID\" = i.\"itemID\" " +
                     "WHERE ci.\"userID\" = ?";
        
        List<CartItem> cartItems = new ArrayList<>();
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_itemID"));
                    item.setUserId(rs.getInt("userID"));
                    item.setItemId(rs.getInt("itemID"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setAddedDate(rs.getDate("added_date"));
                    item.setItemName(rs.getString("name"));
                    item.setItemPrice(rs.getDouble("price"));
                    item.setItemDescription(rs.getString("description"));
                    cartItems.add(item);
                }
            }
        }
        return cartItems;
    }
    
    public void updateCartItemQuantity(int cartItemId, int quantity) throws SQLException {
        String query = "UPDATE cart_item SET quantity = ? WHERE \"cart_itemID\" = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartItemId);
            pstmt.executeUpdate();
        }
    }
    
    public void removeFromCart(int cartItemId) throws SQLException {
        String query = "DELETE FROM cart_item WHERE \"cart_itemID\" = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, cartItemId);
            pstmt.executeUpdate();
        }
    }
}