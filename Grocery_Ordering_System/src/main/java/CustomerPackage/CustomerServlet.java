package CustomerPackage;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        
        try {
            if (action != null) {
                switch (action) {
                    case "delete":
                        deleteCustomer(request, response);
                        break;
                    default:
                        listCustomers(request, response);
                }
            } else {
                listCustomers(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CustomerModel> allCustomers = CustomerControl.getAllCustomers();
            request.setAttribute("allCustomers", allCustomers);
            RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading customers: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("customer.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String cusID = request.getParameter("cusID");
            boolean success = CustomerControl.deleteCustomer(cusID);
            
            if (success) {
                request.setAttribute("successMessage", "Customer deleted successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to delete customer.");
            }
            listCustomers(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting customer: " + e.getMessage());
            listCustomers(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}