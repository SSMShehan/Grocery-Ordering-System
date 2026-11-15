<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*" %>
<%
    // Initialize wishlist session if it doesn't exist
    Set<String> wishlist = (Set<String>) session.getAttribute("wishlist");
    if (wishlist == null) {
        wishlist = new HashSet<String>();
        session.setAttribute("wishlist", wishlist);
    }

    String action = request.getParameter("action");
    String itemId = request.getParameter("id");
    
    // JSON builder
    StringBuilder json = new StringBuilder("{");

    if ("add".equalsIgnoreCase(action) && itemId != null && !itemId.isEmpty()) {
        wishlist.add(itemId);
        
        // Sync to Database if logged in
        Integer userID = (Integer) session.getAttribute("userID");
        if (userID != null) {
            Connection con = null; PreparedStatement pst = null;
            try {
                Class.forName("org.postgresql.Driver");
                con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
                pst = con.prepareStatement("INSERT INTO wishlist_item (userID, itemID) SELECT ?, ? WHERE NOT EXISTS (SELECT 1 FROM wishlist_item WHERE userID=? AND itemID=?)");
                pst.setInt(1, userID); pst.setInt(2, Integer.parseInt(itemId));
                pst.setInt(3, userID); pst.setInt(4, Integer.parseInt(itemId));
                pst.executeUpdate();
            } catch(Exception e){} finally {
                if(pst!=null)try{pst.close();}catch(Exception e){}
                if(con!=null)try{con.close();}catch(Exception e){}
            }
        }
        
        json.append("\"status\":\"success\", \"message\":\"Added to wishlist\", ");
    } else if ("remove".equalsIgnoreCase(action) && itemId != null && !itemId.isEmpty()) {
        wishlist.remove(itemId);
        
        // Sync to Database if logged in
        Integer userID = (Integer) session.getAttribute("userID");
        if (userID != null) {
            Connection con = null; PreparedStatement pst = null;
            try {
                Class.forName("org.postgresql.Driver");
                con = DriverManager.getConnection("jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres", "postgres", "1syERFX5ObrpQ5qR");
                pst = con.prepareStatement("DELETE FROM wishlist_item WHERE userID=? AND itemID=?");
                pst.setInt(1, userID); pst.setInt(2, Integer.parseInt(itemId));
                pst.executeUpdate();
            } catch(Exception e){} finally {
                if(pst!=null)try{pst.close();}catch(Exception e){}
                if(con!=null)try{con.close();}catch(Exception e){}
            }
        }
        
        json.append("\"status\":\"success\", \"message\":\"Removed from wishlist\", ");
    } else if ("check".equalsIgnoreCase(action) && itemId != null && !itemId.isEmpty()) {
        boolean exists = wishlist.contains(itemId);
        json.append("\"exists\":").append(exists).append(", ");
    } else if (!"count".equalsIgnoreCase(action)) {
        json.append("\"status\":\"error\", \"message\":\"Invalid action\", ");
    }
    
    // Always return the count
    json.append("\"count\":").append(wishlist.size());
    json.append("}");
    
    out.print(json.toString());
%>
