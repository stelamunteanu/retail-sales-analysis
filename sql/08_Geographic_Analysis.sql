  #Countries
SELECT
Country,
ROUND(SUM(Quantity*Price),2) Revenue,
COUNT(DISTINCT CustomerID) Customers,
COUNT(DISTINCT Invoice) Orders
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY Country
ORDER BY Revenue DESC;