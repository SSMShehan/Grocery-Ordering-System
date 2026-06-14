<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, Model_Package.CartItem" %>
<%
    Integer userID = (Integer) session.getAttribute("userID");
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
    
    if (userID == null || cartItems == null || cartItems.isEmpty()) {
        response.sendRedirect("cart.jsp?error=Invalid session");
        return;
    }
    
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String province = request.getParameter("province");
    String zipcode = request.getParameter("zipcode");
    String totalStr = request.getParameter("total");
    
    Connection con = null;
    PreparedStatement pstOrder = null;
    PreparedStatement pstOrderItem = null;
    PreparedStatement pstInventory = null;
    PreparedStatement pstClearCartDB = null;
    ResultSet rsKeys = null;
    
    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
        con.setAutoCommit(false); // Begin Transaction
        
        // 1. Insert Order
        String insertOrderSQL = "INSERT INTO \"order\" (\"cusID\", \"order_date\", \"amount\", \"order_status\", \"delivery_address\", \"delivery_city\", \"delivery_province\", \"delivery_zipcode\") VALUES (?, CURRENT_DATE, ?, 'In Progress', ?, ?, ?, ?)";
        pstOrder = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
        pstOrder.setInt(1, userID); // Assuming userID maps to cusID
        pstOrder.setString(2, totalStr);
        pstOrder.setString(3, address);
        pstOrder.setString(4, city);
        pstOrder.setString(5, province);
        pstOrder.setString(6, zipcode);
        pstOrder.executeUpdate();
        
        int orderID = -1;
        rsKeys = pstOrder.getGeneratedKeys();
        if (rsKeys.next()) {
            orderID = rsKeys.getInt(1);
        } else {
            throw new Exception("Order creation failed, no ID obtained.");
        }
        
        // Delivery slot insertion removed as per user request
        
        // 2. Process Cart Items (Insert to order_item & Deduct Inventory)
        String insertOrderItemSQL = "INSERT INTO order_item (\"orderID\", \"itemID\", \"quantity\", \"price\") VALUES (?, ?, ?, ?)";
        String updateInventorySQL = "UPDATE item SET quantity = CAST((CAST(quantity AS INT) - ?) AS VARCHAR) WHERE \"itemID\" = ?";
        
        pstOrderItem = con.prepareStatement(insertOrderItemSQL);
        pstInventory = con.prepareStatement(updateInventorySQL);
        
        for (CartItem item : cartItems) {
            // Insert Order Item
            pstOrderItem.setInt(1, orderID);
            pstOrderItem.setInt(2, item.getItemId());
            pstOrderItem.setString(3, String.valueOf(item.getQuantity()));
            pstOrderItem.setString(4, String.valueOf(item.getItemPrice()));
            pstOrderItem.addBatch();
            
            // Deduct Inventory
            pstInventory.setInt(1, item.getQuantity());
            pstInventory.setInt(2, item.getItemId());
            pstInventory.addBatch();
        }
        
        pstOrderItem.executeBatch();
        pstInventory.executeBatch();
        
        // 3. Clear DB Cart
        pstClearCartDB = con.prepareStatement("DELETE FROM cart_item WHERE \"userID\" = ?");
        pstClearCartDB.setInt(1, userID);
        pstClearCartDB.executeUpdate();
        
        // Commit Transaction
        con.commit();
        
        // 4. Clear Session Cart
        session.removeAttribute("cart");
        
        // 5. Forward to Success
        request.getRequestDispatcher("orderConfirmation.jsp?orderID=" + orderID).forward(request, response);
        
    } catch(Exception e) {
        if (con != null) try { con.rollback(); } catch(Exception ex){}
        e.printStackTrace();
        response.sendRedirect("checkout.jsp?error=Order failed: " + e.getMessage());
    } finally {
        if (rsKeys != null) try { rsKeys.close(); } catch(Exception e){}
        if (pstOrder != null) try { pstOrder.close(); } catch(Exception e){}
        if (pstOrderItem != null) try { pstOrderItem.close(); } catch(Exception e){}
        if (pstInventory != null) try { pstInventory.close(); } catch(Exception e){}
        if (pstClearCartDB != null) try { pstClearCartDB.close(); } catch(Exception e){}
        if (con != null) {
            try { con.setAutoCommit(true); } catch(Exception e){}
            try { con.close(); } catch(Exception e){}
        }
    }
%>
