-- Phần 1

CREATE TABLE Customer (
    customer_id VARCHAR(5) PRIMARY KEY,
    customer_full_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL UNIQUE,
    customer_phone VARCHAR(15) NOT NULL,
    customer_address VARCHAR(255) NOT NULL
);

CREATE TABLE Room (
    room_id VARCHAR(5) PRIMARY KEY,
    room_type VARCHAR(50) NOT NULL,
    room_price DECIMAL(10,2) NOT NULL,
    room_status VARCHAR(20) NOT NULL,
    room_area INT NOT NULL
);

CREATE TABLE Booking (
    booking_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(5) REFERENCES Customer(customer_id),
    room_id VARCHAR(5) REFERENCES Room(room_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    total_amount DECIMAL(10,2)
);

CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES Booking(booking_id),
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL
);

INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
VALUES ('C001', 'Nguyen Anh Tu', 'tu.nguyen@example.com', '0912345678', 'Hanoi, Vietnam'),
       ('C002', 'Tran Thi Mai', 'mai.tran@example.com', '0923456789', 'Ho Chi Minh, Vietnam'),
       ('C003', 'Le Minh Hoang','hoang.le@example.com', '0934567890', 'Danang, Vietnam'),
       ('C004', 'Pham Hoang Nam','nam.pham@example.com','0945678901', 'Hue, Vietnam'),
       ('C005', 'Vu Minh Thu','thu.vu@example.com', '0956789012','Hai Phong, Vietnam'),
       ('C006', 'Nguyen Thi Lan', 'lan.nguyen@example.com', '0967890123', 'Quang Ninh, Vietnam'),
       ('C007', 'Bui Minh Tuan', 'tuan.bui@example.com', '0978901234', 'Bac Giang, Vietnam'),
       ('C008', 'Pham Quang Hieu', 'hieu.pham@example.com', '0989012345', 'Quang Nam, Vietnam'),
       ('C009', 'Le Thi Lan', 'lan.le@example.com', '0990123456', 'Da Lat, Vietnam'),
       ('C010', 'Nguyen Thi Mai','mai.nguyen@example.com', '0901234567','Can Tho, Vietnam');

INSERT INTO Room(room_id,room_type, room_price,room_status,room_area)
VALUES ('R001', 'Single', 100.0, 'Available',25),
       ('R002', 'Double',150.0,'Booked',40),
       ('R003', 'Suite', 250.0, 'Available', 60),
       ('R004', 'Single', 120.0, 'Booked', 30),
       ('R005', 'Double', 160.0, 'Available', 35);

INSERT INTO Booking(customer_id, room_id,check_in_date,check_out_date,total_amount)
VALUES ('C001','R001', '2025-03-01','2025-03-05',400.0),
        ('C002','R002','2025-03-02','2025-03-06',600.0),
        ('C003','R003','2025-03-03', '2025-03-07',1000.0),
        ('C004','R004','2025-03-04','2025-03-08', 480.0),
        ('C005', 'R005','2025-03-05','2025-03-09',800.0),
        ('C006', 'R001', '2025-03-06','2025-03-10',400.0),
        ('C007', 'R002','2025-03-07','2025-03-11',600.0),
        ('C008','R003','2025-03-08','2025-03-12', 1000.0),
        ('C009', 'R004','2025-03-09','2025-03-13',480.0),
        ('C010','R005','2025-03-10','2025-03-14',800.0);

INSERT INTO Payment(booking_id,payment_method,payment_date,payment_amount)
VALUES (1, 'Cash','2025-03-05',400.0),
        (2, 'Credit Card','2025-03-06',600.0),
        (3, 'Bank Transfer','2025-03-07',1000.0),
        (4, 'Cash','2025-03-08',480.0),
        (5,'Credit Card','2025-03-09',800.0),
        (6,'Bank Transfer', '2025-03-10',400.0),
        (7,'Cash','2025-03-11',600.0),
        (8,'Credit Card','2025-03-12',1000.0),
        (9,'Bank Transfer','2025-03-13',480.0),
        (10, 'Cash','2025-03-14', 800.0);

-- Câu 3
UPDATE Booking
SET total_amount = r.room_price * (B.check_out_date - B.check_in_date)
FROM Room r JOIN Booking B on r.room_id = B.room_id
WHERE r.room_status = 'Booked';

-- Câu 4
DELETE FROM Payment
WHERE payment_method = 'Cash' AND payment_amount < 500;

-- Phần 2
-- Câu 5
SELECT customer_id, customer_full_name, customer_email, customer_phone, customer_address
FROM Customer
ORDER BY customer_full_name;

-- Câu 6
SELECT room_id, room_type, room_price, room_area
FROM Room
ORDER BY room_price DESC;

-- Câu 7
SELECT c.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date
FROM Customer c JOIN Booking b on c.customer_id = b.customer_id;

