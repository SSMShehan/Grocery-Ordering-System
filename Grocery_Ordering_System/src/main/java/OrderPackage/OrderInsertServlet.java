// OrderInsertServlet.java
package OrderPackage;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/OrderInsertServlet")
public class OrderInsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String cusID = request.getParameter("cusID");
        String amount = request.getParameter("amount");
        String order_date = request.getParameter("order_date");
        String order_status = request.getParameter("order_status");
        
        try {
            // Validate input parameters
            if (cusID == null || cusID.trim().isEmpty()) {
                throw new IllegalArgumentException("Customer cannot be empty");
            }
            
            if (amount == null || amount.trim().isEmpty()) {
                throw new IllegalArgumentException("Amount cannot be empty");
            }
            
            // Try to insert data
            boolean isTrue = OrderControl.insertOrder(Integer.parseInt(cusID), amount, order_date, order_status);
            
            if(isTrue) {
                response.getWriter().println("<script>alert('Order added successfully'); window.location.href='OrderServlet'</script>");
            }
            else {
                request.setAttribute("errorMessage", "Failed to insert order data. Please check database connection.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
                dispatcher.forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Validation error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error inserting data: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
            dispatcher.forward(request, response);
        }
    }
}