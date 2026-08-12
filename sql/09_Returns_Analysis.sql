  #Retuns
  SELECT
COUNT(*) Returns,
ROUND(SUM(ABS(Quantity)*Price),2) ReturnedValue
FROM fretail_sales
WHERE Invoice LIKE 'C%';

#Products with highest return rate
WITH ProductReturns AS
(
SELECT
    StockCode,
    MAX(Description) AS Description,
    SUM(
        CASE
            WHEN Invoice NOT LIKE 'C%'
            THEN Quantity
            ELSE 0
        END
    ) AS SoldQty,
    ABS(
        SUM(
            CASE
                WHEN Invoice LIKE 'C%'
                THEN Quantity
                ELSE 0
            END
        )
    ) AS ReturnedQty,
    ROUND(
ABS(
            SUM(
                CASE
                    WHEN Invoice LIKE 'C%'
                    THEN Quantity*Price
                    ELSE 0
                END
            )
        ),
    2) AS ReturnedValue

FROM fretail_sales
WHERE StockCode REGEXP '^[0-9]+$'
AND Description NOT LIKE '%mould%'
AND Description NOT LIKE '%error%'
AND Description NOT LIKE '%MIA%'
AND Description NOT LIKE '%smash%'
AND Description NOT LIKE '%missing%'
AND Description NOT LIKE '%wet%'
AND Description NOT LIKE '%damaged%'
AND Description NOT LIKE '%rust%'

GROUP BY StockCode
)
SELECT
StockCode,
Description,
SoldQty,
ReturnedQty,
ROUND(
ReturnedQty*100.0/SoldQty,
2
) AS ReturnRate,
ReturnedValue
FROM ProductReturns
WHERE SoldQty >= 500
AND ReturnedQty <= SoldQty
ORDER BY ReturnRate DESC;