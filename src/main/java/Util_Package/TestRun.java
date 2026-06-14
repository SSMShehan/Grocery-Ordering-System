package Util_Package;

import java.sql.Connection;

public class TestRun {
    public static void main(String[] args) {
        System.out.println("Starting DB Connection Test...");
        Connection con = DBconnection.getConnection();
        if (con != null) {
            System.out.println("Test Result: SUCCESS - Connection established!");
        } else {
            System.out.println("Test Result: FAILED - Connection is null.");
        }
    }
}
