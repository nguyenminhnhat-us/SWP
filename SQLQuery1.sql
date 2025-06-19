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

  
-- Giả sử user_id 2 và 3 là khách hàng
INSERT INTO Orders (user_id, total_amount, status, shipping_address, payment_method)
VALUES 
(1, 550000, 'delivered', N'45 Nguyễn Lương Bằng, Đà Nẵng', N'Thanh toán khi nhận hàng'),
(1, 780000, 'processing', N'27 Lê Duẩn, Đà Nẵng', N'Chuyển khoản'),
(1, 550000, 'delivered', N'45 Nguyễn Lương Bằng, Đà Nẵng', N'Thanh toán khi nhận hàng');
-- Giả sử plant_id 3 là Trầu Bà, plant_id 4 là Kim Tiền, plant_id 8 là Phát Tài
INSERT INTO OrderDetails (order_id, plant_id, quantity, unit_price)
VALUES 
(1, 3, 2, 250000),   -- Trầu Bà x2
(5, 4, 1, 300000),   -- Kim Tiền x1
(6, 8, 2, 400000);   -- Phát Tài x2
-- Giả sử admin có user_id = 1
INSERT INTO Articles (author_id, title, content, category)
VALUES 
(1, N'Mẹo chăm sóc cây Kim Tiền vào mùa hè', 
 N'Cây Kim Tiền cần đặt nơi thoáng, tránh ánh nắng trực tiếp và tưới đều nước mỗi tuần.', 
 N'Chăm sóc cây'),

(1, N'Lợi ích của việc đặt cây xanh trong văn phòng', 
 N'Cây xanh giúp giảm căng thẳng, lọc không khí và tạo không gian làm việc tích cực.', 
 N'Sức khỏe & Môi trường');

INSERT INTO Categories (name, description)
VALUES 
(N'Cây Cảnh Mini', N'Cây nhỏ để bàn làm việc, dễ chăm sóc'),
(N'Cây Lọc Không Khí', N'Cây có khả năng lọc độc tố, làm sạch không khí'),
(N'Cây Trồng Ban Công', N'Cây thích hợp với không gian ngoài trời như ban công'),
(N'Cây May Mắn', N'Cây mang ý nghĩa phong thủy, may mắn cho gia chủ');
-- Giả sử các category_id tương ứng là từ 5 đến 8
INSERT INTO Plants (category_id, name, description, price, stock_quantity, image_url)
VALUES 
(5, N'Cây Sen Đá', N'Cây nhỏ gọn, dễ sống, phù hợp đặt bàn làm việc', 120000, 200, 'images/sen_da.jpg'),
(5, N'Cây Xương Rồng Tai Thỏ', N'Cây cảnh mini với hình dáng độc đáo', 150000, 150, 'images/xuong_rong_tai_tho.jpg'),
(6, N'Cây Lan Ý', N'Cây lọc không khí tốt, lá xanh bóng đẹp', 220000, 100, 'images/lan_y.jpg'),
(6, N'Cây Hồng Môn', N'Vừa lọc khí, vừa có hoa đỏ đẹp', 260000, 90, 'images/hong_mon.jpg'),
(7, N'Cây Dây Nhện', N'Cây ưa sáng, thích hợp trồng treo ngoài ban công', 130000, 110, 'images/day_nhen.jpg'),
(7, N'Cây Ngọc Ngân', N'Màu lá độc đáo, ưa sáng, chịu nắng tốt', 190000, 70, 'images/ngoc_ngan.jpg'),
(8, N'Cây Thiết Mộc Lan', N'Mang tài lộc và thịnh vượng, dễ trồng trong nhà', 350000, 60, 'images/thiet_moc_lan.jpg'),
(8, N'Cây Vạn Lộc', N'Mang ý nghĩa may mắn, màu lá bắt mắt', 280000, 80, 'images/van_loc.jpg');
INSERT INTO Categories (name, description)
VALUES 
(N'Cây Văn Phòng', N'Cây cảnh phù hợp đặt trong môi trường làm việc, giúp giảm căng thẳng và tăng năng suất.'),
(N'Cây Thủy Sinh', N'Cây sống trong nước hoặc môi trường ẩm, trang trí bể cá hoặc không gian sống.'),
(N'Cây Leo Giàn', N'Cây dây leo dùng trang trí hàng rào, cổng nhà, ban công.'),
(N'Cây Cảnh Bonsai', N'Cây được uốn nắn, tạo hình nghệ thuật, thường dùng làm cây cảnh nội thất.'),
(N'Cây Trồng Trong Nhà', N'Cây phù hợp với điều kiện ánh sáng yếu, thường được đặt ở phòng khách hoặc phòng ngủ.'),
(N'Cây Cảnh Ngoại Thất', N'Cây trồng ngoài sân vườn, chịu được nắng, gió và thời tiết khắc nghiệt.'),
(N'Cây Ăn Quả Mini', N'Cây ăn trái được trồng trong chậu nhỏ, phù hợp với không gian hạn chế.'),
(N'Cây Cảnh Phong Thủy', N'Cây mang ý nghĩa may mắn, tài lộc và sức khỏe theo ngũ hành.'),
(N'Cây Trồng Đường Phố', N'Cây bóng mát lớn, trồng ven đường, công viên hoặc dự án đô thị.'),
(N'Cây Sống Đời', N'Loại cây tượng trưng cho sự trường tồn và kiên cường, dễ trồng và ra hoa quanh năm.');
INSERT INTO Articles (author_id, title, content, category)
VALUES
(1, N'Cách chăm sóc cây Lan Ý luôn xanh tốt',
 N'Cây Lan Ý cần đất thoát nước tốt, tưới 2 lần/tuần và đặt nơi có ánh sáng nhẹ.',
 N'Chăm sóc cây'),

