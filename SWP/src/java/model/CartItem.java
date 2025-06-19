package model;

public class CartItem {

    private int cartId;
    private int userId;
    private int plantId;
    private int quantity;
    private Plant plant;

    public CartItem() {
    }

    public CartItem(int cartId, int userId, int plantId, int quantity, Plant plant) {
        this.cartId = cartId;
        this.userId = userId;
        this.plantId = plantId;
        this.quantity = quantity;
        this.plant = plant;
    }

    // Getters and Setters
    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPlantId() {
        return plantId;
    }

    public void setPlantId(int plantId) {
        this.plantId = plantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Plant getPlant() {
        return plant;
    }

    public void setPlant(Plant plant) {
        this.plant = plant;
    }
}
