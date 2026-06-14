package Servlet_Package;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model_Package.CartItem;

/**
 * Redesigned RemoveCartItemServlet
 * - Cleanly removes items from session cart
 * - Handles potential errors gracefully
 */
@WebServlet({ "/customer/RemoveCartItemServlet", "/RemoveCartItemServlet" })
public class RemoveCartItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RemoveCartItemServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== RemoveCartItemServlet: Processing Request ===");
        HttpSession session = request.getSession();

        try {
            String itemIdStr = request.getParameter("itemId");
            System.out.println("Request to remove Item ID: " + itemIdStr);

            if (itemIdStr != null && !itemIdStr.isEmpty()) {
                int itemId = Integer.parseInt(itemIdStr);

                synchronized (session) {
                    @SuppressWarnings("unchecked")
                    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

                    if (cartItems != null) {
                        boolean removed = false;
                        Iterator<CartItem> iterator = cartItems.iterator();
                        while (iterator.hasNext()) {
                            CartItem item = iterator.next();
                            if (item.getItemId() == itemId) {
                                iterator.remove();
                                removed = true;
                                break;
                            }
                        }

                        if (removed) {
                            System.out.println("Successfully removed Item ID: " + itemId);
                            session.setAttribute("cart", cartItems); // Update session
                        } else {
                            System.out.println("Item ID " + itemId + " not found in cart.");
                        }
                    } else {
                        System.out.println("Cart is empty/null, nothing to remove.");
                    }
                }
            } else {
                System.err.println("Invalid or missing itemId parameter.");
            }

            // Redirect back to cart page
            response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");

        } catch (Exception e) {
            System.err.println("Error removing item: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/error.jsp");
        }
    }
}