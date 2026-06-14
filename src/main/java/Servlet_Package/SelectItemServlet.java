package Servlet_Package;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.ItemDAO;
import Model_Package.Item;

@WebServlet("/customer/SelectItemServlet")
public class SelectItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO;
    
    public SelectItemServlet() {
        super();
        itemDAO = new ItemDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            Item item = itemDAO.getItemById(itemId);
            
            if (item != null) {
                request.setAttribute("item", item);
                request.getRequestDispatcher("SelectItem.jsp").forward(request, response);
            } else {
                response.sendRedirect("items_category.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("items_category.jsp");
        }
    }
}