<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, Model_Package.CartItem" %>
<%
    Integer userID = (Integer) session.getAttribute("userID");
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
    
    if (userID != null && cartItems != null) {
        Connection con = null;
        PreparedStatement pstClear = null;
        PreparedStatement pstInsert = null;
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
            
            // Rebuild the cart in DB
            pstClear = con.prepareStatement("DELETE FROM cart_item WHERE userID = ?");
            pstClear.setInt(1, userID);
            pstClear.executeUpdate();
            
            if (!cartItems.isEmpty()) {
                pstInsert = con.prepareStatement("INSERT INTO cart_item (userID, itemID, quantity, added_date) VALUES (?, ?, ?, CURRENT_DATE)");
                for(CartItem item : cartItems) {
                    pstInsert.setInt(1, userID);
                    pstInsert.setInt(2, item.getItemId());
                    pstInsert.setString(3, String.valueOf(item.getQuantity()));
                    pstInsert.addBatch();
                }
                pstInsert.executeBatch();
            }
            out.print("{\"status\":\"synced\"}");
        } catch(Exception e) {
            out.print("{\"status\":\"error\"}");
        } finally {
            if(pstClear!=null)try{pstClear.close();}catch(Exception e){}
            if(pstInsert!=null)try{pstInsert.close();}catch(Exception e){}
            if(con!=null)try{con.close();}catch(Exception e){}
        }
    } else {
        out.print("{\"status\":\"ignored\"}");
    }
%>
