--USE DB
GO
USE Library

-- 8. Display all visitors to the library (and students and teachers) and the books they took.
-- 8. Kitabxananın bütün ziyarətçilərini və onların götürdüyü kitabları çıxarın.
GO
SELECT S.FirstName +' '+ S.LastName AS Fullname, B.[Name] AS Bookname
FROM Books AS B INNER JOIN S_Cards AS SC
ON SC.Id_Book = B.Id INNER JOIN Students AS S
ON SC.Id_Student = S.Id
UNION 
SELECT T.FirstName +' '+ T.LastName AS Fullname, B.[Name] AS Bookname
FROM Books AS B INNER JOIN T_Cards AS TC
ON TC.Id_Book = B.Id INNER JOIN Teachers AS T
ON TC.Id_Teacher = T.Id

--9. Print the most popular author (s) among students and the number of books of this author taken in the library.
--9. Studentlər arasında ən məşhur author(lar) və onun(ların) götürülmüş kitablarının sayını çıxarın.
GO
SELECT A.FirstName, A.LastName, COUNT(B.Id_Author) AS 'Number of books'
FROM Authors AS A INNER JOIN Books AS B
ON A.Id = B.Id_Author INNER JOIN S_Cards AS SC
ON B.Id = SC.Id_Book
GROUP BY A.FirstName, A.LastName, Id_Author
HAVING COUNT(B.Id_Author) =(
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Author) AS C
FROM Authors AS A INNER JOIN Books AS B
ON A.Id = B.Id_Author INNER JOIN S_Cards AS SC
ON B.Id = SC.Id_Book
GROUP BY Id_Author) 
t)

--10. Print the most popular author (s) among the teachers and the number of books of this author taken in the library.
--10.Tələbələr arasında ən məşhur author(lar) və onun(ların) götürülmüş kitablarının sayını çıxarın.
GO
SELECT A.FirstName, A.LastName, COUNT(B.Id_Author) AS 'Number of books'
FROM Authors AS A INNER JOIN Books AS B
ON A.Id = B.Id_Author INNER JOIN T_Cards AS TC
ON B.Id = TC.Id_Book
GROUP BY A.FirstName, A.LastName, B.Id_Author
HAVING COUNT(B.Id_Author) =(
SELECT MAX(C)
FROM (
SELECT COUNT(B.Id_Author) AS C
FROM Authors AS A INNER JOIN Books AS B
ON A.Id = B.Id_Author INNER JOIN T_Cards AS TC
ON B.Id = TC.Id_Book
GROUP BY Id_Author) 
t)

--11. To deduce the most popular subjects (and) among students and teachers.
--11. Student və Teacherlər arasında ən məşhur mövzunu(ları) çıxarın.
GO
SELECT T.[Name] AS Theme, COUNT(SC.Id_Book) AS [Count]
FROM Themes AS T INNER JOIN Books AS B
ON T.Id = B.Id_Themes INNER JOIN S_Cards AS SC
ON SC.Id_Book=B.Id
GROUP BY T.[Name], SC.Id_Book
HAVING COUNT(SC.Id_Book)= (
SELECT MAX(C)
FROM(
SELECT COUNT(SC.Id_Book) AS C
FROM Themes AS T INNER JOIN Books AS B
ON T.Id = B.Id_Themes INNER JOIN S_Cards AS SC
ON SC.Id_Book=B.Id
GROUP BY SC.Id_Book)
t)
UNION
SELECT T.[Name] AS Theme, COUNT(TC.Id_Book) AS [Count]
FROM Themes AS T INNER JOIN Books AS B
ON T.Id = B.Id_Themes INNER JOIN T_Cards AS TC
ON TC.Id_Book=B.Id
GROUP BY T.[Name], TC.Id_Book
HAVING COUNT(TC.Id_Book)= (
SELECT MAX(C)
FROM(
SELECT COUNT(TC.Id_Book) AS C
FROM Themes AS T INNER JOIN Books AS B
ON T.Id = B.Id_Themes INNER JOIN T_Cards AS TC
ON TC.Id_Book=B.Id
GROUP BY TC.Id_Book)
t)

