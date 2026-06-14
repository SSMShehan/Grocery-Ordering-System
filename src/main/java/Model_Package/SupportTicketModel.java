// SupportTicketModel.java
package Model_Package;

import java.sql.Timestamp;

public class SupportTicketModel {
    private int ticketID;
    private int cusID;
    private String subject;
    private String message;
    private String status;
    private Timestamp createdAt;
    private String reply;
    private String customerName;
    private String priority;

    public SupportTicketModel(int ticketID, int cusID, String subject, String message, 
                            String status, Timestamp createdAt, String reply, 
                            String customerName, String priority) {
        this.ticketID = ticketID;
        this.cusID = cusID;
        this.subject = subject;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
        this.reply = reply;
        this.customerName = customerName;
        this.priority = priority;
    }

    // Getters and Setters
    public int getTicketID() { return ticketID; }
    public int getCusID() { return cusID; }
    public String getSubject() { return subject; }
    public String getMessage() { return message; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public String getReply() { return reply; }
    public String getCustomerName() { return customerName; }
    public String getPriority() { return priority; }
}