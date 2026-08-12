-- PORTFOLIO PROJECT: RETAIL SALES ANALYSIS - ONLINE RETAIL (UK, 2009-2010)
-- Dataset: cleaned-data.csv
-- Description: Transaction data from a UK-based online retailer
-- specializing in gift items and home decorations.
-- Time period: December 2009 - December 2010
--
-- Source columns:
-- Invoice      : Invoice number
-- StockCode    : Product/item identifier
-- Description  : Product description
-- Quantity     : Number of purchased items
-- InvoiceDate  : Date and time of transaction
-- Price        : Unit price of the product
-- CustomerID   : Unique customer identifier
-- Country      : Customer's country


CREATE DATABASE retail_analysis;
USE retail_analysis;


CREATE TABLE retail_sales (
    Invoice VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate VARCHAR(20),
    Price DECIMAL(10,2),
    CustomerID VARCHAR(20),
    Country VARCHAR(100)
);
-- Data loading:
-- The dataset was imported using MySQL Table Data Import Wizard.
-- The CSV file was loaded into the retail_sales table.

-- Quick data loading verification:
-- Check the total number of records imported into the table
SELECT COUNT(*) AS randuri_incarcate FROM retail_sales;