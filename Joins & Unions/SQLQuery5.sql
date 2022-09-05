--USE DB
USE Library

--1. Display books with the minimum number of pages issued by a particular publishing house.
GO
SELECT B.[Name] AS 'Book Name',B.Pages
FROM Books AS B INNER JOIN Press AS P
ON B.Id_Press = P.Id
WHERE B.Pages =(
SELECT MIN(Pages)
FROM Books
WHERE Books.Id_Press = P.Id
)

--2. Display the names of publishers who have issued books with an average number of pages larger than 100.
GO
SELECT P.[Name] AS Press, AVG(B.Pages) AS 'Average number of pages'
FROM Books AS B INNER JOIN Press AS P
ON B.Id_Press = P.Id
GROUP BY P.[Name]
HAVING AVG(Pages) > 100

--3. Output the total amount of pages of all the books in the library issued by the publishing houses BHV and BINOM.
GO
SELECT SUM(Pages) AS 'Total Page'
FROM Books AS B INNER JOIN Press AS P
ON B.Id_Press = P.Id
WHERE P.[Name] = 'BHV' OR P.[Name] = 'BİNOM'

--4. Select the names of all students who took books between January 1, 2001 and the current date
GO
SELECT S.FirstName+' '+S.LastName AS Student, SC.DateOut
FROM Students AS S INNER JOIN S_Cards AS SC
ON SC.Id_Student = S.Id
WHERE SC.DateOut BETWEEN '2001-01-01' AND GETDATE()

--5. Find all students who are currently working with the book "Windows 2000 Registry" by Olga Kokoreva
GO
SELECT S.FirstName, S.LastName, SC.DateOut
FROM Books AS B INNER JOIN S_Cards AS SC
ON SC.Id_Book = B.Id
INNER JOIN Students AS S
ON SC.Id_Student = S.Id
WHERE B.[Name] = 'Windows 2000 Registry' --AND DateIn IS NULL

--6. Display information about authors whose average volume of books (in pages) is more than 600 pages
GO
SELECT A.FirstName, A.LastName, AVG(B.Pages) AS 'Average number of pages'
FROM Books AS B INNER JOIN Authors AS A
ON B.Id_Author = A.Id
GROUP BY A.FirstName, A.LastName
HAVING AVG(B.Pages) > 600


--7. Display information about publishers, whose total number of pages of books published by them is more than 700.
GO
SELECT P.[Name] AS Press, SUM(B.Pages) AS 'Total Page'
FROM Books AS B INNER JOIN Press AS P
ON B.Id_Press = P.Id
GROUP BY P.[Name]
HAVING SUM(B.Pages) > 700


