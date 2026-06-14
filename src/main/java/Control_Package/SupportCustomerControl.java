package Control_Package;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import Util_Package.DBconnection;
import Model_Package.SupportCustomerModel;

public class SupportCustomerControl {
    // Get all customers 
    public static List<SupportCustomerModel> getAllCustomers() {
        List<SupportCustomerModel> customers = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT * FROM customer");
            
            while (rs.next()) {
                int cusID = rs.getInt("cusID");
                String name = rs.getString("name");
                String phone = rs.getString("phone");
                String email = rs.getString("email");
                String address = rs.getString("address");
                Date register_date = rs.getDate("register_date");
                String status = rs.getString("status");
                customers.add(new SupportCustomerModel(cusID, name, phone, email, address, register_date, status));
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
        return customers;
    }
    
    // Get customer 
    public static SupportCustomerModel getCustomerById(String cusID) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        SupportCustomerModel customer = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "SELECT * FROM customer WHERE cusID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(cusID));
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String name = rs.getString("name");
                String phone = rs.getString("phone");
                String email = rs.getString("email");
                String address = rs.getString("address");
                Date register_date = rs.getDate("register_date");
                String status = rs.getString("status");
                customer = new SupportCustomerModel(Integer.parseInt(cusID), name, phone, 
                        email, address, register_date, status);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return customer;
    }
}