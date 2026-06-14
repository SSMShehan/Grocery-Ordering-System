package Servlet_Package;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Control_Package.ItemDAO;
import Model_Package.ItemModel;

@WebServlet("/ItemServlet")
public class GetAllServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO = new ItemDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if (action != null) {
                switch (action) {
                    case "edit":
                        showEditForm(request, response);
                        break;
                    case "delete":
                        deleteItem(request, response);
                        break;
                    default:
                        listItems(request, response);
                }
            } else {

                listItems(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ItemModel> allItems = itemDAO.getAllItemModels();
            List<String> categories = itemDAO.getAllCategoriesList();
            request.setAttribute("allItems", allItems);
            request.setAttribute("categories", categories);
            RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
            dispatcher.forward(request, response);
        }

        catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading items: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemID = request.getParameter("itemID");
            List<ItemModel> item = itemDAO.getById(itemID);
            List<String> categories = itemDAO.getAllCategoriesList();

            if (!item.isEmpty()) {
                request.setAttribute("item", item.get(0));
                request.setAttribute("editMode", true);
                request.setAttribute("categories", categories);
                RequestDispatcher dispatcher = request.getRequestDispatcher("item.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Item not found.");
                listItems(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving item: " + e.getMessage());
            listItems(request, response);
        }
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String itemID = request.getParameter("itemID");
            boolean success = itemDAO.deleteItem(itemID);

            if (success) {
                request.setAttribute("successMessage", "Item deleted successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to delete item.");
            }
            listItems(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting item: " + e.getMessage());
            listItems(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}