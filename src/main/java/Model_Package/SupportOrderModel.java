package Model_Package;

import java.sql.Date;

public class SupportOrderModel {
    private int orderID;
    private int cusID;
    private String amount;
    private Date order_date;
    private String order_status;
    private String customerName;

    public SupportOrderModel(int orderID, int cusID, String amount, 
                           Date order_date, String order_status) {
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

    public int getCusID() {
        return cusID;
    }

    public String getAmount() {
        return amount;
    }

    public Date getOrder_date() {
        return order_date;
    }

    public String getOrder_status() {
        return order_status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}