(1, N'Những loại cây lọc không khí tốt nhất trong nhà',
 N'Lan Ý, Lưỡi Hổ, Trầu Bà là những loại cây có khả năng hấp thụ khí độc như formaldehyde.',
 N'Sức khỏe'),

(1, N'Trồng cây Phát Tài đúng cách để thu hút tài lộc',
 N'Cây Phát Tài nên đặt ở hướng Đông Nam, tránh ánh nắng gắt và tưới mỗi 5 ngày.',
 N'Phong thủy'),

(1, N'Mẹo chọn cây để bàn hợp mệnh Kim',
 N'Người mệnh Kim nên chọn cây Kim Tiền, Ngọc Ngân hoặc Cây Bạch Mã Hoàng Tử để hút tài khí.',
 N'Phong thủy'),

(1, N'Lợi ích bất ngờ khi đặt cây trong phòng ngủ',
 N'Một số cây như Lưỡi Hổ, Lan Ý giúp tăng oxy, cải thiện giấc ngủ khi đặt trong phòng ngủ.',
 N'Sức khỏe'),

(1, N'Kỹ thuật nhân giống cây Sen Đá tại nhà',
 N'Chỉ cần tách lá khỏe từ cây mẹ, để khô vài ngày rồi đặt lên đất ẩm để mọc rễ.',
 N'Kỹ thuật'),

(1, N'5 loại cây nên trồng ở ban công đón gió tốt',
 N'Nguyệt Quế, Dây Nhện, Hoa Giấy, Dương Xỉ và Cúc Tần là những lựa chọn lý tưởng cho ban công.',
 N'Không gian sống'),

(1, N'Bí quyết tưới cây đúng cách vào mùa hè',
 N'Tưới vào sáng sớm hoặc chiều muộn, tránh tưới giữa trưa nắng nóng sẽ làm héo rễ.',
 N'Chăm sóc cây'),

(1, N'Cây nào phù hợp làm quà tặng tân gia?',
 N'Cây Kim Ngân, Phát Tài hoặc Thiết Mộc Lan mang ý nghĩa chúc tài lộc và bình an.',
 N'Gợi ý mua sắm'),

(1, N'Những sai lầm thường gặp khi chăm sóc cây cảnh',
 N'Tưới quá nhiều, đặt cây ở nơi không phù hợp ánh sáng là những sai lầm phổ biến.',
 N'Chăm sóc cây');

-- Thêm dữ liệu mẫu cho Reviews (feedback)
INSERT INTO Reviews (user_id, plant_id, order_id, rating, comment)
VALUES
(2, 3, 1, 5, N'Sản phẩm rất đẹp, giao hàng nhanh!'),
(3, 3, 1, 4, N'Cây khỏe mạnh, đúng mô tả.'),
(2, 4, 5, 5, N'Rất hài lòng với cây Kim Tiền.'),
(3, 8, 6, 3, N'Cây Phát Tài hơi nhỏ hơn mong đợi nhưng vẫn ổn.'),
(2, 5, 7, 5, N'Cây Sen Đá rất dễ thương, phù hợp để bàn.'),
(3, 6, 8, 4, N'Cây Lan Ý xanh tốt, giao đúng hẹn.'),
(2, 7, 9, 5, N'Cây Dây Nhện rất đẹp, sẽ ủng hộ tiếp.'),
(3, 8, 10, 5, N'Cây Vạn Lộc màu sắc bắt mắt, rất thích!');

-- Bổ sung thêm OrderDetails để có nhiều sản phẩm bán chạy
INSERT INTO OrderDetails (order_id, plant_id, quantity, unit_price)
VALUES
(2, 3, 5, 250000),   -- Trầu Bà x5
(2, 4, 3, 300000),   -- Kim Tiền x3
(3, 8, 4, 400000),   -- Phát Tài x4
(3, 5, 2, 1800000),  -- Bàng x2
(4, 6, 6, 1200000),  -- Nguyệt Quế x6
(4, 7, 7, 180000),   -- Lưỡi Hổ x7
(5, 5, 3, 1800000),  -- Bàng x3
(6, 6, 2, 1200000),  -- Nguyệt Quế x2
(7, 7, 4, 180000),   -- Lưỡi Hổ x4
(8, 8, 5, 400000);   -- Phát Tài x5

-- Bổ sung thêm dữ liệu cho Plants liên quan (cùng category)
INSERT INTO Plants (category_id, name, description, price, stock_quantity, image_url)
VALUES
(1, N'Cây Sấu', N'Cây bóng mát, lá xanh quanh năm, thích hợp trồng đường phố.', 1700000, 30, 'images/cay_sau.jpg'),
(1, N'Cây Xà Cừ', N'Cây thân gỗ lớn, tán rộng, thường trồng ở công viên.', 2000000, 25, 'images/xa_cu.jpg'),
(3, N'Cây Ngũ Gia Bì', N'Cây nội thất, lọc không khí tốt, dễ chăm sóc.', 350000, 60, 'images/ngu_gia_bi.jpg'),
(3, N'Cây Bạch Mã Hoàng Tử', N'Cây nội thất sang trọng, lá xanh sọc trắng.', 400000, 50, 'images/bach_ma.jpg');