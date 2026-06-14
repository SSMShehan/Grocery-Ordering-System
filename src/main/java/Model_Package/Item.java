package Model_Package;

public class Item {
    private int itemID;
    private String name;
    private String price;
    private String quantity;
    private String category;
    private String description;
    private String imagePath;
    private int discount;
    private String dealPrice;
    
    public Item() {
    }
    
    public Item(int itemID, String name, String price, String quantity, String category, String description) {
        this.itemID = itemID;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.category = category;
        this.description = description;
    }
    
    // Getters and Setters
    public int getItemID() {
        return itemID;
    }
    
    public void setItemID(int itemID) {
        this.itemID = itemID;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPrice() {
        return price;
    }
    
    public void setPrice(String price) {
        this.price = price;
    }
    
    public String getQuantity() {
        return quantity;
    }
    
    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public int getDiscount() { return discount; }
    public void setDiscount(int discount) { this.discount = discount; }
    
    public String getDealPrice() { return dealPrice; }
    public void setDealPrice(String dealPrice) { this.dealPrice = dealPrice; }
}