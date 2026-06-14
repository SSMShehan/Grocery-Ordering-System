package Control_Package;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Model_Package.Item;

public class ItemDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ItemDetailsServlet: Request received.");

        String idStr = request.getParameter("id");
        System.out.println("ItemDetailsServlet: ID parameter = " + idStr);

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int itemId = Integer.parseInt(idStr);

                // Create DAO per request to ensure fresh connection handling
                ItemDAO itemDAO = new ItemDAO();
                Item item = itemDAO.getItemById(itemId);

                if (item != null) {
                    System.out.println("ItemDetailsServlet: Item found: " + item.getName());
                    request.setAttribute("item", item);
                    request.getRequestDispatcher("/customer/item_details.jsp").forward(request, response);
                } else {
                    System.out.println("ItemDetailsServlet: Item not found.");
                    response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
                }

            } catch (NumberFormatException e) {
                System.out.println("ItemDetailsServlet: Invalid ID format.");
                response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
            }
        } else {
            System.out.println("ItemDetailsServlet: No ID provided.");
            response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
        }
    }
}
