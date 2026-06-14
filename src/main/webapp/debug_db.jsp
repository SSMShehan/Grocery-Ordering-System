<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <%@ page import="Util_Package.DBconnection" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>DB Debug</title>
            </head>

            <body>
                <h2>Database Diagnostic</h2>
                <% Connection con=null; try { con=DBconnection.getConnection(); out.println("<p style='color:green'>
                    <b>Connection Successful!</b></p>");

                    String sql = "SELECT category, COUNT(*) as count FROM item GROUP BY category";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    out.println("<h3>Item Counts by Category:</h3>");
                    out.println("<table border='1'>
                        <tr>
                            <th>Category</th>
                            <th>Count</th>
                        </tr>");
                        boolean hasData = false;
                        while(rs.next()) {
                        hasData = true;
                        out.println("<tr>");
                            out.println("<td>" + rs.getString("category") + "</td>");
                            out.println("<td>" + rs.getInt("count") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("
                    </table>");

                    if (!hasData) {
                    out.println("<p style='color:red'><b>No items found in 'item' table!</b></p>");
                    }

                    } catch (Exception e) {
                    out.println("<p style='color:red'><b>Connection/Query Failed:</b> " + e.getMessage() + "</p>");
                    e.printStackTrace(new java.io.PrintWriter(out));
                    } finally {
                    if (con != null) try { con.close(); } catch (Exception e) {}
                    }
                    %>
            </body>

            </html>