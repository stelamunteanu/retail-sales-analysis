#Top 20 products
SELECT
StockCode,
Description,
SUM(Quantity) UnitsSold,
ROUND(SUM(Quantity*Price),2) Revenue
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
AND StockCode REGEXP '^[0-9]+$'
GROUP BY
StockCode,
Description
ORDER BY Revenue DESC
LIMIT 20;

#Buttom products (Top 20)
SELECT
StockCode,
Description,
SUM(Quantity) UnitsSold,
ROUND(SUM(Quantity*Price),2) Revenue
FROM fretail_sales
WHERE Quantity>0
AND Price>0
AND Invoice NOT LIKE 'C%'
AND StockCode REGEXP '^[0-9]+$'
GROUP BY
StockCode,
Description
ORDER BY Revenue ASC
LIMIT 20;

#Pareto Analysis (80/20) Produsele care generează aproximativ 80% din venituri
WITH ProductRevenue AS
(
    SELECT
        StockCode,
        Description,
        SUM(TotalAmount) AS Revenue
    FROM fretail_sales
    WHERE Quantity > 0
      AND Price > 0
      AND Invoice NOT LIKE 'C%'
      AND StockCode REGEXP '^[0-9]+$'
    GROUP BY StockCode, Description
),

Pareto AS
(
    SELECT
        StockCode,
        Description,
        Revenue,

        ROW_NUMBER() OVER(
            ORDER BY Revenue DESC
        ) AS ProductRank,

        SUM(Revenue) OVER(
            ORDER BY Revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RunningRevenue,

        SUM(Revenue) OVER() AS TotalRevenue

    FROM ProductRevenue
)

SELECT
    StockCode,
    Description,
    Revenue,
    ProductRank,
    RunningRevenue,
    TotalRevenue,

    ROUND(
        RunningRevenue / TotalRevenue,
        4
    ) AS CumulativeRevenuePct,

    CASE
        WHEN RunningRevenue / TotalRevenue <= 0.80
            THEN 'Within 80%'
        ELSE 'Above 80%'
    END AS ParetoCategory

FROM Pareto
ORDER BY ProductRank;