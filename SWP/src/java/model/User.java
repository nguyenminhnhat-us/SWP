package model;

import java.math.BigDecimal;

public class User {
    private int userId;
    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String address;
    private String role;
    private boolean isActive;
    private String avatarPath;
    private String authType;

    // Thông tin dành cho chuyên gia
    private String bio;
    private int experienceYears;
    private BigDecimal pricePerDay;  // ✅ tính theo ngày

    // Thông tin mở rộng từ bảng ExpertProfiles
    private String achievements;
    private String specialties;
    private String gallery1;
    private String gallery2;
    private String gallery3;

    // ===== Constructors =====
    public User() {}

    public User(int userId, String email, String password, String fullName,
                String phone, String address, String role, boolean isActive) {
        this.userId = userId;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.role = role;
        this.isActive = isActive;
        this.avatarPath = "uploads/default.jpg";
        this.authType = "local";
    }

    public User(int userId, String email, String password, String fullName, String phone,
                String address, String role, boolean isActive, String avatarPath, String authType,
                String bio, int experienceYears, BigDecimal pricePerDay) {
        this.userId = userId;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.role = role;
        this.isActive = isActive;
        this.avatarPath = avatarPath;
        this.authType = authType;
        this.bio = bio;
        this.experienceYears = experienceYears;
        this.pricePerDay = pricePerDay;
    }

    // ===== Getters & Setters =====
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isIsActive() {
        return isActive;
    }

public boolean isActive() { return isActive; }
public void setIsActive(boolean isActive) { this.isActive = isActive; }

    
    public String getAvatarPath() { return avatarPath; }
    public void setAvatarPath(String avatarPath) { this.avatarPath = avatarPath; }

    public String getAuthType() { return authType; }
    public void setAuthType(String authType) { this.authType = authType; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    public BigDecimal getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(BigDecimal pricePerDay) { this.pricePerDay = pricePerDay; }

    public String getAchievements() { return achievements; }
    public void setAchievements(String achievements) { this.achievements = achievements; }

    public String getSpecialties() { return specialties; }
    public void setSpecialties(String specialties) { this.specialties = specialties; }

    public String getGallery1() { return gallery1; }
    public void setGallery1(String gallery1) { this.gallery1 = gallery1; }

    public String getGallery2() { return gallery2; }
    public void setGallery2(String gallery2) { this.gallery2 = gallery2; }

    public String getGallery3() { return gallery3; }
    public void setGallery3(String gallery3) { this.gallery3 = gallery3; }
}