-- Câu 8
SELECT b.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
FROM Customer c JOIN Booking b on c.customer_id = b.customer_id
                JOIN Payment p on b.booking_id = p.booking_id
ORDER BY p.payment_amount DESC;

-- Câu 9
SELECT * FROM Customer
ORDER BY customer_full_name
LIMIT 3 OFFSET 1;

-- Câu 10
SELECT c.customer_id, c.customer_full_name, COUNT(b.room_id)
FROM Customer c JOIN Booking b on c.customer_id = b.customer_id
GROUP BY c.customer_id, b.room_id, b.total_amount
HAVING COUNT(b.room_id) >= 2 AND SUM(b.total_amount) > 1000;

-- Câu 11
SELECT r.room_id, r.room_type, r.room_price, b.total_amount
FROM Room r JOIN Booking b on r.room_id = b.room_id
GROUP BY r.room_id, b.total_amount
HAVING COUNT(b.room_id) >= 3 AND SUM(b.total_amount) < 1000;

-- Câu 12
SELECT c.customer_id, c.customer_full_name, r.room_id, b.total_amount
FROM Customer c JOIN Booking b on c.customer_id = b.customer_id
                JOIN Room r on b.room_id = r.room_id
GROUP BY c.customer_id, r.room_id, b.total_amount
HAVING SUM(b.total_amount) > 1000;

-- Câu 13
SELECT customer_id, customer_full_name, customer_email, customer_phone
FROM Customer
WHERE customer_full_name like '%Minh%' OR customer_address like '%Hanoi%'
ORDER BY customer_full_name;

-- Câu 14
SELECT room_id, room_type, room_price
FROM Room
ORDER BY room_price DESC
LIMIT 5 OFFSET 5;

-- Phần 3
-- Câu 15
CREATE VIEW vw_information_book AS
    SELECT b.room_id, r.room_type, c.customer_id, c.customer_full_name
    FROM Customer c JOIN Booking b on c.customer_id = b.customer_id
                    JOIN Room r on b.room_id = r.room_id
    WHERE b.check_in_date < '2025-03-10';

-- Câu 16
CREATE VIEW vw_information_room AS
    SELECT b.customer_id, c.customer_full_name, r.room_id, r.room_area
    FROM Customer c JOIN Booking b on c.customer_id = b.customer_id
                JOIN Room r on b.room_id = r.room_id
    WHERE r.room_area > 30;

-- Phần 4
-- Câu 17
CREATE OR REPLACE FUNCTION fn_insert_booking ()
RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.check_out_date) < (NEW.check_in_date) THEN
            RAISE EXCEPTION 'Ngày đặt phòng không thể sau ngày trả phòng được !';
        end if;
        RETURN NEW;
    end;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER check_insert_booking
AFTER INSERT ON Booking
FOR EACH ROW
EXECUTE FUNCTION fn_insert_booking ();

INSERT INTO Booking (customer_id, room_id, check_in_date, check_out_date, total_amount)
VALUES ('C001', 'R004', '2026-04-20', '2026-04-15', 4000.0);

-- Câu 18
CREATE OR REPLACE FUNCTION fn_room_status_on_booking()
RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Room
        SET room_status = 'Booked'
        FROM Room r JOIN Booking b on r.room_id = b.room_id
        WHERE booking_id = NEW.booking_id;

        RETURN NEW;
    end;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER update_room_status_on_booking
AFTER INSERT ON Booking
FOR EACH ROW
EXECUTE FUNCTION fn_room_status_on_booking();

INSERT INTO Booking (customer_id, room_id, check_in_date, check_out_date, total_amount)
VALUES ('C001', 'R005', '2026-04-15', '2026-04-20', 4000.0);

-- Phần 5
-- Câu 19
CREATE OR REPLACE PROCEDURE add_customer (
    p_customer_id VARCHAR,
    p_customer_full_name VARCHAR,
    p_customer_email VARCHAR,
    p_customer_phone VARCHAR,
    p_customer_address VARCHAR
) LANGUAGE plpgsql AS $$
    BEGIN
        INSERT INTO Customer (customer_id, customer_full_name, customer_email, customer_phone, customer_address)
        VALUES (p_customer_id, p_customer_full_name, p_customer_email, p_customer_phone, p_customer_address);
    end;
    $$;

CALL add_customer ('C011', 'Ha Xuan Dai', 'dai.ha@gmail.com','012345678', 'Thanh Hoa, Vietnam');

-- Câu 20
CREATE OR REPLACE PROCEDURE add_payment (
    p_booking_id INT,
    p_payment_method VARCHAR,
    p_payment_amount DECIMAL,
    p_payment_date DATE
) LANGUAGE plpgsql AS $$
    BEGIN
        INSERT INTO Payment(booking_id, payment_method, payment_date, payment_amount)
        VALUES (p_booking_id, p_payment_method, p_payment_date, p_payment_amount);
    end;
    $$;

CALL add_payment (4, 'Cash', 6000.0, '2026-04-15');
