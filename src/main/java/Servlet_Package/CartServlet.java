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

import Control_Package.ItemDAO;
import Model_Package.CartItem;
import Model_Package.Item;

/**
 * Redesigned CartServlet
 * - Fetches item details from DB to ensure data integrity
 * - Handles price parsing robustly
 * - Debug logging included
 */
@WebServlet("/customer/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CartServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Setup
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        System.out.println("=== CartServlet: Processing Add to Cart Request ===");

        // 2. Parse Parameters
        int itemId = -1;
        int quantity = 1;

        try {
            String itemIdStr = request.getParameter("itemId");
            String quantityStr = request.getParameter("quantity");

            System.out.println("Raw Parameters -> itemId: " + itemIdStr + ", quantity: " + quantityStr);

            if (itemIdStr != null && !itemIdStr.isEmpty()) {
                itemId = Integer.parseInt(itemIdStr);
            }
            if (quantityStr != null && !quantityStr.isEmpty()) {
                quantity = Integer.parseInt(quantityStr);
            }
        } catch (NumberFormatException e) {
            System.err.println("Error parsing parameters: " + e.getMessage());
            e.printStackTrace();
            // Redirect with error or handle gracefully
            response.sendRedirect(request.getContextPath() + "/customer/error.jsp");
            return;
        }

        if (itemId == -1) {
            System.err.println("Invalid Item ID received.");
            response.sendRedirect(request.getContextPath() + "/customer/error.jsp");
            return;
        }

        // 3. Fetch Item from Database (Source of Truth)
        ItemDAO itemDAO = new ItemDAO();
        Item dbItem = itemDAO.getItemById(itemId);

        String finalItemName = "Unknown Item";
        double finalItemPrice = 0.0;
        String finalItemDesc = "";

        if (dbItem != null) {
            // Success: Found in DB
            finalItemName = dbItem.getName();
            finalItemDesc = dbItem.getDescription();
            String dbPriceStr = dbItem.getDealPrice() != null ? dbItem.getDealPrice() : dbItem.getPrice();

            System.out.println("DB Lookup Success -> Name: " + finalItemName + ", Deal Price: " + dbPriceStr);

            // Parse Price Safely
            finalItemPrice = parsePrice(dbPriceStr);
            System.out.println("Parsed Price: " + finalItemPrice);

        } else {
            // Failure: Not found in DB (fallback to params or skip)
            System.err.println("Item not found in database for ID: " + itemId);
            // Fallback to request params if available (legacy support)
            finalItemName = request.getParameter("itemName");
            if (finalItemName == null)
                finalItemName = "Item " + itemId;

            finalItemDesc = request.getParameter("itemDescription");

            String paramPrice = request.getParameter("itemPrice");
            finalItemPrice = parsePrice(paramPrice);

            System.out.println("Using Fallback Values -> Name: " + finalItemName + ", Price: " + finalItemPrice);
        }

        // 4. Update Session Cart
        synchronized (session) {
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
            if (cartItems == null) {
                cartItems = new ArrayList<>();
            }

            boolean itemExists = false;
            for (CartItem existing : cartItems) {
                if (existing.getItemId() == itemId) {
                    // Update existing
                    int newQty = existing.getQuantity() + quantity;
                    existing.setQuantity(newQty);
                    // Always update price to latest from DB
                    existing.setItemPrice(finalItemPrice);
                    itemExists = true;
                    System.out.println("Updated existing item quantity to: " + newQty);
                    break;
                }
            }

            if (!itemExists) {
                // Add new
                CartItem newItem = new CartItem();
                newItem.setItemId(itemId);
                newItem.setCartItemId(itemId); // temporary ID
                newItem.setUserId(0); // guest
                newItem.setQuantity(quantity);
                newItem.setItemName(finalItemName);
                newItem.setItemPrice(finalItemPrice);
                newItem.setItemDescription(finalItemDesc);

                cartItems.add(newItem);
                System.out.println("Added new item to cart.");
            }

            session.setAttribute("cart", cartItems);
            System.out.println("Cart Size is now: " + cartItems.size());
        }

        // 5. Redirect User
        response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");
    }

    /**
     * Helper to robustly parse price string to double.
     * Handles "Rs. 100", "100.00", "1,000", null, etc.
     */
    private double parsePrice(String priceStr) {
        if (priceStr == null || priceStr.trim().isEmpty()) {
            return 0.0;
        }
        try {
            // Remove everything except digits and decimal point
            String cleanPrice = priceStr.replaceAll("[^\\d.]", "");
            // Handle cases like "1,000" -> "1000" if comma wasn't removed (though regex
            // above removes commas)
            // If regex removed commas, we are good.

            // Edge case: Multiple dots? (e.g. 1.0.0) - logic below takes standard doubles
            return Double.parseDouble(cleanPrice);
        } catch (NumberFormatException e) {
            System.err.println("Failed to parse price string: '" + priceStr + "'");
            return 0.0;
        }
    }
}