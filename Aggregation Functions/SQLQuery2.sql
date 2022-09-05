GO
USE Employees
GO

/* 1. Get empid, firstname, lastname, country, region, city of all employees from USA. */
GO
SELECT FirstName,LastName, CountryRegionName, City
FROM Employees
WHERE CountryRegionName='United States'
GO

/* 2. Get the number of employees for each specialty. */
GO
SELECT JobTitle, COUNT(*) AS 'Number of employees'
FROM Employees
GROUP BY JobTitle
GO

/* 3. Count the number of people for each name. */
GO
SELECT FirstName, COUNT(*) AS 'Number of people name'
FROM Employees
GROUP BY FirstName
GO

/* 4. Get the most common name. */
GO
SELECT TOP(1) FirstName, COUNT(*) AS [Count]
FROM Employees
GROUP BY FirstName
ORDER BY [Count] DESC
GO

/* 5. Get the least common name. */
GO
SELECT FirstName, COUNT(*) AS [Count]
FROM Employees
GROUP BY FirstName
HAVING COUNT(*) = 1
GO

/* 6. Get the top 5 cities where the most workers are. */
GO
SELECT TOP(5) City, COUNT(*) AS [Count]
FROM Employees
GROUP BY City
ORDER BY [Count] DESC
GO

/* 7. Get the top 5 cities, which have the most unique specialties. */
GO
SELECT TOP(5) JobTitle, COUNT(*) AS [Count]
FROM Employees
GROUP BY JobTitle
ORDER BY [Count] ASC
GO

/* 8. Issue mailing addresses for emailing to all employees who started working on 1/01/2012. */
GO
SELECT EmailAddress, StartDate
FROM Employees
WHERE StartDate >= '2012-01-01'
GO

/* 9. Issue statistics in what year how many employees were employed. */
GO
SELECT YEAR(StartDate), COUNT(*)
FROM Employees
GROUP BY YEAR(StartDate)
GO

/* 10. Issue statistics in which year how many workers in which countries were employed. */
GO
SELECT DISTINCT CountryRegionName, YEAR(StartDate), COUNT(*) AS [Count]
FROM Employees
GROUP BY CountryRegionName, YEAR(StartDate)
GO

/* 11. Refresh the Employees table by adding data from the History table to the EndDate column. */
GO
UPDATE Employees
SET EndDate = h.EndDate
FROM Employees e
JOIN History h
ON h.BusinessEntityID = e.BusinessEntityID
GO


/* 12. Issue statistics on how many employees in which year they left. */
GO
SELECT YEAR(EndDate) AS [Year], COUNT(*) AS [Count]
FROM Employees
GROUP BY YEAR(EndDate)
GO

/* 13. Issue the number of employees who have worked less than a year. */
GO
SELECT FirstName, StartDate, EndDate
FROM Employees
WHERE DATEDIFF(YEAR, StartDate, EndDate) < 1 
GO