package CustomerPackage;

import java.sql.Date;

public class CustomerModel {
    private int cusID;
    private String name;
    private String phone;
    private String email;
    private String address;
    private Date register_date;
    private String status;
    
    public CustomerModel(int cusID, String name, String phone, String email, String address, Date register_date, String status) {
        this.cusID = cusID;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.register_date = register_date;
        this.status = status;
    }

    // Getters and Setters
    public int getCusID() {
        return cusID;
    }

    public void setCusID(int cusID) {
        this.cusID = cusID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getRegister_date() {
        return register_date;
    }

    public void setRegister_date(Date register_date) {
        this.register_date = register_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}