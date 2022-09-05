--USE DB
USE Library

--1. It was impossible to issue a book, which is no longer in the library (in quantity).
--1. Kitabxanada olmayan kitabları , kitabxanadan götürmək olmaz.
GO
CREATE TRIGGER FoundBooks ON S_Cards
AFTER INSERT
AS
BEGIN
IF (SELECT Quantity
FROM Books, inserted
WHERE Books.Id = inserted.Id_Book) = 0
BEGIN
PRINT 'Not found'
END
END

--2. When you return a certain book, its quantity should increase.
--2. Müəyyən kitabı qaytardıqda, onun Quantity-si (sayı) artmalıdır.
GO
CREATE TRIGGER ReturnBook ON S_Cards
AFTER DELETE
AS
BEGIN
UPDATE Books
SET Quantity += 1
WHERE Id = (SELECT Id_Book FROM deleted)
END

--3. When issuing a book, its quantity should decrease.
--3. Kitab kitabxanadan verildikdə onun sayı azalmalıdır.
GO
CREATE TRIGGER GiveBookToStudent ON S_Cards
AFTER INSERT
AS
BEGIN
UPDATE Books
SET Quantity -= 1
WHERE Books.Id = (SELECT Id_Book FROM inserted)
END

--4. You can not give more than three books to one student in his arms.
--4. Bir tələbə artıq 3 itab götütürübsə ona yeni kitab vermək olmaz.
GO
CREATE TRIGGER GiveStudentBook ON S_Cards
AFTER INSERT
AS
BEGIN 
IF (SELECT COUNT(s.Id_Book)
FROM S_Cards as s, inserted
WHERE s.Id_Student = inserted.Id_Student
GROUP BY s.Id_Student) = 3
BEGIN
PRINT 'You can not give '
END
END

--5. You can not issue a new book to a student, if he now read at least one book for more than 2 months.
--5. Əgər tələbə bir kitabı 2aydan çoxdur oxuyursa, bu halda tələbəyə yeni kitab vermək olmaz.
GO
CREATE TRIGGER GiveBookS ON S_Cards
AFTER INSERT
AS
BEGIN
IF (SELECT TOP 1 DATEDIFF(MONTH, S_Cards.DateOut, GETDATE()) AS DIFF
FROM S_Cards, inserted
WHERE S_Cards.DateIn IS NULL AND S_Cards.Id_Student = inserted.Id_Student
ORDER BY DIFF DESC) > 2
BEGIN
PRINT ' You can not issue a new book to a student, if he now read at least one book for more than 2 months.'
END
END


--6. When you delete a book, data about it must be copied to the LibDeleted table.
--6. Kitabı bazadan sildikdə, onun haqqında data LibDeleted cədvəlinə köçürülməlidir.
GO
CREATE TRIGGER DeleteBook ON Books
AFTER DELETE
AS
BEGIN
IF (NOT EXISTS (SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
AND TABLE_NAME = 'LibDeleted'))
BEGIN
SELECT *
INTO LibDeleted
FROM deleted
END
ELSE
BEGIN
INSERT INTO LibDeleted
SELECT *
FROM deleted
END
END