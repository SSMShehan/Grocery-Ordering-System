package Servlet_Package;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.ItemDAO;

/**
 * Redesigned EditServlet
 * - Explicit ID validation
 * - Update feedback loop
 */
@WebServlet({ "/UpdateServlet", "/EditItem" })
public class EditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO = new ItemDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== EditServlet: Updating Item ===");

        String itemID = request.getParameter("itemID");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String quantity = request.getParameter("quantity");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        try {
            if (isEmpty(itemID)) {
                throw new IllegalArgumentException("Item ID is missing.");
            }

            if (isEmpty(name) || isEmpty(price) || isEmpty(quantity)) {
                throw new IllegalArgumentException("Name, Price, and Quantity are required.");
            }

            // Validate numbers formatting check if needed, but ItemDAO handles it as
            // Strings mostly in this legacy DB schema

            boolean updated = itemDAO.updateItem(itemID, name, price, quantity, category, description);

            if (updated) {
                System.out.println("Update successful for Item ID: " + itemID);
                response.sendRedirect("ItemServlet?success=Item+Updated+Successfully");
            } else {
                handleError(request, response, "Failed to update item record.");
            }

        } catch (Exception e) {
            System.err.println("Update Error: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Error updating item: " + e.getMessage());
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", msg);
        // Assuming item.jsp or edit_item.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
        dispatcher.forward(request, response);
    }
}