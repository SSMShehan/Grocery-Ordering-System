package Servlet_Package;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.SupportCustomerControl;
import Model_Package.SupportCustomerModel;

@WebServlet("/SupportAgent/SupportCustomerServlet")
public class SupportCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<SupportCustomerModel> allCustomers = SupportCustomerControl.getAllCustomers();
            request.setAttribute("allCustomers", allCustomers);
            RequestDispatcher dispatcher = request.getRequestDispatcher("support_customer.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading customers: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("support_customer.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}