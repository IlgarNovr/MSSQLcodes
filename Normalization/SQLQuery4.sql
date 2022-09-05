--CREATE DB
GO
CREATE DATABASE AcademyDB2

GO
USE AcademyDB2

--CREATE TABLE
GO
CREATE TABLE Curators(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Name] NVARCHAR(MAX) NOT NULL CHECK([Name] <> ''),
[Surname] NVARCHAR(MAX) NOT NULL CHECK([Surname] <> '')
)

GO
CREATE TABLE Faculties(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Name] NVARCHAR(100) NOT NULL CHECK([Name] <> '') UNIQUE,
)

GO
CREATE TABLE Departments(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
Building INT NOT NULL CHECK(Building>=1 AND Building<=5),
Financing MONEY NOT NULL CHECK(Financing >= 0) DEFAULT(0),
[Name] NVARCHAR(100) NOT NULL CHECK([Name] <> '') UNIQUE,
FacultyId INT NOT NULL FOREIGN KEY REFERENCES Faculties(Id)
)

GO
CREATE TABLE Groups(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Name] NVARCHAR(10) NOT NULL CHECK([Name] <> '') UNIQUE,
[Year] INT NOT NULL CHECK([Year]>=1 AND [Year]<=5),
DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

GO
CREATE TABLE GroupsCurators(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
CuratorId INT NOT NULL FOREIGN KEY REFERENCES Curators(Id),
GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id)
)

GO
CREATE TABLE Subjects(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
[Name] NVARCHAR(100) NOT NULL UNIQUE CHECK([Name] <> '')
)

GO
CREATE TABLE Teachers(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
IsProfessor BIT NOT NULL DEFAULT(0),
[Name] NVARCHAR(MAX) NOT NULL CHECK([Name] <> ''),
Salary MONEY NOT NULL CHECK(Salary > 0),
Surname NVARCHAR(MAX) NOT NULL CHECK([Surname] <> '')
)

GO
CREATE TABLE Lectures(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
LectureDate DATE NOT NULL CHECK(LectureDate <= GETDATE()),
SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id)
)

GO
CREATE TABLE GroupsLectures(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
LectureId INT NOT NULL FOREIGN KEY REFERENCES Lectures(Id),
)

GO
CREATE TABLE Students(
Id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
[Name] NVARCHAR(MAX) NOT NULL,
Rating INT NOT NULL CHECK(Rating>=0 AND Rating<=5),
Surname NVARCHAR(MAX) NOT NULL
)

GO 
CREATE TABLE GroupsStudents(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
StudentId INT NOT NULL FOREIGN KEY REFERENCES Students(Id),
)

--INSERT
GO
INSERT INTO Curators ([Name], Surname)
VALUES
( 'Michael', 'Suyama'),
('Robert' , 'King'),
('Callahan' , 'Laura'),
('Anne' , 'Dodsworth'),
('Qabil', 'Memmedov')

GO
INSERT INTO Faculties ([Name])
VALUES 
('IT'),
('Programming'),
('Computer Science'),
('Design'),
('Cyber Security')

GO
INSERT INTO Departments ([Name], Building, Financing, FacultyId)
VALUES 
( 'IT', 1, 20000, 1),
( 'Programming', 2, 25000, 2),
( 'Computer Science', 3, 10000, 3),
( 'DEsign', 4, 8000, 4),
( 'Cyber Security', 5, 26000, 5)

GO
INSERT INTO Groups ([Name], [Year], DepartmentId)
VALUES 
('44A', 5, 1),
('22B', 4, 2),
('324E', 3, 4),
('671D', 2, 5),
('15A', 1, 3)

GO
INSERT INTO GroupsCurators (CuratorId, GroupId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)

GO
INSERT INTO Subjects ([Name])
VALUES
('IT'),
('Programming'),
('Computer Science'),
('Design'),
('Cyber Security')

GO
INSERT INTO Teachers ([Name], Surname, Salary, IsProfessor)
VALUES 
('Nancy', 'Davolio', 1000, 0),
('Andrew', 'Fuller', 1500, 1),
('Janet', 'Leverling', 500, 0),
('Margaret', 'Peacock' , 2000, 1),
('Steven', 'Buchanan' , 1100, 1)

GO
INSERT INTO Lectures (LectureDate, SubjectId, TeacherId)
VALUES
('2017-01-05', 1, 1),
('2018-02-06', 2, 2),
('2019-03-07', 3, 3),
('2020-04-08', 4, 4),
('2021-05-09', 5, 5)

