package Servlet_Package;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.OrderDAO;

@WebServlet("/customer/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public PlaceOrderServlet() {
        super();
        orderDAO = new OrderDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get form data
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String province = request.getParameter("province");
            String zipcode = request.getParameter("zipcode");
            String paymentMethod = request.getParameter("paymentMethod");
            String totalStr = request.getParameter("total");
            if (totalStr == null || totalStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/cart.jsp");
                return;
            }
            double total = Double.parseDouble(totalStr);
            
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("address", address);
            request.setAttribute("city", city);
            request.setAttribute("province", province);
            request.setAttribute("zipcode", zipcode);
            request.setAttribute("paymentMethod", paymentMethod);
            request.setAttribute("subtotal", request.getParameter("subtotal"));
            request.setAttribute("tax", request.getParameter("tax"));
            request.setAttribute("deliveryFee", request.getParameter("deliveryFee"));
            request.setAttribute("total", request.getParameter("total"));
            
            request.getRequestDispatcher("/customer/PaymentGateway.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error placing order: " + e.getMessage());
            request.getRequestDispatcher("/customer/error.jsp").forward(request, response);
        }
    }
}