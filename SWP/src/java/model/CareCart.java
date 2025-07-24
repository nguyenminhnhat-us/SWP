package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDateTime;

/**
 * Đại diện cho đơn dịch vụ chăm sóc cây của người dùng.
 */
public class CareCart implements Serializable {
    private int cartId;
    private int userId;
    private String plantName;
    private Date dropOffDate;
    private Time appointmentTime;
    private String locationType;
    private String homeAddress;
    private int expertId;
    private int hoursPerDay;
    private String notes;
    private BigDecimal totalPrice;
    private LocalDateTime createdAt;
    private String status;
    // Constructors
    public CareCart() {}

    public CareCart(int cartId, int userId, String plantName, Date dropOffDate, Time appointmentTime,
                    String locationType, String homeAddress, int expertId, int hoursPerDay,
                    String notes, BigDecimal totalPrice, LocalDateTime createdAt, String status) {
        this.cartId = cartId;
        this.userId = userId;
        this.plantName = plantName;
        this.dropOffDate = dropOffDate;
        this.appointmentTime = appointmentTime;
        this.locationType = locationType;
        this.homeAddress = homeAddress;
        this.expertId = expertId;
        this.hoursPerDay = hoursPerDay;
        this.notes = notes;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
        this.status = status;
    }
    
    // Getters & Setters
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

    public String getPlantName() {
        return plantName;
    }

    public void setPlantName(String plantName) {
        this.plantName = plantName;
    }

    public Date getDropOffDate() {
        return dropOffDate;
    }

    public void setDropOffDate(Date dropOffDate) {
        this.dropOffDate = dropOffDate;
    }

    public Time getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }

    public String getLocationType() {
        return locationType;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    public String getHomeAddress() {
        return homeAddress;
    }

    public void setHomeAddress(String homeAddress) {
        this.homeAddress = homeAddress;
    }

    public int getExpertId() {
        return expertId;
    }

    public void setExpertId(int expertId) {
        this.expertId = expertId;
    }

    public int getHoursPerDay() {
        return hoursPerDay;
    }

    public void setHoursPerDay(int hoursPerDay) {
        this.hoursPerDay = hoursPerDay;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
public String getStatus() {
    return status;
}

public void setStatus(String status) {
    this.status = status;
}
}
