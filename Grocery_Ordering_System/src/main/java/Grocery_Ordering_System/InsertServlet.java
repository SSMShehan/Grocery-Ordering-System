package Grocery_Ordering_System;

import java.io.IOException;

import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/InsertServlet")
public class InsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Log that we've entered the InsertServlet
        System.out.println("InsertServlet - Processing POST request");
        
        // Get form parameters
        String name = request.getParameter("name");
        String price = request.getParameter("price");
        String quantity = request.getParameter("quantity");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        
        // Log the received parameters
        System.out.println("InsertServlet - Received parameters:");
        System.out.println("Name: " + name);
        System.out.println("Price: " + price);
        System.out.println("Quantity: " + quantity);
        System.out.println("Category: " + category);
        System.out.println("Description: " + description);
        
        try {
            // Validate input parameters
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Name cannot be empty");
            }
            
            if (price == null || price.trim().isEmpty()) {
                throw new IllegalArgumentException("Price cannot be empty");
            }
            
            if (quantity == null || quantity.trim().isEmpty()) {
                throw new IllegalArgumentException("Quantity cannot be empty");
            }
            
            // Try to insert data
            System.out.println("InsertServlet - Attempting to insert data");
            boolean isTrue = itemControl.insertdata(name, price, quantity, category, description);
            
            if(isTrue) {
                System.out.println("InsertServlet - Data insert successful");
                String alertMessage = "Data Insert Successful";
                response.getWriter().println("<script> alert('"+alertMessage+"'); window.location.href='ItemServlet'</script>");
            }
            else {
                System.out.println("InsertServlet - Data insert failed");
                request.setAttribute("errorMessage", "Failed to insert item data. Please check database connection.");
                RequestDispatcher dis2 = request.getRequestDispatcher("item.jsp");
                dis2.forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            System.out.println("InsertServlet - Validation error: " + e.getMessage());
            request.setAttribute("errorMessage", "Validation error: " + e.getMessage());
            RequestDispatcher dis2 = request.getRequestDispatcher("item.jsp");
            dis2.forward(request, response);
            
        } catch (Exception e) {
            System.out.println("InsertServlet - Exception occurred: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error inserting data: " + e.getMessage());
            RequestDispatcher dis2 = request.getRequestDispatcher("item.jsp");
            dis2.forward(request, response);
        }
    }
}