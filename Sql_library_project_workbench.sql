
CREATE DATABASE SQL_INNOMATICS_LAB
USE SQL_INNOMATICS_LAB



CREATE TABLE Tbl_Publisher(
publisher_PublisherName VARCHAR(255) PRIMARY KEY,
publisher_PublisherAddress VARCHAR(255),
publisher_PublisherPhone VARCHAR(255)
);


CREATE TABLE Tbl_Borrower(
borrower_CardNo INT PRIMARY KEY ,
borrower_BorrowerName VARCHAR(255),
borrower_BorrowerAddress VARCHAR(255),
borrower_BorrowerPhone VARCHAR(255)
);

CREATE TABLE Tbl_Library_Branch (
library_branch_Branch_id INT  PRIMARY KEY auto_increment,
library_branch_BranchName VARCHAR(255),
library_branch_BranchAddress VARCHAR(255)
);


CREATE TABLE Tbl_Book (
book_BookID INT PRIMARY KEY,
book_Title VARCHAR(255),
book_PublisherName VARCHAR(255),
CONSTRAINT FK_Tbl_Book_Tbl_Publisher FOREIGN KEY (book_PublisherName) REFERENCES  Tbl_Publisher(publisher_PublisherName)
);


CREATE TABLE Tbl_Book_Copies(
book_copies_Copies_id INT auto_increment PRIMARY KEY,
book_copies_BookID INT,
book_copies_BranchID INT,
book_copies_No_Of_Copies INT,
CONSTRAINT FK_Tbl_Book_Copies_Tbl_Book FOREIGN KEY (book_copies_BookID) REFERENCES Tbl_Book(book_BookID),
CONSTRAINT FK_Tbl_Book_Copies_Tbl_Library_Branch FOREIGN KEY(book_copies_BranchID) REFERENCES Tbl_Library_Branch(library_branch_Branch_id)
);


CREATE TABLE Tbl_Book_Authors(
book_authors_Author_id INT auto_increment PRIMARY KEY,
book_authors_BookID INT,
book_authors_AuthorName VARCHAR(255),
CONSTRAINT FK_Tbl_Book_Authors_Tbl_Book FOREIGN KEY(book_authors_BookID) REFERENCES Tbl_Book(book_BookID)
);


CREATE TABLE Tbl_Book_Loans(
book_loans_loansid INT auto_increment PRIMARY KEY,
book_loans_BookID INT,
book_loans_BranchID INT,
book_loans_CardNo INT,
book_loans_DateOut VARCHAR(255),
book_loans_DueDate VARCHAR(255),
CONSTRAINT FK_Tbl_Book_Loans_Tbl_Book FOREIGN KEY(book_loans_BookID) REFERENCES Tbl_Book(book_BookID),
CONSTRAINT FK_Tbl_Book_Loans_Tbl_Library_Branch FOREIGN KEY(book_loans_BranchID) REFERENCES Tbl_Library_Branch(library_branch_Branch_id),
CONSTRAINT FK_Tbl_Book_Loans_Tbl_Borrower FOREIGN KEY(book_loans_CardNo) REFERENCES Tbl_Borrower(borrower_CardNo)
);


SELECT * FROM Tbl_Publisher;
SELECT * FROM Tbl_Borrower;
SELECT * FROM Tbl_Library_Branch;
SELECT * FROM Tbl_Book;
SELECT * FROM Tbl_Book_Copies;
SELECT * FROM tbl_book_authors;
SELECT * FROM  Tbl_Book_Loans;

-----------------------------------------------------------------------------------------------------------------------
-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT COUNT(book_copies_Copies_id) Total_copies ,TB.book_Title,TLB.library_branch_BranchName FROM Tbl_Book_Copies TBC JOIN Tbl_Book TB 
ON TBC.book_copies_BookID=TB.book_BookID JOIN Tbl_Library_Branch TLB ON TBC.book_copies_BranchID=TLB.library_branch_Branch_id
WHERE TB.book_Title='The Lost Tribe' AND TLB.library_branch_BranchName='Sharpstown';
	
