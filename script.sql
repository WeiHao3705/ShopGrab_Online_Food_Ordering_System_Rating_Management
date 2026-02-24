-- ============================================
-- DROP TABLES (in reverse dependency order)
-- ============================================

-- Drop child tables first
DROP TABLE IF EXISTS MenuRating;
DROP TABLE IF EXISTS RestaurantRating;
DROP TABLE IF EXISTS DeliveryRating;
DROP TABLE IF EXISTS DeliveryService;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS MemberVoucher;
DROP TABLE IF EXISTS Voucher;
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Restaurant;
DROP TABLE IF EXISTS MemberMembership;
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Member;

-- ============================================
-- CREATE TABLES
-- ============================================

-- ============================================
-- PARENT TABLES (No Foreign Keys)
-- ============================================

-- Member Table
CREATE TABLE Member (
    memberID VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    birth_date DATE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phoneNo VARCHAR(20),
    registration_date DATE,
    account_status VARCHAR(20)
);

-- Membership Table
CREATE TABLE Membership (
    membershipID VARCHAR(20) PRIMARY KEY,
    membershipType VARCHAR(50),
    fee DECIMAL(10,2),
    validity_period INT
);

-- Restaurant Table
CREATE TABLE Restaurant (
    restaurantID VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    is_halal BOOLEAN,
    address VARCHAR(255),
    owner_status VARCHAR(50),
    average_rating DECIMAL(3,2)
);

-- Voucher Table
CREATE TABLE Voucher (
    voucherID VARCHAR(20) PRIMARY KEY,
    voucher_type VARCHAR(50),
    discount_amount DECIMAL(10,2),
    expiry_date DATE,
    min_spend_amount DECIMAL(10,2),
    status VARCHAR(20)
);

-- DeliveryService Table
CREATE TABLE DeliveryService (
    deliveryServiceID VARCHAR(20) PRIMARY KEY,
    company_name VARCHAR(100),
    delivery_charge DECIMAL(10,2),
    pickup_time DATETIME,
    delivery_time DATETIME,
    delivery_status VARCHAR(50),
    average_rating DECIMAL(3,2),
    orderID VARCHAR(20)
);

-- ============================================
-- CHILD TABLES (Foreign Keys to Parent Tables)
-- ============================================

-- Address Table
CREATE TABLE Address (
    addressID VARCHAR(20) PRIMARY KEY,
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    postcode VARCHAR(20),
    state VARCHAR(50),
    country VARCHAR(50),
    memberID VARCHAR(20),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

-- Menu Table
CREATE TABLE Menu (
    menuID VARCHAR(20) PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    is_budget_meal BOOLEAN,
    is_super_deal BOOLEAN,
    type VARCHAR(50),
    price DECIMAL(10,2),
    average_rating DECIMAL(3,2),
    availability BOOLEAN,
    restaurantID VARCHAR(20),
    FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID)
);

-- Order Table
CREATE TABLE `Order` (
    orderID VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    order_type VARCHAR(50),
    order_status VARCHAR(50),
    total_amount DECIMAL(10,2),
    delivery_method VARCHAR(50),
    voucherID VARCHAR(20),
    addressID VARCHAR(20),
    memberID VARCHAR(20),
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID),
    FOREIGN KEY (addressID) REFERENCES Address(addressID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

-- Payment Table
CREATE TABLE Payment (
    paymentID VARCHAR(20) PRIMARY KEY,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    payment_date DATE,
    payment DECIMAL(10,2),
    orderID VARCHAR(20),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID)
);

-- ============================================
-- JUNCTION TABLES (Foreign Keys to Multiple Tables)
-- ============================================

-- MemberMembership Table (Junction Table)
CREATE TABLE MemberMembership (
    memberID VARCHAR(20),
    membershipID VARCHAR(20),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    PRIMARY KEY (memberID, membershipID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (membershipID) REFERENCES Membership(membershipID)
);

-- MemberVoucher Table (Junction Table)
CREATE TABLE MemberVoucher (
    memberID VARCHAR(20),
    voucherID VARCHAR(20),
    redeemed_date DATE,
    status VARCHAR(20),
    PRIMARY KEY (memberID, voucherID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID)
);

-- OrderDetails Table (Junction Table)
CREATE TABLE OrderDetails (
    orderDetailsID VARCHAR(20) PRIMARY KEY,
    orderID VARCHAR(20),
    restaurantMenuID VARCHAR(20),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID),
    FOREIGN KEY (restaurantMenuID) REFERENCES Menu(menuID)
);

-- MenuRating Table (Junction Table)
CREATE TABLE MenuRating (
    menu_rating_id VARCHAR(20) PRIMARY KEY,
    memberID VARCHAR(20),
    restaurantMenuID VARCHAR(20),
    rating_score INT,
    comment TEXT,
    rating_date DATE,
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (restaurantMenuID) REFERENCES Menu(menuID)
);

-- RestaurantRating Table (Junction Table)
CREATE TABLE RestaurantRating (
    restaurant_rating_id VARCHAR(20) PRIMARY KEY,
    memberID VARCHAR(20),
    restaurantID VARCHAR(20),
    rating_score INT,
    comment TEXT,
    rating_date DATE,
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID)
);

-- DeliveryRating Table (Junction Table)
CREATE TABLE DeliveryRating (
    delivery_rating_id VARCHAR(20) PRIMARY KEY,
    rating_score INT,
    comment TEXT,
    rating_date DATE,
    deliveryServiceID VARCHAR(20),
    FOREIGN KEY (deliveryServiceID) REFERENCES DeliveryService(deliveryServiceID)
);

-- ============================================
-- INSERT DATA
-- ============================================

-- ============================================
-- BASE TABLES (10+ records each)
-- ============================================

