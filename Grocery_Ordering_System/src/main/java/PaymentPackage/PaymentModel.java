// PaymentModel.java
package PaymentPackage;

import java.sql.Date;

public class PaymentModel {
    private int paymentID;
    private int orderID;
    private int cusID;
    private String amount;
    private Date paydate;
    private String paymethod;
    private String payment_status;
    private String customerName; // For display purposes
    private String orderDetails; // For display purposes

    public PaymentModel(int paymentID, int orderID, int cusID, String amount, Date paydate, String paymethod, String payment_status) {
        this.paymentID = paymentID;
        this.orderID = orderID;
        this.cusID = cusID;
        this.amount = amount;
        this.paydate = paydate;
        this.paymethod = paymethod;
        this.payment_status = payment_status;
    }

    // Getters and Setters
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

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

    public Date getPaydate() {
        return paydate;
    }

    public void setPaydate(Date paydate) {
        this.paydate = paydate;
    }

    public String getPaymethod() {
        return paymethod;
    }

    public void setPaymethod(String paymethod) {
        this.paymethod = paymethod;
    }

    public String getPayment_status() {
        return payment_status;
    }

    public void setPayment_status(String payment_status) {
        this.payment_status = payment_status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(String orderDetails) {
        this.orderDetails = orderDetails;
    }
}