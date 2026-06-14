package Util_Package;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ItemLister {
    public static void main(String[] args) {
        try (Connection con = DBconnection.getConnection()) {
            String sql = "SELECT itemID, name FROM item";
            try (PreparedStatement pstmt = con.prepareStatement(sql);
                    ResultSet rs = pstmt.executeQuery()) {
                System.out.println("--- ITEM LIST ---");
                while (rs.next()) {
                    System.out.println(rs.getInt("itemID") + ":" + rs.getString("name"));
                }
                System.out.println("--- END LIST ---");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