--12. Display the number of teachers and students who visited the library.
--12. Kitabxanaya neçə tələbə və neçə müəllim gəldiyini ekrana çıxarın.
GO
SELECT COUNT(DISTINCT Id_Student) AS Student, COUNT(DISTINCT Id_Teacher) AS Teacher
FROM S_Cards,T_Cards

--13. If you count the total number of books in the library for 100%, then you need to calculate how many books (in percentage terms) each faculty took.
--13. Əgər bütün kitabların sayını 100% qəbul etsək, siz hər fakultənin neçə faiz kitab götürdüyünü hesablamalısınız.
GO
SELECT F.[Name] AS Faculty, COUNT(Id_Faculty) * 100 / (SELECT COUNT(*) FROM Books) AS '%'
FROM Faculties AS F INNER JOIN Groups AS G
ON G.Id_Faculty = F.Id INNER JOIN Students AS S
ON S.Id_Group = G.Id INNER JOIN S_Cards AS SC
ON SC.Id_Student = S.Id
GROUP BY F.[Name]

--14. Display the most reading faculty and the most reading chair.
--14. Ən çox oxuyan fakultə və dekanatlığı ekrana çıxarın.
GO
SELECT F.[Name], COUNT(Id_Book)
FROM Faculties AS F INNER JOIN Groups AS G
ON F.Id = G.Id_Faculty INNER JOIN Students AS S 
ON G.Id = S.Id_Group INNER JOIN S_Cards AS SC
ON S.Id = SC.Id_Student
GROUP BY F.[Name]
HAVING COUNT(Id_Book) = (
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Book) AS C
FROM Faculties AS F INNER JOIN Groups AS G
ON F.Id = G.Id_Faculty INNER JOIN Students AS S 
ON G.Id = S.Id_Group INNER JOIN S_Cards AS SC
ON S.Id = SC.Id_Student
GROUP BY F.[Name]) 
t)
UNION
SELECT D.[Name], COUNT(Id_Book)
FROM Departments AS D INNER JOIN Teachers AS T
ON D.Id = T.Id_Dep INNER JOIN T_Cards AS TC 
ON T.Id = TC.Id_Teacher
GROUP BY D.[Name]
HAVING COUNT(Id_Book) = (
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Book) AS C
FROM Departments AS D INNER JOIN Teachers AS T
ON D.Id = T.Id_Dep INNER JOIN T_Cards AS TC 
ON T.Id = TC.Id_Teacher
GROUP BY D.[Name]) 
t)


--15. Show the author (s) of the most popular books among teachers and students.
--15. Tələbələr və müəllimlər arasında ən məşhur authoru çıxarın.
GO
SELECT A.FirstName,A.LastName , COUNT(Id_Book) AS 'Number of reader'
FROM Books AS B INNER JOIN S_Cards AS SC
ON SC.Id_Book = B.Id INNER JOIN Authors AS A
ON B.Id_Author = A.Id
GROUP BY A.FirstName,A.LastName,B.Id_Author
HAVING COUNT(Id_Book) = (
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Book) AS C
FROM Books AS B INNER JOIN S_Cards AS SC
ON SC.Id_Book = B.Id INNER JOIN Authors AS A
ON B.Id_Author = A.Id
GROUP BY A.FirstName,A.LastName,B.Id_Author)
t)
UNION
SELECT A.FirstName,A.LastName , COUNT(Id_Book)
FROM Books AS B INNER JOIN T_Cards AS TC
ON TC.Id_Book = B.Id INNER JOIN Authors AS A
ON B.Id_Author = A.Id
GROUP BY A.FirstName,A.LastName,B.Id_Author
HAVING COUNT(Id_Book) = (
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Book) AS C
FROM Books AS B INNER JOIN T_Cards AS TC
ON TC.Id_Book = B.Id INNER JOIN Authors AS A
ON B.Id_Author = A.Id
GROUP BY A.FirstName,A.LastName,B.Id_Author)
t)

