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

-- we want to ensure that the department is only one word; let's check
SELECT DISTINCT DepartmentName
FROM AdWorks..DimEmployee;

-- very few departments only have one word; account for this error without updating the table
SELECT value
FROM AdWorks..DimEmployee
	CROSS APPLY STRING_SPLIT(DepartmentName, ' ')