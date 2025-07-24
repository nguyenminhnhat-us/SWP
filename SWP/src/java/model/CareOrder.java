package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class CareOrder {
    private int careOrderId;
    private int userId;
    private int expertId;
    private int serviceId;
    private String plantName;
    private LocalDate dropOffDate;
    private LocalTime appointmentTime;
    private String locationType;
    private String homeAddress;
    private String status;
    private String notes;
    private BigDecimal totalPrice;
    private int hoursPerDay;
    private String careDates;
    private LocalDateTime createdAt;
    private boolean isAcceptedByExpert;

    // Getters and Setters
    public int getCareOrderId() { return careOrderId; }
    public void setCareOrderId(int careOrderId) { this.careOrderId = careOrderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getExpertId() { return expertId; }
    public void setExpertId(int expertId) { this.expertId = expertId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public String getPlantName() { return plantName; }
    public void setPlantName(String plantName) { this.plantName = plantName; }
    public LocalDate getDropOffDate() { return dropOffDate; }
    public void setDropOffDate(LocalDate dropOffDate) { this.dropOffDate = dropOffDate; }
    public LocalTime getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(LocalTime appointmentTime) { this.appointmentTime = appointmentTime; }
    public String getLocationType() { return locationType; }
    public void setLocationType(String locationType) { this.locationType = locationType; }
    public String getHomeAddress() { return homeAddress; }
    public void setHomeAddress(String homeAddress) { this.homeAddress = homeAddress; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    public int getHoursPerDay() { return hoursPerDay; }
    public void setHoursPerDay(int hoursPerDay) { this.hoursPerDay = hoursPerDay; }
    public String getCareDates() { return careDates; }
    public void setCareDates(String careDates) { this.careDates = careDates; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public boolean isAcceptedByExpert() { return isAcceptedByExpert; }
    public void setAcceptedByExpert(boolean acceptedByExpert) { this.isAcceptedByExpert = acceptedByExpert; }
}