  #Monthly Sales Trend
SELECT
YEAR(InvoiceDate) Year,
MONTH(InvoiceDate) Month,
ROUND(SUM(Quantity*Price),2) Revenue,
COUNT(DISTINCT Invoice) Orders
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY
YEAR(InvoiceDate),
MONTH(InvoiceDate)
ORDER BY
Year,
Month;

  #Month-over-Month Growth
WITH monthly AS
(
SELECT
DATE_FORMAT(InvoiceDate,'%Y-%m') Month,
SUM(Quantity*Price) Revenue
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY Month
)
SELECT
Month,
Revenue,
LAG(Revenue) OVER(ORDER BY Month) PreviousMonth,
ROUND(
(Revenue-LAG(Revenue) OVER(ORDER BY Month))
/
LAG(Revenue) OVER(ORDER BY Month)
*100
,2)
GrowthPercent
FROM monthly;