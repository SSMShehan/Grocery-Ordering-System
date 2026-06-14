package Servlet_Package;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.CategoryControl;

@WebServlet("/CategoryUpdateServlet")
public class CategoryUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String categoryID = request.getParameter("categoryID");
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
            
            // Update the category
            boolean isUpdated = CategoryControl.updateCategory(categoryID, name, description, parentID);
            
            if(isUpdated) {
                response.getWriter().println("<script>alert('Category updated successfully'); window.location.href='CategoryServlet'</script>");
            } else {
                request.setAttribute("errorMessage", "Failed to update category. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("category.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating category: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("category.jsp");
            dispatcher.forward(request, response);
        }
    }
}