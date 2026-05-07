CREATE DATABASE QLThuVien;
USE QLThuVien;

-- TẠO BẢNG CATEGORY
CREATE TABLE Category (
    CategoryID VARCHAR(5) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

-- TẠO BẢNG BOOK
CREATE TABLE Book (
    BookID VARCHAR(6) PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(50),
    PublishYear INT,
    CategoryID VARCHAR(5),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- TẠO BẢNG READER
CREATE TABLE Reader (
    ReaderID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    Phone VARCHAR(15)
);

-- TẠO BẢNG BORROW
CREATE TABLE Borrow (
    ReaderID VARCHAR(6),
    BookID VARCHAR(6),
    BorrowDate DATE,
    ReturnDate DATE,
    FineAmount DECIMAL(8,2),
    PRIMARY KEY (ReaderID, BookID),
    FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID),
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
);
-- THÊM DỮ LIỆU CATEGORY
INSERT INTO Category (CategoryID, CategoryName) VALUES
('C0001', 'Science'),
('C0002', 'Literature'),
('C0003', 'Technology');
-- THÊM DỮ LIỆU BOOK
INSERT INTO Book (BookID, Title, Author, PublishYear, CategoryID) VALUES
('B00001', 'Physics Basic', 'John Smith', 2020, 'C0001'),
('B00002', 'SQL Master', 'David Lee', 2021, 'C0003'),
('B00003', 'Romeo & Juliet', 'Shakespeare', 2018, 'C0002'),
('B00004', 'Advanced Chemistry', 'Alice Brown', 2022, 'C0001'),
('B00005', 'Modern Web Dev', 'Kevin White', 2020, 'C0003');
-- THÊM DỮ LIỆU READER
INSERT INTO Reader (ReaderID, FullName, Gender, Phone) VALUES
('R00001', 'Nguyen Van A', 'Male', '0987654321'),
('R00002', 'Tran Thi B', 'Female', '0912345678'),
('R00003', 'Le Van C', 'Male', '0978123456');
-- THÊM DỮ LIỆU BORROW
INSERT INTO Borrow (ReaderID, BookID, BorrowDate, ReturnDate, FineAmount) VALUES
('R00001', 'B00001', '2025-05-01', '2025-05-10', 100000),
('R00002', 'B00002', '2025-05-03', '2025-05-12', 0),
('R00001', 'B00004', '2025-05-05', '2025-05-15', 200000),
('R00003', 'B00003', '2025-05-02', '2025-05-09', 0);

-- CÂU 1: TẠO VIEW ViewBookBasic
CREATE VIEW ViewBookBasic AS
SELECT 
    b.BookID,
    b.Title,
    c.CategoryName
FROM Book b
JOIN Category c
ON b.CategoryID = c.CategoryID;

-- TRUY VẤN VIEW
SELECT * FROM ViewBookBasic;

-- CÂU 2: TẠO INDEX 
CREATE INDEX idxTitle
ON Book(Title);
-- CÂU 3: TẠO PROCEDURE GetScienceBooks
DELIMITER $$

CREATE PROCEDURE GetScienceBooks()
BEGIN
    SELECT 
        b.BookID,
        b.Title,
        b.Author,
        c.CategoryName
    FROM Book b
    JOIN Category c
    ON b.CategoryID = c.CategoryID
    WHERE c.CategoryName = 'Science';
END $$

DELIMITER ;

-- GỌI PROCEDURE
CALL GetScienceBooks();

-- CÂU 4A: TẠO VIEW ĐẾM SÁCH THEO THỂ LOẠI
CREATE VIEW ViewBookCountByCategory AS
SELECT 
    c.CategoryName,
    COUNT(b.BookID) AS TotalBooks
FROM Category c
LEFT JOIN Book b
ON c.CategoryID = b.CategoryID
GROUP BY c.CategoryName;

-- CÂU 4B: THỂ LOẠI CÓ NHIỀU SÁCH NHẤT
SELECT *
FROM ViewBookCountByCategory
WHERE TotalBooks = (
    SELECT MAX(TotalBooks)
    FROM ViewBookCountByCategory
);

-- CÂU 5A: TẠO PROCEDURE GetMostBorrowedBook
DELIMITER $$

CREATE PROCEDURE GetMostBorrowedBook(
    IN varCategoryID VARCHAR(5)
)
BEGIN
    SELECT 
        b.BookID,
        b.Title,
        COUNT(br.BookID) AS BorrowCount
    FROM Book b
    JOIN Borrow br
    ON b.BookID = br.BookID
    WHERE b.CategoryID = varCategoryID
    GROUP BY b.BookID, b.Title
    ORDER BY BorrowCount DESC
    LIMIT 1;
END $$

DELIMITER ;

-- CÂU 5B: GỌI PROCEDURE
CALL GetMostBorrowedBook('C0001');




