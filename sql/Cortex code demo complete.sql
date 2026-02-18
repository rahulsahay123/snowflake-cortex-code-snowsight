-- ============================================================
-- Snowflake Cortex Code Demo — Complete SQL Script
-- Schema  : SNOWFLAKE_SAMPLE_DATA.TPCH_SF1
-- Persona : Data Engineer (Day 1, no documentation)
-- Author  : Rahul Sahay
-- ============================================================


-- ============================================================
-- 00 — CONTEXT SETTING
-- Prompt : Before I begin, set my working context: role = ACCOUNTADMIN,
--          warehouse = COMPUTE_WH, database = SNOWFLAKE_SAMPLE_DATA,
--          schema = TPCH_SF1. Confirm each step.
-- ============================================================

USE ROLE      ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE  SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA    TPCH_SF1;


-- ============================================================
-- 01 — TABLE DISCOVERY
-- Prompt : How many tables are in the TPCH_SF1 schema? Show me the
--          record count for each table in a single query, ordered
--          by row count descending.
-- ============================================================

SELECT 
    TABLE_NAME,
    ROW_COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'TPCH_SF1'
AND   TABLE_TYPE   = 'BASE TABLE'
ORDER BY ROW_COUNT DESC;


-- ============================================================
-- 02 — OBJECT INVENTORY
-- Prompt : In the current schema TPCH_SF1, show me the count of user
--          defined views, functions and stored procedures grouped by
--          object type in a single query.
-- ============================================================

SELECT 
  'VIEW'      AS OBJECT_TYPE,
  COUNT(*)    AS COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'TPCH_SF1'
UNION ALL
SELECT 
  'FUNCTION'  AS OBJECT_TYPE,
  COUNT(*)    AS COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.FUNCTIONS 
WHERE FUNCTION_SCHEMA = 'TPCH_SF1'
UNION ALL
SELECT 
  'PROCEDURE' AS OBJECT_TYPE,
  COUNT(*)    AS COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.PROCEDURES 
WHERE PROCEDURE_SCHEMA = 'TPCH_SF1'
ORDER BY OBJECT_TYPE;


-- ============================================================
-- 03 — DOCUMENTATION CHECK
-- Prompt : Check if any tables or columns in TPCH_SF1 have comments
--          or descriptions defined. Show table name, column name and
--          the comment in a single query.
-- Expected Output : Zero rows
-- ============================================================

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COMMENT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'TPCH_SF1'
    AND COMMENT IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;


-- ============================================================
-- 04 — DATA DICTIONARY WITH BUSINESS DESCRIPTIONS
-- Prompt : Generate a complete data dictionary for all tables in
--          TPCH_SF1 schema showing table name, column name, data type,
--          nullable flag, ordinal position and a business description
--          for each column. Use INFORMATION_SCHEMA for structure and
--          your knowledge of the TPCH data model to generate meaningful
--          business descriptions. Cover all 8 tables. Order by table
--          name and ordinal position.
-- ============================================================

