package Servlet_Package;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model_Package.CartItem;

/**
 * Redesigned CartControllerServlet
 * - Handles displaying the cart
 * - Calculates totals robustly
 * - Handles session-based cart
 */
@WebServlet({ "/customer/ViewCart", "/ViewCart" })
public class CartControllerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CartControllerServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== CartControllerServlet: Viewing Cart ===");
        HttpSession session = request.getSession();

        try {
            // Get from session
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

            if (cartItems == null) {
                System.out.println("No session cart found - creating empty list");
                cartItems = new ArrayList<>();
                session.setAttribute("cart", cartItems);
            }

            System.out.println("Found " + cartItems.size() + " items in SESSION cart");

            // Calculate totals safely
            double subtotal = 0.0;
            for (CartItem item : cartItems) {
                subtotal += (item.getItemPrice() * item.getQuantity());
            }

            // Calculations
            double tax = subtotal * 0.10; // 10% tax
            double deliveryFee = subtotal > 0 ? 150.00 : 0.0; // Fee only if items exist
            double total = subtotal + tax + deliveryFee;

            // Set attributes for JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", String.format("%.2f", subtotal)); // 2 decimal places
            request.setAttribute("tax", String.format("%.2f", tax));
            request.setAttribute("deliveryFee", String.format("%.2f", deliveryFee));
            request.setAttribute("total", String.format("%.2f", total));

            System.out.println("Calculated Totals -> Sub: " + subtotal + ", Tax: " + tax + ", Total: " + total);

            // Forward to JSP
            request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in CartControllerServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading cart: " + e.getMessage());
            request.getRequestDispatcher("/customer/error.jsp").forward(request, response);
        }
    }

    // Support POST as well (redirect to GET)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}