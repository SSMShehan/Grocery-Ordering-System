package Servlet_Package;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.SupportOrderControl;
import Model_Package.SupportOrderModel;

@WebServlet("/SupportAgent/SupportOrderViewServlet")
public class SupportOrderViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderID = request.getParameter("orderID");
        
        try {
            SupportOrderModel order = SupportOrderControl.getOrderById(orderID);
            if (order != null) {
                request.setAttribute("order", order);
                RequestDispatcher dispatcher = request.getRequestDispatcher("support_order_view.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Order not found");
                RequestDispatcher dispatcher = request.getRequestDispatcher("SupportOrderServlet");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading order details: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("SupportOrderServlet");
            dispatcher.forward(request, response);
        }
    }
}