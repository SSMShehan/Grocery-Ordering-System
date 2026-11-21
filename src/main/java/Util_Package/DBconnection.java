package Util_Package;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBconnection {

    public static Connection getConnection() {
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        if (url == null || url.trim().isEmpty()) {
            url = "jdbc:postgresql://aws-1-ap-northeast-2.pooler.supabase.com:5432/postgres?sslmode=require";
        }
        if (user == null || user.trim().isEmpty()) {
            user = "postgres.mupdoceejdvgqkoqnsst";
        }
        if (pass == null) {
            pass = "";
        }

        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("=== DB CONNECTING TO: " + url + " | USER: " + user + " ===");
            Connection con = DriverManager.getConnection(url, user, pass);
            System.out.println("=== DB CONNECTION SUCCESSFUL ===");
            return con;
        } catch (ClassNotFoundException e) {
            System.err.println("=== DB DRIVER ERROR: " + e.getMessage() + " ===");
            throw new RuntimeException("PostgreSQL JDBC Driver not found: " + e.getMessage(), e);
        } catch (SQLException e) {
            System.err.println("=== DB CONNECTION ERROR: " + e.getMessage() + " ===");
            throw new RuntimeException("DB Connection failed: " + e.getMessage(), e);
        }
    }
}