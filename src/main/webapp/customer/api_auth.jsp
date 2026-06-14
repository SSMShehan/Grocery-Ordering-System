<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String action = request.getParameter("action");
    
    String url = "jdbc:postgresql://db.mupdoceejdvgqkoqnsst.supabase.co:5432/postgres";
    String dbUser = "postgres";
    String dbPass = "1syERFX5ObrpQ5qR";
    
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection(url, dbUser, dbPass);
        
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            
            // Check if email exists
            pst = con.prepareStatement("SELECT * FROM \"user\" WHERE email = ?");
            pst.setString(1, email);
            rs = pst.executeQuery();
            if (rs.next()) {
                response.sendRedirect("register.jsp?error=Email already exists");
                return;
            }
            
            // Insert new user
            pst = con.prepareStatement("INSERT INTO \"user\" (username, email, phone, password, register_date, role, status) VALUES (?, ?, ?, ?, CURRENT_DATE, 'customer', 'Active')");
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, password); // Note: In production, hash this!
            int row = pst.executeUpdate();
            
            if (row > 0) {
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("register.jsp?error=Registration failed");
            }
            
        } else if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            pst = con.prepareStatement("SELECT * FROM \"user\" WHERE (email = ? OR username = ?) AND password = ?");
            pst.setString(1, email);
            pst.setString(2, email);
            pst.setString(3, password);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                int userID = rs.getInt("userID");
                String username = rs.getString("username");
                String role = rs.getString("role");
                
                session.setAttribute("userID", userID);
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                
                if("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("../admin_dashboard.jsp"); // Basic redirect for admin
                    return;
                }
                
                // --- MERGE WISHLIST ---
                Set<String> sessionWishlist = (Set<String>) session.getAttribute("wishlist");
                if (sessionWishlist != null && !sessionWishlist.isEmpty()) {
                    PreparedStatement mergePst = con.prepareStatement("INSERT INTO wishlist_item (userid, itemid) SELECT ?, ? WHERE NOT EXISTS (SELECT 1 FROM wishlist_item WHERE userid=? AND itemid=?)");
                    for(String wId : sessionWishlist) {
                        mergePst.setInt(1, userID);
                        mergePst.setInt(2, Integer.parseInt(wId));
                        mergePst.setInt(3, userID);
                        mergePst.setInt(4, Integer.parseInt(wId));
                        mergePst.executeUpdate();
                    }
                    mergePst.close();
                }
                
                // Now load combined wishlist back to session for fast UI access
                PreparedStatement loadWish = con.prepareStatement("SELECT itemid FROM wishlist_item WHERE userid = ?");
                loadWish.setInt(1, userID);
                ResultSet rsWish = loadWish.executeQuery();
                Set<String> newSessionWish = new HashSet<>();
                while(rsWish.next()) {
                    newSessionWish.add(String.valueOf(rsWish.getInt("itemid")));
                }
                session.setAttribute("wishlist", newSessionWish);
                rsWish.close();
                loadWish.close();

                // --- MERGE CART ---
                PreparedStatement loadCart = con.prepareStatement("SELECT ci.\"cart_itemID\", ci.\"itemID\", ci.quantity, i.name, i.price, i.description FROM cart_item ci JOIN item i ON ci.\"itemID\" = i.\"itemID\" WHERE ci.\"userID\" = ?");
                loadCart.setInt(1, userID);
                ResultSet rsCart = loadCart.executeQuery();
                List<Model_Package.CartItem> sessionCart = (List<Model_Package.CartItem>) session.getAttribute("cart");
                if(sessionCart == null) {
                    sessionCart = new ArrayList<>();
                }
                while(rsCart.next()) {
                    int c_itemID = rsCart.getInt("itemID");
                    boolean exists = false;
                    for(Model_Package.CartItem c : sessionCart) {
                        if(c.getItemId() == c_itemID) { exists = true; break; }
                    }
                    if(!exists) {
                        Model_Package.CartItem newItem = new Model_Package.CartItem();
                        newItem.setItemId(c_itemID);
                        newItem.setCartItemId(rsCart.getInt("cart_itemID"));
                        newItem.setQuantity(rsCart.getInt("quantity"));
                        newItem.setItemName(rsCart.getString("name"));
                        try {
                            String p = rsCart.getString("price").replaceAll("[^\\d.]", "");
                            newItem.setItemPrice(Double.parseDouble(p));
                        } catch(Exception e){}
                        newItem.setItemDescription(rsCart.getString("description"));
                        sessionCart.add(newItem);
                    }
                }
                session.setAttribute("cart", sessionCart);
                rsCart.close(); loadCart.close();
                
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.jsp?error=Invalid email or password");
            }
            
        } else if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("index.jsp");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=System error: " + e.getMessage());
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e){}
        if(pst != null) try { pst.close(); } catch(Exception e){}
        if(con != null) try { con.close(); } catch(Exception e){}
    }
%>
