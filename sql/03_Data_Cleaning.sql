  #Data cleanind + final table
CREATE TABLE fretail_sales (
    Invoice      VARCHAR(20)   NOT NULL,
    StockCode    VARCHAR(20)   NOT NULL,
    Description  VARCHAR(255),
    Quantity     INT           NOT NULL,
    InvoiceDate  DATETIME      NOT NULL,
    Price        DECIMAL(10,2) NOT NULL,
    CustomerID   INT           NULL,
    Country      VARCHAR(100),
    TotalAmount  DECIMAL(12,2) GENERATED ALWAYS AS (Quantity * Price) STORED,
    IsCancelled  TINYINT(1)    GENERATED ALWAYS AS (CASE WHEN Invoice LIKE 'C%' THEN 1 ELSE 0 END) STORED
);

INSERT INTO fretail_sales (Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country)
SELECT
    Invoice,
    StockCode,
    NULLIF(TRIM(Description), '')              AS Description,
    Quantity,
    STR_TO_DATE(InvoiceDate, '%d/%m/%Y %H:%i')  AS InvoiceDate,
    Price,
    CAST(NULLIF(CustomerID, '') AS UNSIGNED)    AS CustomerID,
    Country
FROM retail_sales
GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country;

  #Check the records
SELECT COUNT(*) FROM fretail_sales;
SELECT COUNT(*) FROM retail_sales;
