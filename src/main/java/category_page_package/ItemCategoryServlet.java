package category_page_package;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model_Package.Item;
import Util_Package.DBconnection;

public class ItemCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        List<Item> itemList = new ArrayList<>();

        System.out.println("ItemCategoryServlet: Request received for category: " + category);

        if (category != null && !category.isEmpty()) {
            try {
                Connection con = DBconnection.getConnection();

                String sql = "SELECT * FROM item WHERE category = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, category);

                System.out.println("Executing SQL: " + ps.toString());

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Item item = new Item();
                    item.setItemID(rs.getInt("itemID"));
                    item.setName(rs.getString("name"));
                    item.setPrice(rs.getString("price"));
                    item.setQuantity(rs.getString("quantity"));
                    item.setCategory(rs.getString("category"));
                    item.setDescription(rs.getString("description"));

                    // I'll add attributes to the Item class later, but for now I can just set a dynamic attribute or use a Map?
                    // Actually, modifying Item.java is safer. Let's modify Item.java first.
                    int discount = rs.getInt("discount_percentage");
                    item.setDiscount(discount);
                    double price = Double.parseDouble(rs.getString("price"));
                    item.setDealPrice(String.format("%.2f", price - (price * discount / 100.0)));

                    itemList.add(item);
                }

                System.out.println("Found " + itemList.size() + " items for category: " + category);

            } catch (Exception e) {
                System.out.println("Error fetching items: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("No category specified.");
        }

        request.setAttribute("itemList", itemList);
        request.setAttribute("categoryName", category);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/customer/category.jsp");
        dispatcher.forward(request, response);
    }
}
