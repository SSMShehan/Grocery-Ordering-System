package Grocery_Ordering_System;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBconnection {
	private static String url = "jdbc:mysql://localhost:3306/grocery_store";
	private static String user = "root";
	private static String pass = "Admin@12345";
	private static Connection con;
	
	public static Connection getConnection() {
		try {
			// Updated driver class name for newer MySQL versions
			Class.forName("com.mysql.jdbc.Driver");
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