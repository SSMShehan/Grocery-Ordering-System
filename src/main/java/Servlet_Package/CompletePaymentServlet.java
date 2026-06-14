package Servlet_Package;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Control_Package.OrderDAO;
import Model_Package.CartItem;

@WebServlet("/customer/checkout/CompletePaymentServlet")
public class CompletePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public CompletePaymentServlet() {
        super();
        orderDAO = new OrderDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            // 1. Get User ID (Assuming logged in, fallback to 0 or temporary logic if
            // guest)
            Object userIdObj = session.getAttribute("userId");
            int userId = (userIdObj != null) ? (Integer) userIdObj : 0; // 0 for Guest/Anonymous

            // 2. Get Cart Items
            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");

            if (cartItems == null || cartItems.isEmpty()) {
                throw new Exception("Cart is empty");
            }

            // 3. Get Payment Details
            String address = request.getParameter("address");
            double total = Double.parseDouble(request.getParameter("total"));

            // 4. Save to Database
            // Note: If userId is 0 (Guest), you might want to create a Customer record
            // first like before.
            // For now, we assume logged-in user functionality as requested for "User
            // Profile".
            boolean success = orderDAO.saveOrder(userId, total, address, cartItems);

            if (success) {
                // 5. Clear Cart
                session.removeAttribute("cart");

                // 6. Redirect to confirmation
                // Pass details for receipt display
                String redirectUrl = request.getContextPath() + "/customer/orderConfirmation.jsp" +
                        "?total=" + total +
                        "&email=" + request.getParameter("email") +
                        "&address=" + java.net.URLEncoder.encode(address, "UTF-8") +
                        "&paymentMethod=" + request.getParameter("paymentMethod");

                response.sendRedirect(redirectUrl);
            } else {
                throw new Exception("Database insertion failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error completing payment: " + e.getMessage());
            request.getRequestDispatcher("/customer/error.jsp").forward(request, response);
        }
    }
}