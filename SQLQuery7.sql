--USE DB
USE Library

-- 1. Select all publishers that have books published (3 methods - EXISTS, ANY, SOME).
GO
SELECT DISTINCT FirstName +' '+ LastName AS 'Publishers'
FROM Authors AS A INNER JOIN Books AS B
ON B.Id = A.Id

-- 2. Display the book with the maximum number of pages (2 ways - ALL, aggregate function).
GO
SELECT *
FROM Books
WHERE Pages = (
SELECT MAX(Pages)
FROM Books
)

-- 3. Select all teachers who did not take books in the library (2 methods - EXISTS or ANY, JOIN) .
GO
SELECT FirstName, LastName
FROM Teachers LEFT JOIN T_Cards 
ON Teachers.Id = T_Cards.Id_Teacher
WHERE Id_Teacher IS NULL

-- 4. Choose the books that students and teachers took (2 ways - EXISTS or ANY, JOINs).
GO
SELECT B.[Name]
FROM T_Cards AS TC INNER JOIN Books AS B
ON TC.Id_Book = B.Id
INTERSECT
SELECT B.[Name]
FROM S_Cards AS SC INNER JOIN Books AS B
ON SC.Id_Book = B.Id

-- 5. Choose categories in which books were not taken.

GO
CREATE VIEW VV AS
SELECT Id_Category
FROM Books LEFT JOIN S_Cards 
ON Books.Id = S_Cards.Id_Book
WHERE Id_Book IS NULL
GROUP BY Id_Category
GO
SELECT [Name]
FROM Categories,VV 
WHERE Id = VV.Id_Category