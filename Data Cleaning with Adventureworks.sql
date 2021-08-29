 SELECT *
 FROM AdWorks..DimEmployee
 
 --Standardize dates upon retrieval
 SELECT FORMAT(HireDate, 'MMM dd yyyy') AS ConvertedHireDate,
 FORMAT(BirthDate, 'MMM dd yyyy') AS ConvertedBirthDate,
 FORMAT(StartDate, 'MMM dd yyyy') AS ConvertedStartDate,
 FORMAT(EndDate, 'MMM dd yyyy') AS ConvertedEndDate
 FROM AdWorks..DimEmployee

-- handle null value in the status column; if NULL, assume they are terminated
SELECT FirstName, LastName, ISNULL(Status, 'Terminated') AS TrueStatus
FROM Adworks..DimEmployee

UPDATE AdWorks..DimEmployee
SET Status = ISNULL(Status, 'Terminated')

-- we want to ensure all SalesTerritoryKeys are type char two characters; let's check
SELECT DISTINCT s.SalesTerritoryRegion AS Region, LEN(e.SalesTerritoryKey) AS SalesTerritoryKeyLength
FROM AdWorks..DimEmployee e INNER JOIN AdWorks..DimSalesTerritory s ON e.SalesTerritoryKey = s.SalesTerritoryKey

-- this column is type int; we have some Regions that have a SalesTerritoryKey length of 1; let's isolate those
SELECT DISTINCT s.SalesTerritoryRegion AS Region, LEN(e.SalesTerritoryKey) AS SalesTerritoryKeyLength
FROM AdWorks..DimEmployee e INNER JOIN AdWorks..DimSalesTerritory s ON e.SalesTerritoryKey = s.SalesTerritoryKey
WHERE LEN(e.SalesTerritoryKey) <> 2

-- account for this error without updating the table
SELECT DISTINCT s.SalesTerritoryRegion AS Region,
CASE
	WHEN LEN(e.SalesTerritoryKey) = 1 THEN CONCAT(0,CAST(e.SalesTerritoryKey AS char))
	ELSE CAST(e.SalesTerritoryKey AS char)
END AS SalesTerritoryKey
FROM AdWorks..DimEmployee e INNER JOIN AdWorks..DimSalesTerritory s ON e.SalesTerritoryKey = s.SalesTerritoryKey
ORDER BY 2

-- parse each employee username from the email and add it to the table
SELECT SUBSTRING(EmailAddress, 1, CHARINDEX('@', EmailAddress)-1)
FROM Adworks..DimEmployee

ALTER TABLE Adworks..DimEmployee
ADD UserName Nvarchar(255)

UPDATE AdWorks..DimEmployee
SET UserName = SUBSTRING(EmailAddress, 1, CHARINDEX('@', EmailAddress)-1)

-- check to see if there are any null gender records that need to be addressed
SELECT *
FROM AdWorks..DimEmployee
WHERE Gender = NULL

-- all employees have a gender assigned, so now change M and F to Male and Female 
ALTER TABLE Adworks..DimEmployee
ALTER COLUMN Gender NVARCHAR(10)

UPDATE AdWorks..DimEmployee
SET Gender = CASE
				WHEN Gender = 'F' THEN 'Female'
				ELSE 'Male'
			 END

-- delete unused columns
ALTER TABLE Adworks..DimEmployee
DROP COLUMN ParentEmployeeNationalIDAlternateKey, MiddleName, SalesPersonFlag
