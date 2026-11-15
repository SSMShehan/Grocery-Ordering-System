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
                url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres";
            }
            if (user == null || user.isEmpty()) {
                user = "postgres";
            }
            if (pass == null || pass.isEmpty()) {
                pass = ""; 
            }

            Class.forName("org.postgresql.Driver");
            System.out.println("Attempting to connect to database...");
            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Database connection successful");
        }
        catch(Exception e) {
            System.out.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
}