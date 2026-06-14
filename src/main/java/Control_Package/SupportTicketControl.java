// SupportTicketControl.java
package Control_Package;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;

import Model_Package.SupportTicketModel;
import Util_Package.DBconnection;

public class SupportTicketControl {
    // Get all tickets with customer names
    public static List<SupportTicketModel> getAllTickets() {
        List<SupportTicketModel> tickets = new ArrayList<>();
        Connection con = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            con = DBconnection.getConnection();
            stmt = con.createStatement();
            String sql = "SELECT t.*, u.username as customerName, 'Medium' as priority " +
                         "FROM support_ticket t JOIN user u ON t.cusID = u.userID";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                SupportTicketModel ticket = new SupportTicketModel(
                    rs.getInt("ticketID"),
                    rs.getInt("cusID"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getString("status"),
                    rs.getTimestamp("created_at"),
                    rs.getString("reply"),
                    rs.getString("customerName"),
                    rs.getString("priority")
                );
                tickets.add(ticket);
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
        return tickets;
    }

 // Update createTicket method
    public static boolean createTicket(int cusID, String subject, String message, String priority) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "INSERT INTO support_ticket (cusID, subject, message, priority) VALUES (?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, cusID);
            ps.setString(2, subject);
            ps.setString(3, message);
            ps.setString(4, priority);
            
            int rs = ps.executeUpdate();
            isSuccess = rs > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }

   
    public static boolean updateTicket(int ticketID, String reply, String status, String priority) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "UPDATE support_ticket SET reply=?, status=?, priority=? WHERE ticketID=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, reply);
            ps.setString(2, status);
            ps.setString(3, priority);
            ps.setInt(4, ticketID);
            
            int result = ps.executeUpdate();
            isSuccess = result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }

    // Delete ticket
    public static boolean deleteTicket(int ticketID) {
        boolean isSuccess = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBconnection.getConnection();
            String sql = "DELETE FROM support_ticket WHERE ticketID=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, ticketID);
            
            int result = ps.executeUpdate();
            isSuccess = result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return isSuccess;
    }
}