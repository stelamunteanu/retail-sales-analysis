  #Custumer lifetime value
  SELECT
CustomerID,
COUNT(DISTINCT Invoice) Orders,
SUM(Quantity) Products,
ROUND(SUM(Quantity*Price),2) Revenue
FROM fretail_sales
WHERE CustomerID IS NOT NULL
AND Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY Revenue DESC;

  #Top 20 Custumers
SELECT
    CustomerID,
    COUNT(DISTINCT Invoice) AS Orders,
    SUM(Quantity) AS ItemsPurchased,
    ROUND(SUM(Quantity*Price),2) AS Revenue,
    ROUND(AVG(Quantity*Price),2) AS AverageLineValue
FROM fretail_sales
WHERE CustomerID IS NOT NULL
    AND Quantity>0
    AND Price>0
    AND Invoice NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY Revenue DESC
LIMIT 20;

#Cumers ranking
WITH CustomerRevenue AS
(
SELECT
CustomerID,
ROUND(SUM(Quantity*Price),2) Revenue
FROM fretail_sales
WHERE CustomerID IS NOT NULL
AND Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'

GROUP BY CustomerID
)
SELECT
RANK() OVER(ORDER BY Revenue DESC) CustomerRank,
CustomerID,
Revenue
FROM CustomerRevenue;