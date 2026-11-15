package Util_Package;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBconnection {
    private static String url = System.getenv("DB_URL");
    private static String user = System.getenv("DB_USER");
    private static String pass = System.getenv("DB_PASS");
    private static Connection con;

    public static Connection getConnection() {
        try {
            if (url == null || url.isEmpty()) {
                url = "jdbc:postgresql://aws-1-ap-northeast-2.pooler.supabase.com:5432/postgres?sslmode=require";
            }
            if (user == null || user.isEmpty()) {
                user = "postgres.mupdoceejdvgqkoqnsst";
            }
            if (pass == null || pass.isEmpty()) {
                pass = ""; 
            }

            Class.forName("org.postgresql.Driver");
            System.out.println("=== DB CONNECTING TO: " + url + " | USER: " + user + " ===");
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("=== DB CONNECTION SUCCESSFUL ===");
        }
        catch(Exception e) {
            System.err.println("=== DB ERROR: " + e.getMessage() + " ===");
            e.printStackTrace();
        }
        return con;
    }
}