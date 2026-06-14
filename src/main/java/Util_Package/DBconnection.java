package Util_Package;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBconnection {
	private static String url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres";
	private static String user = "postgres";
	private static String pass = "1syERFX5ObrpQ5qR";
	private static Connection con;
	
	public static Connection getConnection() {
		try {
			
			Class.forName("org.postgresql.Driver");
			System.out.println("Attempting to connect to database: " + url);
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