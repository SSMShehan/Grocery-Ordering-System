package Control_Package;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;

import Model_Package.CategoryModel;
import Util_Package.DBconnection;

public class CategoryControl {
    
    public static boolean insertCategory(String name, String description, Integer parentCategoryID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "INSERT INTO category (name, description, parent_categoryID) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            if (parentCategoryID != null && parentCategoryID > 0) {
                ps.setInt(3, parentCategoryID);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
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

    // Get all categories
    public static List<CategoryModel> getAllCategories() {
        List<CategoryModel> categories = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            String sql = "SELECT c.*, p.name as parent_name FROM category c LEFT JOIN category p ON c.parent_categoryID = p.categoryID";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                int categoryID = rs.getInt("categoryID");
                String name = rs.getString("name");
                String description = rs.getString("description");
                Integer parentCategoryID = rs.getInt("parent_categoryID");
                if (rs.wasNull()) {
                    parentCategoryID = null;
                }
                
                CategoryModel category = new CategoryModel(categoryID, name, description, parentCategoryID);
                category.setParentCategoryName(rs.getString("parent_name"));
                categories.add(category);
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
        return categories;
    }

    // Get all no parent categories
    public static List<CategoryModel> getParentCategories() {
        List<CategoryModel> categories = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM category WHERE parent_categoryID IS NULL");
            
            while (rs.next()) {
                int categoryID = rs.getInt("categoryID");
                String name = rs.getString("name");
                String description = rs.getString("description");
                categories.add(new CategoryModel(categoryID, name, description, null));
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
        return categories;
    }

    // Update category
    public static boolean updateCategory(String categoryID, String name, String description, Integer parentCategoryID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "UPDATE category SET name=?, description=?, parent_categoryID=? WHERE categoryID=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            if (parentCategoryID != null && parentCategoryID > 0) {
                ps.setInt(3, parentCategoryID);
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setInt(4, Integer.parseInt(categoryID));
            
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

    // Delete category
    public static boolean deleteCategory(String categoryID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "DELETE FROM category WHERE categoryID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(categoryID));
            
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