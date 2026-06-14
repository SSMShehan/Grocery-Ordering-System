package Servlet_Package;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model_Package.CartItem;

/**
 * Redesigned UpdateCartItemServlet
 * - Handles Quantity updates for Session Cart
 * - Replaces old DB-only logic
 */
@WebServlet({ "/customer/UpdateCartItemServlet", "/UpdateCartItemServlet" })
public class UpdateCartItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== UpdateCartItemServlet: Processing Request ===");
        HttpSession session = request.getSession();

        try {
            int itemId = Integer.parseInt(request.getParameter("cartItemId")); // Using itemId actually
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            System.out.println("Updating Item ID: " + itemId + " to Quantity: " + quantity);

            if (quantity < 1) {
                // Should probably remove, but let's keep at 1 or handle removal separately
                quantity = 1;
            }

            synchronized (session) {
                @SuppressWarnings("unchecked")
                List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

                boolean updated = false;
                if (cartItems != null) {
                    for (CartItem item : cartItems) {
                        if (item.getItemId() == itemId) { // Matching by ItemID
                            item.setQuantity(quantity);
                            updated = true;
                            // Also update individual total if needed (not persisted property usually)
                            break;
                        }
                    }
                }

                if (updated) {
                    session.setAttribute("cart", cartItems);
                    System.out.println("Quantity updated successfully.");
                } else {
                    System.out.println("Item not found to update.");
                }
            }

            // Redirect back to cart
            response.sendRedirect(request.getContextPath() + "/customer/ViewCart");

        } catch (Exception e) {
            System.err.println("Error updating cart: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/error.jsp");
        }
    }
}