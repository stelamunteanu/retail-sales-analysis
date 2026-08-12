#RFM Metrics
WITH CustomerRFM AS
(
SELECT
CustomerID,
DATEDIFF(
(SELECT MAX(InvoiceDate) FROM fretail_sales),
MAX(InvoiceDate)
) AS Recency,
COUNT(DISTINCT Invoice) Frequency,
ROUND(SUM(Quantity*Price),2) Monetary
FROM fretail_sales
WHERE CustomerID IS NOT NULL
AND Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY CustomerID

)
SELECT *
FROM CustomerRFM;

#RFM Scores
WITH CustomerRFM AS
(
SELECT
CustomerID,
DATEDIFF(
    (SELECT MAX(InvoiceDate) FROM fretail_sales),
    MAX(InvoiceDate)
) AS Recency,
COUNT(DISTINCT Invoice) Frequency,
SUM(Quantity*Price) Monetary
FROM fretail_sales
WHERE CustomerID IS NOT NULL
AND Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY CustomerID
),
Scores AS
(
SELECT *,
NTILE(5) OVER(ORDER BY Recency DESC) AS R,
NTILE(5) OVER(ORDER BY Frequency ASC) AS F,
NTILE(5) OVER(ORDER BY Monetary ASC) AS M
FROM CustomerRFM
)
SELECT *
FROM Scores;


#Custumer segmentation
WITH CustomerRFM AS
(
SELECT
CustomerID,
DATEDIFF(
(SELECT MAX(InvoiceDate) FROM fretail_sales),
MAX(InvoiceDate)
) AS Recency,
COUNT(DISTINCT Invoice) Frequency,
SUM(Quantity*Price) Monetary
FROM fretail_sales
WHERE CustomerID IS NOT NULL
AND Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
GROUP BY CustomerID
),

Scores AS
(
SELECT *,
NTILE(5) OVER(ORDER BY Recency DESC) R,
NTILE(5) OVER(ORDER BY Frequency ASC) F,
NTILE(5) OVER(ORDER BY Monetary ASC) M
FROM CustomerRFM
)

SELECT
CustomerID,
Recency,
Frequency,
ROUND(Monetary,2) Monetary,
CONCAT(R,F,M) AS RFM_Score,
CASE
WHEN R>=4 AND F>=4 AND M>=4 THEN 'Champions'
WHEN R>=3 AND F>=4 THEN 'Loyal Customers'
WHEN R>=4 AND F<=2 THEN 'New Customers'
WHEN R<=2 AND F>=4 THEN 'At Risk'
WHEN R=1 AND F=1 AND M=1 THEN 'Lost Customers'
ELSE 'Potential Loyalists'
END AS CustomerSegment
FROM Scores
ORDER BY Monetary DESC;

