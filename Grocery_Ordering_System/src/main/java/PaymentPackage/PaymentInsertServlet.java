// PaymentInsertServlet.java
package PaymentPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/PaymentInsertServlet")
public class PaymentInsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
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
            
            // Try to insert data
            boolean isTrue = PaymentControl.insertPayment(
                Integer.parseInt(orderID), 
                Integer.parseInt(cusID), 
                amount, 
                paydate, 
                paymethod, 
                payment_status
            );
            
            if(isTrue) {
                response.getWriter().println("<script>alert('Payment added successfully'); window.location.href='PaymentServlet'</script>");
            }
            else {
                request.setAttribute("errorMessage", "Failed to insert payment data. Please check database connection.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
                dispatcher.forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Validation error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error inserting data: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("payment.jsp");
            dispatcher.forward(request, response);
        }
    }
}