package Grocery_Ordering_System;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class itemControl {

    // Insert Data Function (uses PreparedStatement) with improved error handling
    public static boolean insertdata(String name, String price, String quantity, String category, String description) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            System.out.println("itemControl - Getting database connection");
            con = DBconnection.getConnection();
            
            if (con == null) {
                System.out.println("itemControl - Database connection failed");
                return false;
            }
            
            System.out.println("itemControl - Connection successful, preparing statement");
            String sql = "INSERT INTO item (name, price, quantity, category, description) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, price);
            ps.setString(3, quantity);
            ps.setString(4, category);
            ps.setString(5, description);
            
            System.out.println("itemControl - Executing query: " + sql);
            int rs = ps.executeUpdate();
            System.out.println("itemControl - Query executed, rows affected: " + rs);
            
            isSuccess = rs > 0;
        } catch (SQLException e) {
            System.out.println("itemControl - SQL Error during insert: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("itemControl - General Error during insert: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
                System.out.println("itemControl - Database resources closed properly");
            } 
            
            catch (SQLException e) {
                System.out.println("itemControl - Error closing database resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return isSuccess;
    }

    // Get ALL Data with better error handling
    public static List<ItemModel> getAllItem() {
        List<ItemModel> items = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            System.out.println("itemControl - Getting database connection for getAllItem");
            con = DBconnection.getConnection();
            
            if (con == null) {
                System.out.println("itemControl - Database connection failed in getAllItem");
                return items;
            }
            
            stmt = con.createStatement();
            System.out.println("itemControl - Executing SELECT query");
            rs = stmt.executeQuery("SELECT * FROM item");
            
            while (rs.next()) {
                int itemID = rs.getInt("itemID");
                String name = rs.getString("name");
                String price = rs.getString("price");
                String quantity = rs.getString("quantity");
                String category = rs.getString("category");
                String description = rs.getString("description");
                items.add(new ItemModel(itemID, name, price, quantity, category, description));
            }
            
           
            System.out.println("itemControl - Retrieved " + items.size() + " items");
        } 
        
        catch (SQLException e) {
            System.out.println("itemControl - SQL Error in getAllItem: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } 
        //error handling
        catch (Exception e) {
            System.out.println("itemControl - General Error in getAllItem: " + e.getMessage());
            e.printStackTrace();
        } 
        
        finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
                System.out.println("itemControl - Database resources closed properly in getAllItem");
            } 
            
            catch (SQLException e) {
                System.out.println("itemControl - Error closing database resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return items;
    }

    // Get by ID with improved error handling
    public static List<ItemModel> getById(String Id) {
        List<ItemModel> item = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            int convertedID = Integer.parseInt(Id);
            System.out.println("itemControl - Getting database connection for getById: " + Id);
            con = DBconnection.getConnection();
            
            if (con == null) {
                System.out.println("itemControl - Database connection failed in getById");
                return item;
            }
            
            String sql = "SELECT * FROM item WHERE itemID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, convertedID);
            
            System.out.println("itemControl - Executing query with ID: " + convertedID);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                int itemID = rs.getInt("itemID");
                String name = rs.getString("name");
                String price = rs.getString("price");
                String quantity = rs.getString("quantity");
                String category = rs.getString("category");
                String description = rs.getString("description");
                item.add(new ItemModel(itemID, name, price, quantity, category, description));
            }
            System.out.println("itemControl - Retrieved " + item.size() + " items for ID: " + Id);
        } 
        
        catch (NumberFormatException e) {
            System.out.println("itemControl - Invalid ID format: " + Id);
            System.out.println("Error: " + e.getMessage());
        } 
        
        catch (SQLException e) {
            System.out.println("itemControl - SQL Error in getById: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } 
        
        catch (Exception e) {
            System.out.println("itemControl - General Error in getById: " + e.getMessage());
            e.printStackTrace();
        } 
        
        finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
                System.out.println("itemControl - Database resources closed properly in getById");
            } 
            
            catch (SQLException e) {
                System.out.println("itemControl - Error closing database resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return item;
    }
    
    // Delete item method with better error handling
    public static boolean deleteItem(String itemId) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            System.out.println("itemControl - Getting database connection for deleteItem: " + itemId);
            con = DBconnection.getConnection();
            
            if (con == null) {
                System.out.println("itemControl - Database connection failed in deleteItem");
                return false;
            }
            
            String sql = "DELETE FROM item WHERE itemID = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(itemId));
            
            System.out.println("itemControl - Executing delete query with ID: " + itemId);
            int result = ps.executeUpdate();
            
            isSuccess = result > 0;
            System.out.println("itemControl - Delete successful: " + isSuccess + ", rows affected: " + result);
        } 
        
        catch (NumberFormatException e) {
            System.out.println("itemControl - Invalid ID format for delete: " + itemId);
            System.out.println("Error: " + e.getMessage());
        } 
        
        catch (SQLException e) {
            System.out.println("itemControl - SQL Error in deleteItem: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } 
        
        catch (Exception e) {
            System.out.println("itemControl - General Error in deleteItem: " + e.getMessage());
            e.printStackTrace();
        } 
        
        finally {
            // Close resources
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
                System.out.println("itemControl - Database resources closed properly in deleteItem");
            } 
            
            catch (SQLException e) {
                System.out.println("itemControl - Error closing database resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return isSuccess;
    }
    
    // Update item method with better error handling
    public static boolean updateItem(String itemID, String name, String price, String quantity, String category, String description) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            System.out.println("itemControl - Getting database connection for updateItem: " + itemID);
            con = DBconnection.getConnection();
            
            if (con == null) {
                System.out.println("itemControl - Database connection failed in updateItem");
                return false;
            }
            
            String sql = "UPDATE item SET name=?, price=?, quantity=?, category=?, description=? WHERE itemID=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, price);
            ps.setString(3, quantity);
            ps.setString(4, category);
            ps.setString(5, description);
            ps.setInt(6, Integer.parseInt(itemID));
            
            System.out.println("itemControl - Executing update query for ID: " + itemID);
            int result = ps.executeUpdate();
            
            isSuccess = result > 0;
            System.out.println("itemControl - Update successful: " + isSuccess + ", rows affected: " + result);
        } 
        
        catch (NumberFormatException e) {
            System.out.println("itemControl - Invalid ID format for update: " + itemID);
            System.out.println("Error: " + e.getMessage());
        } 
        
        catch (SQLException e) {
            System.out.println("itemControl - SQL Error in updateItem: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } 
        
        catch (Exception e) {
            System.out.println("itemControl - General Error in updateItem: " + e.getMessage());
            e.printStackTrace();
        } 
        
        finally {
            // Close resources
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
                System.out.println("itemControl - Database resources closed properly in updateItem");
            } 
            
            catch (SQLException e) {
                System.out.println("itemControl - Error closing database resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return isSuccess;
    }
}