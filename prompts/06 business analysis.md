# Prompt 06 — Business Analysis

## 🎯 Objective
Run three multi-table business analysis queries using plain english — no column names supplied.

---

## Query 1 — Revenue by Market Segment and Region

### 💬 Prompt
> *"From the TPCH_SF1 schema, calculate net revenue after discounts by customer market segment and geographical region. Use the most relevant tables and columns automatically. Show total revenue and order count per segment and region. Order by revenue descending."*

### ✅ Generated SQL
```sql
SELECT 
    C_MKTSEGMENT AS MARKET_SEGMENT,
    R_NAME AS REGION,
    COUNT(DISTINCT O_ORDERKEY) AS ORDER_COUNT,
    SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS NET_REVENUE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O ON C.C_CUSTKEY = O.O_CUSTKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM L ON O.O_ORDERKEY = L.L_ORDERKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION N ON C.C_NATIONKEY = N.N_NATIONKEY
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION R ON N.N_REGIONKEY = R.R_REGIONKEY
GROUP BY C_MKTSEGMENT, R_NAME
ORDER BY NET_REVENUE DESC;
```

### 💡 Key Talking Points
- 5 table join generated from plain english — no column names supplied
- 25 rows returned in 2.7 seconds on 6M+ row dataset
- Cortex correctly identified `L_EXTENDEDPRICE * (1 - L_DISCOUNT)` as net revenue formula
- Demo narration: *"I didn't mention a single column name. Cortex joined 5 tables and calculated net revenue correctly. That's catalog awareness in action."*

---

## Query 2 — Delayed Shipments by Supplier Nation

### 💬 Prompt
> *"From the TPCH_SF1 schema, find suppliers with the most delayed shipments — where actual receipt was later than the committed delivery date. Show supplier name, their country, number of delayed shipments and average delay in days. Use the most relevant tables and columns automatically. Limit to top 10."*

### ✅ Generated SQL
```sql
SELECT 
    S.S_NAME AS SUPPLIER_NAME,
    N.N_NAME AS NATION,
    COUNT(*) AS DELAYED_SHIPMENTS,
    AVG(DATEDIFF('day', L.L_COMMITDATE, L.L_RECEIPTDATE)) AS AVG_DELAY_DAYS
FROM TPCH_SF1.LINEITEM L
JOIN TPCH_SF1.SUPPLIER S ON L.L_SUPPKEY = S.S_SUPPKEY
JOIN TPCH_SF1.NATION N ON S.S_NATIONKEY = N.N_NATIONKEY
WHERE L.L_RECEIPTDATE > L.L_COMMITDATE
GROUP BY S.S_NAME, N.N_NAME
ORDER BY DELAYED_SHIPMENTS DESC
LIMIT 10;
```

### 💡 Key Talking Points
- 3 table join — LINEITEM → SUPPLIER → NATION
- Cortex correctly used DATEDIFF with L_RECEIPTDATE > L_COMMITDATE filter
- 10 rows in 1.5 seconds on 6M row LINEITEM table
- Demo narration: *"I described a business problem. Cortex identified the right date columns and applied the correct filter automatically."*

---

## Query 3 — Part Supply Margin Analysis

### 💬 Prompt
> *"From the TPCH_SF1 schema, compare supply cost against retail price for parts grouped by part type and brand. Calculate the margin percentage between retail and supply cost. Use the most relevant tables and columns automatically. Show top 10 by margin percentage."*

### ✅ Generated SQL
```sql
SELECT 
    P.P_TYPE,
    P.P_BRAND,
    AVG(P.P_RETAILPRICE) AS AVG_RETAIL_PRICE,
    AVG(PS.PS_SUPPLYCOST) AS AVG_SUPPLY_COST,
    ((AVG(P.P_RETAILPRICE) - AVG(PS.PS_SUPPLYCOST)) / AVG(PS.PS_SUPPLYCOST) * 100) AS MARGIN_PERCENTAGE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART P
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PARTSUPP PS ON P.P_PARTKEY = PS.PS_PARTKEY
GROUP BY P.P_TYPE, P.P_BRAND
ORDER BY MARGIN_PERCENTAGE DESC
LIMIT 10;
```

### 💡 Key Talking Points
- 2 table join — PART → PARTSUPP
- Standard margin formula generated without any hints
- Every business stakeholder relates to margin analysis immediately
- Good Streamlit visualization candidate
