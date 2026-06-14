package Control_Package;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import Model_Package.Item;
import Model_Package.ItemModel;
import Util_Package.DBconnection;

public class ItemDAO {

    private Connection connection;

    public ItemDAO() {
        this.connection = DBconnection.getConnection();
    }

    // ====== CATEGORY METHODS ======

    public Set<String> getAllCategories() {
        Set<String> categories = new HashSet<>();
        String query = "SELECT DISTINCT category FROM item WHERE category IS NOT NULL";

        try (PreparedStatement pstmt = connection.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String category = rs.getString("category");
                if (category != null && !category.trim().isEmpty()) {
                    categories.add(category);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting categories: " + e.getMessage());
            e.printStackTrace();
        }

        return categories;
    }

    public List<String> getAllCategoriesList() {
        return new ArrayList<>(getAllCategories());
    }

    // ====== READ METHODS ======

    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM item";

        try (PreparedStatement pstmt = connection.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Item item = extractItemFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all items: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    public List<Item> getDiscountedItems() {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM item WHERE discount_percentage > 0";

        try (PreparedStatement pstmt = connection.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Item item = extractItemFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getting discounted items: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    public List<ItemModel> getAllItemModels() {
        List<ItemModel> items = new ArrayList<>();
        String query = "SELECT * FROM item";

        try (PreparedStatement pstmt = connection.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                ItemModel item = extractItemModelFromResultSet(rs);
                items.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all items: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    public List<Item> getItemsByCategory(String category) {
        List<Item> items = new ArrayList<>();
        String query = "SELECT * FROM item WHERE category = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setString(1, category);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Item item = extractItemFromResultSet(rs);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting items by category: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    public Item getItemById(int itemId) {
        String query = "SELECT * FROM item WHERE itemID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, itemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractItemFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting item by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<ItemModel> getById(String Id) {
        List<ItemModel> items = new ArrayList<>();

        try {
            int itemId = Integer.parseInt(Id);
            String query = "SELECT * FROM item WHERE itemID = ?";

            try (PreparedStatement pstmt = connection.prepareStatement(query)) {
                pstmt.setInt(1, itemId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        ItemModel item = extractItemModelFromResultSet(rs);
                        items.add(item);
                    }
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: " + Id);
        } catch (SQLException e) {
            System.out.println("Error getting item by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return items;
    }

    // ====== CREATE METHOD ======

    public boolean insertItem(String name, String price, String quantity, String category, String description) {
        boolean isSuccess = false;
        String sql = "INSERT INTO item (name, price, quantity, category, description) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, price);
            pstmt.setString(3, quantity);
            pstmt.setString(4, category);
            pstmt.setString(5, description);

            int result = pstmt.executeUpdate();
            isSuccess = result > 0;

            System.out.println("Item inserted successfully: " + isSuccess);
        } catch (SQLException e) {
            System.out.println("SQL Error during insert: " + e.getMessage());
            e.printStackTrace();
        }

        return isSuccess;
    }

    // ====== UPDATE METHOD ======

    public boolean updateItem(String itemID, String name, String price, String quantity, String category,
            String description) {
        boolean isSuccess = false;
        String sql = "UPDATE item SET name = ?, price = ?, quantity = ?, category = ?, description = ? WHERE itemID = ?";

        try {
            int id = Integer.parseInt(itemID);

            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                pstmt.setString(1, name);
                pstmt.setString(2, price);
                pstmt.setString(3, quantity);
                pstmt.setString(4, category);
                pstmt.setString(5, description);
                pstmt.setInt(6, id);

                int result = pstmt.executeUpdate();
                isSuccess = result > 0;

                System.out.println("Item updated successfully: " + isSuccess);
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: " + itemID);
        } catch (SQLException e) {
            System.out.println("SQL Error during update: " + e.getMessage());
            e.printStackTrace();
        }

        return isSuccess;
    }

    // ====== DELETE METHOD ======

    public boolean deleteItem(String itemId) {
        boolean isSuccess = false;
        String sql = "DELETE FROM item WHERE itemID = ?";

        try {
            int id = Integer.parseInt(itemId);

            try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
                pstmt.setInt(1, id);

                int result = pstmt.executeUpdate();
                isSuccess = result > 0;

                System.out.println("Item deleted successfully: " + isSuccess);
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: " + itemId);
        } catch (SQLException e) {
            System.out.println("SQL Error during delete: " + e.getMessage());
            e.printStackTrace();
        }

        return isSuccess;
    }

    // ====== HELPER METHODS ======

    private Item extractItemFromResultSet(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemID(rs.getInt("itemID"));
        item.setName(rs.getString("name"));
        item.setPrice(rs.getString("price"));
        item.setQuantity(rs.getString("quantity"));
        item.setCategory(rs.getString("category"));
        item.setDescription(rs.getString("description"));
        // item.setImagePath(rs.getString("image_path")); // Image path may not exist in DB
        
        int discount = 0;
        try {
            discount = rs.getInt("discount_percentage");
        } catch(Exception e) { /* ignore if column missing during legacy calls */ }
        item.setDiscount(discount);
        
        try {
            double price = Double.parseDouble(rs.getString("price"));
            item.setDealPrice(String.format("%.2f", price - (price * discount / 100.0)));
        } catch(Exception e) {
            item.setDealPrice(rs.getString("price"));
        }
        
        return item;
    }

    private ItemModel extractItemModelFromResultSet(ResultSet rs) throws SQLException {
        return new ItemModel(
                rs.getInt("itemID"),
                rs.getString("name"),
                rs.getString("price"),
                rs.getString("quantity"),
                rs.getString("category"),
                rs.getString("description"));
    }
}
