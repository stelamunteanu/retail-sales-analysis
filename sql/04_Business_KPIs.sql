  #Total Revenue
SELECT
ROUND(SUM(Quantity*Price),2) AS Revenue
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%';

  #Total Orders
SELECT
COUNT(DISTINCT Invoice) Orders 
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%';

  #Total Custumers
SELECT
COUNT(DISTINCT CustomerID)
FROM fretail_sales
WHERE CustomerID IS NOT NULL
AND Quantity>0
AND Invoice NOT LIKE 'C%';

  #Average order value
SELECT
ROUND(
SUM(Quantity*Price)/COUNT(DISTINCT Invoice)
,2) AS Average_Order_Value
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%';