   #Data quality checks
  #Missing values analysis
SELECT
    SUM(Description IS NULL OR Description = '') AS missing_descriptions,
    SUM(CustomerID IS NULL) AS missing_customer_ids,
    ROUND(SUM(CustomerID IS NULL) * 100.0 / COUNT(*), 2) AS missing_customer_id_percentage
FROM retail_sales;

  #Duplicate transactions check
SELECT Invoice, StockCode, Quantity, InvoiceDate, Price, CustomerID, COUNT(*) AS duplicate_count
FROM retail_sales
GROUP BY Invoice, StockCode, Quantity, InvoiceDate, Price, CustomerID
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

 # Negative quantities and abnormal prices
SELECT
    SUM(Quantity < 0) AS cnegative_quantities,
    SUM(Price <= 0) AS zero_or_negative_prices,
    SUM(Quantity < 0 AND Invoice NOT LIKE 'C%') AS negative_quantities_without_return_invoice
FROM retail_sales;
    
  #Non-standard product codes
SELECT DISTINCT StockCode
FROM retail_sales
WHERE StockCode REGEXP '^[A-Za-z]+$'
ORDER BY StockCode;
    
  #Dataset time range
SELECT
    MIN(STR_TO_DATE(InvoiceDate, '%d/%m/%Y %H:%i')) AS prima_tranzactie,
    MAX(STR_TO_DATE(InvoiceDate, '%d/%m/%Y %H:%i')) AS ultima_tranzactie
FROM retail_sales;