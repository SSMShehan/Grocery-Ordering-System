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
 * Redesigned InsertServlet
 * - Robust input validation
 * - Clearer error reporting
 * - Uses ItemServlet for listing
 */
@WebServlet({ "/InsertServlet", "/AddItem" })
public class InsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO = new ItemDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== InsertServlet: Adding New Item ===");

        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String quantity = request.getParameter("quantity");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        try {
            // Validation
            if (isEmpty(name) || isEmpty(price) || isEmpty(quantity)) {
                throw new IllegalArgumentException("Fields Name, Price, and Quantity are required.");
            }

            // Attempt Insert
            boolean success = itemDAO.insertItem(name, price, quantity, category, description);

            if (success) {
                System.out.println("Insert successful for: " + name);
                // Redirect to list page with success flag
                response.sendRedirect("ItemServlet?success=Item+Added+Successfully");
            } else {
                handleError(request, response, "Failed to insert item into database.");
            }

        } catch (IllegalArgumentException e) {
            handleError(request, response, "Validation Error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Insert Error: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "System Error: " + e.getMessage());
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", msg);
        // Forwarding back to input page (assuming item.jsp or add_item.jsp)
        RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
        dispatcher.forward(request, response);
    }
}