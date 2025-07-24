package model;

import java.math.BigDecimal;

public class OrderDetail {
    private int orderDetailId;
    private int orderId;
    private int plantId;
    private int quantity;
    private BigDecimal unitPrice;

    // ✅ Thêm 2 thuộc tính mới
    private String plantName;
    private String plantImage;

    public OrderDetail() {
    }

    public OrderDetail(int orderId, int plantId, int quantity, BigDecimal unitPrice) {
        this.orderId = orderId;
        this.plantId = plantId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public OrderDetail(int orderDetailId, int orderId, int plantId, int quantity, BigDecimal unitPrice) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.plantId = plantId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    // ✅ Getters and Setters
    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    // ✅ Getter/Setter mới thêm
    public String getPlantName() {
        return plantName;
    }

    public void setPlantName(String plantName) {
        this.plantName = plantName;
    }

    public String getPlantImage() {
        return plantImage;
    }

    public void setPlantImage(String plantImage) {
        this.plantImage = plantImage;
    }
}
