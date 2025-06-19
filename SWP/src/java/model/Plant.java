package model;

public class Plant {
    private int plantId;
    private int categoryId;
    private String name;
    private String description;
    private double price;
    private int stockQuantity;
    private String imageUrl;

    public Plant() {}

    public Plant(int plantId, int categoryId, String name, String description, double price, int stockQuantity, String imageUrl) {
        this.plantId = plantId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    // Getters và Setters
    public int getPlantId() { return plantId; }
    public void setPlantId(int plantId) { this.plantId = plantId; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}