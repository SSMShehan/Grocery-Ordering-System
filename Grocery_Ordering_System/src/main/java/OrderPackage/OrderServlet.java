// OrderServlet.java
package OrderPackage;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import CustomerPackage.CustomerModel;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        
        try {
            if (action != null) {
                switch (action) {
                    case "delete":
                        deleteOrder(request, response);
                        break;
                    default:
                        listOrders(request, response);
                }
            } else {
                listOrders(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<OrderModel> allOrders = OrderControl.getAllOrders();
            List<CustomerModel> allCustomers = OrderControl.getAllCustomers();
            
            request.setAttribute("allOrders", allOrders);
            request.setAttribute("allCustomers", allCustomers);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading orders: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("order.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String orderID = request.getParameter("orderID");
            boolean success = OrderControl.deleteOrder(orderID);
            
            if (success) {
                request.setAttribute("successMessage", "Order deleted successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to delete order.");
            }
            listOrders(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting order: " + e.getMessage());
            listOrders(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}