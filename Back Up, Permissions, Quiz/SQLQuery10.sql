--USE DB
USE Library

--1. Write a function that returns a list of books with the minimum number of pages issued by a particular publisher.
--1. Müəyyən Publisher tərəfindən çap olunmuş minimum səhifəli kitabların siyahısını çıxaran funksiya yazın.
GO
CREATE FUNCTION MinPageBooks (@PressId int)
RETURNS TABLE
AS
RETURN 
SELECT [Name], Pages
FROM Books INNER JOIN (
SELECT min(Pages) AS MPage, Id_Press
FROM Books
WHERE Id_Press = @PressId
GROUP BY Id_Press
) AS T
ON Books.Id_Press = T.Id_Press AND Pages = MPage

--2. Write a function that returns the names of publishers who have published books with an average number of pages greater than N.
--   The average number of pages is passed through the parameter.
--2. Orta səhifə sayı N-dən çox səhifəli kitab çap edən Publisherlərin adını qaytaran funksiya yazın. 
--   N parameter olaraq göndərilir.
GO
CREATE FUNCTION AveragePages (@N int)
RETURNS TABLE
AS
RETURN 
SELECT P.[Name], AVG(B.Pages) AS SPages
FROM Books AS B INNER JOIN Press AS P
ON B.Id_Press = P.Id
GROUP BY P.[Name]
HAVING AVG(Pages) > @N

--3. Write a function that returns the total sum of the pages of all the books in the library issued by the specified publisher.
--3. Müəyyən Publisher tərəfindən çap edilmiş bütün kitab səhifələrinin cəmini tapan və qaytaran funksiya yazın.
GO
CREATE FUNCTION SumPages()
RETURNS TABLE
AS
RETURN 
SELECT Press.[Name], SUM(Pages) AS SPages
FROM Books INNER JOIN Press
ON Books.Id_Press = Press.Id
GROUP BY Press.[Name]

--4. Write a function that returns a list of names and surnames of all students who took books between the two specified dates.
--4. Müəyyən iki tarix aralığında kitab götürmüş Studentlərin ad və soyadını list şəklində qaytaran funksiya yazın.
GO
CREATE FUNCTION WhoTookBook (@DateIn DATETIME, @DateOut DATETIME)
RETURNS TABLE
AS
RETURN 
SELECT FirstName, LastName, DateOut
FROM S_Cards INNER JOIN Students
ON S_Cards.Id_Student = Students.Id
WHERE DateOut BETWEEN @DateIn AND @DateOut

--5. Write a function that returns a list of students who are currently working with the specified book of a certain author.
--5. Müəyyən kitabla hal hazırda işləyən bütün tələbələrin siyahısını qaytaran funksiya yazın.
GO
CREATE FUNCTION StudentsWorkingBook (@BookId int)
RETURNS TABLE
AS
RETURN
SELECT FirstName, LastName, [Name] AS Book
FROM S_Cards AS SC INNER JOIN Students AS S
ON SC.Id_Student = S.Id INNER JOIN Books AS B
ON SC.Id_Book = B.Id
WHERE SC.Id_Book = @BookId

--6. Write a function that returns information about publishers whose total number of pages of books issued by them is greater than N.
--6. Çap etdiyi bütün səhifə cəmi N-dən böyük olan Publisherlər haqqında informasiya qaytaran funksiya yazın.
CREATE FUNCTION SumPageGr(@N int)
RETURNS TABLE
AS
RETURN 
SELECT Press.[Name], SUM(Pages) AS SPages
FROM Books INNER JOIN Press
ON Books.Id_Press = Press.Id
GROUP BY Press.[Name]
HAVING SUM(Pages) > @N

--7. Write a function that returns information about the most popular author among students and about the number of books of this author taken in the library.
--7. Studentlər arasında Ən popular avtor və onun götürülmüş kitablarının sayı haqqında informasiya verən funksiya yazın. 
GO
CREATE FUNCTION PopularAuthor ()
RETURNS TABLE
AS 
RETURN 
SELECT A.FirstName, A.LastName, COUNT(Id_Author) AS CountBook
FROM Authors AS A INNER JOIN Books AS B
ON A.Id = B.Id_Author INNER JOIN S_Cards AS SC
ON B.Id = SC.Id_Book
GROUP BY A.FirstName, A.LastName, Id_Author
HAVING COUNT(Id_Author) = (
SELECT MAX(Cnt)
FROM (
SELECT COUNT(Id_Author) AS Cnt
FROM Authors AS A INNER JOIN Books AS B
ON A.Id = B.Id_Author INNER JOIN S_Cards AS SC
ON B.Id = SC.Id_Book
GROUP BY Id_Author)t
) 

--8. Write a function that returns a list of books that were taken by both teachers and students.
--Studentlər və Teacherlər (hər ikisi) tərəfindən götürülmüş (ortaq - həm onlar həm bunlar) kitabların listini qaytaran funksiya yazın.
GO
CREATE FUNCTION BooksTakenST ()
RETURNS TABLE
AS 
RETURN 
SELECT B.[Name]
FROM T_Cards AS TC INNER JOIN Books AS B
ON TC.Id_Book = B.Id
INTERSECT
SELECT B.[Name]
FROM S_Cards AS SC INNER JOIN Books AS B
ON SC.Id_Book = B.Id

--9. Write a function that returns the number of students who did not take books.
--9. Kitab götürməyən tələbələrin sayını qaytaran funksiya yazın.
GO
CREATE FUNCTION DidntTakeBookStudentsCount ()
RETURNS INT
AS
BEGIN
DECLARE @count int
SELECT @count = COUNT(*)
FROM Students AS S LEFT JOIN S_Cards AS SC
ON S.Id = SC.Id_Student
WHERE SC.Id_Student IS NULL
RETURN @count
END