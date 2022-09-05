GO
CREATE DATABASE AcademyDB

GO
USE AcademyDB

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
Financing MONEY NOT NULL CHECK(Financing >= 0) DEFAULT(0),
[Name] NVARCHAR(100) NOT NULL CHECK([Name] <> '') UNIQUE,
)

GO
CREATE TABLE Departments(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
[Name] NVARCHAR(MAX) NOT NULL CHECK([Name] <> ''),
Salary MONEY NOT NULL CHECK(Salary > 0),
Surname NVARCHAR(MAX) NOT NULL CHECK([Surname] <> '')
)

GO
CREATE TABLE Lectures(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
LectureRoom NVARCHAR(MAX) NOT NULL CHECK(LectureRoom <> ''),
SubjectId INT NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
TeacherId INT NOT NULL FOREIGN KEY REFERENCES Teachers(Id)
)

GO
CREATE TABLE GroupsLectures(
Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
GroupId INT NOT NULL FOREIGN KEY REFERENCES Groups(Id),
LectureId INT NOT NULL FOREIGN KEY REFERENCES Lectures(Id),
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
INSERT INTO Faculties (Financing, [Name])
VALUES 
(10000, 'IT'),
(13000, 'Programming'),
(8000, 'Computer Science'),
(11000, 'Design'),
(15000, 'Cyber Security')

GO
INSERT INTO Departments ([Name], Financing, FacultyId)
VALUES 
( 'IT', 20000, 1),
( 'Programming', 25000, 2),
( 'Computer Science', 10000, 3),
( 'DEsign', 8000, 4),
( 'Cyber Security', 26000, 5)

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
INSERT INTO Teachers ([Name], Surname, Salary)
VALUES 
('Nancy', 'Davolio', 1000),
('Andrew', 'Fuller', 1500),
('Janet', 'Leverling', 500),
('Margaret', 'Peacock' , 2000),
('Steven', 'Buchanan' , 1100)

GO
INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId)
VALUES
('A1', 1, 1),
('A2', 2, 2),
('A3', 3, 3),
('A4', 4, 4),
('A5', 5, 5)

GO
INSERT INTO GroupsLectures (LectureId, GroupId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5)

-----------------------------------------------------------------------------
--1. Print all possible pairs of lines of teachers and groups.
GO
SELECT Teachers.[Name] AS TName, Teachers.Surname AS TSurname, [Year], Lectures.LectureRoom
FROM Groups, GroupsLectures, Lectures, Teachers
WHERE Groups.Id = GroupId AND Lectures.Id = LectureId AND Teachers.Id = TeacherId

--2. Print names of faculties, where financing fund of departments exceeds financing fund of the faculty.
GO
SELECT Faculties.[Name], Faculties.Financing AS FacultyFin, Departments.Financing AS DepartmentFin
FROM Faculties, Departments
WHERE Faculties.Id = FacultyId AND Departments.Financing > Faculties.Financing

--3. Print names of the group curators and groups names they are supervising.
GO
SELECT Curators.[Name] + Curators.Surname AS Curator, Groups.[Name] AS [Group]
FROM Groups, GroupsCurators, Curators
WHERE Groups.Id = GroupId AND Curators.Id = CuratorID

--4. Print names of the teachers who deliver lectures in the group "15A".
GO
SELECT Teachers.[Name], Teachers.Surname
FROM Groups, GroupsLectures, Lectures, Teachers
WHERE Groups.[Name] = '15A' AND  Groups.Id = GroupId AND Lectures.Id = LectureId AND Teachers.Id = TeacherId


--5. Print names of the teachers and names of the faculties where they are lecturing.
GO
SELECT Teachers.[Name], Teachers.Surname, Faculties.[Name] AS FName
FROM Faculties, Departments, Groups, GroupsLectures, Lectures, Teachers
WHERE Faculties.Id = FacultyId AND Departments.Id = DepartmentId AND Groups.Id = GroupId AND Lectures.Id = LectureId AND Teachers.Id = TeacherId

--6. Print names of the departments and names of the groups that relate to them.
GO
SELECT Groups.[Name] AS GroupName, Departments.[Name] AS DepartmentName
FROM Groups, Departments
WHERE Departments.Id = DepartmentId

--7. Print names of the subjects that the teacher "Nancy Davolio" teaches.
GO
SELECT Teachers.[Name],Teachers.Surname, Subjects.[Name] AS [Subject]
FROM Subjects, Lectures, Teachers
WHERE Subjects.Id = SubjectId AND Teachers.Id = TeacherId AND Teachers.[Name]='Nancy' AND Teachers.Surname = 'Davolio'

--8. Print names of the departments, where "IT" is taught.
GO
SELECT Departments.[Name], Departments.Financing
FROM Departments, Groups, GroupsLectures, Lectures, Subjects
WHERE Departments.Id = DepartmentId AND Groups.Id = GroupId AND Lectures.Id = LectureId AND Subjects.Id = SubjectId AND Subjects.[Name] = 'IT'

--9. Print names of the groups that belong to the "Computer Science" faculty.
SELECT Groups.Id, Groups.[Name], Groups.[Year], Departments.[Name] AS Department
FROM Groups, Departments, Faculties
WHERE Faculties.Id = FacultyId AND Departments.Id = DepartmentId AND Faculties.[Name] = 'Computer Science'

--10. Print names of the 5th year groups, as well as names of the faculties to which they relate.
GO
SELECT Groups.[Name] AS GroupName, Faculties.[Name] AS FacultyName
FROM Groups, Departments, Faculties
WHERE Faculties.Id = FacultyId AND Departments.Id = DepartmentId AND [YEAR] = 5

--11. Print full names of the teachers and lectures they deliver (names of subjects and groups), 
--    and select only those lectures that are delivered in the classroom "A5".
GO
SELECT Teachers.[Name] AS TName, Teachers.Surname AS TSurname, Subjects.[Name] AS [Subject], Groups.[Name] AS GroupName, LectureRoom
FROM Groups, GroupsLectures, Lectures, Teachers, Subjects
WHERE Groups.Id = GroupId AND Lectures.Id = LectureId AND Teachers.Id = TeacherId AND Subjects.Id = SubjectId AND LectureRoom = 'A5'
