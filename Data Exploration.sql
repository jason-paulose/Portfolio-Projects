-- Count rows
SELECT COUNT(*) as [Row Count]
FROM AdWorks..FactInternetSales

-- Count distinct number of products
SELECT COUNT(DISTINCT ProductKey) AS [Distinct Product Count]
FROM AdWorks..FactInternetSales

-- Calculate the amount($) sold per product, for all products
SELECT p.EnglishProductName AS Product, SUM(i.SalesAmount) as [Sales Amount]
FROM AdWorks..DimProduct p LEFT JOIN AdWorks..FactInternetSales i ON p.ProductKey = i.ProductKey
GROUP BY p.EnglishProductName;

-- Calculate the average amount sold per day
SELECT OrderDate, SUM(SalesAmount) as [Sales Amount]
FROM AdWorks..FactInternetSales
GROUP BY OrderDate
ORDER BY 1

-- Calculate standard deviation of customer expenditure to understand disparity (to nearest $)
SELECT ROUND(STDEV(SalesAmount),2) AS [STD Total Spend]
FROM AdWorks..FactInternetSales

-- Calculate the Max sales amount
SELECT MAX(SalesAmount) AS [Max Sales Amount]
FROM AdWorks..FactInternetSales

-- Slice data to calculate number of orders from households with 3, 4, and 5 children in 2018
SELECT c.TotalChildren AS [Number of Children], COUNT(i.SalesOrderNumber) AS [Total Number of Orders]
FROM AdWorks..DimCustomer c LEFT JOIN AdWorks..FactInternetSales i ON c.CustomerKey = i.CustomerKey
WHERE c.TotalChildren IN (3,4,5) AND YEAR(i.OrderDate) = '2018'
GROUP BY c.TotalChildren