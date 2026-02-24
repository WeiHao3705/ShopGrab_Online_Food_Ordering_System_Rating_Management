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

CREATE TABLE Membership (
    membershipID VARCHAR(20) PRIMARY KEY,
    membershipType VARCHAR(50),
    fee DECIMAL(10,2),
    validity_period INT
);

CREATE TABLE Restaurant (
    restaurantID VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    is_halal BOOLEAN,
    address VARCHAR(255),
    owner_status VARCHAR(50),
    average_rating DECIMAL(3,2)
);

CREATE TABLE Voucher (
    voucherID VARCHAR(20) PRIMARY KEY,
    voucher_type VARCHAR(50),
    discount_amount DECIMAL(10,2),
    expiry_date DATE,
    min_spend_amount DECIMAL(10,2),
    status VARCHAR(20)
);

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

CREATE TABLE DeliveryService (
    deliveryServiceID VARCHAR(20) PRIMARY KEY,
    company_name VARCHAR(100),
    delivery_charge DECIMAL(10,2),
    pickup_time DATETIME,
    delivery_time DATETIME,
    delivery_status VARCHAR(50),
    average_rating DECIMAL(3,2),
    orderID VARCHAR(20),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID)
);

CREATE TABLE Payment (
    paymentID VARCHAR(20) PRIMARY KEY,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    payment_date DATE,
    paymentAmount DECIMAL(10,2),
    orderID VARCHAR(20),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID)
);

CREATE TABLE MemberMembership (
    memberMembershipID VARCHAR(20),
    memberID VARCHAR(20),
    membershipID VARCHAR(20),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    PRIMARY KEY (memberMembershipID, memberID, membershipID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (membershipID) REFERENCES Membership(membershipID)
);

CREATE TABLE MemberVoucher (
    memberVoucherID VARCHAR(20) PRIMARY KEY,
    voucherID VARCHAR(20),
    memberID VARCHAR(20),
    redeemed_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

CREATE TABLE OrderDetails (
    orderDetailsID VARCHAR(20),
    orderID VARCHAR(20),
    restaurantMenuID VARCHAR(20),
    quantity INT,
    price_at_time_of_order DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    PRIMARY KEY (orderDetailsID, orderID, restaurantMenuID),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID),
    FOREIGN KEY (restaurantMenuID) REFERENCES Menu(menuID)
);

CREATE TABLE MenuRating (
    menu_rating_ID VARCHAR(20),
    memberID VARCHAR(20),
    restaurantMenuID VARCHAR(20),
    rating_score INT,
    comment TEXT,
    rating_date DATE,
    PRIMARY KEY (menu_rating_ID, memberID, restaurantMenuID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (restaurantMenuID) REFERENCES Menu(menuID)
);

CREATE TABLE DeliveryRating (
    delivery_rating_ID VARCHAR(20) PRIMARY KEY,
    rating_score INT NOT NULL,
    comment TEXT,
    rating_date DATE NOT NULL,
    deliveryServiceID VARCHAR(20) NOT NULL,
    memberID VARCHAR(20) NOT NULL,
    FOREIGN KEY (deliveryServiceID) REFERENCES DeliveryService(deliveryServiceID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);
