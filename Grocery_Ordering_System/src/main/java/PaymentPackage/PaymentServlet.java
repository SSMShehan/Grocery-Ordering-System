// PaymentServlet.java
package PaymentPackage;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import CustomerPackage.CustomerModel;
import OrderPackage.OrderModel;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        
        try {
            if (action != null) {
                switch (action) {
                    case "delete":
                        deletePayment(request, response);
                        break;
                    default:
                        listPayments(request, response);
                }
            } else {
                listPayments(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<PaymentModel> allPayments = PaymentControl.getAllPayments();
            List<CustomerModel> allCustomers = PaymentControl.getAllCustomers();
            List<OrderModel> allOrders = PaymentControl.getAllOrders();
            
            request.setAttribute("allPayments", allPayments);
            request.setAttribute("allCustomers", allCustomers);
            request.setAttribute("allOrders", allOrders);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading payments: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void deletePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String paymentID = request.getParameter("paymentID");
            boolean success = PaymentControl.deletePayment(paymentID);
            
            if (success) {
                request.setAttribute("successMessage", "Payment deleted successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to delete payment.");
            }
            listPayments(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting payment: " + e.getMessage());
            listPayments(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}