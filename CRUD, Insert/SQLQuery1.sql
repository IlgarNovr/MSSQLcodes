CREATE DATABASE Department
USE Department

CREATE TABLE Departments(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Financing MONEY NOT NULL CHECK(Financing >=0) DEFAULT(0),
[Name] NVARCHAR(100) NOT NULL UNIQUE CHECK([Name] <> '')
)

CREATE TABLE Faculties(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Dean NVARCHAR(MAX) NOT NULL CHECK(Dean <>''),
[Name] NVARCHAR(100) NOT NULL UNIQUE CHECK([Name] <> '')
)

CREATE TABLE Groups(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Name] NVARCHAR(10) NOT NULL UNIQUE CHECK([Name] <>''),
Rating INT NOT NULL CHECK(Rating>=0 AND Rating<=5),
[Year] INT NOT NULL CHECK([Year]>=0 AND [Year]<=5)
)

CREATE TABLE Teachers(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
EmploymentDate DATE NOT NULL CHECK(EmploymentDate>='01-01-1990'),
IsAssistant BIT NOT NULL DEFAULT(0),
IsProfessor BIT NOT NULL DEFAULT(0),
[Name] NVARCHAR(MAX) NOT NULL CHECK([Name] <> ''),
Position NVARCHAR(MAX) NOT NULL CHECK(Position <> ''),
Premium MONEY NOT NULL CHECK(Premium >=0) DEFAULT(0),
Salary MONEY NOT NULL CHECK(Salary>0),
Surname NVARCHAR(MAX) CHECK(Surname <> '')
)

INSERT INTO Departments ([Name], Financing)
VALUES 
( 'IT', 5000),
( 'Programming', 8000),
( 'Computer Science', 4000),
( 'Design', 3000),
( 'Cyber Security', 10000)

INSERT INTO Faculties (Dean, [Name])
VALUES 
( 'Davolio	Nancy', 'IT'),
('Fuller Andrew', 'Programming'),
('Leverling	Janet', 'Computer Science'),
('Peacock	Margaret' ,'Design'),
('Buchanan	Steven' ,'Cyber Security')

INSERT INTO Groups ([Name], Rating, [Year])
VALUES 
('ASD50', 1, 2),
('F35', 2, 2),
('DES2', 3, 4),
('PAT8', 4, 5),
('SA43', 5, 3)

INSERT INTO Teachers ([Name], Surname, EmploymentDate, IsAssistant,IsProfessor,Position,Premium,Salary)
VALUES 
('Michael', 'Suyama', '1991-12-13', 1, 0, 'Assistant', 200, 900),
('Robert', 'King', '1992-02-21', 0, 0,'Teacher',100,700),
('Laura', 'Callahan', '1993-05-11', 0, 1, 'Prf', 410, 1300),
('Anne', 'Dodsworth', '1994-08-23', 0, 1, 'Prf', 380, 1360),
('Gabil', 'Mammedov', '1995-01-29', 1, 0, 'Assistant', 210, 900)


--1. Print departments table but arrange its fields in the reverse order.

SELECT *
FROM Departments
ORDER BY Id DESC --ASC

--2. Print group names and their ratings using “Group Name” and “Group Rating”, respectively, as names of the fields.

SELECT [Name] AS 'Group Name', Rating AS 'Group Rating'
FROM  Groups

--3. Print for the teachers their surname, percentage of wage rate to premium ratio and percentage of wage rate to the salary ratio

SELECT Surname, Premium / Salary * 100 AS 'Percentage of wage'
FROM Teachers

--4. Print the faculty table as a single field in the following format: "The dean of faculty [faculty] is [dean]".

SELECT 'The dean of faculty ' + [Name] + ' is ' + Dean
FROM Faculties

--5. Identify names of the teachers who are professors and whose wage rate exceeds 1050.

SELECT Id, [Name]
FROM Teachers
WHERE IsProfessor = 1 AND Salary > 1050

--6. Print names of the departments whose funding is less than 11,000 or more than 25,000.

SELECT [Name]
FROM Departments
WHERE Financing NOT BETWEEN 11000 AND 25000

--7. Print names of faculties other than Computer Science.

SELECT [Name]
FROM Faculties
WHERE [Name] != 'Computer Science'

--8. Print names and positions of teachers who are not professors.
SELECT [Name], Position
FROM Teachers
WHERE IsProfessor != 1

--9. Print surnames, positions, wage rates, and premia of assistants whose premium is in the range from 160 to 550.

SELECT *
FROM Teachers
WHERE IsAssistant = 1 AND Premium BETWEEN 160 AND 550

--10. Print surnames and wage rates of assistants.

SELECT Surname, Salary
FROM Teachers
WHERE IsAssistant = 1

--11. Print surnames and positions of the teachers who were hired before 01.01.1993.

SELECT Surname, Position
FROM Teachers
WHERE EmploymentDate < '1993-01-01'

--12. Print names of the departments in alphabetical order up to the Software Development Department. 
--    The output field should be named "Name of Department".

SELECT [Name] AS 'Name of Department'
FROM Departments
ORDER BY [Name] ASC

--13. Print names of the assistants whose salary (amount of wage rate and premium) is not more than 1200.

SELECT [Name]
FROM Teachers
WHERE IsAssistant = 1 AND Salary !> 1200

--14. Print names of groups of the 5th year whose rating is in the range from 2 to 4.

SELECT [Name]
FROM Groups
WHERE [YEAR] = 5 AND Rating BETWEEN 2 AND 4

--Print names of assistants whose wage rate is less than 550 or premium is less than 400.

SELECT [Name]
FROM Teachers
WHERE IsAssistant = 1 AND (Salary < 550 OR Premium < 400)