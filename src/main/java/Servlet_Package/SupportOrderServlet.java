package Servlet_Package;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.SupportOrderControl;
import Model_Package.SupportOrderModel;

@WebServlet("/SupportAgent/SupportOrderServlet")
public class SupportOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<SupportOrderModel> allOrders = SupportOrderControl.getAllOrders();
            request.setAttribute("allOrders", allOrders);
            RequestDispatcher dispatcher = request.getRequestDispatcher("support_order.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading orders: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("support_order.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}