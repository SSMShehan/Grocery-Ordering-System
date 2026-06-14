package Servlet_Package;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.CategoryControl;

@WebServlet("/CategoryInsertServlet")
public class CategoryInsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String parentCategoryID = request.getParameter("parent_categoryID");
        
        try {
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Name cannot be empty");
            }
            
            Integer parentID = null;
            if (parentCategoryID != null && !parentCategoryID.isEmpty() && !parentCategoryID.equals("0")) {
                parentID = Integer.parseInt(parentCategoryID);
            }
            
            
            boolean isTrue = CategoryControl.insertCategory(name, description, parentID);
            
            if(isTrue) {
                response.getWriter().println("<script>alert('Category added successfully'); window.location.href='CategoryServlet'</script>");
            }
            else {
                request.setAttribute("errorMessage", "Failed to insert category data. Please check database connection.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("category.jsp");
                dispatcher.forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Validation error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("category.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error inserting data: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("category.jsp");
            dispatcher.forward(request, response);
        }
    }
}