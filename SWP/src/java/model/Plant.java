package model;

public class Plant {
    private int plantId;
    private int categoryId;
    private String name;
    private String description;
    private double price;
    private int stockQuantity;
    private String imageUrl;

    public Plant(int plantId, int categoryId, String name, String description, double price, int stockQuantity, String imageUrl) {
        this.plantId = plantId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    // Getters
    public int getPlantId() { return plantId; }
    public int getCategoryId() { return categoryId; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public double getPrice() { return price; }
    public int getStockQuantity() { return stockQuantity; }
    public String getImageUrl() { return imageUrl; }
}