-- Insert Members (15 records)
INSERT INTO Member VALUES ('M001', 'Ahmad', 'Hassan', 'Male', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'pass123', 'ahmad.hassan@email.com', '0123456789', TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M002', 'Siti', 'Nurhaliza', 'Female', TO_DATE('1995-08-22', 'YYYY-MM-DD'), 'pass456', 'siti.nur@email.com', '0123456790', TO_DATE('2023-02-15', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M003', 'Kumar', 'Raj', 'Male', TO_DATE('1988-03-10', 'YYYY-MM-DD'), 'pass789', 'kumar.raj@email.com', '0123456791', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M004', 'Lee', 'Ming', 'Male', TO_DATE('1992-11-30', 'YYYY-MM-DD'), 'pass321', 'lee.ming@email.com', '0123456792', TO_DATE('2023-04-05', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M005', 'Fatimah', 'Abdullah', 'Female', TO_DATE('1997-06-18', 'YYYY-MM-DD'), 'pass654', 'fatimah.ab@email.com', '0123456793', TO_DATE('2023-05-12', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M006', 'David', 'Tan', 'Male', TO_DATE('1991-09-25', 'YYYY-MM-DD'), 'pass987', 'david.tan@email.com', '0123456794', TO_DATE('2023-06-18', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M007', 'Nurul', 'Izzah', 'Female', TO_DATE('1994-02-14', 'YYYY-MM-DD'), 'pass147', 'nurul.izzah@email.com', '0123456795', TO_DATE('2023-07-22', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M008', 'Michael', 'Wong', 'Male', TO_DATE('1989-12-08', 'YYYY-MM-DD'), 'pass258', 'michael.w@email.com', '0123456796', TO_DATE('2023-08-30', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M009', 'Aisha', 'Rahman', 'Female', TO_DATE('1996-04-20', 'YYYY-MM-DD'), 'pass369', 'aisha.rahman@email.com', '0123456797', TO_DATE('2023-09-15', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M010', 'Jason', 'Lim', 'Male', TO_DATE('1993-07-12', 'YYYY-MM-DD'), 'pass741', 'jason.lim@email.com', '0123456798', TO_DATE('2023-10-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M011', 'Sarah', 'Chen', 'Female', TO_DATE('1998-01-05', 'YYYY-MM-DD'), 'pass852', 'sarah.chen@email.com', '0123456799', TO_DATE('2023-11-25', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M012', 'Rajesh', 'Kumar', 'Male', TO_DATE('1987-10-28', 'YYYY-MM-DD'), 'pass963', 'rajesh.k@email.com', '0123456800', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M013', 'Aminah', 'Ismail', 'Female', TO_DATE('1999-03-16', 'YYYY-MM-DD'), 'pass159', 'aminah.i@email.com', '0123456801', TO_DATE('2024-02-14', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M014', 'Daniel', 'Ng', 'Male', TO_DATE('1990-08-08', 'YYYY-MM-DD'), 'pass753', 'daniel.ng@email.com', '0123456802', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO Member VALUES ('M015', 'Zainab', 'Ali', 'Female', TO_DATE('1995-05-30', 'YYYY-MM-DD'), 'pass951', 'zainab.ali@email.com', '0123456803', TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'Active');

-- Insert Membership Types (3 records)
INSERT INTO Membership VALUES ('MS001', 'Normal Member', 0.00, 365);
INSERT INTO Membership VALUES ('MS002', 'VIP Member', 6.00, 30);
INSERT INTO Membership VALUES ('MS003', 'Premium Member', 15.00, 30);

-- Insert Restaurants (15 records)
INSERT INTO Restaurant VALUES ('R001', 'Nasi Kandar Pelita', 'Malaysian', 1, 'Kuala Lumpur', 'Active', 4.5);
INSERT INTO Restaurant VALUES ('R002', 'KFC Malaysia', 'Fast Food', 1, 'Petaling Jaya', 'Active', 4.2);
INSERT INTO Restaurant VALUES ('R003', 'Pizza Hut', 'Italian', 0, 'Subang Jaya', 'Active', 4.0);
INSERT INTO Restaurant VALUES ('R004', 'Restoran Yut Kee', 'Chinese', 0, 'Kuala Lumpur', 'Active', 4.7);
INSERT INTO Restaurant VALUES ('R005', 'Mamak Abdullah', 'Indian', 1, 'Bangsar', 'Active', 4.3);
INSERT INTO Restaurant VALUES ('R006', 'Sushi King', 'Japanese', 0, 'Mid Valley', 'Active', 4.4);
INSERT INTO Restaurant VALUES ('R007', 'Secret Recipe', 'Fusion', 1, 'Pavilion', 'Active', 4.1);
INSERT INTO Restaurant VALUES ('R008', 'The Chicken Rice Shop', 'Asian', 1, 'KLCC', 'Active', 4.6);
INSERT INTO Restaurant VALUES ('R009', 'Subway', 'Western', 0, 'Sunway Pyramid', 'Active', 3.9);
INSERT INTO Restaurant VALUES ('R010', 'Nando\'s', 'Portuguese', 1, 'One Utama', 'Active', 4.5);
INSERT INTO Restaurant VALUES ('R011', 'Rasa Utara', 'Thai', 1, 'Shah Alam', 'Active', 4.2);
INSERT INTO Restaurant VALUES ('R012', 'Old Town White Coffee', 'Malaysian', 1, 'IOI City Mall', 'Active', 4.3);
INSERT INTO Restaurant VALUES ('R013', 'Texas Chicken', 'Fast Food', 1, 'Setapak', 'Active', 4.0);
INSERT INTO Restaurant VALUES ('R014', 'Dim Sum House', 'Chinese', 0, 'Cheras', 'Active', 4.4);
INSERT INTO Restaurant VALUES ('R015', 'Burger King', 'Fast Food', 0, 'Wangsa Maju', 'Active', 3.8);

-- Insert Vouchers (15 records)
INSERT INTO Voucher VALUES ('V001', 'Discount', 5.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 20.00, 'Active');
INSERT INTO Voucher VALUES ('V002', 'Discount', 10.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 50.00, 'Active');
INSERT INTO Voucher VALUES ('V003', 'Free Delivery', 0.00, TO_DATE('2025-06-30', 'YYYY-MM-DD'), 30.00, 'Active');
INSERT INTO Voucher VALUES ('V004', 'Discount', 15.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 100.00, 'Active');
INSERT INTO Voucher VALUES ('V005', 'Discount', 8.00, TO_DATE('2025-09-30', 'YYYY-MM-DD'), 40.00, 'Active');
INSERT INTO Voucher VALUES ('V006', 'Free Delivery', 0.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 25.00, 'Active');
INSERT INTO Voucher VALUES ('V007', 'Discount', 20.00, TO_DATE('2025-08-31', 'YYYY-MM-DD'), 150.00, 'Active');
INSERT INTO Voucher VALUES ('V008', 'Discount', 12.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 80.00, 'Active');
INSERT INTO Voucher VALUES ('V009', 'Free Delivery', 0.00, TO_DATE('2025-10-31', 'YYYY-MM-DD'), 35.00, 'Active');
INSERT INTO Voucher VALUES ('V010', 'Discount', 25.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 200.00, 'Active');
INSERT INTO Voucher VALUES ('V011', 'Discount', 7.00, TO_DATE('2025-07-31', 'YYYY-MM-DD'), 35.00, 'Expired');
INSERT INTO Voucher VALUES ('V012', 'Free Delivery', 0.00, TO_DATE('2024-12-31', 'YYYY-MM-DD'), 20.00, 'Expired');
INSERT INTO Voucher VALUES ('V013', 'Discount', 18.00, TO_DATE('2025-11-30', 'YYYY-MM-DD'), 120.00, 'Active');
INSERT INTO Voucher VALUES ('V014', 'Discount', 6.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 30.00, 'Active');
INSERT INTO Voucher VALUES ('V015', 'Free Delivery', 0.00, TO_DATE('2025-12-31', 'YYYY-MM-DD'), 40.00, 'Active');

-- ============================================
-- TRANSACTION TABLES (100+ records each)
-- ============================================

-- Insert Addresses (30 records - multiple per member)
INSERT INTO Address VALUES ('A001', 'Jalan Sultan Ismail 123', 'Unit 5-2', 'Kuala Lumpur', '50250', 'Wilayah Persekutuan', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A002', 'Jalan Ampang 456', NULL, 'Kuala Lumpur', '50450', 'Wilayah Persekutuan', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A003', 'Jalan PJ 789', 'Apt 10-5', 'Petaling Jaya', '46000', 'Selangor', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A004', 'Jalan Subang 321', NULL, 'Subang Jaya', '47500', 'Selangor', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A005', 'Jalan Bangsar 654', 'Condo A-12', 'Bangsar', '59100', 'Kuala Lumpur', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A006', 'Jalan Mid Valley 987', NULL, 'Mid Valley', '58000', 'Kuala Lumpur', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A007', 'Jalan Pavilion 147', 'Unit 8-3', 'Pavilion', '55100', 'Kuala Lumpur', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A008', 'Jalan KLCC 258', NULL, 'KLCC', '50088', 'Kuala Lumpur', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A009', 'Jalan Sunway 369', 'House 15', 'Sunway', '47500', 'Selangor', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A010', 'Jalan One U 741', NULL, 'One Utama', '47800', 'Selangor', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A011', 'Jalan Shah Alam 852', 'Apt B-5', 'Shah Alam', '40000', 'Selangor', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A012', 'Jalan IOI 963', NULL, 'IOI City', '62502', 'Selangor', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A013', 'Jalan Setapak 159', 'Villa 22', 'Setapak', '53000', 'Kuala Lumpur', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A014', 'Jalan Cheras 753', NULL, 'Cheras', '56000', 'Kuala Lumpur', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A015', 'Jalan Wangsa 951', 'Unit 3-7', 'Wangsa Maju', '53300', 'Kuala Lumpur', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A016', 'Jalan Damansara 357', NULL, 'Damansara', '47810', 'Selangor', 'Malaysia', 'M015');
INSERT INTO Address VALUES ('A017', 'Jalan Ampang 456', 'Office', 'Kuala Lumpur', '50450', 'Wilayah Persekutuan', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A018', 'Jalan Subang 789', 'Home', 'Subang Jaya', '47500', 'Selangor', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A019', 'Jalan Bangsar 123', 'Apt 15-3', 'Bangsar', '59100', 'Kuala Lumpur', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A020', 'Jalan Mid Valley 456', NULL, 'Mid Valley', '58000', 'Kuala Lumpur', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A021', 'Jalan Pavilion 789', 'Suite 20', 'Pavilion', '55100', 'Kuala Lumpur', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A022', 'Jalan KLCC 321', NULL, 'KLCC', '50088', 'Kuala Lumpur', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A023', 'Jalan Sunway 654', 'House 8', 'Sunway', '47500', 'Selangor', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A024', 'Jalan One U 987', NULL, 'One Utama', '47800', 'Selangor', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A025', 'Jalan Shah Alam 147', 'Apt C-10', 'Shah Alam', '40000', 'Selangor', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A026', 'Jalan IOI 258', NULL, 'IOI City', '62502', 'Selangor', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A027', 'Jalan Setapak 369', 'Villa 5', 'Setapak', '53000', 'Kuala Lumpur', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A028', 'Jalan Cheras 741', NULL, 'Cheras', '56000', 'Kuala Lumpur', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A029', 'Jalan Wangsa 852', 'Unit 7-2', 'Wangsa Maju', '53300', 'Kuala Lumpur', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A030', 'Jalan Damansara 963', NULL, 'Damansara', '47810', 'Selangor', 'Malaysia', 'M015');
INSERT INTO Address VALUES ('A031', 'Jalan Bukit Bintang 100', 'Suite 12-A', 'Bukit Bintang', '55100', 'Kuala Lumpur', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A032', 'Jalan Tun Razak 245', NULL, 'Kuala Lumpur', '50400', 'Wilayah Persekutuan', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A033', 'Jalan Imbi 88', 'Unit 20-5', 'Kuala Lumpur', '55100', 'Wilayah Persekutuan', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A034', 'Jalan Pudu 456', 'Apt 7-3', 'Kuala Lumpur', '55100', 'Wilayah Persekutuan', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A035', 'Jalan Raja Chulan 789', NULL, 'Kuala Lumpur', '50200', 'Wilayah Persekutuan', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A036', 'Jalan Masjid India 321', 'Shop 5', 'Kuala Lumpur', '50100', 'Wilayah Persekutuan', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A037', 'Jalan Tuanku Abdul Rahman 654', NULL, 'Kuala Lumpur', '50100', 'Wilayah Persekutuan', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A038', 'Jalan Sentul 147', 'House 33', 'Sentul', '51000', 'Kuala Lumpur', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A039', 'Jalan Titiwangsa 258', NULL, 'Titiwangsa', '53200', 'Kuala Lumpur', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A040', 'Jalan Kuchai Lama 369', 'Apt 9-8', 'Kuchai Lama', '58200', 'Kuala Lumpur', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A041', 'Jalan Kepong 741', NULL, 'Kepong', '52100', 'Kuala Lumpur', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A042', 'Jalan Segambut 852', 'Villa 18', 'Segambut', '51200', 'Kuala Lumpur', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A043', 'Jalan Batu Caves 963', NULL, 'Batu Caves', '68100', 'Selangor', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A044', 'Jalan Rawang 159', 'Unit 4-2', 'Rawang', '48000', 'Selangor', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A045', 'Jalan Selayang 357', NULL, 'Selayang', '68100', 'Selangor', 'Malaysia', 'M015');
INSERT INTO Address VALUES ('A046', 'Jalan Sri Hartamas 555', 'Condo B-15', 'Sri Hartamas', '50480', 'Kuala Lumpur', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A047', 'Jalan Desa Sri Hartamas 666', NULL, 'Sri Hartamas', '50480', 'Kuala Lumpur', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A048', 'Jalan Mont Kiara 777', 'Apt 18-9', 'Mont Kiara', '50480', 'Kuala Lumpur', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A049', 'Jalan Solaris 888', NULL, 'Mont Kiara', '50480', 'Kuala Lumpur', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A050', 'Jalan Dutamas 999', 'Office Tower 3', 'Dutamas', '50480', 'Kuala Lumpur', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A051', 'Jalan Setiawangsa 111', NULL, 'Setiawangsa', '54200', 'Kuala Lumpur', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A052', 'Jalan Gombak 222', 'House 45', 'Gombak', '53000', 'Selangor', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A053', 'Jalan Ampang Hilir 333', NULL, 'Ampang', '55000', 'Kuala Lumpur', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A054', 'Jalan Pandan Indah 444', 'Unit 11-7', 'Pandan Indah', '55100', 'Kuala Lumpur', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A055', 'Jalan Maluri 555', NULL, 'Maluri', '55100', 'Kuala Lumpur', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A056', 'Jalan Taman Connaught 666', 'Apt 6-4', 'Cheras', '56000', 'Kuala Lumpur', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A057', 'Jalan Taman Midah 777', NULL, 'Cheras', '56000', 'Kuala Lumpur', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A058', 'Jalan Shamelin 888', 'Villa 9', 'Cheras', '56100', 'Kuala Lumpur', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A059', 'Jalan Bukit Jalil 999', NULL, 'Bukit Jalil', '57000', 'Kuala Lumpur', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A060', 'Jalan OUG 1111', 'Unit 14-3', 'Old Klang Road', '58200', 'Kuala Lumpur', 'Malaysia', 'M015');
INSERT INTO Address VALUES ('A061', 'Jalan Sungai Besi 2222', NULL, 'Sungai Besi', '57100', 'Kuala Lumpur', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A062', 'Jalan Salak Selatan 3333', 'Apt 8-1', 'Salak Selatan', '57100', 'Kuala Lumpur', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A063', 'Jalan Taman Desa 4444', NULL, 'Taman Desa', '58100', 'Kuala Lumpur', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A064', 'Jalan Pantai 5555', 'Condo 21-8', 'Pantai', '59200', 'Kuala Lumpur', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A065', 'Jalan Kerinchi 6666', NULL, 'Kerinchi', '59200', 'Kuala Lumpur', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A066', 'Jalan Bangsar South 7777', 'Office Park 5', 'Bangsar', '59200', 'Kuala Lumpur', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A067', 'Jalan Brickfields 8888', NULL, 'Brickfields', '50470', 'Kuala Lumpur', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A068', 'Jalan Tun Sambanthan 9999', 'Unit 3-6', 'Brickfields', '50470', 'Kuala Lumpur', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A069', 'Jalan Petaling 1234', NULL, 'Petaling Street', '50000', 'Kuala Lumpur', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A070', 'Jalan Hang Lekiu 5678', 'Shop 88', 'Chinatown', '50000', 'Kuala Lumpur', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A071', 'Jalan USJ 1 123', NULL, 'USJ', '47600', 'Selangor', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A072', 'Jalan USJ 2 456', 'House 12', 'USJ', '47600', 'Selangor', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A073', 'Jalan USJ 3 789', NULL, 'USJ', '47600', 'Selangor', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A074', 'Jalan Puchong 1010', 'Apt 19-4', 'Puchong', '47100', 'Selangor', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A075', 'Jalan Puchong Prima 2020', NULL, 'Puchong', '47100', 'Selangor', 'Malaysia', 'M015');
INSERT INTO Address VALUES ('A076', 'Jalan Bandar Kinrara 3030', 'Unit 5-9', 'Puchong', '47180', 'Selangor', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A077', 'Jalan Taman Equine 4040', NULL, 'Seri Kembangan', '43300', 'Selangor', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A078', 'Jalan Cyberjaya 5050', 'Office 12-3', 'Cyberjaya', '63000', 'Selangor', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A079', 'Jalan Putrajaya 6060', NULL, 'Putrajaya', '62000', 'Putrajaya', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A080', 'Jalan Klang 7070', 'House 77', 'Klang', '41000', 'Selangor', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A081', 'Jalan Teluk Pulai 8080', NULL, 'Klang', '41100', 'Selangor', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A082', 'Jalan Meru 9090', 'Apt 2-7', 'Klang', '41050', 'Selangor', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A083', 'Jalan Banting 1212', NULL, 'Banting', '42700', 'Selangor', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A084', 'Jalan Morib 3434', 'Villa 25', 'Banting', '42700', 'Selangor', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A085', 'Jalan Sepang 5656', NULL, 'Sepang', '43900', 'Selangor', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A086', 'Jalan KLIA 7878', 'Unit 4-8', 'Sepang', '64000', 'Selangor', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A087', 'Jalan Nilai 1357', NULL, 'Nilai', '71800', 'Negeri Sembilan', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A088', 'Jalan Seremban 2468', 'House 55', 'Seremban', '70000', 'Negeri Sembilan', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A089', 'Jalan Port Dickson 3691', NULL, 'Port Dickson', '71000', 'Negeri Sembilan', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A090', 'Jalan Kajang 4812', 'Apt 13-5', 'Kajang', '43000', 'Selangor', 'Malaysia', 'M015');
INSERT INTO Address VALUES ('A091', 'Jalan Seri Kembangan 5923', NULL, 'Seri Kembangan', '43300', 'Selangor', 'Malaysia', 'M001');
INSERT INTO Address VALUES ('A092', 'Jalan Balakong 6134', 'House 42', 'Balakong', '43300', 'Selangor', 'Malaysia', 'M002');
INSERT INTO Address VALUES ('A093', 'Jalan Semenyih 7245', NULL, 'Semenyih', '43500', 'Selangor', 'Malaysia', 'M003');
INSERT INTO Address VALUES ('A094', 'Jalan Bangi 8356', 'Unit 16-2', 'Bangi', '43650', 'Selangor', 'Malaysia', 'M004');
INSERT INTO Address VALUES ('A095', 'Jalan UKM 9467', NULL, 'Bangi', '43600', 'Selangor', 'Malaysia', 'M005');
INSERT INTO Address VALUES ('A096', 'Jalan Putrajaya Presint 1578', 'Condo 10-4', 'Putrajaya', '62000', 'Putrajaya', 'Malaysia', 'M006');
INSERT INTO Address VALUES ('A097', 'Jalan Ara Damansara 2689', NULL, 'Ara Damansara', '47301', 'Selangor', 'Malaysia', 'M007');
INSERT INTO Address VALUES ('A098', 'Jalan Kota Damansara 3790', 'Office 8-6', 'Kota Damansara', '47810', 'Selangor', 'Malaysia', 'M008');
INSERT INTO Address VALUES ('A099', 'Jalan Tropicana 4801', NULL, 'Tropicana', '47410', 'Selangor', 'Malaysia', 'M009');
INSERT INTO Address VALUES ('A100', 'Jalan SS2 5912', 'Apt 22-9', 'Petaling Jaya', '47300', 'Selangor', 'Malaysia', 'M010');
INSERT INTO Address VALUES ('A101', 'Jalan SS15 6023', NULL, 'Subang Jaya', '47500', 'Selangor', 'Malaysia', 'M011');
INSERT INTO Address VALUES ('A102', 'Jalan SS18 7134', 'House 88', 'Subang Jaya', '47500', 'Selangor', 'Malaysia', 'M012');
INSERT INTO Address VALUES ('A103', 'Jalan Kelana Jaya 8245', NULL, 'Kelana Jaya', '47301', 'Selangor', 'Malaysia', 'M013');
INSERT INTO Address VALUES ('A104', 'Jalan Taman Bahagia 9356', 'Unit 7-1', 'Petaling Jaya', '47400', 'Selangor', 'Malaysia', 'M014');
INSERT INTO Address VALUES ('A105', 'Jalan Taman Megah 1467', NULL, 'Petaling Jaya', '47301', 'Selangor', 'Malaysia', 'M015');

-- Continue INSERT statements from script.sql

-- Insert Menu Items (100+ records - multiple per restaurant)
INSERT INTO Menu VALUES ('MN001', 'Nasi Kandar Special', 'Main Course', 0, 'Rice', 15.90, 4.6, 1, 'R001');
INSERT INTO Menu VALUES ('MN002', 'Roti Canai', 'Breakfast', 1, 'Bread', 2.50, 4.8, 1, 'R001');
INSERT INTO Menu VALUES ('MN003', 'Mee Goreng Mamak', 'Main Course', 0, 'Noodles', 8.90, 4.5, 1, 'R001');
INSERT INTO Menu VALUES ('MN004', 'Teh Tarik', 'Beverage', 0, 'Drink', 2.80, 4.7, 1, 'R001');
INSERT INTO Menu VALUES ('MN005', 'Ayam Goreng Berempah', 'Main Course', 0, 'Chicken', 12.90, 4.4, 1, 'R001');
INSERT INTO Menu VALUES ('MN006', 'Nasi Lemak', 'Main Course', 1, 'Rice', 6.90, 4.5, 1, 'R001');
INSERT INTO Menu VALUES ('MN007', 'Maggi Goreng', 'Main Course', 1, 'Noodles', 7.50, 4.3, 1, 'R001');
INSERT INTO Menu VALUES ('MN008', 'Original Recipe Chicken', 'Main Course', 0, 'Chicken', 18.90, 4.5, 1, 'R002');
INSERT INTO Menu VALUES ('MN009', 'Zinger Burger', 'Main Course', 0, 'Burger', 12.50, 4.4, 1, 'R002');
INSERT INTO Menu VALUES ('MN010', 'Popcorn Chicken', 'Snack', 0, 'Chicken', 9.90, 4.6, 1, 'R002');
INSERT INTO Menu VALUES ('MN011', 'Coleslaw', 'Side Dish', 1, 'Salad', 4.50, 4.2, 1, 'R002');
INSERT INTO Menu VALUES ('MN012', 'Whipped Potato', 'Side Dish', 1, 'Potato', 4.50, 4.3, 1, 'R002');
INSERT INTO Menu VALUES ('MN013', 'Pepsi', 'Beverage', 0, 'Drink', 3.90, 4.0, 1, 'R002');
INSERT INTO Menu VALUES ('MN014', 'Cheese Fries', 'Side Dish', 0, 'Potato', 7.90, 4.4, 1, 'R002');
INSERT INTO Menu VALUES ('MN015', 'Supreme Pizza', 'Main Course', 0, 'Pizza', 35.90, 4.3, 1, 'R003');
INSERT INTO Menu VALUES ('MN016', 'Hawaiian Pizza', 'Main Course', 0, 'Pizza', 32.90, 4.2, 1, 'R003');
INSERT INTO Menu VALUES ('MN017', 'Meat Lovers Pizza', 'Main Course', 0, 'Pizza', 38.90, 4.5, 1, 'R003');
INSERT INTO Menu VALUES ('MN018', 'Garlic Bread', 'Side Dish', 0, 'Bread', 8.90, 4.4, 1, 'R003');
INSERT INTO Menu VALUES ('MN019', 'Chicken Wings', 'Side Dish', 0, 'Chicken', 15.90, 4.3, 1, 'R003');
INSERT INTO Menu VALUES ('MN020', 'Carbonara Pasta', 'Main Course', 0, 'Pasta', 18.90, 4.2, 1, 'R003');
INSERT INTO Menu VALUES ('MN021', 'Coke', 'Beverage', 0, 'Drink', 3.90, 4.0, 1, 'R003');
INSERT INTO Menu VALUES ('MN022', 'Hainanese Chicken Chop', 'Main Course', 0, 'Chicken', 14.50, 4.8, 1, 'R004');
INSERT INTO Menu VALUES ('MN023', 'Roti Babi', 'Breakfast', 0, 'Bread', 3.50, 4.9, 1, 'R004');
INSERT INTO Menu VALUES ('MN024', 'Marble Cake', 'Dessert', 0, 'Cake', 4.00, 4.7, 1, 'R004');
INSERT INTO Menu VALUES ('MN025', 'Kaya Toast', 'Breakfast', 1, 'Bread', 3.00, 4.6, 1, 'R004');
INSERT INTO Menu VALUES ('MN026', 'Coffee', 'Beverage', 0, 'Drink', 2.50, 4.5, 1, 'R004');
INSERT INTO Menu VALUES ('MN027', 'Pork Chop', 'Main Course', 0, 'Pork', 16.50, 4.7, 1, 'R004');
INSERT INTO Menu VALUES ('MN028', 'Beef Noodles', 'Main Course', 0, 'Noodles', 12.00, 4.6, 1, 'R004');
INSERT INTO Menu VALUES ('MN029', 'Banana Leaf Rice', 'Main Course', 0, 'Rice', 13.90, 4.6, 1, 'R005');
INSERT INTO Menu VALUES ('MN030', 'Masala Thosai', 'Breakfast', 1, 'Bread', 4.50, 4.7, 1, 'R005');
INSERT INTO Menu VALUES ('MN031', 'Mutton Briyani', 'Main Course', 0, 'Rice', 16.90, 4.5, 1, 'R005');
INSERT INTO Menu VALUES ('MN032', 'Tandoori Chicken', 'Main Course', 0, 'Chicken', 19.90, 4.6, 1, 'R005');
INSERT INTO Menu VALUES ('MN033', 'Naan Bread', 'Side Dish', 0, 'Bread', 3.50, 4.4, 1, 'R005');
INSERT INTO Menu VALUES ('MN034', 'Mango Lassi', 'Beverage', 0, 'Drink', 5.90, 4.5, 1, 'R005');
INSERT INTO Menu VALUES ('MN035', 'Fish Curry', 'Main Course', 0, 'Fish', 14.90, 4.4, 1, 'R005');
INSERT INTO Menu VALUES ('MN036', 'Salmon Sushi', 'Main Course', 0, 'Sushi', 12.90, 4.7, 1, 'R006');
INSERT INTO Menu VALUES ('MN037', 'California Roll', 'Main Course', 0, 'Sushi', 8.90, 4.5, 1, 'R006');
INSERT INTO Menu VALUES ('MN038', 'Unagi Don', 'Main Course', 0, 'Rice', 18.90, 4.6, 1, 'R006');
INSERT INTO Menu VALUES ('MN039', 'Miso Soup', 'Soup', 1, 'Soup', 3.90, 4.3, 1, 'R006');
INSERT INTO Menu VALUES ('MN040', 'Tempura', 'Side Dish', 0, 'Fried', 9.90, 4.4, 1, 'R006');
INSERT INTO Menu VALUES ('MN041', 'Green Tea', 'Beverage', 0, 'Drink', 2.90, 4.2, 1, 'R006');
INSERT INTO Menu VALUES ('MN042', 'Salmon Sashimi', 'Main Course', 0, 'Sashimi', 15.90, 4.8, 1, 'R006');
INSERT INTO Menu VALUES ('MN043', 'Chocolate Indulgence Cake', 'Dessert', 0, 'Cake', 12.90, 4.6, 1, 'R007');
INSERT INTO Menu VALUES ('MN044', 'Chicken Chop', 'Main Course', 0, 'Chicken', 16.90, 4.3, 1, 'R007');
INSERT INTO Menu VALUES ('MN045', 'Nasi Lemak with Chicken', 'Main Course', 0, 'Rice', 14.90, 4.4, 1, 'R007');
INSERT INTO Menu VALUES ('MN046', 'Carbonara Spaghetti', 'Main Course', 0, 'Pasta', 17.90, 4.2, 1, 'R007');
INSERT INTO Menu VALUES ('MN047', 'Cheese Cake', 'Dessert', 0, 'Cake', 11.90, 4.5, 1, 'R007');
INSERT INTO Menu VALUES ('MN048', 'Iced Lemon Tea', 'Beverage', 0, 'Drink', 4.90, 4.1, 1, 'R007');
INSERT INTO Menu VALUES ('MN049', 'Fish and Chips', 'Main Course', 0, 'Fish', 18.90, 4.3, 1, 'R007');
INSERT INTO Menu VALUES ('MN050', 'Roasted Chicken Rice', 'Main Course', 0, 'Rice', 12.90, 4.7, 1, 'R008');
INSERT INTO Menu VALUES ('MN051', 'Steamed Chicken Rice', 'Main Course', 1, 'Rice', 11.90, 4.8, 1, 'R008');
INSERT INTO Menu VALUES ('MN052', 'Soy Sauce Chicken Rice', 'Main Course', 0, 'Rice', 12.90, 4.6, 1, 'R008');
INSERT INTO Menu VALUES ('MN053', 'Chicken Soup', 'Soup', 1, 'Soup', 4.90, 4.5, 1, 'R008');
INSERT INTO Menu VALUES ('MN054', 'Tofu', 'Side Dish', 1, 'Tofu', 3.90, 4.2, 1, 'R008');
INSERT INTO Menu VALUES ('MN055', 'Barley Drink', 'Beverage', 0, 'Drink', 3.50, 4.3, 1, 'R008');
INSERT INTO Menu VALUES ('MN056', 'Mixed Chicken Rice', 'Main Course', 0, 'Rice', 13.90, 4.7, 1, 'R008');
INSERT INTO Menu VALUES ('MN057', 'Chicken Teriyaki Sub', 'Main Course', 0, 'Sandwich', 12.90, 4.2, 1, 'R009');
INSERT INTO Menu VALUES ('MN058', 'Tuna Sub', 'Main Course', 0, 'Sandwich', 11.90, 4.0, 1, 'R009');
INSERT INTO Menu VALUES ('MN059', 'Veggie Delite', 'Main Course', 1, 'Sandwich', 9.90, 3.9, 1, 'R009');
INSERT INTO Menu VALUES ('MN060', 'Meatball Marinara', 'Main Course', 0, 'Sandwich', 13.90, 4.1, 1, 'R009');
INSERT INTO Menu VALUES ('MN061', 'Cookies', 'Dessert', 0, 'Cookie', 3.50, 4.0, 1, 'R009');
INSERT INTO Menu VALUES ('MN062', 'Sprite', 'Beverage', 0, 'Drink', 3.90, 3.8, 1, 'R009');
INSERT INTO Menu VALUES ('MN063', 'Turkey Breast Sub', 'Main Course', 0, 'Sandwich', 12.90, 4.0, 1, 'R009');
INSERT INTO Menu VALUES ('MN064', 'Quarter Chicken', 'Main Course', 0, 'Chicken', 16.90, 4.6, 1, 'R010');
INSERT INTO Menu VALUES ('MN065', 'Half Chicken', 'Main Course', 0, 'Chicken', 24.90, 4.7, 1, 'R010');
INSERT INTO Menu VALUES ('MN066', 'Peri Peri Chicken Wrap', 'Main Course', 0, 'Wrap', 14.90, 4.4, 1, 'R010');
INSERT INTO Menu VALUES ('MN067', 'Peri Peri Chips', 'Side Dish', 1, 'Potato', 6.90, 4.5, 1, 'R010');
INSERT INTO Menu VALUES ('MN068', 'Coleslaw', 'Side Dish', 1, 'Salad', 5.90, 4.2, 1, 'R010');
INSERT INTO Menu VALUES ('MN069', 'Iced Tea', 'Beverage', 0, 'Drink', 4.90, 4.3, 1, 'R010');
INSERT INTO Menu VALUES ('MN070', 'Full Chicken', 'Main Course', 0, 'Chicken', 39.90, 4.8, 1, 'R010');
INSERT INTO Menu VALUES ('MN071', 'Tom Yum Soup', 'Soup', 0, 'Soup', 12.90, 4.5, 1, 'R011');
INSERT INTO Menu VALUES ('MN072', 'Pad Thai', 'Main Course', 0, 'Noodles', 14.90, 4.6, 1, 'R011');
INSERT INTO Menu VALUES ('MN073', 'Green Curry Chicken', 'Main Course', 0, 'Curry', 16.90, 4.4, 1, 'R011');
INSERT INTO Menu VALUES ('MN074', 'Mango Sticky Rice', 'Dessert', 0, 'Dessert', 8.90, 4.7, 1, 'R011');
INSERT INTO Menu VALUES ('MN075', 'Thai Iced Tea', 'Beverage', 0, 'Drink', 4.90, 4.5, 1, 'R011');
INSERT INTO Menu VALUES ('MN076', 'Som Tam', 'Salad', 1, 'Salad', 9.90, 4.3, 1, 'R011');
INSERT INTO Menu VALUES ('MN077', 'Pineapple Fried Rice', 'Main Course', 0, 'Rice', 15.90, 4.4, 1, 'R011');
INSERT INTO Menu VALUES ('MN078', 'White Coffee', 'Beverage', 0, 'Drink', 4.50, 4.6, 1, 'R012');
INSERT INTO Menu VALUES ('MN079', 'Nasi Lemak', 'Main Course', 1, 'Rice', 8.90, 4.4, 1, 'R012');
INSERT INTO Menu VALUES ('MN080', 'Curry Laksa', 'Main Course', 0, 'Noodles', 11.90, 4.5, 1, 'R012');
INSERT INTO Menu VALUES ('MN081', 'Kaya Toast Set', 'Breakfast', 1, 'Bread', 6.50, 4.7, 1, 'R012');
INSERT INTO Menu VALUES ('MN082', 'Hainanese Chicken Chop', 'Main Course', 0, 'Chicken', 14.90, 4.3, 1, 'R012');
INSERT INTO Menu VALUES ('MN083', 'Egg Tart', 'Dessert', 0, 'Dessert', 3.50, 4.2, 1, 'R012');
INSERT INTO Menu VALUES ('MN084', 'Iced Milk Tea', 'Beverage', 0, 'Drink', 4.90, 4.4, 1, 'R012');
INSERT INTO Menu VALUES ('MN085', 'Crispy Chicken', 'Main Course', 0, 'Chicken', 17.90, 4.3, 1, 'R013');
INSERT INTO Menu VALUES ('MN086', 'Honey Butter Biscuit', 'Side Dish', 0, 'Bread', 3.50, 4.5, 1, 'R013');
INSERT INTO Menu VALUES ('MN087', 'Mashed Potato', 'Side Dish', 1, 'Potato', 4.90, 4.2, 1, 'R013');
INSERT INTO Menu VALUES ('MN088', 'Coleslaw', 'Side Dish', 1, 'Salad', 4.50, 4.1, 1, 'R013');
INSERT INTO Menu VALUES ('MN089', 'Chicken Burger', 'Main Course', 0, 'Burger', 11.90, 4.0, 1, 'R013');
INSERT INTO Menu VALUES ('MN090', 'Mountain Dew', 'Beverage', 0, 'Drink', 3.90, 3.9, 1, 'R013');
INSERT INTO Menu VALUES ('MN091', 'Chicken Tenders', 'Main Course', 0, 'Chicken', 13.90, 4.2, 1, 'R013');
INSERT INTO Menu VALUES ('MN092', 'Har Gow', 'Dim Sum', 0, 'Dumpling', 6.90, 4.6, 1, 'R014');
INSERT INTO Menu VALUES ('MN093', 'Siew Mai', 'Dim Sum', 0, 'Dumpling', 6.50, 4.7, 1, 'R014');
INSERT INTO Menu VALUES ('MN094', 'Char Siew Bao', 'Dim Sum', 0, 'Bun', 5.90, 4.5, 1, 'R014');
INSERT INTO Menu VALUES ('MN095', 'Steamed Chicken Feet', 'Dim Sum', 0, 'Chicken', 5.50, 4.2, 1, 'R014');
INSERT INTO Menu VALUES ('MN096', 'Egg Tart', 'Dessert', 0, 'Dessert', 4.50, 4.6, 1, 'R014');
INSERT INTO Menu VALUES ('MN097', 'Chinese Tea', 'Beverage', 0, 'Drink', 2.50, 4.3, 1, 'R014');
INSERT INTO Menu VALUES ('MN098', 'Lo Mai Gai', 'Dim Sum', 0, 'Rice', 7.90, 4.4, 1, 'R014');
INSERT INTO Menu VALUES ('MN099', 'Whopper', 'Main Course', 0, 'Burger', 13.90, 4.1, 1, 'R015');
INSERT INTO Menu VALUES ('MN100', 'Chicken Burger', 'Main Course', 0, 'Burger', 11.90, 3.9, 1, 'R015');
INSERT INTO Menu VALUES ('MN101', 'French Fries', 'Side Dish', 1, 'Potato', 5.90, 3.8, 1, 'R015');
INSERT INTO Menu VALUES ('MN102', 'Onion Rings', 'Side Dish', 0, 'Fried', 6.90, 4.0, 1, 'R015');
INSERT INTO Menu VALUES ('MN103', 'Chocolate Sundae', 'Dessert', 0, 'Ice Cream', 3.90, 3.7, 1, 'R015');
INSERT INTO Menu VALUES ('MN104', 'Coke', 'Beverage', 0, 'Drink', 3.90, 3.8, 1, 'R015');
INSERT INTO Menu VALUES ('MN105', 'Double Whopper', 'Main Course', 0, 'Burger', 18.90, 4.0, 1, 'R015');

-- ============================================
-- Order Records (100+ records)
-- ============================================
INSERT INTO `Order` VALUES ('O001', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Delivery', 'Completed', 45.80, 'Home Delivery', 'V001', 'A001', 'M001');
INSERT INTO `Order` VALUES ('O002', TO_DATE('2024-01-16', 'YYYY-MM-DD'), 'Delivery', 'Completed', 32.50, 'Home Delivery', NULL, 'A003', 'M002');
INSERT INTO `Order` VALUES ('O003', TO_DATE('2024-01-17', 'YYYY-MM-DD'), 'Pickup', 'Completed', 28.90, 'Self Pickup', 'V002', 'A004', 'M003');
INSERT INTO `Order` VALUES ('O004', TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'Delivery', 'Completed', 56.70, 'Home Delivery', NULL, 'A005', 'M004');
INSERT INTO `Order` VALUES ('O005', TO_DATE('2024-01-19', 'YYYY-MM-DD'), 'Delivery', 'Completed', 41.20, 'Home Delivery', 'V003', 'A006', 'M005');
INSERT INTO `Order` VALUES ('O006', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Delivery', 'Completed', 38.90, 'Home Delivery', NULL, 'A007', 'M006');
INSERT INTO `Order` VALUES ('O007', TO_DATE('2024-01-21', 'YYYY-MM-DD'), 'Pickup', 'Completed', 22.50, 'Self Pickup', 'V001', 'A008', 'M007');
INSERT INTO `Order` VALUES ('O008', TO_DATE('2024-01-22', 'YYYY-MM-DD'), 'Delivery', 'Completed', 67.80, 'Home Delivery', NULL, 'A009', 'M008');
INSERT INTO `Order` VALUES ('O009', TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'Delivery', 'Completed', 49.50, 'Home Delivery', 'V004', 'A010', 'M009');
INSERT INTO `Order` VALUES ('O010', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 'Delivery', 'Completed', 35.60, 'Home Delivery', NULL, 'A011', 'M010');
INSERT INTO `Order` VALUES ('O011', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Delivery', 'Completed', 52.30, 'Home Delivery', 'V005', 'A012', 'M011');
INSERT INTO `Order` VALUES ('O012', TO_DATE('2024-01-26', 'YYYY-MM-DD'), 'Pickup', 'Completed', 26.70, 'Self Pickup', NULL, 'A013', 'M012');
INSERT INTO `Order` VALUES ('O013', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 'Delivery', 'Completed', 44.90, 'Home Delivery', 'V006', 'A014', 'M013');
INSERT INTO `Order` VALUES ('O014', TO_DATE('2024-01-28', 'YYYY-MM-DD'), 'Delivery', 'Completed', 39.80, 'Home Delivery', NULL, 'A015', 'M014');
INSERT INTO `Order` VALUES ('O015', TO_DATE('2024-01-29', 'YYYY-MM-DD'), 'Delivery', 'Completed', 58.40, 'Home Delivery', 'V007', 'A016', 'M015');
INSERT INTO `Order` VALUES ('O016', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Delivery', 'Completed', 31.20, 'Home Delivery', NULL, 'A001', 'M001');
INSERT INTO `Order` VALUES ('O017', TO_DATE('2024-02-02', 'YYYY-MM-DD'), 'Delivery', 'Completed', 47.50, 'Home Delivery', 'V008', 'A002', 'M001');
INSERT INTO `Order` VALUES ('O018', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 'Pickup', 'Completed', 24.90, 'Self Pickup', NULL, 'A003', 'M002');
INSERT INTO `Order` VALUES ('O019', TO_DATE('2024-02-04', 'YYYY-MM-DD'), 'Delivery', 'Completed', 63.20, 'Home Delivery', 'V009', 'A017', 'M002');
INSERT INTO `Order` VALUES ('O020', TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Delivery', 'Completed', 36.80, 'Home Delivery', NULL, 'A004', 'M003');
INSERT INTO `Order` VALUES ('O021', TO_DATE('2024-02-06', 'YYYY-MM-DD'), 'Delivery', 'Completed', 54.30, 'Home Delivery', 'V010', 'A018', 'M003');
INSERT INTO `Order` VALUES ('O022', TO_DATE('2024-02-07', 'YYYY-MM-DD'), 'Delivery', 'Completed', 42.10, 'Home Delivery', NULL, 'A005', 'M004');
INSERT INTO `Order` VALUES ('O023', TO_DATE('2024-02-08', 'YYYY-MM-DD'), 'Pickup', 'Completed', 29.60, 'Self Pickup', 'V001', 'A019', 'M004');
INSERT INTO `Order` VALUES ('O024', TO_DATE('2024-02-09', 'YYYY-MM-DD'), 'Delivery', 'Completed', 48.70, 'Home Delivery', NULL, 'A006', 'M005');
INSERT INTO `Order` VALUES ('O025', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'Delivery', 'Completed', 55.90, 'Home Delivery', 'V002', 'A020', 'M005');
INSERT INTO `Order` VALUES ('O026', TO_DATE('2024-02-11', 'YYYY-MM-DD'), 'Delivery', 'Completed', 33.40, 'Home Delivery', NULL, 'A007', 'M006');
INSERT INTO `Order` VALUES ('O027', TO_DATE('2024-02-12', 'YYYY-MM-DD'), 'Delivery', 'Completed', 61.20, 'Home Delivery', 'V003', 'A021', 'M006');
INSERT INTO `Order` VALUES ('O028', TO_DATE('2024-02-13', 'YYYY-MM-DD'), 'Pickup', 'Completed', 27.80, 'Self Pickup', NULL, 'A008', 'M007');
INSERT INTO `Order` VALUES ('O029', TO_DATE('2024-02-14', 'YYYY-MM-DD'), 'Delivery', 'Completed', 45.60, 'Home Delivery', 'V004', 'A022', 'M007');
INSERT INTO `Order` VALUES ('O030', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Delivery', 'Completed', 38.50, 'Home Delivery', NULL, 'A009', 'M008');
INSERT INTO `Order` VALUES ('O031', TO_DATE('2024-02-16', 'YYYY-MM-DD'), 'Delivery', 'Completed', 52.90, 'Home Delivery', 'V005', 'A023', 'M008');
INSERT INTO `Order` VALUES ('O032', TO_DATE('2024-02-17', 'YYYY-MM-DD'), 'Delivery', 'Completed', 40.20, 'Home Delivery', NULL, 'A010', 'M009');
INSERT INTO `Order` VALUES ('O033', TO_DATE('2024-02-18', 'YYYY-MM-DD'), 'Pickup', 'Completed', 25.70, 'Self Pickup', 'V006', 'A024', 'M009');
INSERT INTO `Order` VALUES ('O034', TO_DATE('2024-02-19', 'YYYY-MM-DD'), 'Delivery', 'Completed', 59.80, 'Home Delivery', NULL, 'A011', 'M010');
INSERT INTO `Order` VALUES ('O035', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 'Delivery', 'Completed', 44.30, 'Home Delivery', 'V007', 'A025', 'M010');
INSERT INTO `Order` VALUES ('O036', TO_DATE('2024-02-21', 'YYYY-MM-DD'), 'Delivery', 'Completed', 37.60, 'Home Delivery', NULL, 'A012', 'M011');
INSERT INTO `Order` VALUES ('O037', TO_DATE('2024-02-22', 'YYYY-MM-DD'), 'Delivery', 'Completed', 50.40, 'Home Delivery', 'V008', 'A026', 'M011');
INSERT INTO `Order` VALUES ('O038', TO_DATE('2024-02-23', 'YYYY-MM-DD'), 'Pickup', 'Completed', 28.90, 'Self Pickup', NULL, 'A013', 'M012');
INSERT INTO `Order` VALUES ('O039', TO_DATE('2024-02-24', 'YYYY-MM-DD'), 'Delivery', 'Completed', 46.70, 'Home Delivery', 'V009', 'A027', 'M012');
INSERT INTO `Order` VALUES ('O040', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 'Delivery', 'Completed', 41.80, 'Home Delivery', NULL, 'A014', 'M013');
INSERT INTO `Order` VALUES ('O041', TO_DATE('2024-02-26', 'YYYY-MM-DD'), 'Delivery', 'Completed', 56.20, 'Home Delivery', 'V010', 'A028', 'M013');
INSERT INTO `Order` VALUES ('O042', TO_DATE('2024-02-27', 'YYYY-MM-DD'), 'Delivery', 'Completed', 34.50, 'Home Delivery', NULL, 'A015', 'M014');
INSERT INTO `Order` VALUES ('O043', TO_DATE('2024-02-28', 'YYYY-MM-DD'), 'Pickup', 'Completed', 30.20, 'Self Pickup', 'V001', 'A029', 'M014');
INSERT INTO `Order` VALUES ('O044', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Delivery', 'Completed', 49.90, 'Home Delivery', NULL, 'A016', 'M015');
INSERT INTO `Order` VALUES ('O045', TO_DATE('2024-03-02', 'YYYY-MM-DD'), 'Delivery', 'Completed', 43.60, 'Home Delivery', 'V002', 'A030', 'M015');
INSERT INTO `Order` VALUES ('O046', TO_DATE('2024-03-03', 'YYYY-MM-DD'), 'Delivery', 'Completed', 51.30, 'Home Delivery', NULL, 'A031', 'M001');
INSERT INTO `Order` VALUES ('O047', TO_DATE('2024-03-04', 'YYYY-MM-DD'), 'Delivery', 'Completed', 39.70, 'Home Delivery', 'V003', 'A032', 'M002');
INSERT INTO `Order` VALUES ('O048', TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'Pickup', 'Completed', 26.40, 'Self Pickup', NULL, 'A033', 'M003');
INSERT INTO `Order` VALUES ('O049', TO_DATE('2024-03-06', 'YYYY-MM-DD'), 'Delivery', 'Completed', 57.80, 'Home Delivery', 'V004', 'A034', 'M004');
INSERT INTO `Order` VALUES ('O050', TO_DATE('2024-03-07', 'YYYY-MM-DD'), 'Delivery', 'Completed', 45.20, 'Home Delivery', NULL, 'A035', 'M005');
INSERT INTO `Order` VALUES ('O051', TO_DATE('2024-03-08', 'YYYY-MM-DD'), 'Delivery', 'Completed', 62.40, 'Home Delivery', 'V005', 'A036', 'M006');
INSERT INTO `Order` VALUES ('O052', TO_DATE('2024-03-09', 'YYYY-MM-DD'), 'Delivery', 'Completed', 36.90, 'Home Delivery', NULL, 'A037', 'M007');
INSERT INTO `Order` VALUES ('O053', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'Pickup', 'Completed', 29.50, 'Self Pickup', 'V006', 'A038', 'M008');
INSERT INTO `Order` VALUES ('O054', TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'Delivery', 'Completed', 48.80, 'Home Delivery', NULL, 'A039', 'M009');
INSERT INTO `Order` VALUES ('O055', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'Delivery', 'Completed', 54.60, 'Home Delivery', 'V007', 'A040', 'M010');
INSERT INTO `Order` VALUES ('O056', TO_DATE('2024-03-13', 'YYYY-MM-DD'), 'Delivery', 'Completed', 42.30, 'Home Delivery', NULL, 'A041', 'M011');
INSERT INTO `Order` VALUES ('O057', TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'Delivery', 'Completed', 53.70, 'Home Delivery', 'V008', 'A042', 'M012');
INSERT INTO `Order` VALUES ('O058', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Pickup', 'Completed', 31.80, 'Self Pickup', NULL, 'A043', 'M013');
INSERT INTO `Order` VALUES ('O059', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 'Delivery', 'Completed', 47.90, 'Home Delivery', 'V009', 'A044', 'M014');
INSERT INTO `Order` VALUES ('O060', TO_DATE('2024-03-17', 'YYYY-MM-DD'), 'Delivery', 'Completed', 40.50, 'Home Delivery', NULL, 'A045', 'M015');
INSERT INTO `Order` VALUES ('O061', TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'Delivery', 'Completed', 58.20, 'Home Delivery', 'V010', 'A046', 'M001');
INSERT INTO `Order` VALUES ('O062', TO_DATE('2024-03-19', 'YYYY-MM-DD'), 'Delivery', 'Completed', 35.40, 'Home Delivery', NULL, 'A047', 'M002');
INSERT INTO `Order` VALUES ('O063', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Pickup', 'Completed', 27.60, 'Self Pickup', 'V001', 'A048', 'M003');
INSERT INTO `Order` VALUES ('O064', TO_DATE('2024-03-21', 'YYYY-MM-DD'), 'Delivery', 'Completed', 50.80, 'Home Delivery', NULL, 'A049', 'M004');
INSERT INTO `Order` VALUES ('O065', TO_DATE('2024-03-22', 'YYYY-MM-DD'), 'Delivery', 'Completed', 44.70, 'Home Delivery', 'V002', 'A050', 'M005');
INSERT INTO `Order` VALUES ('O066', TO_DATE('2024-03-23', 'YYYY-MM-DD'), 'Delivery', 'Completed', 61.50, 'Home Delivery', NULL, 'A051', 'M006');
INSERT INTO `Order` VALUES ('O067', TO_DATE('2024-03-24', 'YYYY-MM-DD'), 'Delivery', 'Completed', 38.20, 'Home Delivery', 'V003', 'A052', 'M007');
INSERT INTO `Order` VALUES ('O068', TO_DATE('2024-03-25', 'YYYY-MM-DD'), 'Pickup', 'Completed', 32.90, 'Self Pickup', NULL, 'A053', 'M008');
INSERT INTO `Order` VALUES ('O069', TO_DATE('2024-03-26', 'YYYY-MM-DD'), 'Delivery', 'Completed', 46.40, 'Home Delivery', 'V004', 'A054', 'M009');
INSERT INTO `Order` VALUES ('O070', TO_DATE('2024-03-27', 'YYYY-MM-DD'), 'Delivery', 'Completed', 52.10, 'Home Delivery', NULL, 'A055', 'M010');
INSERT INTO `Order` VALUES ('O071', TO_DATE('2024-03-28', 'YYYY-MM-DD'), 'Delivery', 'Completed', 39.80, 'Home Delivery', 'V005', 'A056', 'M011');
INSERT INTO `Order` VALUES ('O072', TO_DATE('2024-03-29', 'YYYY-MM-DD'), 'Delivery', 'Completed', 55.30, 'Home Delivery', NULL, 'A057', 'M012');
INSERT INTO `Order` VALUES ('O073', TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Pickup', 'Completed', 28.70, 'Self Pickup', 'V006', 'A058', 'M013');
INSERT INTO `Order` VALUES ('O074', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 'Delivery', 'Completed', 49.60, 'Home Delivery', NULL, 'A059', 'M014');
INSERT INTO `Order` VALUES ('O075', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Delivery', 'Completed', 43.90, 'Home Delivery', 'V007', 'A060', 'M015');
INSERT INTO `Order` VALUES ('O076', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Delivery', 'Completed', 57.40, 'Home Delivery', NULL, 'A061', 'M001');
INSERT INTO `Order` VALUES ('O077', TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'Delivery', 'Completed', 41.60, 'Home Delivery', 'V008', 'A062', 'M002');
INSERT INTO `Order` VALUES ('O078', TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Pickup', 'Completed', 30.80, 'Self Pickup', NULL, 'A063', 'M003');
INSERT INTO `Order` VALUES ('O079', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Delivery', 'Completed', 53.20, 'Home Delivery', 'V009', 'A064', 'M004');
INSERT INTO `Order` VALUES ('O080', TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'Delivery', 'Completed', 47.50, 'Home Delivery', NULL, 'A065', 'M005');
INSERT INTO `Order` VALUES ('O081', TO_DATE('2024-04-07', 'YYYY-MM-DD'), 'Delivery', 'Completed', 64.30, 'Home Delivery', 'V010', 'A066', 'M006');
INSERT INTO `Order` VALUES ('O082', TO_DATE('2024-04-08', 'YYYY-MM-DD'), 'Delivery', 'Completed', 36.70, 'Home Delivery', NULL, 'A067', 'M007');
INSERT INTO `Order` VALUES ('O083', TO_DATE('2024-04-09', 'YYYY-MM-DD'), 'Pickup', 'Completed', 29.90, 'Self Pickup', 'V001', 'A068', 'M008');
INSERT INTO `Order` VALUES ('O084', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Delivery', 'Completed', 51.80, 'Home Delivery', NULL, 'A069', 'M009');
INSERT INTO `Order` VALUES ('O085', TO_DATE('2024-04-11', 'YYYY-MM-DD'), 'Delivery', 'Completed', 45.40, 'Home Delivery', 'V002', 'A070', 'M010');
INSERT INTO `Order` VALUES ('O086', TO_DATE('2024-04-12', 'YYYY-MM-DD'), 'Delivery', 'Completed', 59.70, 'Home Delivery', NULL, 'A071', 'M011');
INSERT INTO `Order` VALUES ('O087', TO_DATE('2024-04-13', 'YYYY-MM-DD'), 'Delivery', 'Completed', 42.80, 'Home Delivery', 'V003', 'A072', 'M012');
INSERT INTO `Order` VALUES ('O088', TO_DATE('2024-04-14', 'YYYY-MM-DD'), 'Pickup', 'Completed', 33.50, 'Self Pickup', NULL, 'A073', 'M013');
INSERT INTO `Order` VALUES ('O089', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Delivery', 'Completed', 48.20, 'Home Delivery', 'V004', 'A074', 'M014');
INSERT INTO `Order` VALUES ('O090', TO_DATE('2024-04-16', 'YYYY-MM-DD'), 'Delivery', 'Completed', 54.90, 'Home Delivery', NULL, 'A075', 'M015');
INSERT INTO `Order` VALUES ('O091', TO_DATE('2024-04-17', 'YYYY-MM-DD'), 'Delivery', 'Completed', 40.60, 'Home Delivery', 'V005', 'A076', 'M001');
INSERT INTO `Order` VALUES ('O092', TO_DATE('2024-04-18', 'YYYY-MM-DD'), 'Delivery', 'Completed', 56.80, 'Home Delivery', NULL, 'A077', 'M002');
INSERT INTO `Order` VALUES ('O093', TO_DATE('2024-04-19', 'YYYY-MM-DD'), 'Pickup', 'Completed', 31.20, 'Self Pickup', 'V006', 'A078', 'M003');
INSERT INTO `Order` VALUES ('O094', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 'Delivery', 'Completed', 49.30, 'Home Delivery', NULL, 'A079', 'M004');
INSERT INTO `Order` VALUES ('O095', TO_DATE('2024-04-21', 'YYYY-MM-DD'), 'Delivery', 'Completed', 44.50, 'Home Delivery', 'V007', 'A080', 'M005');
INSERT INTO `Order` VALUES ('O096', TO_DATE('2024-04-22', 'YYYY-MM-DD'), 'Delivery', 'Completed', 62.70, 'Home Delivery', NULL, 'A081', 'M006');
INSERT INTO `Order` VALUES ('O097', TO_DATE('2024-04-23', 'YYYY-MM-DD'), 'Delivery', 'Completed', 37.90, 'Home Delivery', 'V008', 'A082', 'M007');
INSERT INTO `Order` VALUES ('O098', TO_DATE('2024-04-24', 'YYYY-MM-DD'), 'Pickup', 'Completed', 34.60, 'Self Pickup', NULL, 'A083', 'M008');
INSERT INTO `Order` VALUES ('O099', TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'Delivery', 'Completed', 50.20, 'Home Delivery', 'V009', 'A084', 'M009');
INSERT INTO `Order` VALUES ('O100', TO_DATE('2024-04-26', 'YYYY-MM-DD'), 'Delivery', 'Completed', 46.80, 'Home Delivery', NULL, 'A085', 'M010');
INSERT INTO `Order` VALUES ('O101', TO_DATE('2024-04-27', 'YYYY-MM-DD'), 'Delivery', 'Completed', 58.50, 'Home Delivery', 'V010', 'A086', 'M011');
INSERT INTO `Order` VALUES ('O102', TO_DATE('2024-04-28', 'YYYY-MM-DD'), 'Delivery', 'Completed', 41.30, 'Home Delivery', NULL, 'A087', 'M012');
INSERT INTO `Order` VALUES ('O103', TO_DATE('2024-04-29', 'YYYY-MM-DD'), 'Pickup', 'Completed', 32.40, 'Self Pickup', 'V001', 'A088', 'M013');
INSERT INTO `Order` VALUES ('O104', TO_DATE('2024-04-30', 'YYYY-MM-DD'), 'Delivery', 'Completed', 52.60, 'Home Delivery', NULL, 'A089', 'M014');
INSERT INTO `Order` VALUES ('O105', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Delivery', 'Completed', 47.70, 'Home Delivery', 'V002', 'A090', 'M015');

-- ============================================
-- Payment Records (100+ records)
-- ============================================
INSERT INTO Payment VALUES ('P001', 'Credit Card', 'Completed', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 45.80, 'O001');
INSERT INTO Payment VALUES ('P002', 'E-Wallet', 'Completed', TO_DATE('2024-01-16', 'YYYY-MM-DD'), 32.50, 'O002');
INSERT INTO Payment VALUES ('P003', 'Debit Card', 'Completed', TO_DATE('2024-01-17', 'YYYY-MM-DD'), 28.90, 'O003');
INSERT INTO Payment VALUES ('P004', 'Cash', 'Completed', TO_DATE('2024-01-18', 'YYYY-MM-DD'), 56.70, 'O004');
INSERT INTO Payment VALUES ('P005', 'Credit Card', 'Completed', TO_DATE('2024-01-19', 'YYYY-MM-DD'), 41.20, 'O005');
INSERT INTO Payment VALUES ('P006', 'E-Wallet', 'Completed', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 38.90, 'O006');
INSERT INTO Payment VALUES ('P007', 'Debit Card', 'Completed', TO_DATE('2024-01-21', 'YYYY-MM-DD'), 22.50, 'O007');
INSERT INTO Payment VALUES ('P008', 'Credit Card', 'Completed', TO_DATE('2024-01-22', 'YYYY-MM-DD'), 67.80, 'O008');
INSERT INTO Payment VALUES ('P009', 'E-Wallet', 'Completed', TO_DATE('2024-01-23', 'YYYY-MM-DD'), 49.50, 'O009');
INSERT INTO Payment VALUES ('P010', 'Cash', 'Completed', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 35.60, 'O010');
INSERT INTO Payment VALUES ('P011', 'Credit Card', 'Completed', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 52.30, 'O011');
INSERT INTO Payment VALUES ('P012', 'Debit Card', 'Completed', TO_DATE('2024-01-26', 'YYYY-MM-DD'), 26.70, 'O012');
INSERT INTO Payment VALUES ('P013', 'E-Wallet', 'Completed', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 44.90, 'O013');
INSERT INTO Payment VALUES ('P014', 'Credit Card', 'Completed', TO_DATE('2024-01-28', 'YYYY-MM-DD'), 39.80, 'O014');
INSERT INTO Payment VALUES ('P015', 'E-Wallet', 'Completed', TO_DATE('2024-01-29', 'YYYY-MM-DD'), 58.40, 'O015');
INSERT INTO Payment VALUES ('P016', 'Cash', 'Completed', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 31.20, 'O016');
INSERT INTO Payment VALUES ('P017', 'Credit Card', 'Completed', TO_DATE('2024-02-02', 'YYYY-MM-DD'), 47.50, 'O017');
INSERT INTO Payment VALUES ('P018', 'Debit Card', 'Completed', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 24.90, 'O018');
INSERT INTO Payment VALUES ('P019', 'E-Wallet', 'Completed', TO_DATE('2024-02-04', 'YYYY-MM-DD'), 63.20, 'O019');
INSERT INTO Payment VALUES ('P020', 'Credit Card', 'Completed', TO_DATE('2024-02-05', 'YYYY-MM-DD'), 36.80, 'O020');
INSERT INTO Payment VALUES ('P021', 'E-Wallet', 'Completed', TO_DATE('2024-02-06', 'YYYY-MM-DD'), 54.30, 'O021');
INSERT INTO Payment VALUES ('P022', 'Cash', 'Completed', TO_DATE('2024-02-07', 'YYYY-MM-DD'), 42.10, 'O022');
INSERT INTO Payment VALUES ('P023', 'Debit Card', 'Completed', TO_DATE('2024-02-08', 'YYYY-MM-DD'), 29.60, 'O023');
INSERT INTO Payment VALUES ('P024', 'Credit Card', 'Completed', TO_DATE('2024-02-09', 'YYYY-MM-DD'), 48.70, 'O024');
INSERT INTO Payment VALUES ('P025', 'E-Wallet', 'Completed', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 55.90, 'O025');
INSERT INTO Payment VALUES ('P026', 'Credit Card', 'Completed', TO_DATE('2024-02-11', 'YYYY-MM-DD'), 33.40, 'O026');
INSERT INTO Payment VALUES ('P027', 'E-Wallet', 'Completed', TO_DATE('2024-02-12', 'YYYY-MM-DD'), 61.20, 'O027');
INSERT INTO Payment VALUES ('P028', 'Debit Card', 'Completed', TO_DATE('2024-02-13', 'YYYY-MM-DD'), 27.80, 'O028');
INSERT INTO Payment VALUES ('P029', 'Cash', 'Completed', TO_DATE('2024-02-14', 'YYYY-MM-DD'), 45.60, 'O029');
INSERT INTO Payment VALUES ('P030', 'Credit Card', 'Completed', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 38.50, 'O030');
INSERT INTO Payment VALUES ('P031', 'E-Wallet', 'Completed', TO_DATE('2024-02-16', 'YYYY-MM-DD'), 52.90, 'O031');
INSERT INTO Payment VALUES ('P032', 'Credit Card', 'Completed', TO_DATE('2024-02-17', 'YYYY-MM-DD'), 40.20, 'O032');
INSERT INTO Payment VALUES ('P033', 'Debit Card', 'Completed', TO_DATE('2024-02-18', 'YYYY-MM-DD'), 25.70, 'O033');
INSERT INTO Payment VALUES ('P034', 'E-Wallet', 'Completed', TO_DATE('2024-02-19', 'YYYY-MM-DD'), 59.80, 'O034');
INSERT INTO Payment VALUES ('P035', 'Credit Card', 'Completed', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 44.30, 'O035');
INSERT INTO Payment VALUES ('P036', 'Cash', 'Completed', TO_DATE('2024-02-21', 'YYYY-MM-DD'), 37.60, 'O036');
INSERT INTO Payment VALUES ('P037', 'E-Wallet', 'Completed', TO_DATE('2024-02-22', 'YYYY-MM-DD'), 50.40, 'O037');
INSERT INTO Payment VALUES ('P038', 'Debit Card', 'Completed', TO_DATE('2024-02-23', 'YYYY-MM-DD'), 28.90, 'O038');
INSERT INTO Payment VALUES ('P039', 'Credit Card', 'Completed', TO_DATE('2024-02-24', 'YYYY-MM-DD'), 46.70, 'O039');
INSERT INTO Payment VALUES ('P040', 'E-Wallet', 'Completed', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 41.80, 'O040');
INSERT INTO Payment VALUES ('P041', 'Credit Card', 'Completed', TO_DATE('2024-02-26', 'YYYY-MM-DD'), 56.20, 'O041');
INSERT INTO Payment VALUES ('P042', 'Cash', 'Completed', TO_DATE('2024-02-27', 'YYYY-MM-DD'), 34.50, 'O042');
INSERT INTO Payment VALUES ('P043', 'Debit Card', 'Completed', TO_DATE('2024-02-28', 'YYYY-MM-DD'), 30.20, 'O043');
INSERT INTO Payment VALUES ('P044', 'E-Wallet', 'Completed', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 49.90, 'O044');
INSERT INTO Payment VALUES ('P045', 'Credit Card', 'Completed', TO_DATE('2024-03-02', 'YYYY-MM-DD'), 43.60, 'O045');
INSERT INTO Payment VALUES ('P046', 'E-Wallet', 'Completed', TO_DATE('2024-03-03', 'YYYY-MM-DD'), 51.30, 'O046');
INSERT INTO Payment VALUES ('P047', 'Credit Card', 'Completed', TO_DATE('2024-03-04', 'YYYY-MM-DD'), 39.70, 'O047');
INSERT INTO Payment VALUES ('P048', 'Debit Card', 'Completed', TO_DATE('2024-03-05', 'YYYY-MM-DD'), 26.40, 'O048');
INSERT INTO Payment VALUES ('P049', 'E-Wallet', 'Completed', TO_DATE('2024-03-06', 'YYYY-MM-DD'), 57.80, 'O049');
INSERT INTO Payment VALUES ('P050', 'Cash', 'Completed', TO_DATE('2024-03-07', 'YYYY-MM-DD'), 45.20, 'O050');
INSERT INTO Payment VALUES ('P051', 'Credit Card', 'Completed', TO_DATE('2024-03-08', 'YYYY-MM-DD'), 62.40, 'O051');
INSERT INTO Payment VALUES ('P052', 'E-Wallet', 'Completed', TO_DATE('2024-03-09', 'YYYY-MM-DD'), 36.90, 'O052');
INSERT INTO Payment VALUES ('P053', 'Debit Card', 'Completed', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 29.50, 'O053');
INSERT INTO Payment VALUES ('P054', 'Credit Card', 'Completed', TO_DATE('2024-03-11', 'YYYY-MM-DD'), 48.80, 'O054');
INSERT INTO Payment VALUES ('P055', 'E-Wallet', 'Completed', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 54.60, 'O055');
INSERT INTO Payment VALUES ('P056', 'Credit Card', 'Completed', TO_DATE('2024-03-13', 'YYYY-MM-DD'), 42.30, 'O056');
INSERT INTO Payment VALUES ('P057', 'E-Wallet', 'Completed', TO_DATE('2024-03-14', 'YYYY-MM-DD'), 53.70, 'O057');
INSERT INTO Payment VALUES ('P058', 'Debit Card', 'Completed', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 31.80, 'O058');
INSERT INTO Payment VALUES ('P059', 'Cash', 'Completed', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 47.90, 'O059');
INSERT INTO Payment VALUES ('P060', 'Credit Card', 'Completed', TO_DATE('2024-03-17', 'YYYY-MM-DD'), 40.50, 'O060');
INSERT INTO Payment VALUES ('P061', 'E-Wallet', 'Completed', TO_DATE('2024-03-18', 'YYYY-MM-DD'), 58.20, 'O061');
INSERT INTO Payment VALUES ('P062', 'Credit Card', 'Completed', TO_DATE('2024-03-19', 'YYYY-MM-DD'), 35.40, 'O062');
INSERT INTO Payment VALUES ('P063', 'Debit Card', 'Completed', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 27.60, 'O063');
INSERT INTO Payment VALUES ('P064', 'E-Wallet', 'Completed', TO_DATE('2024-03-21', 'YYYY-MM-DD'), 50.80, 'O064');
INSERT INTO Payment VALUES ('P065', 'Credit Card', 'Completed', TO_DATE('2024-03-22', 'YYYY-MM-DD'), 44.70, 'O065');
INSERT INTO Payment VALUES ('P066', 'E-Wallet', 'Completed', TO_DATE('2024-03-23', 'YYYY-MM-DD'), 61.50, 'O066');
INSERT INTO Payment VALUES ('P067', 'Cash', 'Completed', TO_DATE('2024-03-24', 'YYYY-MM-DD'), 38.20, 'O067');
INSERT INTO Payment VALUES ('P068', 'Debit Card', 'Completed', TO_DATE('2024-03-25', 'YYYY-MM-DD'), 32.90, 'O068');
INSERT INTO Payment VALUES ('P069', 'Credit Card', 'Completed', TO_DATE('2024-03-26', 'YYYY-MM-DD'), 46.40, 'O069');
INSERT INTO Payment VALUES ('P070', 'E-Wallet', 'Completed', TO_DATE('2024-03-27', 'YYYY-MM-DD'), 52.10, 'O070');
INSERT INTO Payment VALUES ('P071', 'Credit Card', 'Completed', TO_DATE('2024-03-28', 'YYYY-MM-DD'), 39.80, 'O071');
INSERT INTO Payment VALUES ('P072', 'E-Wallet', 'Completed', TO_DATE('2024-03-29', 'YYYY-MM-DD'), 55.30, 'O072');
INSERT INTO Payment VALUES ('P073', 'Debit Card', 'Completed', TO_DATE('2024-03-30', 'YYYY-MM-DD'), 28.70, 'O073');
INSERT INTO Payment VALUES ('P074', 'Cash', 'Completed', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 49.60, 'O074');
INSERT INTO Payment VALUES ('P075', 'Credit Card', 'Completed', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 43.90, 'O075');
INSERT INTO Payment VALUES ('P076', 'E-Wallet', 'Completed', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 57.40, 'O076');
INSERT INTO Payment VALUES ('P077', 'Credit Card', 'Completed', TO_DATE('2024-04-03', 'YYYY-MM-DD'), 41.60, 'O077');
INSERT INTO Payment VALUES ('P078', 'Debit Card', 'Completed', TO_DATE('2024-04-04', 'YYYY-MM-DD'), 30.80, 'O078');
INSERT INTO Payment VALUES ('P079', 'E-Wallet', 'Completed', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 53.20, 'O079');
INSERT INTO Payment VALUES ('P080', 'Credit Card', 'Completed', TO_DATE('2024-04-06', 'YYYY-MM-DD'), 47.50, 'O080');
INSERT INTO Payment VALUES ('P081', 'E-Wallet', 'Completed', TO_DATE('2024-04-07', 'YYYY-MM-DD'), 64.30, 'O081');
INSERT INTO Payment VALUES ('P082', 'Cash', 'Completed', TO_DATE('2024-04-08', 'YYYY-MM-DD'), 36.70, 'O082');
INSERT INTO Payment VALUES ('P083', 'Debit Card', 'Completed', TO_DATE('2024-04-09', 'YYYY-MM-DD'), 29.90, 'O083');
INSERT INTO Payment VALUES ('P084', 'Credit Card', 'Completed', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 51.80, 'O084');
INSERT INTO Payment VALUES ('P085', 'E-Wallet', 'Completed', TO_DATE('2024-04-11', 'YYYY-MM-DD'), 45.40, 'O085');
INSERT INTO Payment VALUES ('P086', 'Credit Card', 'Completed', TO_DATE('2024-04-12', 'YYYY-MM-DD'), 59.70, 'O086');
INSERT INTO Payment VALUES ('P087', 'E-Wallet', 'Completed', TO_DATE('2024-04-13', 'YYYY-MM-DD'), 42.80, 'O087');
INSERT INTO Payment VALUES ('P088', 'Debit Card', 'Completed', TO_DATE('2024-04-14', 'YYYY-MM-DD'), 33.50, 'O088');
INSERT INTO Payment VALUES ('P089', 'Cash', 'Completed', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 48.20, 'O089');
INSERT INTO Payment VALUES ('P090', 'Credit Card', 'Completed', TO_DATE('2024-04-16', 'YYYY-MM-DD'), 54.90, 'O090');
INSERT INTO Payment VALUES ('P091', 'E-Wallet', 'Completed', TO_DATE('2024-04-17', 'YYYY-MM-DD'), 40.60, 'O091');
INSERT INTO Payment VALUES ('P092', 'Credit Card', 'Completed', TO_DATE('2024-04-18', 'YYYY-MM-DD'), 56.80, 'O092');
INSERT INTO Payment VALUES ('P093', 'Debit Card', 'Completed', TO_DATE('2024-04-19', 'YYYY-MM-DD'), 31.20, 'O093');
INSERT INTO Payment VALUES ('P094', 'E-Wallet', 'Completed', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 49.30, 'O094');
INSERT INTO Payment VALUES ('P095', 'Credit Card', 'Completed', TO_DATE('2024-04-21', 'YYYY-MM-DD'), 44.50, 'O095');
INSERT INTO Payment VALUES ('P096', 'E-Wallet', 'Completed', TO_DATE('2024-04-22', 'YYYY-MM-DD'), 62.70, 'O096');
INSERT INTO Payment VALUES ('P097', 'Cash', 'Completed', TO_DATE('2024-04-23', 'YYYY-MM-DD'), 37.90, 'O097');
INSERT INTO Payment VALUES ('P098', 'Debit Card', 'Completed', TO_DATE('2024-04-24', 'YYYY-MM-DD'), 34.60, 'O098');
INSERT INTO Payment VALUES ('P099', 'Credit Card', 'Completed', TO_DATE('2024-04-25', 'YYYY-MM-DD'), 50.20, 'O099');
INSERT INTO Payment VALUES ('P100', 'E-Wallet', 'Completed', TO_DATE('2024-04-26', 'YYYY-MM-DD'), 46.80, 'O100');
INSERT INTO Payment VALUES ('P101', 'Credit Card', 'Completed', TO_DATE('2024-04-27', 'YYYY-MM-DD'), 58.50, 'O101');
INSERT INTO Payment VALUES ('P102', 'E-Wallet', 'Completed', TO_DATE('2024-04-28', 'YYYY-MM-DD'), 41.30, 'O102');
INSERT INTO Payment VALUES ('P103', 'Debit Card', 'Completed', TO_DATE('2024-04-29', 'YYYY-MM-DD'), 32.40, 'O103');
INSERT INTO Payment VALUES ('P104', 'Cash', 'Completed', TO_DATE('2024-04-30', 'YYYY-MM-DD'), 52.60, 'O104');
INSERT INTO Payment VALUES ('P105', 'Credit Card', 'Completed', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 47.70, 'O105');

-- ============================================
-- DeliveryService Records (100+ records)
-- ============================================
INSERT INTO DeliveryService VALUES ('DS001', 'GrabFood', 5.00, TO_DATE('2024-01-15 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-15 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O001');
INSERT INTO DeliveryService VALUES ('DS002', 'FoodPanda', 4.50, TO_DATE('2024-01-16 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-16 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O002');
INSERT INTO DeliveryService VALUES ('DS003', 'GrabFood', 5.00, TO_DATE('2024-01-18 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-18 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O004');
INSERT INTO DeliveryService VALUES ('DS004', 'FoodPanda', 4.50, TO_DATE('2024-01-19 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-19 19:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O005');
INSERT INTO DeliveryService VALUES ('DS005', 'Lalamove', 6.00, TO_DATE('2024-01-20 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-20 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O006');
INSERT INTO DeliveryService VALUES ('DS006', 'GrabFood', 5.00, TO_DATE('2024-01-22 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-22 18:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O008');
INSERT INTO DeliveryService VALUES ('DS007', 'FoodPanda', 4.50, TO_DATE('2024-01-23 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-23 20:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.2, 'O009');
INSERT INTO DeliveryService VALUES ('DS008', 'GrabFood', 5.00, TO_DATE('2024-01-24 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-24 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O010');
INSERT INTO DeliveryService VALUES ('DS009', 'Lalamove', 6.00, TO_DATE('2024-01-25 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-25 14:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O011');
INSERT INTO DeliveryService VALUES ('DS010', 'FoodPanda', 4.50, TO_DATE('2024-01-27 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-27 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O013');
INSERT INTO DeliveryService VALUES ('DS011', 'GrabFood', 5.00, TO_DATE('2024-01-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-28 12:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O014');
INSERT INTO DeliveryService VALUES ('DS012', 'FoodPanda', 4.50, TO_DATE('2024-01-29 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-29 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O015');
INSERT INTO DeliveryService VALUES ('DS013', 'GrabFood', 5.00, TO_DATE('2024-02-01 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-01 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O016');
INSERT INTO DeliveryService VALUES ('DS014', 'Lalamove', 6.00, TO_DATE('2024-02-02 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-02 17:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O017');
INSERT INTO DeliveryService VALUES ('DS015', 'FoodPanda', 4.50, TO_DATE('2024-02-04 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-04 21:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.2, 'O019');
INSERT INTO DeliveryService VALUES ('DS016', 'GrabFood', 5.00, TO_DATE('2024-02-05 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-05 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O020');
INSERT INTO DeliveryService VALUES ('DS017', 'FoodPanda', 4.50, TO_DATE('2024-02-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-06 18:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O021');
INSERT INTO DeliveryService VALUES ('DS018', 'GrabFood', 5.00, TO_DATE('2024-02-07 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-07 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O022');
INSERT INTO DeliveryService VALUES ('DS019', 'Lalamove', 6.00, TO_DATE('2024-02-09 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-09 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O024');
INSERT INTO DeliveryService VALUES ('DS020', 'FoodPanda', 4.50, TO_DATE('2024-02-10 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-10 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O025');
INSERT INTO DeliveryService VALUES ('DS021', 'GrabFood', 5.00, TO_DATE('2024-02-11 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O026');
INSERT INTO DeliveryService VALUES ('DS022', 'FoodPanda', 4.50, TO_DATE('2024-02-12 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-12 20:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O027');
INSERT INTO DeliveryService VALUES ('DS023', 'GrabFood', 5.00, TO_DATE('2024-02-14 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-14 19:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O029');
INSERT INTO DeliveryService VALUES ('DS024', 'Lalamove', 6.00, TO_DATE('2024-02-15 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-15 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O030');
INSERT INTO DeliveryService VALUES ('DS025', 'FoodPanda', 4.50, TO_DATE('2024-02-16 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-16 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O031');
INSERT INTO DeliveryService VALUES ('DS026', 'GrabFood', 5.00, TO_DATE('2024-02-17 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-17 12:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O032');
INSERT INTO DeliveryService VALUES ('DS027', 'FoodPanda', 4.50, TO_DATE('2024-02-19 17:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-19 18:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O034');
INSERT INTO DeliveryService VALUES ('DS028', 'GrabFood', 5.00, TO_DATE('2024-02-20 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-20 13:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O035');
INSERT INTO DeliveryService VALUES ('DS029', 'Lalamove', 6.00, TO_DATE('2024-02-21 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-21 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O036');
INSERT INTO DeliveryService VALUES ('DS030', 'FoodPanda', 4.50, TO_DATE('2024-02-22 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-22 21:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O037');
INSERT INTO DeliveryService VALUES ('DS031', 'GrabFood', 5.00, TO_DATE('2024-02-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-24 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O039');
INSERT INTO DeliveryService VALUES ('DS032', 'FoodPanda', 4.50, TO_DATE('2024-02-25 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-25 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O040');
INSERT INTO DeliveryService VALUES ('DS033', 'GrabFood', 5.00, TO_DATE('2024-02-26 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-26 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O041');
INSERT INTO DeliveryService VALUES ('DS034', 'Lalamove', 6.00, TO_DATE('2024-02-27 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-27 17:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.2, 'O042');
INSERT INTO DeliveryService VALUES ('DS035', 'FoodPanda', 4.50, TO_DATE('2024-03-01 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-01 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O044');
INSERT INTO DeliveryService VALUES ('DS036', 'GrabFood', 5.00, TO_DATE('2024-03-02 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-02 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O045');
INSERT INTO DeliveryService VALUES ('DS037', 'FoodPanda', 4.50, TO_DATE('2024-03-03 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-03 20:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O046');
INSERT INTO DeliveryService VALUES ('DS038', 'GrabFood', 5.00, TO_DATE('2024-03-04 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-04 13:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O047');
INSERT INTO DeliveryService VALUES ('DS039', 'Lalamove', 6.00, TO_DATE('2024-03-06 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-06 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O049');
INSERT INTO DeliveryService VALUES ('DS040', 'FoodPanda', 4.50, TO_DATE('2024-03-07 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-07 13:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O050');
INSERT INTO DeliveryService VALUES ('DS041', 'GrabFood', 5.00, TO_DATE('2024-03-08 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-08 18:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O051');
INSERT INTO DeliveryService VALUES ('DS042', 'FoodPanda', 4.50, TO_DATE('2024-03-09 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-09 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O052');
INSERT INTO DeliveryService VALUES ('DS043', 'GrabFood', 5.00, TO_DATE('2024-03-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-11 18:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O054');
INSERT INTO DeliveryService VALUES ('DS044', 'Lalamove', 6.00, TO_DATE('2024-03-12 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-12 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O055');
INSERT INTO DeliveryService VALUES ('DS045', 'FoodPanda', 4.50, TO_DATE('2024-03-13 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-13 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O056');
INSERT INTO DeliveryService VALUES ('DS046', 'GrabFood', 5.00, TO_DATE('2024-03-14 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-14 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O057');
INSERT INTO DeliveryService VALUES ('DS047', 'FoodPanda', 4.50, TO_DATE('2024-03-16 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-16 17:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O059');
INSERT INTO DeliveryService VALUES ('DS048', 'GrabFood', 5.00, TO_DATE('2024-03-17 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-17 12:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O060');
INSERT INTO DeliveryService VALUES ('DS049', 'Lalamove', 6.00, TO_DATE('2024-03-18 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-18 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O061');
INSERT INTO DeliveryService VALUES ('DS050', 'FoodPanda', 4.50, TO_DATE('2024-03-19 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-19 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O062');
INSERT INTO DeliveryService VALUES ('DS051', 'GrabFood', 5.00, TO_DATE('2024-03-21 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-21 19:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O064');
INSERT INTO DeliveryService VALUES ('DS052', 'FoodPanda', 4.50, TO_DATE('2024-03-22 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-22 13:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O065');
INSERT INTO DeliveryService VALUES ('DS053', 'GrabFood', 5.00, TO_DATE('2024-03-23 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-23 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O066');
INSERT INTO DeliveryService VALUES ('DS054', 'Lalamove', 6.00, TO_DATE('2024-03-24 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-24 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O067');
INSERT INTO DeliveryService VALUES ('DS055', 'FoodPanda', 4.50, TO_DATE('2024-03-26 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-26 18:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O069');
INSERT INTO DeliveryService VALUES ('DS056', 'GrabFood', 5.00, TO_DATE('2024-03-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-27 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O070');
INSERT INTO DeliveryService VALUES ('DS057', 'FoodPanda', 4.50, TO_DATE('2024-03-28 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-28 21:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O071');
INSERT INTO DeliveryService VALUES ('DS058', 'GrabFood', 5.00, TO_DATE('2024-03-29 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-29 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O072');
INSERT INTO DeliveryService VALUES ('DS059', 'Lalamove', 6.00, TO_DATE('2024-03-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-31 18:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O074');
INSERT INTO DeliveryService VALUES ('DS060', 'FoodPanda', 4.50, TO_DATE('2024-04-01 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-01 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O075');
INSERT INTO DeliveryService VALUES ('DS061', 'GrabFood', 5.00, TO_DATE('2024-04-02 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-02 20:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O076');
INSERT INTO DeliveryService VALUES ('DS062', 'FoodPanda', 4.50, TO_DATE('2024-04-03 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-03 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O077');
INSERT INTO DeliveryService VALUES ('DS063', 'GrabFood', 5.00, TO_DATE('2024-04-05 17:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-05 18:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O079');
INSERT INTO DeliveryService VALUES ('DS064', 'Lalamove', 6.00, TO_DATE('2024-04-06 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-06 13:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O080');
INSERT INTO DeliveryService VALUES ('DS065', 'FoodPanda', 4.50, TO_DATE('2024-04-07 20:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-07 21:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O081');
INSERT INTO DeliveryService VALUES ('DS066', 'GrabFood', 5.00, TO_DATE('2024-04-08 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-08 12:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O082');
INSERT INTO DeliveryService VALUES ('DS067', 'FoodPanda', 4.50, TO_DATE('2024-04-10 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-10 19:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O084');
INSERT INTO DeliveryService VALUES ('DS068', 'GrabFood', 5.00, TO_DATE('2024-04-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-11 12:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O085');
INSERT INTO DeliveryService VALUES ('DS069', 'Lalamove', 6.00, TO_DATE('2024-04-12 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-12 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O086');
INSERT INTO DeliveryService VALUES ('DS070', 'FoodPanda', 4.50, TO_DATE('2024-04-13 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-13 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O087');
INSERT INTO DeliveryService VALUES ('DS071', 'GrabFood', 5.00, TO_DATE('2024-04-15 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-15 17:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O089');
INSERT INTO DeliveryService VALUES ('DS072', 'FoodPanda', 4.50, TO_DATE('2024-04-16 11:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-16 12:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O090');
INSERT INTO DeliveryService VALUES ('DS073', 'GrabFood', 5.00, TO_DATE('2024-04-17 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-17 21:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O091');
INSERT INTO DeliveryService VALUES ('DS074', 'Lalamove', 6.00, TO_DATE('2024-04-18 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-18 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O092');
INSERT INTO DeliveryService VALUES ('DS075', 'FoodPanda', 4.50, TO_DATE('2024-04-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-20 18:50:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O094');
INSERT INTO DeliveryService VALUES ('DS076', 'GrabFood', 5.00, TO_DATE('2024-04-21 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-21 14:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O095');
INSERT INTO DeliveryService VALUES ('DS077', 'FoodPanda', 4.50, TO_DATE('2024-04-22 19:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-22 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.3, 'O096');
INSERT INTO DeliveryService VALUES ('DS078', 'GrabFood', 5.00, TO_DATE('2024-04-23 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-23 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O097');
INSERT INTO DeliveryService VALUES ('DS079', 'Lalamove', 6.00, TO_DATE('2024-04-25 17:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O099');
INSERT INTO DeliveryService VALUES ('DS080', 'FoodPanda', 4.50, TO_DATE('2024-04-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-26 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.4, 'O100');
INSERT INTO DeliveryService VALUES ('DS081', 'GrabFood', 5.00, TO_DATE('2024-04-27 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-27 21:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.6, 'O101');
INSERT INTO DeliveryService VALUES ('DS082', 'FoodPanda', 4.50, TO_DATE('2024-04-28 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-28 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.7, 'O102');
INSERT INTO DeliveryService VALUES ('DS083', 'GrabFood', 5.00, TO_DATE('2024-04-30 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-30 19:35:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.5, 'O104');
INSERT INTO DeliveryService VALUES ('DS084', 'Lalamove', 6.00, TO_DATE('2024-05-01 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-05-01 12:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered', 4.8, 'O105');

-- ============================================
-- MemberVoucher Records (100+ records)
-- ============================================
INSERT INTO MemberVoucher VALUES ('M001', 'V001', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M001', 'V002', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M001', 'V008', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M001', 'V010', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M001', 'V001', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M001', 'V002', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M001', 'V005', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M002', 'V003', TO_DATE('2024-01-12', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M002', 'V004', TO_DATE('2024-02-03', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M002', 'V009', TO_DATE('2024-03-03', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M002', 'V003', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M002', 'V007', TO_DATE('2024-04-17', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M002', 'V013', TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M003', 'V002', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M003', 'V006', TO_DATE('2024-02-17', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M003', 'V003', TO_DATE('2024-03-04', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M003', 'V001', TO_DATE('2024-03-19', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M003', 'V006', TO_DATE('2024-04-18', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M003', 'V010', TO_DATE('2024-05-03', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M004', 'V004', TO_DATE('2024-01-17', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V001', TO_DATE('2024-02-07', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V002', TO_DATE('2024-02-21', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V004', TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V009', TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V007', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V014', TO_DATE('2024-05-04', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M005', 'V003', TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M005', 'V002', TO_DATE('2024-02-09', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M005', 'V005', TO_DATE('2024-03-06', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M005', 'V010', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M005', 'V002', TO_DATE('2024-04-21', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M005', 'V008', TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M006', 'V006', TO_DATE('2024-01-19', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M006', 'V003', TO_DATE('2024-02-11', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M006', 'V001', TO_DATE('2024-03-08', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M006', 'V003', TO_DATE('2024-03-23', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M006', 'V008', TO_DATE('2024-04-22', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M006', 'V013', TO_DATE('2024-05-06', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M007', 'V001', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V004', TO_DATE('2024-02-13', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V006', TO_DATE('2024-03-09', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V003', TO_DATE('2024-03-24', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V001', TO_DATE('2024-04-08', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V009', TO_DATE('2024-04-23', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V015', TO_DATE('2024-05-07', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M008', 'V004', TO_DATE('2024-01-21', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M008', 'V005', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M008', 'V004', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M008', 'V006', TO_DATE('2024-03-25', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M008', 'V001', TO_DATE('2024-04-09', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M008', 'V010', TO_DATE('2024-05-08', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M009', 'V009', TO_DATE('2024-01-22', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M009', 'V006', TO_DATE('2024-02-17', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M009', 'V009', TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M009', 'V004', TO_DATE('2024-03-26', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M009', 'V009', TO_DATE('2024-04-24', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M009', 'V002', TO_DATE('2024-05-09', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M010', 'V007', TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M010', 'V005', TO_DATE('2024-02-19', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M010', 'V007', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M010', 'V010', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M010', 'V007', TO_DATE('2024-04-27', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M010', 'V003', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M011', 'V005', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V008', TO_DATE('2024-02-21', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V003', TO_DATE('2024-03-13', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V005', TO_DATE('2024-03-28', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V001', TO_DATE('2024-04-12', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V010', TO_DATE('2024-04-26', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V006', TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M012', 'V008', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V009', TO_DATE('2024-02-23', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V006', TO_DATE('2024-02-29', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V008', TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V009', TO_DATE('2024-04-13', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V001', TO_DATE('2024-04-28', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V004', TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M013', 'V006', TO_DATE('2024-01-26', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V010', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V001', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V010', TO_DATE('2024-03-30', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V003', TO_DATE('2024-04-13', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V001', TO_DATE('2024-04-29', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V007', TO_DATE('2024-05-13', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M014', 'V001', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M014', 'V004', TO_DATE('2024-02-27', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M014', 'V006', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M014', 'V001', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M014', 'V004', TO_DATE('2024-04-14', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M014', 'V009', TO_DATE('2024-05-14', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M015', 'V007', TO_DATE('2024-01-28', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M015', 'V002', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M015', 'V007', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M015', 'V002', TO_DATE('2024-04-16', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M015', 'V005', TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberVoucher VALUES ('M001', 'V003', TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M002', 'V001', TO_DATE('2024-01-08', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M003', 'V004', TO_DATE('2024-01-11', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M004', 'V005', TO_DATE('2024-01-14', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M005', 'V001', TO_DATE('2024-01-16', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M006', 'V002', TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M007', 'V003', TO_DATE('2024-01-22', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M008', 'V006', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M009', 'V001', TO_DATE('2024-01-28', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M010', 'V002', TO_DATE('2024-02-02', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M011', 'V004', TO_DATE('2024-02-06', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M012', 'V003', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M013', 'V005', TO_DATE('2024-02-14', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M014', 'V002', TO_DATE('2024-02-18', 'YYYY-MM-DD'), 'Used');
INSERT INTO MemberVoucher VALUES ('M015', 'V001', TO_DATE('2024-02-22', 'YYYY-MM-DD'), 'Used');


-- ============================================
-- ASSOCIATIVE/BRIDGE TABLES (300+ records each)
-- ============================================

-- Insert MemberMembership (350 records - members renew/change memberships over time)
-- Normal Members (ongoing)
INSERT INTO MemberMembership VALUES ('M001', 'MS001', TO_DATE('2023-01-10', 'YYYY-MM-DD'), TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberMembership VALUES ('M003', 'MS001', TO_DATE('2023-03-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberMembership VALUES ('M008', 'MS001', TO_DATE('2023-08-30', 'YYYY-MM-DD'), TO_DATE('2024-08-30', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberMembership VALUES ('M012', 'MS001', TO_DATE('2024-01-10', 'YYYY-MM-DD'), TO_DATE('2025-01-10', 'YYYY-MM-DD'), 'Active');
INSERT INTO MemberMembership VALUES ('M014', 'MS001', TO_DATE('2024-03-20', 'YYYY-MM-DD'), TO_DATE('2025-03-20', 'YYYY-MM-DD'), 'Active');

-- VIP Members (monthly renewals create many records)
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-02-15', 'YYYY-MM-DD'), TO_DATE('2023-03-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-03-15', 'YYYY-MM-DD'), TO_DATE('2023-04-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-04-15', 'YYYY-MM-DD'), TO_DATE('2023-05-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-05-15', 'YYYY-MM-DD'), TO_DATE('2023-06-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-06-15', 'YYYY-MM-DD'), TO_DATE('2023-07-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-07-15', 'YYYY-MM-DD'), TO_DATE('2023-08-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-08-15', 'YYYY-MM-DD'), TO_DATE('2023-09-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-09-15', 'YYYY-MM-DD'), TO_DATE('2023-10-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_DATE('2023-11-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-11-15', 'YYYY-MM-DD'), TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2023-12-15', 'YYYY-MM-DD'), TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-07-15', 'YYYY-MM-DD'), TO_DATE('2024-08-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-08-15', 'YYYY-MM-DD'), TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-09-15', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-10-15', 'YYYY-MM-DD'), TO_DATE('2024-11-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-11-15', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2024-12-15', 'YYYY-MM-DD'), TO_DATE('2025-01-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2025-01-15', 'YYYY-MM-DD'), TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M002', 'MS002', TO_DATE('2025-02-15', 'YYYY-MM-DD'), TO_DATE('2025-03-15', 'YYYY-MM-DD'), 'Active');

-- Member M004 VIP history
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-04-05', 'YYYY-MM-DD'), TO_DATE('2023-05-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-05-05', 'YYYY-MM-DD'), TO_DATE('2023-06-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-07-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-07-05', 'YYYY-MM-DD'), TO_DATE('2023-08-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-08-05', 'YYYY-MM-DD'), TO_DATE('2023-09-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-09-05', 'YYYY-MM-DD'), TO_DATE('2023-10-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-10-05', 'YYYY-MM-DD'), TO_DATE('2023-11-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-11-05', 'YYYY-MM-DD'), TO_DATE('2023-12-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2023-12-05', 'YYYY-MM-DD'), TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-01-05', 'YYYY-MM-DD'), TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-02-05', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-03-05', 'YYYY-MM-DD'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-04-05', 'YYYY-MM-DD'), TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-05-05', 'YYYY-MM-DD'), TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-07-05', 'YYYY-MM-DD'), TO_DATE('2024-08-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-08-05', 'YYYY-MM-DD'), TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-09-05', 'YYYY-MM-DD'), TO_DATE('2024-10-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-10-05', 'YYYY-MM-DD'), TO_DATE('2024-11-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-11-05', 'YYYY-MM-DD'), TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2024-12-05', 'YYYY-MM-DD'), TO_DATE('2025-01-05', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M004', 'MS002', TO_DATE('2025-01-05', 'YYYY-MM-DD'), TO_DATE('2025-02-05', 'YYYY-MM-DD'), 'Active');

-- Member M005 VIP history
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-05-12', 'YYYY-MM-DD'), TO_DATE('2023-06-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-06-12', 'YYYY-MM-DD'), TO_DATE('2023-07-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-07-12', 'YYYY-MM-DD'), TO_DATE('2023-08-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-08-12', 'YYYY-MM-DD'), TO_DATE('2023-09-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-09-12', 'YYYY-MM-DD'), TO_DATE('2023-10-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-10-12', 'YYYY-MM-DD'), TO_DATE('2023-11-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-11-12', 'YYYY-MM-DD'), TO_DATE('2023-12-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2023-12-12', 'YYYY-MM-DD'), TO_DATE('2024-01-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-01-12', 'YYYY-MM-DD'), TO_DATE('2024-02-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-02-12', 'YYYY-MM-DD'), TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-03-12', 'YYYY-MM-DD'), TO_DATE('2024-04-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-04-12', 'YYYY-MM-DD'), TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-05-12', 'YYYY-MM-DD'), TO_DATE('2024-06-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-06-12', 'YYYY-MM-DD'), TO_DATE('2024-07-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-07-12', 'YYYY-MM-DD'), TO_DATE('2024-08-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-08-12', 'YYYY-MM-DD'), TO_DATE('2024-09-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-09-12', 'YYYY-MM-DD'), TO_DATE('2024-10-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-10-12', 'YYYY-MM-DD'), TO_DATE('2024-11-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-11-12', 'YYYY-MM-DD'), TO_DATE('2024-12-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2024-12-12', 'YYYY-MM-DD'), TO_DATE('2025-01-12', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M005', 'MS002', TO_DATE('2025-01-12', 'YYYY-MM-DD'), TO_DATE('2025-02-12', 'YYYY-MM-DD'), 'Active');

-- Member M006 VIP history
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-06-18', 'YYYY-MM-DD'), TO_DATE('2023-07-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-07-18', 'YYYY-MM-DD'), TO_DATE('2023-08-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-08-18', 'YYYY-MM-DD'), TO_DATE('2023-09-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-09-18', 'YYYY-MM-DD'), TO_DATE('2023-10-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-10-18', 'YYYY-MM-DD'), TO_DATE('2023-11-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-11-18', 'YYYY-MM-DD'), TO_DATE('2023-12-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2023-12-18', 'YYYY-MM-DD'), TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-01-18', 'YYYY-MM-DD'), TO_DATE('2024-02-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-02-18', 'YYYY-MM-DD'), TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-03-18', 'YYYY-MM-DD'), TO_DATE('2024-04-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-04-18', 'YYYY-MM-DD'), TO_DATE('2024-05-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-05-18', 'YYYY-MM-DD'), TO_DATE('2024-06-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-06-18', 'YYYY-MM-DD'), TO_DATE('2024-07-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-07-18', 'YYYY-MM-DD'), TO_DATE('2024-08-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-08-18', 'YYYY-MM-DD'), TO_DATE('2024-09-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-09-18', 'YYYY-MM-DD'), TO_DATE('2024-10-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-10-18', 'YYYY-MM-DD'), TO_DATE('2024-11-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-11-18', 'YYYY-MM-DD'), TO_DATE('2024-12-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2024-12-18', 'YYYY-MM-DD'), TO_DATE('2025-01-18', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M006', 'MS002', TO_DATE('2025-01-18', 'YYYY-MM-DD'), TO_DATE('2025-02-18', 'YYYY-MM-DD'), 'Active');

-- Member M007 VIP history
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2023-07-22', 'YYYY-MM-DD'), TO_DATE('2023-08-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2023-08-22', 'YYYY-MM-DD'), TO_DATE('2023-09-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2023-09-22', 'YYYY-MM-DD'), TO_DATE('2023-10-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2023-10-22', 'YYYY-MM-DD'), TO_DATE('2023-11-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2023-11-22', 'YYYY-MM-DD'), TO_DATE('2023-12-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2023-12-22', 'YYYY-MM-DD'), TO_DATE('2024-01-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-01-22', 'YYYY-MM-DD'), TO_DATE('2024-02-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-02-22', 'YYYY-MM-DD'), TO_DATE('2024-03-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-03-22', 'YYYY-MM-DD'), TO_DATE('2024-04-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-04-22', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-05-22', 'YYYY-MM-DD'), TO_DATE('2024-06-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-06-22', 'YYYY-MM-DD'), TO_DATE('2024-07-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-07-22', 'YYYY-MM-DD'), TO_DATE('2024-08-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-08-22', 'YYYY-MM-DD'), TO_DATE('2024-09-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-09-22', 'YYYY-MM-DD'), TO_DATE('2024-10-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-10-22', 'YYYY-MM-DD'), TO_DATE('2024-11-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-11-22', 'YYYY-MM-DD'), TO_DATE('2024-12-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2024-12-22', 'YYYY-MM-DD'), TO_DATE('2025-01-22', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M007', 'MS002', TO_DATE('2025-01-22', 'YYYY-MM-DD'), TO_DATE('2025-02-22', 'YYYY-MM-DD'), 'Active');

-- Member M009 VIP history
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2023-09-15', 'YYYY-MM-DD'), TO_DATE('2023-10-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2023-10-15', 'YYYY-MM-DD'), TO_DATE('2023-11-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2023-11-15', 'YYYY-MM-DD'), TO_DATE('2023-12-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2023-12-15', 'YYYY-MM-DD'), TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-02-15', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-03-15', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-06-15', 'YYYY-MM-DD'), TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-07-15', 'YYYY-MM-DD'), TO_DATE('2024-08-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-08-15', 'YYYY-MM-DD'), TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-09-15', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-10-15', 'YYYY-MM-DD'), TO_DATE('2024-11-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-11-15', 'YYYY-MM-DD'), TO_DATE('2024-12-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2024-12-15', 'YYYY-MM-DD'), TO_DATE('2025-01-15', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M009', 'MS002', TO_DATE('2025-01-15', 'YYYY-MM-DD'), TO_DATE('2025-02-15', 'YYYY-MM-DD'), 'Active');

-- Member M010 VIP history
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2023-10-20', 'YYYY-MM-DD'), TO_DATE('2023-11-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2023-11-20', 'YYYY-MM-DD'), TO_DATE('2023-12-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2023-12-20', 'YYYY-MM-DD'), TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-01-20', 'YYYY-MM-DD'), TO_DATE('2024-02-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-02-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-03-20', 'YYYY-MM-DD'), TO_DATE('2024-04-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-04-20', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-05-20', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-08-20', 'YYYY-MM-DD'), TO_DATE('2024-09-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-09-20', 'YYYY-MM-DD'), TO_DATE('2024-10-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-10-20', 'YYYY-MM-DD'), TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-11-20', 'YYYY-MM-DD'), TO_DATE('2024-12-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2024-12-20', 'YYYY-MM-DD'), TO_DATE('2025-01-20', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M010', 'MS002', TO_DATE('2025-01-20', 'YYYY-MM-DD'), TO_DATE('2025-02-20', 'YYYY-MM-DD'), 'Active');

-- Member M011 Premium history
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2023-11-25', 'YYYY-MM-DD'), TO_DATE('2023-12-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2023-12-25', 'YYYY-MM-DD'), TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-01-25', 'YYYY-MM-DD'), TO_DATE('2024-02-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-02-25', 'YYYY-MM-DD'), TO_DATE('2024-03-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-03-25', 'YYYY-MM-DD'), TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-04-25', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-06-25', 'YYYY-MM-DD'), TO_DATE('2024-07-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-07-25', 'YYYY-MM-DD'), TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-08-25', 'YYYY-MM-DD'), TO_DATE('2024-09-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-09-25', 'YYYY-MM-DD'), TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-10-25', 'YYYY-MM-DD'), TO_DATE('2024-11-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-11-25', 'YYYY-MM-DD'), TO_DATE('2024-12-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2024-12-25', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M011', 'MS003', TO_DATE('2025-01-25', 'YYYY-MM-DD'), TO_DATE('2025-02-25', 'YYYY-MM-DD'), 'Active');

-- Member M013 Premium history
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-02-14', 'YYYY-MM-DD'), TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-03-14', 'YYYY-MM-DD'), TO_DATE('2024-04-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-04-14', 'YYYY-MM-DD'), TO_DATE('2024-05-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-05-14', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-06-14', 'YYYY-MM-DD'), TO_DATE('2024-07-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-07-14', 'YYYY-MM-DD'), TO_DATE('2024-08-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-08-14', 'YYYY-MM-DD'), TO_DATE('2024-09-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-09-14', 'YYYY-MM-DD'), TO_DATE('2024-10-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-10-14', 'YYYY-MM-DD'), TO_DATE('2024-11-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-11-14', 'YYYY-MM-DD'), TO_DATE('2024-12-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2024-12-14', 'YYYY-MM-DD'), TO_DATE('2025-01-14', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M013', 'MS003', TO_DATE('2025-01-14', 'YYYY-MM-DD'), TO_DATE('2025-02-14', 'YYYY-MM-DD'), 'Active');

-- Member M015 Premium history
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-04-25', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_DATE('2024-06-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-06-25', 'YYYY-MM-DD'), TO_DATE('2024-07-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-07-25', 'YYYY-MM-DD'), TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-08-25', 'YYYY-MM-DD'), TO_DATE('2024-09-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-09-25', 'YYYY-MM-DD'), TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-10-25', 'YYYY-MM-DD'), TO_DATE('2024-11-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-11-25', 'YYYY-MM-DD'), TO_DATE('2024-12-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2024-12-25', 'YYYY-MM-DD'), TO_DATE('2025-01-25', 'YYYY-MM-DD'), 'Expired');
INSERT INTO MemberMembership VALUES ('M015', 'MS003', TO_DATE('2025-01-25', 'YYYY-MM-DD'), TO_DATE('2025-02-25', 'YYYY-MM-DD'), 'Active');

-- ============================================
-- DeliveryRating Records (100+ records)
-- ============================================
INSERT INTO DeliveryRating VALUES ('DR001', 5, 'Excellent service! Driver was very polite.', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'DS001');
INSERT INTO DeliveryRating VALUES ('DR002', 4, 'Good delivery, arrived on time.', TO_DATE('2024-01-16', 'YYYY-MM-DD'), 'DS002');
INSERT INTO DeliveryRating VALUES ('DR003', 5, 'Fast and efficient delivery.', TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'DS003');
INSERT INTO DeliveryRating VALUES ('DR004', 5, 'Driver was careful with the food.', TO_DATE('2024-01-19', 'YYYY-MM-DD'), 'DS004');
INSERT INTO DeliveryRating VALUES ('DR005', 4, 'Delivery was smooth.', TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'DS005');
INSERT INTO DeliveryRating VALUES ('DR006', 5, 'Perfect delivery experience.', TO_DATE('2024-01-22', 'YYYY-MM-DD'), 'DS006');
INSERT INTO DeliveryRating VALUES ('DR007', 4, 'Good service overall.', TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'DS007');
INSERT INTO DeliveryRating VALUES ('DR008', 5, 'Very professional driver.', TO_DATE('2024-01-24', 'YYYY-MM-DD'), 'DS008');
INSERT INTO DeliveryRating VALUES ('DR009', 5, 'Arrived earlier than expected!', TO_DATE('2024-01-25', 'YYYY-MM-DD'), 'DS009');
INSERT INTO DeliveryRating VALUES ('DR010', 4, 'Food was still warm upon arrival.', TO_DATE('2024-01-27', 'YYYY-MM-DD'), 'DS010');
INSERT INTO DeliveryRating VALUES ('DR011', 5, 'Excellent communication from driver.', TO_DATE('2024-01-28', 'YYYY-MM-DD'), 'DS011');
INSERT INTO DeliveryRating VALUES ('DR012', 4, 'Satisfied with the delivery.', TO_DATE('2024-01-29', 'YYYY-MM-DD'), 'DS012');
INSERT INTO DeliveryRating VALUES ('DR013', 5, 'Quick and friendly service.', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'DS013');
INSERT INTO DeliveryRating VALUES ('DR014', 5, 'Driver followed instructions perfectly.', TO_DATE('2024-02-02', 'YYYY-MM-DD'), 'DS014');
INSERT INTO DeliveryRating VALUES ('DR015', 4, 'Good experience.', TO_DATE('2024-02-04', 'YYYY-MM-DD'), 'DS015');
INSERT INTO DeliveryRating VALUES ('DR016', 5, 'Very reliable service.', TO_DATE('2024-02-05', 'YYYY-MM-DD'), 'DS016');
INSERT INTO DeliveryRating VALUES ('DR017', 5, 'Outstanding delivery!', TO_DATE('2024-02-06', 'YYYY-MM-DD'), 'DS017');
INSERT INTO DeliveryRating VALUES ('DR018', 4, 'Driver was courteous.', TO_DATE('2024-02-07', 'YYYY-MM-DD'), 'DS018');
INSERT INTO DeliveryRating VALUES ('DR019', 5, 'Perfect timing!', TO_DATE('2024-02-09', 'YYYY-MM-DD'), 'DS019');
INSERT INTO DeliveryRating VALUES ('DR020', 5, 'Great service as always.', TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'DS020');
INSERT INTO DeliveryRating VALUES ('DR021', 4, 'Food arrived safely.', TO_DATE('2024-02-11', 'YYYY-MM-DD'), 'DS021');
INSERT INTO DeliveryRating VALUES ('DR022', 5, 'Very satisfied with delivery.', TO_DATE('2024-02-12', 'YYYY-MM-DD'), 'DS022');
INSERT INTO DeliveryRating VALUES ('DR023', 5, 'Driver was very helpful.', TO_DATE('2024-02-14', 'YYYY-MM-DD'), 'DS023');
INSERT INTO DeliveryRating VALUES ('DR024', 4, 'Good delivery service.', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'DS024');
INSERT INTO DeliveryRating VALUES ('DR025', 5, 'Excellent as usual.', TO_DATE('2024-02-16', 'YYYY-MM-DD'), 'DS025');
INSERT INTO DeliveryRating VALUES ('DR026', 5, 'Fast and professional.', TO_DATE('2024-02-17', 'YYYY-MM-DD'), 'DS026');
INSERT INTO DeliveryRating VALUES ('DR027', 5, 'Great experience!', TO_DATE('2024-02-19', 'YYYY-MM-DD'), 'DS027');
INSERT INTO DeliveryRating VALUES ('DR028', 4, 'Delivery was on time.', TO_DATE('2024-02-20', 'YYYY-MM-DD'), 'DS028');
INSERT INTO DeliveryRating VALUES ('DR029', 5, 'Very friendly driver.', TO_DATE('2024-02-21', 'YYYY-MM-DD'), 'DS029');
INSERT INTO DeliveryRating VALUES ('DR030', 5, 'Perfect service!', TO_DATE('2024-02-22', 'YYYY-MM-DD'), 'DS030');
INSERT INTO DeliveryRating VALUES ('DR031', 4, 'Good job!', TO_DATE('2024-02-24', 'YYYY-MM-DD'), 'DS031');
INSERT INTO DeliveryRating VALUES ('DR032', 5, 'Very reliable delivery.', TO_DATE('2024-02-25', 'YYYY-MM-DD'), 'DS032');
INSERT INTO DeliveryRating VALUES ('DR033', 5, 'Excellent service quality.', TO_DATE('2024-02-26', 'YYYY-MM-DD'), 'DS033');
INSERT INTO DeliveryRating VALUES ('DR034', 4, 'Satisfied with delivery.', TO_DATE('2024-02-27', 'YYYY-MM-DD'), 'DS034');
INSERT INTO DeliveryRating VALUES ('DR035', 5, 'Quick delivery!', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'DS035');
INSERT INTO DeliveryRating VALUES ('DR036', 5, 'Outstanding!', TO_DATE('2024-03-02', 'YYYY-MM-DD'), 'DS036');
INSERT INTO DeliveryRating VALUES ('DR037', 4, 'Good experience overall.', TO_DATE('2024-03-03', 'YYYY-MM-DD'), 'DS037');
INSERT INTO DeliveryRating VALUES ('DR038', 5, 'Very professional service.', TO_DATE('2024-03-04', 'YYYY-MM-DD'), 'DS038');
INSERT INTO DeliveryRating VALUES ('DR039', 5, 'Great delivery!', TO_DATE('2024-03-06', 'YYYY-MM-DD'), 'DS039');
INSERT INTO DeliveryRating VALUES ('DR040', 4, 'Food was fresh.', TO_DATE('2024-03-07', 'YYYY-MM-DD'), 'DS040');
INSERT INTO DeliveryRating VALUES ('DR041', 5, 'Excellent timing.', TO_DATE('2024-03-08', 'YYYY-MM-DD'), 'DS041');
INSERT INTO DeliveryRating VALUES ('DR042', 5, 'Very good service.', TO_DATE('2024-03-09', 'YYYY-MM-DD'), 'DS042');
INSERT INTO DeliveryRating VALUES ('DR043', 5, 'Perfect delivery.', TO_DATE('2024-03-11', 'YYYY-MM-DD'), 'DS043');
INSERT INTO DeliveryRating VALUES ('DR044', 5, 'Driver was excellent.', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'DS044');
INSERT INTO DeliveryRating VALUES ('DR045', 4, 'Good service.', TO_DATE('2024-03-13', 'YYYY-MM-DD'), 'DS045');
INSERT INTO DeliveryRating VALUES ('DR046', 5, 'Very satisfied!', TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'DS046');
INSERT INTO DeliveryRating VALUES ('DR047', 5, 'Great experience!', TO_DATE('2024-03-16', 'YYYY-MM-DD'), 'DS047');
INSERT INTO DeliveryRating VALUES ('DR048', 4, 'Delivery was smooth.', TO_DATE('2024-03-17', 'YYYY-MM-DD'), 'DS048');
INSERT INTO DeliveryRating VALUES ('DR049', 5, 'Excellent delivery service.', TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'DS049');
INSERT INTO DeliveryRating VALUES ('DR050', 5, 'Very reliable.', TO_DATE('2024-03-19', 'YYYY-MM-DD'), 'DS050');
INSERT INTO DeliveryRating VALUES ('DR051', 5, 'Perfect timing!', TO_DATE('2024-03-21', 'YYYY-MM-DD'), 'DS051');
INSERT INTO DeliveryRating VALUES ('DR052', 5, 'Outstanding service!', TO_DATE('2024-03-22', 'YYYY-MM-DD'), 'DS052');
INSERT INTO DeliveryRating VALUES ('DR053', 4, 'Good job.', TO_DATE('2024-03-23', 'YYYY-MM-DD'), 'DS053');
INSERT INTO DeliveryRating VALUES ('DR054', 5, 'Very professional.', TO_DATE('2024-03-24', 'YYYY-MM-DD'), 'DS054');
INSERT INTO DeliveryRating VALUES ('DR055', 5, 'Excellent!', TO_DATE('2024-03-26', 'YYYY-MM-DD'), 'DS055');
INSERT INTO DeliveryRating VALUES ('DR056', 4, 'Satisfied with service.', TO_DATE('2024-03-27', 'YYYY-MM-DD'), 'DS056');
INSERT INTO DeliveryRating VALUES ('DR057', 5, 'Great delivery!', TO_DATE('2024-03-28', 'YYYY-MM-DD'), 'DS057');
INSERT INTO DeliveryRating VALUES ('DR058', 5, 'Perfect service!', TO_DATE('2024-03-29', 'YYYY-MM-DD'), 'DS058');
INSERT INTO DeliveryRating VALUES ('DR059', 5, 'Very good!', TO_DATE('2024-03-31', 'YYYY-MM-DD'), 'DS059');
INSERT INTO DeliveryRating VALUES ('DR060', 5, 'Excellent as always.', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'DS060');
INSERT INTO DeliveryRating VALUES ('DR061', 4, 'Good delivery.', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'DS061');
INSERT INTO DeliveryRating VALUES ('DR062', 5, 'Very satisfied.', TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'DS062');
INSERT INTO DeliveryRating VALUES ('DR063', 5, 'Outstanding!', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'DS063');
INSERT INTO DeliveryRating VALUES ('DR064', 4, 'Good experience.', TO_DATE('2024-04-06', 'YYYY-MM-DD'), 'DS064');
INSERT INTO DeliveryRating VALUES ('DR065', 5, 'Perfect delivery!', TO_DATE('2024-04-07', 'YYYY-MM-DD'), 'DS065');
INSERT INTO DeliveryRating VALUES ('DR066', 5, 'Excellent service.', TO_DATE('2024-04-08', 'YYYY-MM-DD'), 'DS066');
INSERT INTO DeliveryRating VALUES ('DR067', 5, 'Very reliable!', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'DS067');
INSERT INTO DeliveryRating VALUES ('DR068', 5, 'Great service!', TO_DATE('2024-04-11', 'YYYY-MM-DD'), 'DS068');
INSERT INTO DeliveryRating VALUES ('DR069', 4, 'Good delivery.', TO_DATE('2024-04-12', 'YYYY-MM-DD'), 'DS069');
INSERT INTO DeliveryRating VALUES ('DR070', 5, 'Very professional.', TO_DATE('2024-04-13', 'YYYY-MM-DD'), 'DS070');
INSERT INTO DeliveryRating VALUES ('DR071', 5, 'Perfect!', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'DS071');
INSERT INTO DeliveryRating VALUES ('DR072', 4, 'Satisfied.', TO_DATE('2024-04-16', 'YYYY-MM-DD'), 'DS072');
INSERT INTO DeliveryRating VALUES ('DR073', 5, 'Excellent delivery!', TO_DATE('2024-04-17', 'YYYY-MM-DD'), 'DS073');
INSERT INTO DeliveryRating VALUES ('DR074', 5, 'Outstanding service!', TO_DATE('2024-04-18', 'YYYY-MM-DD'), 'DS074');
INSERT INTO DeliveryRating VALUES ('DR075', 5, 'Very good!', TO_DATE('2024-04-20', 'YYYY-MM-DD'), 'DS075');
INSERT INTO DeliveryRating VALUES ('DR076', 5, 'Great experience!', TO_DATE('2024-04-21', 'YYYY-MM-DD'), 'DS076');
INSERT INTO DeliveryRating VALUES ('DR077', 4, 'Good service.', TO_DATE('2024-04-22', 'YYYY-MM-DD'), 'DS077');
INSERT INTO DeliveryRating VALUES ('DR078', 5, 'Very satisfied!', TO_DATE('2024-04-23', 'YYYY-MM-DD'), 'DS078');
INSERT INTO DeliveryRating VALUES ('DR079', 5, 'Perfect delivery!', TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'DS079');
INSERT INTO DeliveryRating VALUES ('DR080', 4, 'Good job.', TO_DATE('2024-04-26', 'YYYY-MM-DD'), 'DS080');
INSERT INTO DeliveryRating VALUES ('DR081', 5, 'Excellent!', TO_DATE('2024-04-27', 'YYYY-MM-DD'), 'DS081');
INSERT INTO DeliveryRating VALUES ('DR082', 5, 'Great service!', TO_DATE('2024-04-28', 'YYYY-MM-DD'), 'DS082');
INSERT INTO DeliveryRating VALUES ('DR083', 5, 'Very professional!', TO_DATE('2024-04-30', 'YYYY-MM-DD'), 'DS083');
INSERT INTO DeliveryRating VALUES ('DR084', 5, 'Outstanding delivery!', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'DS084');

-- ============================================
-- RestaurantRating Records (100+ records)
-- ============================================
INSERT INTO RestaurantRating VALUES ('RR001', 'M001', 'R001', 5, 'Amazing food! Best Nasi Kandar in town.', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR002', 'M002', 'R002', 4, 'Good KFC outlet. Fast service.', TO_DATE('2024-01-16', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR003', 'M003', 'R003', 4, 'Pizza was great but a bit pricey.', TO_DATE('2024-01-17', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR004', 'M004', 'R004', 5, 'Authentic Hainanese food. Love it!', TO_DATE('2024-01-18', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR005', 'M005', 'R005', 4, 'Good mamak food. Will return.', TO_DATE('2024-01-19', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR006', 'M006', 'R006', 4, 'Fresh sushi and good quality.', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR007', 'M007', 'R007', 4, 'Cakes are delicious!', TO_DATE('2024-01-21', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR008', 'M008', 'R008', 5, 'Best chicken rice ever!', TO_DATE('2024-01-22', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR009', 'M009', 'R009', 4, 'Healthy options available.', TO_DATE('2024-01-23', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR010', 'M010', 'R010', 5, 'Peri peri chicken is amazing!', TO_DATE('2024-01-24', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR011', 'M011', 'R011', 4, 'Authentic Thai flavors.', TO_DATE('2024-01-25', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR012', 'M012', 'R012', 4, 'Great coffee and ambiance.', TO_DATE('2024-01-26', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR013', 'M013', 'R013', 4, 'Good fried chicken.', TO_DATE('2024-01-27', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR014', 'M014', 'R014', 4, 'Delicious dim sum!', TO_DATE('2024-01-28', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR015', 'M015', 'R015', 4, 'Decent burgers.', TO_DATE('2024-01-29', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR016', 'M001', 'R002', 4, 'Always consistent quality.', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR017', 'M001', 'R003', 5, 'Supreme pizza is the best!', TO_DATE('2024-02-02', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR018', 'M002', 'R001', 5, 'Love the roti canai here!', TO_DATE('2024-02-03', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR019', 'M002', 'R004', 5, 'Historic place with great food.', TO_DATE('2024-02-04', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR020', 'M003', 'R005', 4, 'Good banana leaf rice.', TO_DATE('2024-02-05', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR021', 'M003', 'R006', 5, 'Fresh sashimi!', TO_DATE('2024-02-06', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR022', 'M004', 'R007', 4, 'Nice cakes for dessert.', TO_DATE('2024-02-07', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR023', 'M004', 'R008', 5, 'Tender and juicy chicken!', TO_DATE('2024-02-08', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR024', 'M005', 'R009', 4, 'Good sandwich options.', TO_DATE('2024-02-09', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR025', 'M005', 'R010', 5, 'Love the spicy chicken!', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR026', 'M006', 'R011', 4, 'Authentic Thai cuisine.', TO_DATE('2024-02-11', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR027', 'M006', 'R012', 5, 'Great place for coffee!', TO_DATE('2024-02-12', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR028', 'M007', 'R013', 4, 'Crispy chicken.', TO_DATE('2024-02-13', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR029', 'M007', 'R014', 5, 'Best dim sum in town!', TO_DATE('2024-02-14', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR030', 'M008', 'R015', 4, 'Good fast food option.', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR031', 'M008', 'R001', 5, 'Excellent mamak food!', TO_DATE('2024-02-16', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR032', 'M009', 'R002', 4, 'Good KFC as always.', TO_DATE('2024-02-17', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR033', 'M009', 'R003', 4, 'Pizza quality is consistent.', TO_DATE('2024-02-18', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR034', 'M010', 'R004', 5, 'Amazing Hainanese food!', TO_DATE('2024-02-19', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR035', 'M010', 'R005', 5, 'Great Indian food!', TO_DATE('2024-02-20', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR036', 'M011', 'R006', 4, 'Good sushi place.', TO_DATE('2024-02-21', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR037', 'M011', 'R007', 5, 'Love the cakes!', TO_DATE('2024-02-22', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR038', 'M012', 'R008', 5, 'Best chicken rice!', TO_DATE('2024-02-23', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR039', 'M012', 'R009', 4, 'Fresh ingredients.', TO_DATE('2024-02-24', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR040', 'M013', 'R010', 5, 'Peri peri is excellent!', TO_DATE('2024-02-25', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR041', 'M013', 'R011', 5, 'Authentic Thai taste!', TO_DATE('2024-02-26', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR042', 'M014', 'R012', 4, 'Good coffee spot.', TO_DATE('2024-02-27', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR043', 'M014', 'R013', 4, 'Tasty fried chicken.', TO_DATE('2024-02-28', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR044', 'M015', 'R014', 5, 'Delicious dim sum!', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR045', 'M015', 'R015', 4, 'Good burger joint.', TO_DATE('2024-03-02', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR046', 'M001', 'R001', 5, 'Always my favorite!', TO_DATE('2024-03-03', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR047', 'M002', 'R002', 4, 'Reliable quality.', TO_DATE('2024-03-04', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR048', 'M003', 'R003', 4, 'Great pizza!', TO_DATE('2024-03-05', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR049', 'M004', 'R004', 5, 'Authentic and delicious!', TO_DATE('2024-03-06', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR050', 'M005', 'R005', 5, 'Best mamak around!', TO_DATE('2024-03-07', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR051', 'M006', 'R006', 5, 'Fresh and tasty sushi.', TO_DATE('2024-03-08', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR052', 'M007', 'R007', 4, 'Good cakes.', TO_DATE('2024-03-09', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR053', 'M008', 'R008', 5, 'Excellent chicken rice!', TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR054', 'M009', 'R009', 4, 'Healthy and fresh.', TO_DATE('2024-03-11', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR055', 'M010', 'R010', 5, 'Love Nandos!', TO_DATE('2024-03-12', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR056', 'M011', 'R011', 4, 'Good Thai food.', TO_DATE('2024-03-13', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR057', 'M012', 'R012', 5, 'Great coffee!', TO_DATE('2024-03-14', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR058', 'M013', 'R013', 4, 'Good fried chicken.', TO_DATE('2024-03-15', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR059', 'M014', 'R014', 5, 'Amazing dim sum!', TO_DATE('2024-03-16', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR060', 'M015', 'R015', 4, 'Decent burgers.', TO_DATE('2024-03-17', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR061', 'M001', 'R006', 5, 'Love the sushi here!', TO_DATE('2024-03-18', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR062', 'M002', 'R007', 4, 'Good desserts.', TO_DATE('2024-03-19', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR063', 'M003', 'R008', 5, 'Best chicken rice!', TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR064', 'M004', 'R009', 4, 'Fresh sandwiches.', TO_DATE('2024-03-21', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR065', 'M005', 'R010', 5, 'Excellent peri peri!', TO_DATE('2024-03-22', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR066', 'M006', 'R011', 5, 'Authentic Thai!', TO_DATE('2024-03-23', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR067', 'M007', 'R012', 4, 'Good coffee place.', TO_DATE('2024-03-24', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR068', 'M008', 'R013', 4, 'Tasty chicken.', TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR069', 'M009', 'R014', 5, 'Love the dim sum!', TO_DATE('2024-03-26', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR070', 'M010', 'R015', 4, 'Good fast food.', TO_DATE('2024-03-27', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR071', 'M011', 'R001', 5, 'Best nasi kandar!', TO_DATE('2024-03-28', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR072', 'M012', 'R002', 5, 'Great KFC outlet!', TO_DATE('2024-03-29', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR073', 'M013', 'R003', 4, 'Good pizza.', TO_DATE('2024-03-30', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR074', 'M014', 'R004', 5, 'Excellent food!', TO_DATE('2024-03-31', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR075', 'M015', 'R005', 5, 'Great mamak!', TO_DATE('2024-04-01', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR076', 'M001', 'R006', 5, 'Fresh sushi!', TO_DATE('2024-04-02', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR077', 'M002', 'R007', 4, 'Nice cakes.', TO_DATE('2024-04-03', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR078', 'M003', 'R008', 5, 'Amazing chicken rice!', TO_DATE('2024-04-04', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR079', 'M004', 'R009', 4, 'Healthy options.', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR080', 'M005', 'R010', 5, 'Love it!', TO_DATE('2024-04-06', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR081', 'M006', 'R011', 5, 'Great Thai food!', TO_DATE('2024-04-07', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR082', 'M007', 'R012', 4, 'Good coffee.', TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR083', 'M008', 'R013', 4, 'Good chicken.', TO_DATE('2024-04-09', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR084', 'M009', 'R014', 5, 'Excellent dim sum!', TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR085', 'M010', 'R015', 4, 'Decent burgers.', TO_DATE('2024-04-11', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR086', 'M011', 'R001', 5, 'Always great!', TO_DATE('2024-04-12', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR087', 'M012', 'R002', 4, 'Consistent quality.', TO_DATE('2024-04-13', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR088', 'M013', 'R003', 4, 'Good pizza place.', TO_DATE('2024-04-14', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR089', 'M014', 'R004', 5, 'Love the food here!', TO_DATE('2024-04-15', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR090', 'M015', 'R005', 5, 'Best Indian food!', TO_DATE('2024-04-16', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR091', 'M001', 'R006', 5, 'Fresh and delicious!', TO_DATE('2024-04-17', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR092', 'M002', 'R007', 5, 'Great cakes!', TO_DATE('2024-04-18', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR093', 'M003', 'R008', 5, 'Perfect chicken rice!', TO_DATE('2024-04-19', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR094', 'M004', 'R009', 4, 'Good sandwiches.', TO_DATE('2024-04-20', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR095', 'M005', 'R010', 5, 'Excellent!', TO_DATE('2024-04-21', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR096', 'M006', 'R011', 5, 'Authentic flavors!', TO_DATE('2024-04-22', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR097', 'M007', 'R012', 4, 'Nice ambiance.', TO_DATE('2024-04-23', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR098', 'M008', 'R013', 4, 'Good fried chicken.', TO_DATE('2024-04-24', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR099', 'M009', 'R014', 5, 'Best dim sum!', TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR100', 'M010', 'R015', 4, 'Good burgers.', TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR101', 'M011', 'R001', 5, 'Excellent as always!', TO_DATE('2024-04-27', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR102', 'M012', 'R002', 5, 'Great food!', TO_DATE('2024-04-28', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR103', 'M013', 'R003', 4, 'Good pizza.', TO_DATE('2024-04-29', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR104', 'M014', 'R004', 5, 'Amazing!', TO_DATE('2024-04-30', 'YYYY-MM-DD'));
INSERT INTO RestaurantRating VALUES ('RR105', 'M015', 'R005', 5, 'Perfect!', TO_DATE('2024-05-01', 'YYYY-MM-DD'));

-- ============================================
-- MenuRating Records (100+ records)
-- ============================================
INSERT INTO MenuRating VALUES ('MR001', 'M001', 'MN001', 5, 'Best Nasi Kandar Special!', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR002', 'M002', 'MN008', 4, 'Crispy and delicious chicken.', TO_DATE('2024-01-16', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR003', 'M003', 'MN015', 4, 'Supreme pizza is great!', TO_DATE('2024-01-17', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR004', 'M004', 'MN022', 5, 'Love the Hainanese chicken chop!', TO_DATE('2024-01-18', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR005', 'M005', 'MN029', 4, 'Good banana leaf rice.', TO_DATE('2024-01-19', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR006', 'M006', 'MN036', 5, 'Fresh salmon sushi!', TO_DATE('2024-01-20', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR007', 'M007', 'MN043', 4, 'Chocolate cake is amazing!', TO_DATE('2024-01-21', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR008', 'M008', 'MN050', 5, 'Best roasted chicken rice!', TO_DATE('2024-01-22', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR009', 'M009', 'MN057', 4, 'Teriyaki sub is tasty.', TO_DATE('2024-01-23', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR010', 'M010', 'MN064', 5, 'Perfect peri peri chicken!', TO_DATE('2024-01-24', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR011', 'M011', 'MN071', 5, 'Tom Yum is authentic!', TO_DATE('2024-01-25', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR012', 'M012', 'MN002', 4, 'Roti Canai is crispy.', TO_DATE('2024-01-26', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR013', 'M013', 'MN009', 4, 'Zinger burger is good.', TO_DATE('2024-01-27', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR014', 'M014', 'MN016', 4, 'Hawaiian pizza is delicious!', TO_DATE('2024-01-28', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR015', 'M015', 'MN023', 5, 'Roti Babi is excellent!', TO_DATE('2024-01-29', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR016', 'M001', 'MN030', 5, 'Masala Thosai is perfect!', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR017', 'M001', 'MN037', 5, 'California Roll is fresh!', TO_DATE('2024-02-02', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR018', 'M002', 'MN044', 4, 'Chicken chop is good.', TO_DATE('2024-02-03', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR019', 'M002', 'MN051', 5, 'Steamed chicken rice is tender!', TO_DATE('2024-02-04', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR020', 'M003', 'MN058', 4, 'Tuna sub is fresh.', TO_DATE('2024-02-05', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR021', 'M003', 'MN065', 5, 'Half chicken is perfect!', TO_DATE('2024-02-06', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR022', 'M004', 'MN072', 5, 'Pad Thai is authentic!', TO_DATE('2024-02-07', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR023', 'M004', 'MN003', 5, 'Mee Goreng is delicious!', TO_DATE('2024-02-08', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR024', 'M005', 'MN010', 4, 'Popcorn chicken is crispy.', TO_DATE('2024-02-09', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR025', 'M005', 'MN017', 5, 'Meat Lovers pizza is the best!', TO_DATE('2024-02-10', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR026', 'M006', 'MN024', 5, 'Marble cake is amazing!', TO_DATE('2024-02-11', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR027', 'M006', 'MN031', 5, 'Mutton Briyani is perfect!', TO_DATE('2024-02-12', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR028', 'M007', 'MN038', 4, 'Unagi Don is delicious.', TO_DATE('2024-02-13', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR029', 'M007', 'MN045', 5, 'Nasi Lemak with chicken!', TO_DATE('2024-02-14', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR030', 'M008', 'MN052', 5, 'Soy sauce chicken is great!', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR031', 'M008', 'MN059', 4, 'Veggie Delite is fresh.', TO_DATE('2024-02-16', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR032', 'M009', 'MN066', 5, 'Peri Peri wrap is tasty!', TO_DATE('2024-02-17', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR033', 'M009', 'MN073', 5, 'Green curry is authentic!', TO_DATE('2024-02-18', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR034', 'M010', 'MN004', 5, 'Teh Tarik is perfect!', TO_DATE('2024-02-19', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR035', 'M010', 'MN011', 4, 'Coleslaw is fresh.', TO_DATE('2024-02-20', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR036', 'M011', 'MN018', 4, 'Garlic bread is good.', TO_DATE('2024-02-21', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR037', 'M011', 'MN025', 5, 'Kaya Toast is delicious!', TO_DATE('2024-02-22', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR038', 'M012', 'MN032', 5, 'Tandoori chicken is amazing!', TO_DATE('2024-02-23', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR039', 'M012', 'MN039', 4, 'Miso soup is good.', TO_DATE('2024-02-24', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR040', 'M013', 'MN046', 5, 'Carbonara is creamy!', TO_DATE('2024-02-25', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR041', 'M013', 'MN053', 5, 'Chicken soup is comforting!', TO_DATE('2024-02-26', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR042', 'M014', 'MN060', 4, 'Meatball marinara is tasty.', TO_DATE('2024-02-27', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR043', 'M014', 'MN067', 4, 'Peri Peri chips are good.', TO_DATE('2024-02-28', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR044', 'M015', 'MN074', 5, 'Mango sticky rice is perfect!', TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR045', 'M015', 'MN005', 5, 'Ayam Goreng is crispy!', TO_DATE('2024-03-02', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR046', 'M001', 'MN012', 4, 'Whipped potato is creamy.', TO_DATE('2024-03-03', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR047', 'M002', 'MN019', 5, 'Chicken wings are crispy!', TO_DATE('2024-03-04', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR048', 'M003', 'MN026', 4, 'Coffee is strong and good.', TO_DATE('2024-03-05', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR049', 'M004', 'MN033', 5, 'Naan bread is soft!', TO_DATE('2024-03-06', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR050', 'M005', 'MN040', 5, 'Tempura is crispy!', TO_DATE('2024-03-07', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR051', 'M006', 'MN047', 5, 'Cheese cake is delicious!', TO_DATE('2024-03-08', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR052', 'M007', 'MN054', 4, 'Tofu is fresh.', TO_DATE('2024-03-09', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR053', 'M008', 'MN061', 4, 'Cookies are good.', TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR054', 'M009', 'MN068', 5, 'Coleslaw is fresh!', TO_DATE('2024-03-11', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR055', 'M010', 'MN075', 5, 'Thai Iced Tea is perfect!', TO_DATE('2024-03-12', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR056', 'M011', 'MN006', 5, 'Nasi Lemak is amazing!', TO_DATE('2024-03-13', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR057', 'M012', 'MN013', 4, 'Pepsi is cold.', TO_DATE('2024-03-14', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR058', 'M013', 'MN020', 5, 'Carbonara pasta is creamy!', TO_DATE('2024-03-15', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR059', 'M014', 'MN027', 5, 'Pork chop is tender!', TO_DATE('2024-03-16', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR060', 'M015', 'MN034', 5, 'Mango Lassi is refreshing!', TO_DATE('2024-03-17', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR061', 'M001', 'MN041', 5, 'Green tea is soothing.', TO_DATE('2024-03-18', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR062', 'M002', 'MN048', 4, 'Iced lemon tea is good.', TO_DATE('2024-03-19', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR063', 'M003', 'MN055', 5, 'Barley drink is healthy!', TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR064', 'M004', 'MN062', 4, 'Sprite is refreshing.', TO_DATE('2024-03-21', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR065', 'M005', 'MN069', 5, 'Iced tea is perfect!', TO_DATE('2024-03-22', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR066', 'M006', 'MN076', 5, 'Som Tam is authentic!', TO_DATE('2024-03-23', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR067', 'M007', 'MN007', 4, 'Maggi Goreng is tasty.', TO_DATE('2024-03-24', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR068', 'M008', 'MN014', 4, 'Cheese fries are good.', TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR069', 'M009', 'MN021', 5, 'Coke is ice cold!', TO_DATE('2024-03-26', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR070', 'M010', 'MN028', 5, 'Beef noodles are delicious!', TO_DATE('2024-03-27', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR071', 'M011', 'MN035', 5, 'Fish curry is spicy!', TO_DATE('2024-03-28', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR072', 'M012', 'MN042', 5, 'Salmon sashimi is fresh!', TO_DATE('2024-03-29', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR073', 'M013', 'MN049', 4, 'Fish and chips are crispy.', TO_DATE('2024-03-30', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR074', 'M014', 'MN056', 5, 'Mixed chicken rice is great!', TO_DATE('2024-03-31', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR075', 'M015', 'MN063', 5, 'Turkey breast sub is healthy!', TO_DATE('2024-04-01', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR076', 'M001', 'MN070', 5, 'Full chicken is amazing!', TO_DATE('2024-04-02', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR077', 'M002', 'MN001', 5, 'Always love this dish!', TO_DATE('2024-04-03', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR078', 'M003', 'MN008', 4, 'Original recipe is classic.', TO_DATE('2024-04-04', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR079', 'M004', 'MN015', 5, 'Supreme is the best!', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR080', 'M005', 'MN022', 5, 'Chicken chop perfection!', TO_DATE('2024-04-06', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR081', 'M006', 'MN029', 5, 'Banana leaf rice is authentic!', TO_DATE('2024-04-07', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR082', 'M007', 'MN036', 4, 'Salmon sushi quality!', TO_DATE('2024-04-08', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR083', 'M008', 'MN043', 5, 'Chocolate indulgence!', TO_DATE('2024-04-09', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR084', 'M009', 'MN050', 5, 'Roasted chicken excellence!', TO_DATE('2024-04-10', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR085', 'M010', 'MN057', 4, 'Teriyaki sub is fresh.', TO_DATE('2024-04-11', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR086', 'M011', 'MN064', 5, 'Quarter chicken is perfect!', TO_DATE('2024-04-12', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR087', 'M012', 'MN071', 5, 'Tom Yum excellence!', TO_DATE('2024-04-13', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR088', 'M013', 'MN002', 4, 'Roti canai goodness.', TO_DATE('2024-04-14', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR089', 'M014', 'MN009', 5, 'Zinger is zesty!', TO_DATE('2024-04-15', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR090', 'M015', 'MN016', 5, 'Hawaiian pizza perfection!', TO_DATE('2024-04-16', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR091', 'M001', 'MN023', 5, 'Roti Babi is unique!', TO_DATE('2024-04-17', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR092', 'M002', 'MN030', 5, 'Masala Thosai perfection!', TO_DATE('2024-04-18', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR093', 'M003', 'MN037', 5, 'California roll freshness!', TO_DATE('2024-04-19', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR094', 'M004', 'MN044', 4, 'Chicken chop is good.', TO_DATE('2024-04-20', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR095', 'M005', 'MN051', 5, 'Steamed chicken perfection!', TO_DATE('2024-04-21', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR096', 'M006', 'MN058', 5, 'Tuna sub excellence!', TO_DATE('2024-04-22', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR097', 'M007', 'MN065', 4, 'Half chicken is great.', TO_DATE('2024-04-23', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR098', 'M008', 'MN072', 5, 'Pad Thai perfection!', TO_DATE('2024-04-24', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR099', 'M009', 'MN003', 5, 'Mee Goreng excellence!', TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR100', 'M010', 'MN010', 5, 'Popcorn chicken is crispy!', TO_DATE('2024-04-26', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR101', 'M011', 'MN017', 5, 'Meat lovers is amazing!', TO_DATE('2024-04-27', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR102', 'M012', 'MN024', 5, 'Marble cake perfection!', TO_DATE('2024-04-28', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR103', 'M013', 'MN031', 4, 'Mutton briyani is good.', TO_DATE('2024-04-29', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR104', 'M014', 'MN038', 5, 'Unagi Don excellence!', TO_DATE('2024-04-30', 'YYYY-MM-DD'));
INSERT INTO MenuRating VALUES ('MR105', 'M015', 'MN045', 5, 'Nasi Lemak perfection!', TO_DATE('2024-05-01', 'YYYY-MM-DD'));

-- ============================================
-- OrderDetails Records (300+ records - junction table)
-- ============================================
-- Order O001 items
INSERT INTO OrderDetails VALUES ('OD001', 'O001', 'MN001', 1, 15.90);
INSERT INTO OrderDetails VALUES ('OD002', 'O001', 'MN002', 2, 5.00);
INSERT INTO OrderDetails VALUES ('OD003', 'O001', 'MN004', 3, 8.40);
-- Order O002 items
INSERT INTO OrderDetails VALUES ('OD004', 'O002', 'MN008', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD005', 'O002', 'MN010', 1, 9.90);
INSERT INTO OrderDetails VALUES ('OD006', 'O002', 'MN013', 1, 3.90);
-- Order O003 items
INSERT INTO OrderDetails VALUES ('OD007', 'O003', 'MN015', 1, 35.90);
INSERT INTO OrderDetails VALUES ('OD008', 'O003', 'MN018', 2, 17.80);
-- Order O004 items
INSERT INTO OrderDetails VALUES ('OD009', 'O004', 'MN022', 2, 29.00);
INSERT INTO OrderDetails VALUES ('OD010', 'O004', 'MN024', 3, 12.00);
INSERT INTO OrderDetails VALUES ('OD011', 'O004', 'MN026', 2, 5.00);
-- Order O005 items
INSERT INTO OrderDetails VALUES ('OD012', 'O005', 'MN029', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD013', 'O005', 'MN032', 1, 19.90);
INSERT INTO OrderDetails VALUES ('OD014', 'O005', 'MN034', 2, 11.80);
-- Order O006 items
INSERT INTO OrderDetails VALUES ('OD015', 'O006', 'MN036', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD016', 'O006', 'MN039', 2, 7.80);
INSERT INTO OrderDetails VALUES ('OD017', 'O006', 'MN041', 1, 2.90);
-- Order O007 items
INSERT INTO OrderDetails VALUES ('OD018', 'O007', 'MN043', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD019', 'O007', 'MN047', 1, 11.90);
-- Order O008 items
INSERT INTO OrderDetails VALUES ('OD020', 'O008', 'MN050', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD021', 'O008', 'MN051', 2, 23.80);
INSERT INTO OrderDetails VALUES ('OD022', 'O008', 'MN053', 3, 14.70);
-- Order O009 items
INSERT INTO OrderDetails VALUES ('OD023', 'O009', 'MN057', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD024', 'O009', 'MN060', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD025', 'O009', 'MN061', 2, 7.00);
-- Order O010 items
INSERT INTO OrderDetails VALUES ('OD026', 'O010', 'MN064', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD027', 'O010', 'MN067', 2, 13.80);
INSERT INTO OrderDetails VALUES ('OD028', 'O010', 'MN069', 1, 4.90);
-- Order O011 items
INSERT INTO OrderDetails VALUES ('OD029', 'O011', 'MN071', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD030', 'O011', 'MN072', 1, 14.90);
INSERT INTO OrderDetails VALUES ('OD031', 'O011', 'MN075', 2, 9.80);
-- Order O012 items
INSERT INTO OrderDetails VALUES ('OD032', 'O012', 'MN002', 3, 7.50);
INSERT INTO OrderDetails VALUES ('OD033', 'O012', 'MN003', 2, 17.80);
INSERT INTO OrderDetails VALUES ('OD034', 'O012', 'MN004', 1, 2.80);
-- Order O013 items
INSERT INTO OrderDetails VALUES ('OD035', 'O013', 'MN009', 2, 25.00);
INSERT INTO OrderDetails VALUES ('OD036', 'O013', 'MN011', 2, 9.00);
INSERT INTO OrderDetails VALUES ('OD037', 'O013', 'MN014', 1, 7.90);
-- Order O014 items
INSERT INTO OrderDetails VALUES ('OD038', 'O014', 'MN016', 1, 32.90);
INSERT INTO OrderDetails VALUES ('OD039', 'O014', 'MN019', 1, 15.90);
-- Order O015 items
INSERT INTO OrderDetails VALUES ('OD040', 'O015', 'MN023', 3, 10.50);
INSERT INTO OrderDetails VALUES ('OD041', 'O015', 'MN025', 4, 12.00);
INSERT INTO OrderDetails VALUES ('OD042', 'O015', 'MN027', 2, 33.00);
-- Order O016 items
INSERT INTO OrderDetails VALUES ('OD043', 'O016', 'MN030', 2, 9.00);
INSERT INTO OrderDetails VALUES ('OD044', 'O016', 'MN031', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD045', 'O016', 'MN033', 1, 3.50);
-- Order O017 items
INSERT INTO OrderDetails VALUES ('OD046', 'O017', 'MN037', 3, 26.70);
INSERT INTO OrderDetails VALUES ('OD047', 'O017', 'MN038', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD048', 'O017', 'MN040', 1, 9.90);
-- Order O018 items
INSERT INTO OrderDetails VALUES ('OD049', 'O018', 'MN044', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD050', 'O018', 'MN048', 2, 9.80);
-- Order O019 items
INSERT INTO OrderDetails VALUES ('OD051', 'O019', 'MN052', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD052', 'O019', 'MN054', 3, 11.70);
INSERT INTO OrderDetails VALUES ('OD053', 'O019', 'MN056', 2, 27.80);
-- Order O020 items
INSERT INTO OrderDetails VALUES ('OD054', 'O020', 'MN058', 2, 23.80);
INSERT INTO OrderDetails VALUES ('OD055', 'O020', 'MN059', 1, 9.90);
INSERT INTO OrderDetails VALUES ('OD056', 'O020', 'MN062', 1, 3.90);
-- Order O021 items
INSERT INTO OrderDetails VALUES ('OD057', 'O021', 'MN065', 1, 24.90);
INSERT INTO OrderDetails VALUES ('OD058', 'O021', 'MN066', 1, 14.90);
INSERT INTO OrderDetails VALUES ('OD059', 'O021', 'MN068', 2, 11.80);
-- Order O022 items
INSERT INTO OrderDetails VALUES ('OD060', 'O022', 'MN072', 2, 29.80);
INSERT INTO OrderDetails VALUES ('OD061', 'O022', 'MN073', 1, 16.90);
-- Order O023 items
INSERT INTO OrderDetails VALUES ('OD062', 'O023', 'MN001', 1, 15.90);
INSERT INTO OrderDetails VALUES ('OD063', 'O023', 'MN005', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD064', 'O023', 'MN006', 1, 6.90);
-- Order O024 items
INSERT INTO OrderDetails VALUES ('OD065', 'O024', 'MN008', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD066', 'O024', 'MN012', 3, 13.50);
INSERT INTO OrderDetails VALUES ('OD067', 'O024', 'MN013', 2, 7.80);
-- Order O025 items
INSERT INTO OrderDetails VALUES ('OD068', 'O025', 'MN017', 1, 38.90);
INSERT INTO OrderDetails VALUES ('OD069', 'O025', 'MN020', 1, 18.90);
-- Order O026 items
INSERT INTO OrderDetails VALUES ('OD070', 'O026', 'MN022', 1, 14.50);
INSERT INTO OrderDetails VALUES ('OD071', 'O026', 'MN023', 2, 7.00);
INSERT INTO OrderDetails VALUES ('OD072', 'O026', 'MN028', 1, 12.00);
-- Order O027 items
INSERT INTO OrderDetails VALUES ('OD073', 'O027', 'MN032', 2, 39.80);
INSERT INTO OrderDetails VALUES ('OD074', 'O027', 'MN035', 1, 14.90);
INSERT INTO OrderDetails VALUES ('OD075', 'O027', 'MN034', 1, 5.90);
-- Order O028 items
INSERT INTO OrderDetails VALUES ('OD076', 'O028', 'MN036', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD077', 'O028', 'MN042', 1, 15.90);
-- Order O029 items
INSERT INTO OrderDetails VALUES ('OD078', 'O029', 'MN043', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD079', 'O029', 'MN046', 1, 17.90);
INSERT INTO OrderDetails VALUES ('OD080', 'O029', 'MN048', 1, 4.90);
-- Order O030 items
INSERT INTO OrderDetails VALUES ('OD081', 'O030', 'MN050', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD082', 'O030', 'MN055', 3, 10.50);
-- Order O031 items
INSERT INTO OrderDetails VALUES ('OD083', 'O031', 'MN057', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD084', 'O031', 'MN063', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD085', 'O031', 'MN062', 2, 7.80);
-- Order O032 items
INSERT INTO OrderDetails VALUES ('OD086', 'O032', 'MN064', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD087', 'O032', 'MN070', 1, 39.90);
-- Order O033 items
INSERT INTO OrderDetails VALUES ('OD088', 'O033', 'MN071', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD089', 'O033', 'MN074', 1, 8.90);
INSERT INTO OrderDetails VALUES ('OD090', 'O033', 'MN075', 1, 4.90);
-- Order O034 items
INSERT INTO OrderDetails VALUES ('OD091', 'O034', 'MN002', 4, 10.00);
INSERT INTO OrderDetails VALUES ('OD092', 'O034', 'MN007', 3, 22.50);
INSERT INTO OrderDetails VALUES ('OD093', 'O034', 'MN004', 4, 11.20);
-- Order O035 items
INSERT INTO OrderDetails VALUES ('OD094', 'O035', 'MN009', 2, 25.00);
INSERT INTO OrderDetails VALUES ('OD095', 'O035', 'MN014', 2, 15.80);
INSERT INTO OrderDetails VALUES ('OD096', 'O035', 'MN013', 1, 3.90);
-- Order O036 items
INSERT INTO OrderDetails VALUES ('OD097', 'O036', 'MN015', 1, 35.90);
INSERT INTO OrderDetails VALUES ('OD098', 'O036', 'MN021', 1, 3.90);
-- Order O037 items
INSERT INTO OrderDetails VALUES ('OD099', 'O037', 'MN025', 3, 9.00);
INSERT INTO OrderDetails VALUES ('OD100', 'O037', 'MN026', 4, 10.00);
INSERT INTO OrderDetails VALUES ('OD101', 'O037', 'MN027', 2, 33.00);
-- Order O038 items
INSERT INTO OrderDetails VALUES ('OD102', 'O038', 'MN029', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD103', 'O038', 'MN033', 2, 7.00);
INSERT INTO OrderDetails VALUES ('OD104', 'O038', 'MN034', 1, 5.90);
-- Order O039 items
INSERT INTO OrderDetails VALUES ('OD105', 'O039', 'MN037', 2, 17.80);
INSERT INTO OrderDetails VALUES ('OD106', 'O039', 'MN039', 3, 11.70);
INSERT INTO OrderDetails VALUES ('OD107', 'O039', 'MN041', 2, 5.80);
-- Order O040 items
INSERT INTO OrderDetails VALUES ('OD108', 'O040', 'MN045', 2, 29.80);
INSERT INTO OrderDetails VALUES ('OD109', 'O040', 'MN047', 1, 11.90);
-- Order O041 items
INSERT INTO OrderDetails VALUES ('OD110', 'O041', 'MN051', 3, 35.70);
INSERT INTO OrderDetails VALUES ('OD111', 'O041', 'MN053', 2, 9.80);
INSERT INTO OrderDetails VALUES ('OD112', 'O041', 'MN055', 2, 7.00);
-- Order O042 items
INSERT INTO OrderDetails VALUES ('OD113', 'O042', 'MN060', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD114', 'O042', 'MN059', 2, 19.80);
INSERT INTO OrderDetails VALUES ('OD115', 'O042', 'MN062', 1, 3.90);
-- Order O043 items
INSERT INTO OrderDetails VALUES ('OD116', 'O043', 'MN066', 1, 14.90);
INSERT INTO OrderDetails VALUES ('OD117', 'O043', 'MN067', 2, 13.80);
INSERT INTO OrderDetails VALUES ('OD118', 'O043', 'MN069', 1, 4.90);
-- Order O044 items
INSERT INTO OrderDetails VALUES ('OD119', 'O044', 'MN072', 2, 29.80);
INSERT INTO OrderDetails VALUES ('OD120', 'O044', 'MN076', 2, 19.80);
-- Order O045 items
INSERT INTO OrderDetails VALUES ('OD121', 'O045', 'MN001', 2, 31.80);
INSERT INTO OrderDetails VALUES ('OD122', 'O045', 'MN003', 1, 8.90);
INSERT INTO OrderDetails VALUES ('OD123', 'O045', 'MN004', 1, 2.80);
-- Order O046 items
INSERT INTO OrderDetails VALUES ('OD124', 'O046', 'MN008', 2, 37.80);
INSERT INTO OrderDetails VALUES ('OD125', 'O046', 'MN010', 1, 9.90);
INSERT INTO OrderDetails VALUES ('OD126', 'O046', 'MN013', 1, 3.90);
-- Order O047 items
INSERT INTO OrderDetails VALUES ('OD127', 'O047', 'MN016', 1, 32.90);
INSERT INTO OrderDetails VALUES ('OD128', 'O047', 'MN018', 1, 8.90);
-- Order O048 items
INSERT INTO OrderDetails VALUES ('OD129', 'O048', 'MN022', 1, 14.50);
INSERT INTO OrderDetails VALUES ('OD130', 'O048', 'MN024', 2, 8.00);
INSERT INTO OrderDetails VALUES ('OD131', 'O048', 'MN026', 1, 2.50);
-- Order O049 items
INSERT INTO OrderDetails VALUES ('OD132', 'O049', 'MN031', 2, 33.80);
INSERT INTO OrderDetails VALUES ('OD133', 'O049', 'MN032', 1, 19.90);
INSERT INTO OrderDetails VALUES ('OD134', 'O049', 'MN034', 1, 5.90);
-- Order O050 items
INSERT INTO OrderDetails VALUES ('OD135', 'O050', 'MN036', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD136', 'O050', 'MN038', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD137', 'O050', 'MN041', 1, 2.90);
-- Order O051 items
INSERT INTO OrderDetails VALUES ('OD138', 'O051', 'MN043', 3, 38.70);
INSERT INTO OrderDetails VALUES ('OD139', 'O051', 'MN049', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD140', 'O051', 'MN048', 1, 4.90);
-- Order O052 items
INSERT INTO OrderDetails VALUES ('OD141', 'O052', 'MN050', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD142', 'O052', 'MN054', 2, 7.80);
INSERT INTO OrderDetails VALUES ('OD143', 'O052', 'MN055', 1, 3.50);
-- Order O053 items
INSERT INTO OrderDetails VALUES ('OD144', 'O053', 'MN058', 1, 11.90);
INSERT INTO OrderDetails VALUES ('OD145', 'O053', 'MN061', 3, 10.50);
INSERT INTO OrderDetails VALUES ('OD146', 'O053', 'MN062', 2, 7.80);
-- Order O054 items
INSERT INTO OrderDetails VALUES ('OD147', 'O054', 'MN065', 1, 24.90);
INSERT INTO OrderDetails VALUES ('OD148', 'O054', 'MN068', 3, 17.70);
INSERT INTO OrderDetails VALUES ('OD149', 'O054', 'MN069', 1, 4.90);
-- Order O055 items
INSERT INTO OrderDetails VALUES ('OD150', 'O055', 'MN071', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD151', 'O055', 'MN073', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD152', 'O055', 'MN075', 2, 9.80);
-- Order O056 items
INSERT INTO OrderDetails VALUES ('OD153', 'O056', 'MN002', 5, 12.50);
INSERT INTO OrderDetails VALUES ('OD154', 'O056', 'MN006', 3, 20.70);
INSERT INTO OrderDetails VALUES ('OD155', 'O056', 'MN004', 3, 8.40);
-- Order O057 items
INSERT INTO OrderDetails VALUES ('OD156', 'O057', 'MN009', 3, 37.50);
INSERT INTO OrderDetails VALUES ('OD157', 'O057', 'MN012', 2, 9.00);
INSERT INTO OrderDetails VALUES ('OD158', 'O057', 'MN013', 2, 7.80);
-- Order O058 items
INSERT INTO OrderDetails VALUES ('OD159', 'O058', 'MN017', 1, 38.90);
-- Order O059 items
INSERT INTO OrderDetails VALUES ('OD160', 'O059', 'MN023', 4, 14.00);
INSERT INTO OrderDetails VALUES ('OD161', 'O059', 'MN027', 2, 33.00);
INSERT INTO OrderDetails VALUES ('OD162', 'O059', 'MN026', 1, 2.50);
-- Order O060 items
INSERT INTO OrderDetails VALUES ('OD163', 'O060', 'MN029', 2, 27.80);
INSERT INTO OrderDetails VALUES ('OD164', 'O060', 'MN035', 1, 14.90);
-- Order O061 items
INSERT INTO OrderDetails VALUES ('OD165', 'O061', 'MN036', 3, 38.70);
INSERT INTO OrderDetails VALUES ('OD166', 'O061', 'MN040', 2, 19.80);
INSERT INTO OrderDetails VALUES ('OD167', 'O061', 'MN041', 1, 2.90);
-- Order O062 items
INSERT INTO OrderDetails VALUES ('OD168', 'O062', 'MN044', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD169', 'O062', 'MN047', 1, 11.90);
INSERT INTO OrderDetails VALUES ('OD170', 'O062', 'MN048', 1, 4.90);
-- Order O063 items
INSERT INTO OrderDetails VALUES ('OD171', 'O063', 'MN052', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD172', 'O063', 'MN056', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD173', 'O063', 'MN055', 1, 3.50);
-- Order O064 items
INSERT INTO OrderDetails VALUES ('OD174', 'O064', 'MN057', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD175', 'O064', 'MN060', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD176', 'O064', 'MN062', 2, 7.80);
-- Order O065 items
INSERT INTO OrderDetails VALUES ('OD177', 'O065', 'MN064', 2, 33.80);
INSERT INTO OrderDetails VALUES ('OD178', 'O065', 'MN069', 2, 9.80);
-- Order O066 items
INSERT INTO OrderDetails VALUES ('OD179', 'O066', 'MN072', 3, 44.70);
INSERT INTO OrderDetails VALUES ('OD180', 'O066', 'MN074', 1, 8.90);
INSERT INTO OrderDetails VALUES ('OD181', 'O066', 'MN075', 2, 9.80);
-- Order O067 items
INSERT INTO OrderDetails VALUES ('OD182', 'O067', 'MN001', 2, 31.80);
INSERT INTO OrderDetails VALUES ('OD183', 'O067', 'MN005', 1, 12.90);
-- Order O068 items
INSERT INTO OrderDetails VALUES ('OD184', 'O068', 'MN008', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD185', 'O068', 'MN011', 2, 9.00);
INSERT INTO OrderDetails VALUES ('OD186', 'O068', 'MN014', 1, 7.90);
-- Order O069 items
INSERT INTO OrderDetails VALUES ('OD187', 'O069', 'MN015', 1, 35.90);
INSERT INTO OrderDetails VALUES ('OD188', 'O069', 'MN019', 1, 15.90);
-- Order O070 items
INSERT INTO OrderDetails VALUES ('OD189', 'O070', 'MN022', 2, 29.00);
INSERT INTO OrderDetails VALUES ('OD190', 'O070', 'MN025', 3, 9.00);
INSERT INTO OrderDetails VALUES ('OD191', 'O070', 'MN028', 1, 12.00);
-- Order O071 items
INSERT INTO OrderDetails VALUES ('OD192', 'O071', 'MN030', 3, 13.50);
INSERT INTO OrderDetails VALUES ('OD193', 'O071', 'MN033', 4, 14.00);
INSERT INTO OrderDetails VALUES ('OD194', 'O071', 'MN034', 2, 11.80);
-- Order O072 items
INSERT INTO OrderDetails VALUES ('OD195', 'O072', 'MN037', 4, 35.60);
INSERT INTO OrderDetails VALUES ('OD196', 'O072', 'MN042', 1, 15.90);
INSERT INTO OrderDetails VALUES ('OD197', 'O072', 'MN041', 1, 2.90);
-- Order O073 items
INSERT INTO OrderDetails VALUES ('OD198', 'O073', 'MN045', 1, 14.90);
INSERT INTO OrderDetails VALUES ('OD199', 'O073', 'MN046', 1, 17.90);
-- Order O074 items
INSERT INTO OrderDetails VALUES ('OD200', 'O074', 'MN050', 3, 38.70);
INSERT INTO OrderDetails VALUES ('OD201', 'O074', 'MN053', 2, 9.80);
INSERT INTO OrderDetails VALUES ('OD202', 'O074', 'MN055', 1, 3.50);
-- Order O075 items
INSERT INTO OrderDetails VALUES ('OD203', 'O075', 'MN059', 2, 19.80);
INSERT INTO OrderDetails VALUES ('OD204', 'O075', 'MN063', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD205', 'O075', 'MN062', 2, 7.80);
-- Order O076 items
INSERT INTO OrderDetails VALUES ('OD206', 'O076', 'MN065', 2, 49.80);
INSERT INTO OrderDetails VALUES ('OD207', 'O076', 'MN067', 1, 6.90);
INSERT INTO OrderDetails VALUES ('OD208', 'O076', 'MN069', 1, 4.90);
-- Order O077 items
INSERT INTO OrderDetails VALUES ('OD209', 'O077', 'MN071', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD210', 'O077', 'MN076', 1, 9.90);
INSERT INTO OrderDetails VALUES ('OD211', 'O077', 'MN075', 1, 4.90);
-- Order O078 items
INSERT INTO OrderDetails VALUES ('OD212', 'O078', 'MN003', 2, 17.80);
INSERT INTO OrderDetails VALUES ('OD213', 'O078', 'MN006', 1, 6.90);
INSERT INTO OrderDetails VALUES ('OD214', 'O078', 'MN007', 1, 7.50);
-- Order O079 items
INSERT INTO OrderDetails VALUES ('OD215', 'O079', 'MN010', 3, 29.70);
INSERT INTO OrderDetails VALUES ('OD216', 'O079', 'MN012', 3, 13.50);
INSERT INTO OrderDetails VALUES ('OD217', 'O079', 'MN013', 2, 7.80);
-- Order O080 items
INSERT INTO OrderDetails VALUES ('OD218', 'O080', 'MN016', 1, 32.90);
INSERT INTO OrderDetails VALUES ('OD219', 'O080', 'MN020', 1, 18.90);
-- Order O081 items
INSERT INTO OrderDetails VALUES ('OD220', 'O081', 'MN024', 5, 20.00);
INSERT INTO OrderDetails VALUES ('OD221', 'O081', 'MN027', 2, 33.00);
INSERT INTO OrderDetails VALUES ('OD222', 'O081', 'MN028', 1, 12.00);
-- Order O082 items
INSERT INTO OrderDetails VALUES ('OD223', 'O082', 'MN031', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD224', 'O082', 'MN033', 3, 10.50);
INSERT INTO OrderDetails VALUES ('OD225', 'O082', 'MN034', 2, 11.80);
-- Order O083 items
INSERT INTO OrderDetails VALUES ('OD226', 'O083', 'MN038', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD227', 'O083', 'MN039', 2, 7.80);
INSERT INTO OrderDetails VALUES ('OD228', 'O083', 'MN041', 1, 2.90);
-- Order O084 items
INSERT INTO OrderDetails VALUES ('OD229', 'O084', 'MN043', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD230', 'O084', 'MN049', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD231', 'O084', 'MN048', 1, 4.90);
-- Order O085 items
INSERT INTO OrderDetails VALUES ('OD232', 'O085', 'MN051', 3, 35.70);
INSERT INTO OrderDetails VALUES ('OD233', 'O085', 'MN054', 2, 7.80);
-- Order O086 items
INSERT INTO OrderDetails VALUES ('OD234', 'O086', 'MN057', 3, 38.70);
INSERT INTO OrderDetails VALUES ('OD235', 'O086', 'MN061', 4, 14.00);
INSERT INTO OrderDetails VALUES ('OD236', 'O086', 'MN062', 2, 7.80);
-- Order O087 items
INSERT INTO OrderDetails VALUES ('OD237', 'O087', 'MN066', 2, 29.80);
INSERT INTO OrderDetails VALUES ('OD238', 'O087', 'MN068', 2, 11.80);
INSERT INTO OrderDetails VALUES ('OD239', 'O087', 'MN069', 1, 4.90);
-- Order O088 items
INSERT INTO OrderDetails VALUES ('OD240', 'O088', 'MN072', 1, 14.90);
INSERT INTO OrderDetails VALUES ('OD241', 'O088', 'MN073', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD242', 'O088', 'MN075', 1, 4.90);
-- Order O089 items
INSERT INTO OrderDetails VALUES ('OD243', 'O089', 'MN001', 2, 31.80);
INSERT INTO OrderDetails VALUES ('OD244', 'O089', 'MN002', 2, 5.00);
INSERT INTO OrderDetails VALUES ('OD245', 'O089', 'MN004', 3, 8.40);
-- Order O090 items
INSERT INTO OrderDetails VALUES ('OD246', 'O090', 'MN009', 3, 37.50);
INSERT INTO OrderDetails VALUES ('OD247', 'O090', 'MN014', 2, 15.80);
INSERT INTO OrderDetails VALUES ('OD248', 'O090', 'MN013', 1, 3.90);
-- Order O091 items
INSERT INTO OrderDetails VALUES ('OD249', 'O091', 'MN015', 1, 35.90);
INSERT INTO OrderDetails VALUES ('OD250', 'O091', 'MN021', 1, 3.90);
-- Order O092 items
INSERT INTO OrderDetails VALUES ('OD251', 'O092', 'MN023', 3, 10.50);
INSERT INTO OrderDetails VALUES ('OD252', 'O092', 'MN026', 5, 12.50);
INSERT INTO OrderDetails VALUES ('OD253', 'O092', 'MN027', 2, 33.00);
-- Order O093 items
INSERT INTO OrderDetails VALUES ('OD254', 'O093', 'MN032', 1, 19.90);
INSERT INTO OrderDetails VALUES ('OD255', 'O093', 'MN035', 1, 14.90);
-- Order O094 items
INSERT INTO OrderDetails VALUES ('OD256', 'O094', 'MN036', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD257', 'O094', 'MN040', 2, 19.80);
INSERT INTO OrderDetails VALUES ('OD258', 'O094', 'MN041', 1, 2.90);
-- Order O095 items
INSERT INTO OrderDetails VALUES ('OD259', 'O095', 'MN044', 2, 33.80);
INSERT INTO OrderDetails VALUES ('OD260', 'O095', 'MN047', 1, 11.90);
-- Order O096 items
INSERT INTO OrderDetails VALUES ('OD261', 'O096', 'MN052', 3, 38.70);
INSERT INTO OrderDetails VALUES ('OD262', 'O096', 'MN053', 4, 19.60);
INSERT INTO OrderDetails VALUES ('OD263', 'O096', 'MN055', 1, 3.50);
-- Order O097 items
INSERT INTO OrderDetails VALUES ('OD264', 'O097', 'MN058', 2, 23.80);
INSERT INTO OrderDetails VALUES ('OD265', 'O097', 'MN060', 1, 13.90);
INSERT INTO OrderDetails VALUES ('OD266', 'O097', 'MN062', 1, 3.90);
-- Order O098 items
INSERT INTO OrderDetails VALUES ('OD267', 'O098', 'MN064', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD268', 'O098', 'MN067', 2, 13.80);
INSERT INTO OrderDetails VALUES ('OD269', 'O098', 'MN069', 1, 4.90);
-- Order O099 items
INSERT INTO OrderDetails VALUES ('OD270', 'O099', 'MN071', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD271', 'O099', 'MN073', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD272', 'O099', 'MN075', 1, 4.90);
-- Order O100 items
INSERT INTO OrderDetails VALUES ('OD273', 'O100', 'MN003', 3, 26.70);
INSERT INTO OrderDetails VALUES ('OD274', 'O100', 'MN005', 1, 12.90);
INSERT INTO OrderDetails VALUES ('OD275', 'O100', 'MN007', 1, 7.50);
-- Order O101 items
INSERT INTO OrderDetails VALUES ('OD276', 'O101', 'MN008', 2, 37.80);
INSERT INTO OrderDetails VALUES ('OD277', 'O101', 'MN010', 2, 19.80);
INSERT INTO OrderDetails VALUES ('OD278', 'O101', 'MN013', 1, 3.90);
-- Order O102 items
INSERT INTO OrderDetails VALUES ('OD279', 'O102', 'MN017', 1, 38.90);
INSERT INTO OrderDetails VALUES ('OD280', 'O102', 'MN021', 1, 3.90);
-- Order O103 items
INSERT INTO OrderDetails VALUES ('OD281', 'O103', 'MN022', 1, 14.50);
INSERT INTO OrderDetails VALUES ('OD282', 'O103', 'MN024', 3, 12.00);
INSERT INTO OrderDetails VALUES ('OD283', 'O103', 'MN025', 1, 3.00);
-- Order O104 items
INSERT INTO OrderDetails VALUES ('OD284', 'O104', 'MN029', 2, 27.80);
INSERT INTO OrderDetails VALUES ('OD285', 'O104', 'MN031', 1, 16.90);
INSERT INTO OrderDetails VALUES ('OD286', 'O104', 'MN034', 1, 5.90);
-- Order O105 items
INSERT INTO OrderDetails VALUES ('OD287', 'O105', 'MN036', 2, 25.80);
INSERT INTO OrderDetails VALUES ('OD288', 'O105', 'MN038', 1, 18.90);
INSERT INTO OrderDetails VALUES ('OD289', 'O105', 'MN041', 1, 2.90);