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
 * Redesigned CheckoutServlet
 * - Prepares cart data for checkout page
 * - Calculates final totals
 */
@WebServlet("/customer/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CheckoutServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== CheckoutServlet: Initiating Checkout ===");
        HttpSession session = request.getSession();

        try {
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

            if (cartItems == null || cartItems.isEmpty()) {
                // Cannot checkout empty cart
                System.out.println("Cart is empty, redirecting to shop.");
                response.sendRedirect(request.getContextPath() + "/customer/index.jsp");
                return;
            }

            // Recalculate Totals (Single Source of Truth)
            double subtotal = 0.0;
            for (CartItem item : cartItems) {
                subtotal += (item.getItemPrice() * item.getQuantity());
            }

            double tax = subtotal * 0.10;
            double delivery = 150.00;
            double total = subtotal + tax + delivery;

            // Set attributes for Checkout JSP
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", String.format("%.2f", subtotal));
            request.setAttribute("tax", String.format("%.2f", tax));
            request.setAttribute("deliveryFee", String.format("%.2f", delivery));
            request.setAttribute("total", String.format("%.2f", total));

            System.out.println("Checkout Totals -> Total: " + total);

            // Forward to Checkout Page
            request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in CheckoutServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error during checkout: " + e.getMessage());
            request.getRequestDispatcher("/customer/error.jsp").forward(request, response);
        }
    }
}