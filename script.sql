-- Drop table if it already exists
DROP TABLE OrderDetails CASCADE CONSTRAINTS;
DROP TABLE DeliveryRating CASCADE CONSTRAINTS;
DROP TABLE FoodRating CASCADE CONSTRAINTS;
DROP TABLE DeliveryService CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;
DROP TABLE Orders CASCADE CONSTRAINTS;            
DROP TABLE MemberVoucher CASCADE CONSTRAINTS;
DROP TABLE MemberMembership CASCADE CONSTRAINTS;
DROP TABLE MenuItem CASCADE CONSTRAINTS;
DROP TABLE Voucher CASCADE CONSTRAINTS;
DROP TABLE Member CASCADE CONSTRAINTS;
DROP TABLE Membership CASCADE CONSTRAINTS;
DROP TABLE Restaurant CASCADE CONSTRAINTS;

-- CREATE TABLE QUERIES

CREATE TABLE Membership (
    membershipID NUMBER PRIMARY KEY,
    membershipType VARCHAR2(50) NOT NULL UNIQUE,
    fee NUMBER(10,2) NOT NULL,
    validity_period NUMBER NOT NULL,
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
    CONSTRAINT chk_email_format CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')),
    CONSTRAINT chk_phone_format CHECK (REGEXP_LIKE(phoneNo, '^\+?[0-9]{7,15}$')),
    -- considering whether to add a age restriction on this application
    CONSTRAINT chk_birth_date CHECK (birth_date <= SYSDATE - INTERVAL '12' YEAR)
);

CREATE TABLE Voucher (
    voucherID NUMBER PRIMARY KEY,
    voucher_code VARCHAR2(50) NOT NULL UNIQUE,
    voucher_type VARCHAR2(50) NOT NULL,
    discount_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    expiry_date DATE NOT NULL,
    min_spend_amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    quantity NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT chk_discount_amount CHECK (discount_amount >= 0),
    CONSTRAINT chk_min_spend CHECK (min_spend_amount >= 0),
    CONSTRAINT chk_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_expiry_date CHECK (expiry_date > SYSDATE)
);

CREATE TABLE Restaurant (
    restaurantID NUMBER PRIMARY KEY,
    restaurant_name VARCHAR2(100) NOT NULL,
    restaurant_category VARCHAR2(50) NOT NULL,
    is_halal NUMBER(1) DEFAULT 0 NOT NULL,  
    location_area VARCHAR2(100) NOT NULL,
    current_status VARCHAR2(20) DEFAULT 'Open' NOT NULL,
    average_rating NUMBER(3,2) DEFAULT 0,
    CONSTRAINT chk_status CHECK (current_status IN ('Open','Closed','Suspended')),
    CONSTRAINT chk_rating CHECK (average_rating BETWEEN 0 AND 5),
    CONSTRAINT chk_halal CHECK (is_halal IN (0,1)),
    -- considering whether to add the restaurant_category constraint
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
    CONSTRAINT chk_membership_status CHECK (status IN ('Active','Expired','Cancelled')),
    CONSTRAINT chk_membership_dates CHECK (end_date > start_date)
);

CREATE TABLE MemberVoucher (
    memberVoucherID NUMBER PRIMARY KEY,
    voucherID NUMBER NOT NULL,
    memberID NUMBER NOT NULL,
    redeemed_date DATE,
    status VARCHAR2(20) DEFAULT 'Available' NOT NULL,
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    CONSTRAINT chk_voucher_status CHECK (status IN ('Available','Redeemed','Expired')),
    CONSTRAINT chk_redeemed_date CHECK (redeemed_date IS NULL OR redeemed_date <= SYSDATE),
    CONSTRAINT chk_voucher_availability CHECK (
        (status = 'Available' AND redeemed_date IS NULL) OR
        (status = 'Redeemed' AND redeemed_date IS NOT NULL) OR
        (status = 'Expired' AND redeemed_date IS NULL)
    ),
    CONSTRAINT uq_voucher_member UNIQUE (voucherID, memberID)
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
    FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID),
    CONSTRAINT chk_budget_meal CHECK (is_budget_meal IN (0,1)),
    CONSTRAINT chk_super_deal CHECK (is_super_deal IN (0,1)),
    CONSTRAINT chk_availability CHECK (availability IN (0,1)),
    CONSTRAINT chk_item_restaurant UNIQUE (item_name, restaurantID)
);

CREATE TABLE Orders (
    orderID NUMBER PRIMARY KEY,
    order_date DATE DEFAULT SYSDATE NOT NULL,
    order_status VARCHAR2(50) DEFAULT 'Pending' NOT NULL,
    total_amount NUMBER(10,2) NOT NULL CHECK (total_amount >= 0),
    delivery_method VARCHAR2(50) NOT NULL,
    memberVoucherID NUMBER,
    memberID NUMBER NOT NULL,
    FOREIGN KEY (memberVoucherID) REFERENCES MemberVoucher(memberVoucherID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    CONSTRAINT chk_order_status CHECK (order_status IN ('Pending','Completed','Cancelled','On Delivery')),
    CONSTRAINT chk_delivery_method CHECK (delivery_method IN ('Delivery','Self-Pickup')),

);

CREATE TABLE Payment (
    paymentID NUMBER PRIMARY KEY,
    payment_method VARCHAR2(50) NOT NULL,
    payment_status VARCHAR2(50) DEFAULT 'Pending' NOT NULL,
    payment_amount NUMBER(10,2) NOT NULL CHECK (payment_amount >= 0),
    payment_date DATE DEFAULT SYSDATE NOT NULL,
    orderID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Pending','Completed','Failed','Refunded')),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Credit Card','Debit Card','E-Wallet','Cash'))
);

CREATE TABLE DeliveryService (
    deliveryServiceID NUMBER PRIMARY KEY,
    company_name VARCHAR2(100) NOT NULL,
    delivery_charge NUMBER(10,2) NOT NULL CHECK (delivery_charge >= 0),
    pickup_time TIMESTAMP NOT NULL,
    delivery_time TIMESTAMP NOT NULL,
    delivery_address VARCHAR2(255) NOT NULL,
    delivery_status VARCHAR2(50) DEFAULT 'Pending' NOT NULL,
    orderID NUMBER NOT NULL,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    CONSTRAINT chk_delivery_status CHECK (delivery_status IN ('Pending','On Delivery','Completed','Cancelled')),
    CONSTRAINT chk_delivery_times CHECK (delivery_time > pickup_time)
);

CREATE TABLE DeliveryRating (
    delivery_rating_id NUMBER PRIMARY KEY,
    rating_score NUMBER NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
    "comment" CLOB,
    rating_date DATE DEFAULT SYSDATE NOT NULL,
    orderID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE FoodRating (
    food_rating_ID NUMBER PRIMARY KEY,
    rating_score NUMBER NOT NULL CHECK (rating_score BETWEEN 1 AND 5),
    "comment" CLOB,
    rating_date DATE DEFAULT SYSDATE NOT NULL,
    orderID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

CREATE TABLE OrderDetails (
    orderDetailsID NUMBER PRIMARY KEY,
    orderID NUMBER NOT NULL UNIQUE,
    menuitemID NUMBER NOT NULL,
    quantity NUMBER NOT NULL CHECK (quantity > 0),
    price_at_time_ordered NUMBER(10,2) NOT NULL CHECK (price_at_time_ordered >= 0),
    subtotal NUMBER(10,2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (orderID) REFERENCES Orders(orderID),
    FOREIGN KEY (menuitemID) REFERENCES MenuItem(menuitemID)
);