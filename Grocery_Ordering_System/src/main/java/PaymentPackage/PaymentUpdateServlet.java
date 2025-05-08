// PaymentUpdateServlet.java
package PaymentPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/PaymentUpdateServlet")
public class PaymentUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String paymentID = request.getParameter("paymentID");
        String orderID = request.getParameter("orderID");
        String cusID = request.getParameter("cusID");
        String amount = request.getParameter("amount");
        String paydate = request.getParameter("paydate");
        String paymethod = request.getParameter("paymethod");
        String payment_status = request.getParameter("payment_status");
        
        try {
            // Validate input parameters
            if (orderID == null || orderID.trim().isEmpty()) {
                throw new IllegalArgumentException("Order cannot be empty");
            }
            
            if (cusID == null || cusID.trim().isEmpty()) {
                throw new IllegalArgumentException("Customer cannot be empty");
            }
            
            if (amount == null || amount.trim().isEmpty()) {
                throw new IllegalArgumentException("Amount cannot be empty");
            }
            
            // Update the payment
            boolean isUpdated = PaymentControl.updatePayment(
                paymentID, 
                orderID, 
                cusID, 
                amount, 
                paydate, 
                paymethod, 
                payment_status
            );
            
            if(isUpdated) {
                response.getWriter().println("<script>alert('Payment updated successfully'); window.location.href='PaymentServlet'</script>");
            } else {
                request.setAttribute("errorMessage", "Failed to update payment. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating payment: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        }
    }
}