package Model_Package;

import java.sql.Date;

public class CategoryModel {
    private int categoryID;
    private String name;
    private String description;
    private Integer parentCategoryID;
    private String parentCategoryName;
    
    public CategoryModel(int categoryID, String name, String description, Integer parentCategoryID) {
        this.categoryID = categoryID;
        this.name = name;
        this.description = description;
        this.parentCategoryID = parentCategoryID;
    }

    
    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getParentCategoryID() {
        return parentCategoryID;
    }

    public void setParentCategoryID(Integer parentCategoryID) {
        this.parentCategoryID = parentCategoryID;
    }

    public String getParentCategoryName() {
        return parentCategoryName;
    }

    public void setParentCategoryName(String parentCategoryName) {
        this.parentCategoryName = parentCategoryName;
    }
}