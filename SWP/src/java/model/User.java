package model;

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
    private String authType; // Thêm trường này

    public User() {
    }

    public User(int userId, String email, String password, String fullName, String phone, String address, String role, boolean isActive, String authType) {
        this.userId = userId;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.role = role;
        this.isActive = isActive;
        this.avatarPath = "uploads/default.jpg"; // Giá trị mặc định
        this.authType = authType; // Thêm authType
    }

    // Getters và Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isIsActive() {
        return isActive;
    }
    
    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getAvatarPath() {
        return avatarPath;
    }

    public void setAvatarPath(String avatarPath) {
        this.avatarPath = avatarPath;
    }

    public String getAuthType() {
        return authType;
    } // Thêm getter

    public void setAuthType(String authType) {
        this.authType = authType;
    } // Thêm setter
}
