CREATE DATABASE Library;
USE Library;

CREATE TABLE Books (
    bookID INT AUTO_INCREMENT PRIMARY KEY,
    bookName VARCHAR(255) NOT NULL,
    USN VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

INSERT INTO Books (bookName, USN, Author, price) VALUES
('Three men in a boat', 'USN001', 'Author_1', 11.22),
('Becoming', 'USN002', 'Author_2', 12.50),
('The help', 'USN003', 'Author_3', 9.75),
('ORV', 'USN004', 'tls123_4', 15.20),
('Harry Potter', 'USN005', 'Author_5', 8.40);
