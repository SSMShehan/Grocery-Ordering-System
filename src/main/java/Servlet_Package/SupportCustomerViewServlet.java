package Servlet_Package;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.SupportCustomerControl;
import Model_Package.SupportCustomerModel;

@WebServlet("/SupportCustomerViewServlet")
public class SupportCustomerViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String cusID = request.getParameter("cusID");
        
        try {
            SupportCustomerModel customer = SupportCustomerControl.getCustomerById(cusID);
            if (customer != null) {
                request.setAttribute("customer", customer);
                RequestDispatcher dispatcher = request.getRequestDispatcher("support_customer_view.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Customer not found");
                RequestDispatcher dispatcher = request.getRequestDispatcher("SupportCustomerServlet");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading customer details: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("SupportCustomerServlet");
            dispatcher.forward(request, response);
        }
    }
}