// OrderModel.java
package OrderPackage;

import java.sql.Date;

public class OrderModel {
    private int orderID;
    private int cusID;
    private String amount;
    private Date order_date;
    private String order_status;
    private String customerName; // For display purposes

    public OrderModel(int orderID, int cusID, String amount, Date order_date, String order_status) {
        this.orderID = orderID;
        this.cusID = cusID;
        this.amount = amount;
        this.order_date = order_date;
        this.order_status = order_status;
    }

    // Getters and Setters
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getCusID() {
        return cusID;
    }

    public void setCusID(int cusID) {
        this.cusID = cusID;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public Date getOrder_date() {
        return order_date;
    }

    public void setOrder_date(Date order_date) {
        this.order_date = order_date;
    }

    public String getOrder_status() {
        return order_status;
    }

    public void setOrder_status(String order_status) {
        this.order_status = order_status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}