------------------------------------------------------------------------------------------------------------------------------
-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT COUNT(book_copies_No_Of_Copies) No_of_copies,book_Title,library_branch_BranchName FROM Tbl_Book_Copies TBC JOIN Tbl_Book TB ON 
TBC.book_copies_BookID=TB.book_BookID JOIN Tbl_Library_Branch TLB ON TBC.book_copies_BranchID=TLB.library_branch_Branch_id 
WHERE TB.book_Title='The Lost Tribe' GROUP BY(TLB.library_branch_BranchName);

-----------------------------------------------------------------------------------------------------------------------------------
-- Retrieve the names of all borrowers who do not have any books checked out.

SELECT TB.borrower_BorrowerName FROM Tbl_Borrower TB  LEFT JOIN Tbl_Book_Loans TBL ON
 TB.borrower_CardNo=TBL.book_loans_CardNo WHERE TBL.book_loans_loansid IS NULL;

-------------------------------------------------------------------------------------------------------------
-- For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
-- retrieve the book title, the borrower's name, and the borrower's address. 

SELECT BO.book_Title,TBR.borrower_BorrowerName,TBR.borrower_BorrowerAddress FROM Tbl_Book_Loans TBL JOIN Tbl_Book BO
ON TBL.book_loans_BookID=BO.book_BookID JOIN Tbl_Library_Branch TLB ON TBL.book_loans_BranchID=TLB.library_branch_Branch_id
JOIN Tbl_Borrower TBR ON TBL.book_loans_CardNo=TBR.borrower_CardNo WHERE TLB.library_branch_BranchName='Sharpstown' AND 
TBL.book_loans_DueDate='2/3/18';

-------------------------------------------------------------------------------------------------------------------------------
-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT COUNT(*) Total_No_of_books ,TLB.library_branch_BranchName FROM Tbl_Library_Branch TLB  JOIN Tbl_Book_Loans TBL 
ON TLB.library_branch_Branch_id=TBL.book_loans_BranchID GROUP BY (TLB.library_branch_BranchName);

------------------------------------------------------------------------------------------------------------------------------
-- Retrieve the names, addresses, and number of books checked
-- out for all borrowers who have more than five books checked out.

SELECT  COUNT(*) Books_check_out,borrower_BorrowerName ,borrower_BorrowerAddress FROM Tbl_Borrower TB JOIN
Tbl_Book_Loans TBL ON TB.borrower_CardNo=TBL.book_loans_CardNo 
GROUP BY borrower_BorrowerName,borrower_BorrowerAddress
HAVING(COUNT(*)>5);

-------------------------------------------------------------------------------
--- -- For each book authored by "Stephen King", retrieve the title 
-- and the number of copies owned by the library branch whose name is "Central".

SELECT COUNT( DISTINCT book_copies_No_Of_Copies) No_of_copies,TB.book_Title,TLB.library_branch_BranchName
FROM Tbl_Book_Copies TBC JOIN Tbl_Book TB ON TBC.book_copies_BookID=TB.book_BookID
JOIN Tbl_book_authors TBA ON TB.book_BookID=TBA.book_authors_BookID  
JOIN Tbl_Library_Branch TLB ON TBC.book_copies_BranchID=TLB.library_branch_Branch_id
WHERE TBA.book_authors_AuthorName='Stephen King' AND 
TLB.library_branch_BranchName='Central' GROUP BY book_Title,library_branch_BranchName;
------------------------------------------------------------------------------------------

-- Retrive data from above 

SELECT * FROM Tbl_Publisher;
SELECT * FROM Tbl_Borrower;
SELECT * FROM Tbl_Library_Branch;
SELECT * FROM Tbl_Book;
SELECT * FROM Tbl_Book_Copies;
SELECT * FROM Tbl_book_authors;
SELECT * FROM  Tbl_Book_Loans;












