-- Tạo database mới có tên plant_care_system
CREATE DATABASE plant_care_systemcu;
GO

-- Sử dụng database vừa tạo
USE plant_care_systemcu;
GO

-- Bảng Users: Lưu thông tin người dùng (khách hàng và quản trị viên)
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    address NVARCHAR(MAX),
    role NVARCHAR(20) NOT NULL CHECK (role IN ('customer', 'admin')) DEFAULT 'customer',
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    is_active BIT DEFAULT 1,
	avatar_path VARCHAR(255) DEFAULT 'uploads/default.jpg',
  auth_type NVARCHAR(20) DEFAULT 'local'
);
CREATE TABLE otp_codes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(100) NOT NULL,
    otp NVARCHAR(10) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Bảng Categories: Lưu danh mục loại cây
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

-- Bảng Plants: Lưu thông tin cây cảnh
CREATE TABLE Plants (
    plant_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    image_url NVARCHAR(255),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
	
);

-- Bảng Cart: Lưu giỏ hàng của người dùng
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    plant_id INT NOT NULL,
    quantity INT NOT NULL,
    added_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plant_id) REFERENCES Plants(plant_id) ON DELETE CASCADE
);

-- Bảng Orders: Lưu đơn hàng mua cây
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status NVARCHAR(20) NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')) DEFAULT 'pending',
    shipping_address NVARCHAR(MAX) NOT NULL,
    payment_method NVARCHAR(50),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Bảng OrderDetails: Lưu chi tiết cây trong đơn hàng
CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    plant_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (plant_id) REFERENCES Plants(plant_id) ON DELETE SET NULL
);

-- Bảng Reviews: Lưu đánh giá cây đã mua
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    plant_id INT,
    order_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plant_id) REFERENCES Plants(plant_id) ON DELETE SET NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE NO ACTION
);


-- Bảng CareServices: Lưu gói dịch vụ chăm sóc
CREATE TABLE CareServices (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    duration_days INT NOT NULL
);

-- Bảng CareOrders: Lưu đơn gửi cây chăm sóc
CREATE TABLE CareOrders (
    care_order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    service_id INT,
    plant_name NVARCHAR(100) NOT NULL,
    drop_off_date DATE NOT NULL,
    status NVARCHAR(20) NOT NULL CHECK (status IN ('pending', 'in_progress', 'completed')) DEFAULT 'pending',
    notes NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES CareServices(service_id) ON DELETE SET NULL
);

-- Bảng CareHistory: Lưu lịch sử chăm sóc cây
CREATE TABLE CareHistory (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    care_order_id INT NOT NULL,
    update_date DATETIME2 DEFAULT SYSDATETIME(),
    status_update NVARCHAR(100),
    notes NVARCHAR(MAX),
    image_url NVARCHAR(255),
    FOREIGN KEY (care_order_id) REFERENCES CareOrders(care_order_id) ON DELETE CASCADE
);

-- Bảng Consultations: Lưu lịch hẹn tư vấn
CREATE TABLE Consultations (
    consultation_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    expert_id INT,
    appointment_date DATETIME2 NOT NULL,
    issue_description NVARCHAR(MAX),
    status NVARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')) DEFAULT 'pending',
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE NO ACTION,
    FOREIGN KEY (expert_id) REFERENCES Users(user_id) ON DELETE NO ACTION
);


-- Bảng Messages: Lưu tin nhắn chat với chuyên gia
CREATE TABLE Messages (
    message_id INT IDENTITY(1,1) PRIMARY KEY,
    consultation_id INT NOT NULL,
    sender_id INT NULL,
    receiver_id INT NULL,
    content NVARCHAR(MAX) NOT NULL,
    sent_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (consultation_id) REFERENCES Consultations(consultation_id) ON DELETE NO ACTION,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id) ON DELETE NO ACTION,
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id) ON DELETE NO ACTION
);

-- Bảng Articles: Lưu bài viết tư vấn
CREATE TABLE Articles (
    article_id INT IDENTITY(1,1) PRIMARY KEY,
    author_id INT,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    category NVARCHAR(100),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    updated_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (author_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Bảng Notifications: Lưu thông báo
CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    type NVARCHAR(20) NOT NULL CHECK (type IN ('care_update', 'order_status')),
    content NVARCHAR(MAX) NOT NULL,
    sent_at DATETIME2 DEFAULT SYSDATETIME(),
    is_read BIT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Bảng Reports: Lưu dữ liệu thống kê
CREATE TABLE Reports (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    admin_id INT NOT NULL,
    report_type NVARCHAR(20) NOT NULL CHECK (report_type IN ('revenue', 'service_usage', 'order_stats')),
    data NVARCHAR(MAX) NOT NULL, -- Lưu JSON dạng chuỗi
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (admin_id) REFERENCES Users(user_id) ON DELETE CASCADE
);
GO
INSERT INTO Users (email, password, full_name, phone, address, role, is_active)
VALUES 
('admin@plant.com', 'admin123', N'Admin Chính', '0905000001', N'123 Trần Phú, Đà Nẵng', 'admin', 1),

('user1@plant.com', 'user123', N'Nguyễn Văn A', '0905111222', N'45 Nguyễn Lương Bằng, Đà Nẵng', 'customer', 1),

('user2@plant.com', 'user456', N'Trần Thị B', '0905333444', N'27 Lê Duẩn, Đà Nẵng', 'customer', 1);

-- Thêm dữ liệu mẫu cho Categories
INSERT INTO Categories (name, description)
VALUES 
(N'Cây Xanh Công Trình', N'Các loại cây xanh phù hợp cho công trình, dự án lớn'),
(N'Cây Xanh Ngoại Thất', N'Các loại cây xanh trang trí sân vườn, ban công'),
(N'Cây Xanh Nội Thất', N'Các loại cây xanh trang trí trong nhà, văn phòng'),
(N'Cây Phong Thủy', N'Các loại cây mang ý nghĩa phong thủy');

-- Thêm dữ liệu mẫu cho Plants
INSERT INTO Plants (category_id, name, description, price, stock_quantity, image_url)
VALUES 
(1, N'Cây Phượng Vĩ', N'Cây phượng vĩ là loại cây thân gỗ có hoa đẹp, thích hợp trồng trong công viên, trường học', 1500000, 50, 'images/phuong_vy.jpg'),
(2, N'Cây Hoa Sữa', N'Cây hoa sữa có hương thơm đặc trưng, thích hợp trồng trong sân vườn', 2000000, 30, 'images/hoa_sua.jpg'),
(3, N'Cây Trầu Bà', N'Cây trầu bà dễ chăm sóc, có tác dụng thanh lọc không khí', 250000, 100, 'images/trau_ba.jpg'),
(4, N'Cây Kim Tiền', N'Cây kim tiền mang ý nghĩa phong thủy tốt, thu hút tài lộc', 300000, 80, 'images/kim_tien.jpg'),
(1, N'Cây Bàng', N'Cây bàng có tán rộng, thích hợp làm cây bóng mát', 1800000, 40, 'images/bang.jpg'),
(2, N'Cây Nguyệt Quế', N'Cây nguyệt quế có hương thơm, thích hợp trồng trong vườn', 1200000, 45, 'images/nguyet_que.jpg'),
(3, N'Cây Lưỡi Hổ', N'Cây lưỡi hổ dễ chăm sóc, có khả năng hấp thụ bức xạ', 180000, 120, 'images/luoi_ho.jpg'),
(4, N'Cây Phát Tài', N'Cây phát tài mang ý nghĩa may mắn, thịnh vượng', 400000, 60, 'images/phat_tai.jpg');