SELECT 
  t.TABLE_NAME,
  c.COLUMN_NAME,
  c.DATA_TYPE,
  c.IS_NULLABLE,
  c.ORDINAL_POSITION,
  CASE UPPER(t.TABLE_NAME)
    WHEN 'CUSTOMER' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'C_CUSTKEY'    THEN 'Primary key identifier for customer'
        WHEN 'C_NAME'       THEN 'Customer name'
        WHEN 'C_ADDRESS'    THEN 'Customer street address'
        WHEN 'C_NATIONKEY'  THEN 'Foreign key reference to nation'
        WHEN 'C_PHONE'      THEN 'Customer phone number'
        WHEN 'C_ACCTBAL'    THEN 'Customer account balance'
        WHEN 'C_MKTSEGMENT' THEN 'Market segment classification'
        WHEN 'C_COMMENT'    THEN 'Customer comment field'
      END
    WHEN 'ORDERS' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'O_ORDERKEY'      THEN 'Primary key identifier for order'
        WHEN 'O_CUSTKEY'       THEN 'Foreign key reference to customer'
        WHEN 'O_ORDERSTATUS'   THEN 'Order status flag'
        WHEN 'O_TOTALPRICE'    THEN 'Total price of order'
        WHEN 'O_ORDERDATE'     THEN 'Date order was placed'
        WHEN 'O_ORDERPRIORITY' THEN 'Order priority code'
        WHEN 'O_CLERK'         THEN 'Clerk who processed the order'
        WHEN 'O_SHIPPRIORITY'  THEN 'Shipping priority indicator'
        WHEN 'O_COMMENT'       THEN 'Order comment field'
      END
    WHEN 'LINEITEM' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'L_ORDERKEY'      THEN 'Foreign key reference to order'
        WHEN 'L_PARTKEY'       THEN 'Foreign key reference to part'
        WHEN 'L_SUPPKEY'       THEN 'Foreign key reference to supplier'
        WHEN 'L_LINENUMBER'    THEN 'Line item sequence number within order'
        WHEN 'L_QUANTITY'      THEN 'Quantity ordered'
        WHEN 'L_EXTENDEDPRICE' THEN 'Line item extended price'
        WHEN 'L_DISCOUNT'      THEN 'Line item discount percentage'
        WHEN 'L_TAX'           THEN 'Line item tax rate'
        WHEN 'L_RETURNFLAG'    THEN 'Return flag indicator'
        WHEN 'L_LINESTATUS'    THEN 'Line item status code'
        WHEN 'L_SHIPDATE'      THEN 'Date line item was shipped'
        WHEN 'L_COMMITDATE'    THEN 'Date line item was committed for shipping'
        WHEN 'L_RECEIPTDATE'   THEN 'Date line item was received'
        WHEN 'L_SHIPINSTRUCT'  THEN 'Shipping instructions'
        WHEN 'L_SHIPMODE'      THEN 'Shipping mode'
        WHEN 'L_COMMENT'       THEN 'Line item comment field'
      END
    WHEN 'PARTSUPP' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'PS_PARTKEY'    THEN 'Foreign key reference to part'
        WHEN 'PS_SUPPKEY'    THEN 'Foreign key reference to supplier'
        WHEN 'PS_AVAILQTY'   THEN 'Available quantity'
        WHEN 'PS_SUPPLYCOST' THEN 'Supplier cost'
        WHEN 'PS_COMMENT'    THEN 'Part supplier comment field'
      END
    WHEN 'SUPPLIER' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'S_SUPPKEY'   THEN 'Primary key identifier for supplier'
        WHEN 'S_NAME'      THEN 'Supplier name'
        WHEN 'S_ADDRESS'   THEN 'Supplier street address'
        WHEN 'S_NATIONKEY' THEN 'Foreign key reference to nation'
        WHEN 'S_PHONE'     THEN 'Supplier phone number'
        WHEN 'S_ACCTBAL'   THEN 'Supplier account balance'
        WHEN 'S_COMMENT'   THEN 'Supplier comment field'
      END
    WHEN 'NATION' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'N_NATIONKEY' THEN 'Primary key identifier for nation'
        WHEN 'N_NAME'      THEN 'Nation name'
        WHEN 'N_REGIONKEY' THEN 'Foreign key reference to region'
        WHEN 'N_COMMENT'   THEN 'Nation comment field'
      END
    WHEN 'REGION' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'R_REGIONKEY' THEN 'Primary key identifier for region'
        WHEN 'R_NAME'      THEN 'Region name'
        WHEN 'R_COMMENT'   THEN 'Region comment field'
      END
    WHEN 'PART' THEN
      CASE UPPER(c.COLUMN_NAME)
        WHEN 'P_PARTKEY'     THEN 'Primary key identifier for part'
        WHEN 'P_NAME'        THEN 'Part name'
        WHEN 'P_MFGR'        THEN 'Part manufacturer'
        WHEN 'P_BRAND'       THEN 'Part brand'
        WHEN 'P_TYPE'        THEN 'Part type'
        WHEN 'P_SIZE'        THEN 'Part size'
        WHEN 'P_CONTAINER'   THEN 'Container type for the part'
        WHEN 'P_RETAILPRICE' THEN 'Suggested retail price'
        WHEN 'P_COMMENT'     THEN 'Part comment field'
      END
  END AS BUSINESS_DESCRIPTION
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.TABLES   t
JOIN SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.COLUMNS  c
  ON  t.TABLE_NAME   = c.TABLE_NAME
  AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
WHERE t.TABLE_SCHEMA = 'TPCH_SF1'
  AND t.TABLE_TYPE   = 'BASE TABLE'
ORDER BY t.TABLE_NAME, c.ORDINAL_POSITION;


-- ============================================================
-- 05 — DATA PROFILING — ORDERS TABLE
-- Prompt : Profile the ORDERS table in TPCH_SF1 schema using a single
--          query. For each column show: column name, data type, total
--          row count, null count, null percentage, distinct value count.
--          For numeric columns additionally show min, max and average.
--          For date columns show earliest and latest date. Use
--          INFORMATION_SCHEMA to dynamically pick up column metadata.
--          Round all decimals to 2 places.
-- ============================================================