--16. Display the names of the most popular books among teachers and students.
--16. Müəllim və Tələbələr arasında ən məşhur kitabların adlarını çıxarın.
GO
SELECT B.[Name], COUNT(Id_Book) AS [Count]
FROM S_Cards AS SC INNER JOIN Books AS B
ON SC.Id_Book = B.Id
GROUP BY B.[Name]
HAVING COUNT(Id_Book) = (
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Book) AS C
FROM S_Cards AS SC INNER JOIN Books AS B
ON SC.Id_Book = B.Id
GROUP BY B.[Name]) 
t)
UNION
SELECT B.[Name], COUNT(Id_Book) 
FROM T_Cards AS TC INNER JOIN Books AS B
ON TC.Id_Book = B.Id
GROUP BY B.[Name]
HAVING COUNT(Id_Book) = (
SELECT MAX(C)
FROM (
SELECT COUNT(Id_Book) AS C
FROM T_Cards AS TC INNER JOIN Books AS B
ON TC.Id_Book = B.Id
GROUP BY B.[Name]) 
t)

--17. Show all students and teachers of designers.
--17. Dizayn sahəsində olan bütün tələbə və müəllimləri ekrana çıxarın.
GO
SELECT FirstName, LastName, D.[Name] AS 'Faculty or department' 
FROM Teachers AS T INNER JOIN Departments AS D
ON T.Id_Dep = D.Id
WHERE D.[Name] = 'Graphics and Designs'
UNION 
SELECT FirstName, LastName, F.[Name] 
FROM Students AS S  INNER JOIN Groups AS G
ON S.Id_Group = G.Id INNER JOIN Faculties AS F
ON G.Id_Faculty = F.Id
WHERE F.[Name] = 'Web Design'

--18. Show all information about students and teachers who have taken books.
--18. Kitab götürən tələbə və müəllimlər haqqında informasiya çıxarın.
GO
SELECT FirstName, LastName, DateOut, B.[Name] AS 'Book name'
FROM Teachers AS T INNER JOIN T_Cards AS TC
ON TC.Id_Teacher = T.Id INNER JOIN Books AS B
ON TC.Id_Book=B.Id
WHERE TC.DateIn IS NULL
UNION 
SELECT FirstName, LastName, DateOut, B.[Name]
FROM Students AS S INNER JOIN S_Cards AS SC
ON SC.Id_Student = S.Id INNER JOIN Books AS B
ON SC.Id_Book=B.Id
WHERE SC.DateIn IS NULL

--19. Show books that were taken by both teachers and students.
--19. Həm müəllimlərin, həm də tələbələrin götürdüyü kitabları göstərin.
GO
SELECT B.[Name] AS BOOKS
FROM T_Cards AS TC INNER JOIN Books AS B
ON TC.Id_Book = B.Id
INTERSECT
SELECT B.[Name]
FROM S_Cards AS SC INNER JOIN Books AS B
ON SC.Id_Book = B.Id


--20. Show how many books each librarian issued.
--20. Hər kitbxanaçının (libs) neçə kitab verdiyini ekrana çıxarın.
GO
SELECT FirstName, LastName, COUNT(Id_Lib) AS 'Number of books'
FROM (
SELECT L.FirstName, L.LastName, Id_Lib
FROM T_Cards AS TC INNER JOIN Libs AS L
ON TC.Id_Lib = L.Id
UNION ALL
SELECT L.FirstName, L.LastName, Id_Lib
FROM S_Cards AS SC INNER JOIN Libs AS L
ON SC.Id_Lib = L.Id )t
GROUP BY  FirstName, LastName

