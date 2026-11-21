package Util_Package;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBconnection {

    private static String sanitizeUrl(String rawUrl) {
        if (rawUrl == null) return null;
        String cleaned = rawUrl.trim();

        // If markdown link format was pasted: [text](https://url) or [url](url)
        if (cleaned.contains("[") && cleaned.contains("](")) {
            int start = cleaned.indexOf("](");
            int end = cleaned.indexOf(")", start);
            if (start != -1 && end != -1) {
                cleaned = cleaned.substring(start + 2, end).trim();
            }
        } else if (cleaned.startsWith("[") && cleaned.contains("]")) {
            int end = cleaned.indexOf("]");
            cleaned = cleaned.substring(1, end).trim();
        }

        // Strip surrounding quotes
        if ((cleaned.startsWith("\"") && cleaned.endsWith("\"")) || 
            (cleaned.startsWith("'") && cleaned.endsWith("'"))) {
            cleaned = cleaned.substring(1, cleaned.length() - 1).trim();
        }

        // Strip http:// or https:// if accidentally prefixed
        if (cleaned.startsWith("https://")) {
            cleaned = cleaned.substring(8);
        } else if (cleaned.startsWith("http://")) {
            cleaned = cleaned.substring(7);
        }

        // Ensure proper JDBC prefix
        if (cleaned.startsWith("postgres://")) {
            cleaned = "jdbc:postgresql://" + cleaned.substring(11);
        } else if (cleaned.startsWith("postgresql://")) {
            cleaned = "jdbc:postgresql://" + cleaned.substring(13);
        } else if (!cleaned.startsWith("jdbc:postgresql://")) {
            cleaned = "jdbc:postgresql://" + cleaned;
        }

        // Ensure sslmode=require for cloud PostgreSQL
        if (!cleaned.contains("sslmode=")) {
            cleaned += (cleaned.contains("?") ? "&" : "?") + "sslmode=require";
        }

        return cleaned;
    }

    private static String cleanValue(String val) {
        if (val == null) return null;
        String cleaned = val.trim();
        if ((cleaned.startsWith("\"") && cleaned.endsWith("\"")) || 
            (cleaned.startsWith("'") && cleaned.endsWith("'"))) {
            cleaned = cleaned.substring(1, cleaned.length() - 1).trim();
        }
        return cleaned;
    }

    public static Connection getConnection() {
        String rawUrl = System.getenv("DB_URL");
        String rawUser = System.getenv("DB_USER");
        String rawPass = System.getenv("DB_PASS");

        String url = sanitizeUrl(rawUrl);
        String user = cleanValue(rawUser);
        String pass = cleanValue(rawPass);

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