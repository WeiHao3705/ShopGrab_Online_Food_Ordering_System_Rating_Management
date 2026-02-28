-- Drop table if it already exists
DROP TABLE OrderDetails;
DROP TABLE DeliveryRating;
DROP TABLE FoodRating;
DROP TABLE DeliveryService;
DROP TABLE Payment;
DROP TABLE Orders;            
DROP TABLE MemberVoucher;
DROP TABLE MemberMembership;
DROP TABLE Address;
DROP TABLE MenuItem;
DROP TABLE Voucher;
DROP TABLE Member;
DROP TABLE Membership;
DROP TABLE Restaurant;

-- CREATE TABLE QUERY
CREATE TABLE Membership (
    membershipID INT PRIMARY KEY NOT NULL,
    membershipType VARCHAR(50) NOT NULL,
    fee DECIMAL(10,2) NOT NULL,
    validity_period INT NOT NULL,
    CONSTRAINT chk_fee CHECK (fee >= 0),
    CONSTRAINT chk_validity CHECK (validity_period > 0)
);

CREATE TABLE Member (
    memberID NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    gender VARCHAR2(10) NOT NULL,
    birth_date DATE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    phoneNo VARCHAR2(20) NOT NULL UNIQUE,
    registration_date DATE DEFAULT SYSDATE NOT NULL,
    account_status VARCHAR2(20) DEFAULT 'Active' NOT NULL,
    CONSTRAINT chk_gender CHECK (gender IN ('Male','Female','Other')),
    CONSTRAINT chk_account_status CHECK (account_status IN ('Active','Inactive','Suspended')),
    CONSTRAINT chk_email_format CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);

CREATE TABLE Voucher (
    voucherID NUMBER PRIMARY KEY,
    voucher_type VARCHAR2(50) NOT NULL,
    discount_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    expiry_date DATE NOT NULL,
    min_spend_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    quantity NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT chk_discount_amount CHECK (discount_amount >= 0),
    CONSTRAINT chk_min_spend CHECK (min_spend_amount >= 0),
    CONSTRAINT chk_quantity CHECK (quantity >= 0)
);

CREATE TABLE Restaurant (
    restaurantID NUMBER PRIMARY KEY,
    restaurant_name VARCHAR2(100) NOT NULL,
    restaurant_category VARCHAR2(50) NOT NULL,
    is_halal NUMBER(1) DEFAULT 0 NOT NULL,  -- 0 = false, 1 = true
    location_area VARCHAR2(100) NOT NULL,
    current_status VARCHAR2(20) DEFAULT 'Open' NOT NULL,
    average_rating NUMBER(3,2) DEFAULT 0,
    CONSTRAINT chk_status CHECK (current_status IN ('Open','Closed','Suspended')),
    CONSTRAINT chk_rating CHECK (average_rating BETWEEN 0 AND 5)
);

CREATE TABLE Address (
    addressID INT PRIMARY KEY,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    memberID INT NOT NULL,
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

CREATE TABLE MemberMembership (
    memberMembershipID NUMBER PRIMARY KEY,
    memberID NUMBER NOT NULL,
    membershipID NUMBER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'Active' NOT NULL,
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (membershipID) REFERENCES Membership(membershipID),
    CONSTRAINT chk_membership_status CHECK (status IN ('Active','Expired','Cancelled'))
);

CREATE TABLE MemberVoucher (
    memberVoucherID NUMBER PRIMARY KEY,
    voucherID NUMBER NOT NULL,
    memberID NUMBER NOT NULL,
    redeemed_date DATE,
    status VARCHAR2(20) DEFAULT 'Available' NOT NULL,
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    CONSTRAINT chk_voucher_status CHECK (status IN ('Available','Redeemed','Expired'))
);

CREATE TABLE MenuItem (
    menuitemID NUMBER PRIMARY KEY,
    item_name VARCHAR2(100) NOT NULL,
    item_category VARCHAR2(50) NOT NULL,
    is_budget_meal NUMBER(1) DEFAULT 0 NOT NULL,   
    is_super_deal NUMBER(1) DEFAULT 0 NOT NULL,    
    type VARCHAR2(50) NOT NULL,
    price NUMBER(10,2) NOT NULL CHECK (price >= 0),
    availability NUMBER(1) DEFAULT 1 NOT NULL,      
    restaurantID NUMBER NOT NULL,
    FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID)
);

CREATE TABLE Orders (
    orderID NUMBER PRIMARY KEY,
    order_date DATE DEFAULT SYSDATE NOT NULL,
    order_type VARCHAR2(50) NOT NULL,
    order_status VARCHAR2(50) DEFAULT 'Pending' NOT NULL,
    total_amount NUMBER(10,2) NOT NULL CHECK (total_amount >= 0),
    delivery_method VARCHAR2(50) NOT NULL,
    memberVoucherID NUMBER,
    addressID NUMBER NOT NULL,
    memberID NUMBER NOT NULL,
    FOREIGN KEY (memberVoucherID) REFERENCES MemberVoucher(memberVoucherID),
    FOREIGN KEY (addressID) REFERENCES Address(addressID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    CONSTRAINT chk_order_status CHECK (order_status IN ('Pending','Completed','Cancelled','On Delivery'))
);

CREATE TABLE Payment (
    paymentID NUMBER PRIMARY KEY,
    payment_method VARCHAR2(50) NOT NULL,
    payment_status VARCHAR2(50) DEFAULT 'Pending' NOT NULL,
    payment_amount NUMBER(10,2) NOT NULL CHECK (payment_amount >= 0),
    payment_date DATE DEFAULT SYSDATE NOT NULL,
    orderID NUMBER NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE DeliveryService (
    deliveryServiceID NUMBER PRIMARY KEY,
    company_name VARCHAR2(100) NOT NULL,
    delivery_charge NUMBER(10,2) NOT NULL CHECK (delivery_charge >= 0),
    pickup_time TIMESTAMP NOT NULL,
    delivery_time TIMESTAMP NOT NULL,
    delivery_status VARCHAR2(50) DEFAULT 'Pending' NOT NULL,
    average_rating NUMBER(3,2) DEFAULT 0 CHECK (average_rating BETWEEN 0 AND 5),
    orderID NUMBER NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    CONSTRAINT chk_delivery_status CHECK (delivery_status IN ('Pending','On Delivery','Completed','Cancelled'))
);

CREATE TABLE DeliveryRating (
    delivery_rating_id NUMBER PRIMARY KEY,
    rating_score NUMBER NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
    comment_text CLOB,
    rating_date DATE DEFAULT SYSDATE NOT NULL,
    orderID NUMBER NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE FoodRating (
    food_rating_ID NUMBER PRIMARY KEY,
    rating_score NUMBER NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
    comment_text CLOB,
    rating_date DATE DEFAULT SYSDATE NOT NULL,
    orderID NUMBER NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE OrderDetails (
    orderDetailsID NUMBER PRIMARY KEY,
    orderID NUMBER NOT NULL,
    menuitemID NUMBER NOT NULL,
    quantity NUMBER NOT NULL CHECK (quantity > 0),
    price_at_time_ordered NUMBER(10,2) NOT NULL CHECK (price_at_time_ordered >= 0),
    subtotal NUMBER(10,2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (menuitemID) REFERENCES MenuItem(menuitemID)
);