SELECT
    COUNT(*)                                                        AS TOTAL_ROWS,
    COUNT(DISTINCT O_ORDERKEY)                                      AS DISTINCT_ORDERKEY,
    SUM(CASE WHEN O_ORDERKEY IS NULL THEN 1 ELSE 0 END)            AS NULL_ORDERKEY,
    COUNT(DISTINCT O_CUSTKEY)                                       AS DISTINCT_CUSTKEY,
    SUM(CASE WHEN O_CUSTKEY IS NULL THEN 1 ELSE 0 END)             AS NULL_CUSTKEY,
    COUNT(DISTINCT O_ORDERSTATUS)                                   AS DISTINCT_ORDERSTATUS,
    SUM(CASE WHEN O_ORDERSTATUS IS NULL THEN 1 ELSE 0 END)         AS NULL_ORDERSTATUS,
    ROUND(MIN(O_TOTALPRICE), 2)                                     AS MIN_TOTALPRICE,
    ROUND(MAX(O_TOTALPRICE), 2)                                     AS MAX_TOTALPRICE,
    ROUND(AVG(O_TOTALPRICE), 2)                                     AS AVG_TOTALPRICE,
    SUM(CASE WHEN O_TOTALPRICE IS NULL THEN 1 ELSE 0 END)          AS NULL_TOTALPRICE,
    MIN(O_ORDERDATE)                                                AS EARLIEST_ORDERDATE,
    MAX(O_ORDERDATE)                                                AS LATEST_ORDERDATE,
    SUM(CASE WHEN O_ORDERDATE IS NULL THEN 1 ELSE 0 END)           AS NULL_ORDERDATE,
    COUNT(DISTINCT O_ORDERPRIORITY)                                 AS DISTINCT_ORDERPRIORITY,
    SUM(CASE WHEN O_ORDERPRIORITY IS NULL THEN 1 ELSE 0 END)       AS NULL_ORDERPRIORITY,
    ROUND(MIN(O_SHIPPRIORITY), 2)                                   AS MIN_SHIPPRIORITY,
    ROUND(MAX(O_SHIPPRIORITY), 2)                                   AS MAX_SHIPPRIORITY,
    SUM(CASE WHEN O_SHIPPRIORITY IS NULL THEN 1 ELSE 0 END)        AS NULL_SHIPPRIORITY
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;

-- Order Status Distribution
SELECT
    O_ORDERSTATUS,
    COUNT(*)                                                        AS ORDER_COUNT,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2)             AS PCT_SHARE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
GROUP BY O_ORDERSTATUS
ORDER BY ORDER_COUNT DESC;


-- ============================================================
-- 06 — BUSINESS ANALYSIS QUERIES
-- Three multi-table queries — all from plain english prompts
-- No column names supplied to Cortex
-- ============================================================

-- Query 1 — Revenue by Market Segment and Region (5 table join)
-- Prompt : From the TPCH_SF1 schema, calculate net revenue after
--          discounts by customer market segment and geographical region.
--          Use the most relevant tables and columns automatically.
--          Show total revenue and order count per segment and region.
--          Order by revenue descending.

SELECT 
    C_MKTSEGMENT                             AS MARKET_SEGMENT,
    R_NAME                                   AS REGION,
    COUNT(DISTINCT O_ORDERKEY)               AS ORDER_COUNT,
    SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT))  AS NET_REVENUE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS   O ON C.C_CUSTKEY   = O.O_CUSTKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM L ON O.O_ORDERKEY  = L.L_ORDERKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION   N ON C.C_NATIONKEY = N.N_NATIONKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION   R ON N.N_REGIONKEY = R.R_REGIONKEY
GROUP BY C_MKTSEGMENT, R_NAME
ORDER BY NET_REVENUE DESC;


-- Query 2 — Delayed Shipments by Supplier Nation (3 table join)
-- Prompt : From the TPCH_SF1 schema, find suppliers with the most
--          delayed shipments — where actual receipt was later than the
--          committed delivery date. Show supplier name, their country,
--          number of delayed shipments and average delay in days.
--          Use the most relevant tables and columns automatically.
--          Limit to top 10.

SELECT 
    S.S_NAME                                                        AS SUPPLIER_NAME,
    N.N_NAME                                                        AS NATION,
    COUNT(*)                                                        AS DELAYED_SHIPMENTS,
    AVG(DATEDIFF('day', L.L_COMMITDATE, L.L_RECEIPTDATE))          AS AVG_DELAY_DAYS
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM  L
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER  S ON L.L_SUPPKEY   = S.S_SUPPKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION    N ON S.S_NATIONKEY = N.N_NATIONKEY
WHERE L.L_RECEIPTDATE > L.L_COMMITDATE
GROUP BY S.S_NAME, N.N_NAME
ORDER BY DELAYED_SHIPMENTS DESC
LIMIT 10;


-- Query 3 — Part Supply Margin Analysis (2 table join)
-- Prompt : From the TPCH_SF1 schema, compare supply cost against retail
--          price for parts grouped by part type and brand. Calculate the
--          margin percentage between retail and supply cost. Use the most
--          relevant tables and columns automatically. Show top 10 by
--          margin percentage.

SELECT 
    P.P_TYPE,
    P.P_BRAND,
    AVG(P.P_RETAILPRICE)                                            AS AVG_RETAIL_PRICE,
    AVG(PS.PS_SUPPLYCOST)                                          AS AVG_SUPPLY_COST,
    ((AVG(P.P_RETAILPRICE) - AVG(PS.PS_SUPPLYCOST))
        / AVG(PS.PS_SUPPLYCOST) * 100)                             AS MARGIN_PERCENTAGE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART     P
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PARTSUPP PS ON P.P_PARTKEY = PS.PS_PARTKEY
GROUP BY P.P_TYPE, P.P_BRAND
ORDER BY MARGIN_PERCENTAGE DESC
LIMIT 10;
