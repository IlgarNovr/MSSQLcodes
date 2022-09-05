-- 1. Create a database "Teachers" and add two tables to it.
GO
CREATE DATABASE TeachersDb

GO
USE TeachersDb

GO
CREATE TABLE Posts(
	Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(20)
)

GO
CREATE TABLE Teachers(
	Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] NVARCHAR(15),
	Code CHAR(10),
	IdPost INT NOT NULL FOREIGN KEY REFERENCES Posts(Id),
	Tel CHAR(7),
	Salary INT,
	Rise NUMERIC(6,2),
	HireDate DATETIME
)

-- 2. Delete the "POSTS" table.
-- 3. In the "TEACHERS" table, delete the "IdPost" column
GO
ALTER TABLE Teachers
DROP CONSTRAINT FK__Teachers__IdPost__267ABA7A
GO
ALTER TABLE Teachers
DROP COLUMN IdPost
GO
DROP TABLE Posts


-- 4. For the "HireDate" column, create a limit: the date of hiring must be at least 01/01/1990.
GO
ALTER TABLE Teachers
ADD CHECK(HireDate > '1990-01-01')

-- 5. Create a unique constraint for the "Code" column.
GO
ALTER TABLE Teachers
ADD UNIQUE (Code)

-- 6. Change the data type In the Salary field from INTEGER to NUMERIC (6,2).
GO
ALTER TABLE Teachers
ALTER COLUMN Salary NUMERIC(6,2)

-- 7. Add to the table "TeachersS" the following restriction: 
--    the salary should not be less than 1000, but also should not Exceed 5000.
GO
ALTER TABLE Teachers
ADD CHECK(Salary BETWEEN 1000 AND 5000)

-- 8. Rename Tel column to Phone.
GO
sp_rename 'Teachers.Tel', 'Phone', 'COLUMN'

-- 9. Change the data type in the Phone field from CHAR (7) to CHAR (11).
GO
ALTER TABLE Teachers
ALTER COLUMN Phone NVARCHAR(11)

-- 10. Create again the "POSTS" table.
-- 11. For the Name field of the "POSTS" table, you must set a limit on the position 
--     (professor, assistant professor, teacher or assistant).
GO
CREATE TABLE Posts(
	Id INT NOT NULL IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(20) CHECK ([Name] IN ('professor', 'assistant professor', 'teacher', 'assistant')),
)

-- 12. For the Name field of the "TeachersS" table, specify a restriction 
--     in which to prohibit the presence of figures in the teacher's surname.
GO
ALTER TABLE Teachers
ADD CHECK([Name] NOT LIKE '%[0-9]%')

-- 13. Add the IdPost (int) column to the "TeachersS" table.
-- 14. Associate the field IdPost table "TeachersS" with the field Id of the table "POSTS".
GO
ALTER TABLE Teachers
ADD IdPost INT NOT NULL FOREIGN KEY REFERENCES Posts(Id)

-- 15. Fill both tables with data.
GO
INSERT INTO Posts ( Name)
VALUES ('professor');
INSERT INTO Posts ( Name)
VALUES ('assistant professor');
INSERT INTO Posts ( Name)
VALUES ('teacher');
INSERT INTO Posts (Name)
VALUES ('assistant');
INSERT INTO Teachers ( [Name], Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES ( N'Sidorov','0123456789', 1, NULL, 1070, 470, '01 .09.1992');
INSERT INTO Teachers (Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES ( N'Ramishevsky','4567890123', 2,' 4567890', 1110, 370, '09 .09.1998');
INSERT INTO Teachers (Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES ( N'Horenko','1234567890', 3, NULL, 2000, 230, '10 .10.2001');
INSERT INTO Teachers  (Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES ( N'Vibrovsky','2345678901', 4, NULL, 4000, 170, '01 .09.2003');
INSERT INTO Teachers (Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES (N'Voropaev', NULL, 4, NULL, 1500, 150, '02 .09.2002');
INSERT INTO Teachers (Name, Code, IdPost, Phone, Salary, Rise, HireDate)
VALUES ( N'Kuzintsev','5678901234', 3,'4567890', 3000, 270, '01 .01.1991');
----------------------
-- 16. Create a view:

-- 16.1. All job titles.
GO
CREATE VIEW JobTitle AS
SELECT [Name]
FROM Posts

-- 16.2. All the names of teachers.
GO
CREATE VIEW TeachersNames AS
SELECT [Name]
FROM Teachers

-- 16.3. The identifier, the name of the teacher, his position, the general s / n (sort by s \ n).
GO
CREATE VIEW AboutTeacher AS
SELECT T.Id, T.[Name], P.[Name] AS Position
FROM Teachers AS T INNER JOIN Posts AS P
ON T.IdPost = P.Id

-- 16.4. Identification number, surname, telephone number (only those who have a phone number).
GO
CREATE VIEW Phone AS
SELECT Id, [Name], Phone
FROM Teachers
WHERE Phone IS NOT NULL

-- 16.5. Surname, position, date of admission in the format [dd/mm/yy].
GO
CREATE VIEW TDate AS
SELECT T.[Name], P.[Name] AS Position, FORMAT(HireDate, 'dd-mm-yy') AS HireDate
FROM Teachers AS T INNER JOIN Posts AS P
ON T.IdPost = P.Id

-- 16.6. Surname, position, date of receipt in the format [dd month_text yyyy].
GO
CREATE VIEW TTDate AS
SELECT T.[Name], P.[Name] AS Position, FORMAT(HireDate, 'dd-mm-yyyy') AS HireDate
FROM Teachers AS T INNER JOIN Posts AS P
ON T.IdPost = P.Id