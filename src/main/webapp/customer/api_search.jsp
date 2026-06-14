<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String queryParam = request.getParameter("q");
    
    // Default empty JSON array response
    StringBuilder jsonResponse = new StringBuilder("[");
    
    if (queryParam != null && !queryParam.trim().isEmpty()) {
        Connection con = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            String url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres"; 
            String user = "postgres";
            String pass = "1syERFX5ObrpQ5qR"; 
            Class.forName("org.postgresql.Driver"); 
            con = DriverManager.getConnection(url, user, pass); 
            
            // ILIKE is PostgreSQL's case-insensitive LIKE
            String sql = "SELECT * FROM item WHERE name ILIKE ? AND quantity > '0' LIMIT 5";
            pst = con.prepareStatement(sql);
            pst.setString(1, "%" + queryParam.trim() + "%");
            rs = pst.executeQuery();
            
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    jsonResponse.append(",");
                }
                
                int id = rs.getInt("itemID");
                String name = rs.getString("name").replace("\"", "\\\"").replace("\\", "\\\\");
                String price = rs.getString("price");
                String category = rs.getString("category").replace("\"", "\\\"").replace("\\", "\\\\");
                
                jsonResponse.append("{")
                            .append("\"id\":").append(id).append(",")
                            .append("\"name\":\"").append(name).append("\",")
                            .append("\"price\":\"").append(price).append("\",")
                            .append("\"category\":\"").append(category).append("\"")
                            .append("}");
                first = false;
            }
        } catch (Exception e) {
            // Ignore for API, it will return valid JSON array or partial array (or we can handle it better, but empty is safe)
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e){}
            if(pst != null) try { pst.close(); } catch(Exception e){}
            if(con != null) try { con.close(); } catch(Exception e){}
        }
    }
    
    jsonResponse.append("]");
    out.print(jsonResponse.toString());
%>
