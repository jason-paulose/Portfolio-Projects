SELECT *
FROM AdWorks..FactInternetSales
ORDER BY OrderDateKey;

SELECT CustomerKey, FirstName, MiddleName, LastName, Gender, BirthDate, YearlyIncome
FROM Adworks..DimCustomer
ORDER BY 1;

-- Look at count of Male vs. Female customers
SELECT Gender, COUNT(CustomerKey) AS [Gender Counts]
FROM AdWorks..DimCustomer
GROUP BY Gender;

-- Look at youngest customer for each gender
SELECT Gender, MAX(BirthDate) AS [Most Recent Birth]
FROM AdWorks..DimCustomer
GROUP BY Gender;

-- Look at average number of children for each income bracket
SELECT YearlyIncome, AVG(TotalChildren)
FROM AdWorks..DimCustomer
GROUP BY YearlyIncome
ORDER BY 1;