GO
INSERT INTO GroupsLectures (LectureId, GroupId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)

GO 
INSERT INTO Students ([Name], Surname, Rating)
VALUES
('Romany', 'Snyder', 1),
('Randy', 'Prince', 2),
('Lucille', 'OBrien', 3),
('Kory', 'Valencia', 4),
('Malakai', 'Newman', 5)

GO
INSERT INTO GroupsStudents (StudentId, GroupId)
VALUES
(1, 5),
(2, 4),
(3, 3),
(4, 2),
(5, 1)

-----------------------------------------------------------------------------

--1. Print numbers of buildings if the total financing fund of the departments located in them exceeds 100,000.

GO
SELECT Building, Financing
FROM Departments
WHERE Financing > 10000

--2. Print names of the 5th year groups of the IT department that have more than 10 double periods in the first week.
GO
SELECT G.[Name] AS GroupName, D.[Name] AS Department
FROM Groups AS G, Departments AS D
WHERE G.DepartmentId = D.Id AND (G.[Year] = 5 AND D.[Name] = 'IT')

--3. Print names of the groups whose rating (average rating of all students in the group) is greater than the rating of the "324E" group.

GO
SELECT G.[Name], AVG(Rating)
FROM Groups AS G, Students AS S, GroupsStudents AS GS
WHERE GS.StudentId = S.Id AND GS.GroupId = G.Id 
GROUP BY G.Name
HAVING AVG(Rating) > (
SELECT AVG(Rating) 
FROM Groups AS G, Students AS S, GroupsStudents AS GS
WHERE GS.StudentId = S.Id AND GS.GroupId = G.Id AND G.[Name] = '324E'
)

--4. Print full names of teachers whose wage rate is higher than the average wage rate of professors.

GO
SELECT [Name], Surname, Salary
FROM Teachers
WHERE IsProfessor = 0 AND Salary > (
SELECT AVG(Salary)
FROM Teachers
WHERE IsProfessor = 1
)

--5. Print names of groups with more than one curator.

GO
SELECT G.[Name], COUNT(CuratorID) AS [Count]
FROM Groups AS G, GroupsCurators AS GC, Curators AS C
WHERE GC.GroupId = G.Id AND GC.CuratorID = C.Id
GROUP BY G.[Name]
HAVING COUNT(CuratorID) > 1

--6. Print names of the groups whose rating (the average rating of all students of the group) 
--   is less than the minimum rating of the 5th year groups.

GO
SELECT G.[Name] AS GroupName, AVG(Rating) AS Rating
FROM Students AS S, Groups AS G, GroupsStudents AS GS
WHERE GS.StudentId = S.Id AND GS.GroupId = G.Id 
GROUP BY G.[Name]
HAVING AVG(Rating) < (
SELECT AVG(Rating)
FROM Students AS S, Groups AS G, GroupsStudents AS GS
WHERE GS.StudentId = S.Id AND GS.GroupId = G.Id 
GROUP BY G.[Year]
HAVING G.[Year] = 5)

--7. Print names of the faculties with total financing fund of the departments
--   greater than the total financing fund of the IT department.

GO
SELECT F.[Name] AS Faculty, D.Financing
FROM Faculties AS F, Departments AS D
WHERE D.FacultyId = F.Id AND D.Financing > (
SELECT Financing
FROM Departments
WHERE [Name] = 'IT')

--8. Print names of the subjects and full names of the teachers who deliver the greates number of lectures in them.

GO
SELECT S.[Name] AS Sublect, T.[Name]+' '+T.Surname AS Teacher
FROM Subjects AS S, Teachers AS T, Lectures AS L
WHERE L.SubjectId = S.Id AND L.TeacherId = T.Id


--9. Print name of the subject in which the least number of lectures are delivered.

GO
SELECT S.[Name], COUNT(SubjectId) AS [Count]
FROM Lectures AS L, Subjects AS S
WHERE L.SubjectId = S.Id
GROUP BY S.[Name]
HAVING COUNT(SubjectId) = 1

--10. Print number of students and subjects taught at the IT department.

GO
SELECT COUNT(StudentId) AS 'Students Count', COUNT(SubjectId) AS 'Subjects Count'
FROM Departments AS D, Groups AS G, GroupsStudents AS GS, GroupsLectures AS GL, Lectures AS L
WHERE G.DepartmentId = D.Id AND GS.GroupId = G.Id AND GL.GroupId = G.Id AND GL.LectureId = L.Id
GROUP BY D.[Name]
HAVING D.[Name] = 'IT'