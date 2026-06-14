package Util_Package;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class Seeder {

    public static void main(String[] args) {
        System.out.println("Starting Database Seeding...");

        try (Connection con = DBconnection.getConnection()) {
            if (con == null) {
                System.out.println("Failed to connect to the database!");
                return;
            }

            // Seed Categories
            seedCategories(con);

            // Seed Items
            seedItems(con);

            // Seed Users
            seedUsers(con);

            System.out.println("Database Seeding Completed Successfully!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void seedCategories(Connection con) throws Exception {
        System.out.println("Seeding Categories...");
        String[] categories = {
                "Fruits", "Vegetables", "Dairy & Eggs", "Bakery", "Beverages", "Snacks",
                "Baby Products", "Frozen Food", "Household", "Health & Beauty", "Rice & Grains", "Baking"
        };

        // Add a few descriptions
        String description = "Fresh and organic products";

        String insertSQL = "INSERT INTO category (name, description) VALUES (?, ?)";
        String checkSQL = "SELECT count(*) FROM category WHERE name = ?";
        String updateSQL = "UPDATE category SET name = ? WHERE name = 'Dairy'";

        try (PreparedStatement pstmtInsert = con.prepareStatement(insertSQL);
                PreparedStatement pstmtCheck = con.prepareStatement(checkSQL);
                PreparedStatement pstmtUpdate = con.prepareStatement(updateSQL)) {

            // Rename Dairy to Dairy & Eggs if it exists
            pstmtUpdate.setString(1, "Dairy & Eggs");
            pstmtUpdate.executeUpdate();

            for (String cat : categories) {
                pstmtCheck.setString(1, cat);
                try (ResultSet rs = pstmtCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        pstmtInsert.setString(1, cat);
                        pstmtInsert.setString(2, description);
                        pstmtInsert.executeUpdate();
                        System.out.println("Inserted Category: " + cat);
                    } else {
                        System.out.println("Category already exists: " + cat);
                    }
                }
            }
        }
    }

    private static void seedItems(Connection con) throws Exception {
        System.out.println("Seeding Items...");

        // Helper class to hold item data temporarily
        class ItemData {
            String name;
            String price;
            String quantity;
            String category;
            String description;

            ItemData(String n, String p, String q, String c, String d) {
                name = n;
                price = p;
                quantity = q;
                category = c;
                description = d;
            }
        }

        ItemData[] items = {
                // Fruits
                new ItemData("Apple", "50", "100", "Fruits", "Red Delicious Apples"),
                new ItemData("Banana", "20", "200", "Fruits", "Fresh Bananas"),
                new ItemData("Orange", "60", "150", "Fruits", "Juicy Oranges"),

                // Vegetables
                new ItemData("Carrot", "40", "100", "Vegetables", "Crunchy Carrots"),
                new ItemData("Potato", "30", "300", "Vegetables", "Large Potatoes"),
                new ItemData("Tomato", "35", "200", "Vegetables", "Red Tomatoes"),

                // Dairy & Eggs
                new ItemData("Milk", "80", "50", "Dairy & Eggs", "Fresh Cow Milk"),
                new ItemData("Cheese", "250", "20", "Dairy & Eggs", "Cheddar Cheese"),
                new ItemData("Yogurt", "45", "50", "Dairy & Eggs", "Plain Yogurt"),
                new ItemData("Eggs", "20", "500", "Dairy & Eggs", "Farm Fresh Eggs"),

                // Bakery
                new ItemData("Bread", "60", "40", "Bakery", "Whole Wheat Bread"),
                new ItemData("Croissant", "120", "30", "Bakery", "Butter Croissant"),

                // Beverages
                new ItemData("Orange Juice", "150", "50", "Beverages", "Freshly Squeezed"),
                new ItemData("Mineral Water", "40", "100", "Beverages", "1L Bottle"),

                // Snacks
                new ItemData("Potato Chips", "100", "50", "Snacks", "Salted Chips"),
                new ItemData("Cookies", "120", "60", "Snacks", "Choco Chip Cookies"),

                // Baby Products
                new ItemData("Baby Diapers", "1500", "50", "Baby Products", "Soft and absorbent"),
                new ItemData("Baby Wipes", "450", "100", "Baby Products", "Gentle on skin"),

                // Frozen Food
                new ItemData("Frozen Peas", "300", "30", "Frozen Food", "Sweet Garden Peas"),
                new ItemData("Ice Cream", "600", "20", "Frozen Food", "Vanilla Bean"),

                // Household
                new ItemData("Laundry Detergent", "800", "40", "Household", "Lemon Scent"),
                new ItemData("Dish Soap", "250", "60", "Household", "Grease Fighter"),

                // Health & Beauty
                new ItemData("Shampoo", "450", "30", "Health & Beauty", "Smooth & Silky"),
                new ItemData("Soap", "80", "100", "Health & Beauty", "Moisturizing Bar"),

                // Rice & Grains
                new ItemData("Basmati Rice", "350", "100", "Rice & Grains", "Premium Quality"),
                new ItemData("Pasta", "200", "50", "Rice & Grains", "Italian Spaghetti"),

                // Baking
                new ItemData("Flour", "150", "60", "Baking", "All Purpose Flour"),
                new ItemData("Sugar", "120", "80", "Baking", "White Granulated Sugar")
        };

        String insertSQL = "INSERT INTO item (name, price, quantity, category, description) VALUES (?, ?, ?, ?, ?)";
        String checkSQL = "SELECT count(*) FROM item WHERE name = ?";

        try (PreparedStatement pstmtInsert = con.prepareStatement(insertSQL);
                PreparedStatement pstmtCheck = con.prepareStatement(checkSQL)) {

            for (ItemData item : items) {
                pstmtCheck.setString(1, item.name);
                try (ResultSet rs = pstmtCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        pstmtInsert.setString(1, item.name);
                        pstmtInsert.setString(2, item.price);
                        pstmtInsert.setString(3, item.quantity);
                        pstmtInsert.setString(4, item.category);
                        pstmtInsert.setString(5, item.description);
                        pstmtInsert.executeUpdate();
                        System.out.println("Inserted Item: " + item.name);
                    } else {
                        System.out.println("Item already exists: " + item.name);
                        // Optional: Update category if needed
                    }
                }
            }
        }
    }

    private static void seedUsers(Connection con) throws Exception {
        System.out.println("Seeding Users...");

        // username, password, email, phone, role
        String[][] users = {
                { "admin", "123", "admin@gmail.com", "0771234567", "admin" },
                { "cus", "123", "cus@gmail.com", "0711234567", "customer" }
        };

        String insertSQL = "INSERT INTO user (username, password, email, phone, role) VALUES (?, ?, ?, ?, ?)";
        String checkSQL = "SELECT count(*) FROM user WHERE username = ?";

        try (PreparedStatement pstmtInsert = con.prepareStatement(insertSQL);
                PreparedStatement pstmtCheck = con.prepareStatement(checkSQL)) {

            for (String[] user : users) {
                pstmtCheck.setString(1, user[0]);
                try (ResultSet rs = pstmtCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        pstmtInsert.setString(1, user[0]);
                        pstmtInsert.setString(2, user[1]);
                        pstmtInsert.setString(3, user[2]);
                        pstmtInsert.setString(4, user[3]);
                        pstmtInsert.setString(5, user[4]);
                        pstmtInsert.executeUpdate();
                        System.out.println("Inserted User: " + user[0]);
                    } else {
                        System.out.println("User already exists: " + user[0]);
                    }
                }
            }
        }
    }
}
