package Grocery_Ordering_System;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateServlet")
public class EditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String itemID = request.getParameter("itemID");
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String quantity = request.getParameter("quantity");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        
        try {
            // Validate input parameters
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Name cannot be empty");
            }
            
            if (price == null || price.trim().isEmpty()) {
                throw new IllegalArgumentException("Price cannot be empty");
            }
            
            if (quantity == null || quantity.trim().isEmpty()) {
                throw new IllegalArgumentException("Quantity cannot be empty");
            }
            
            // Update the item
            boolean isUpdated = itemControl.updateItem(itemID, name, price, quantity, category, description);
            
            if(isUpdated) {
                response.getWriter().println("<script>alert('Item updated successfully'); window.location.href='ItemServlet'</script>");
            } else {
                request.setAttribute("errorMessage", "Failed to update item. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating item: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
            dispatcher.forward(request, response);
        }
    }
}