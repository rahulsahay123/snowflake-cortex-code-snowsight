# Prompt 01 — Table Discovery

## 🎯 Objective
Discover all tables and row counts in the schema.

## 💬 Prompt
> *"How many tables are in the TPCH_SF1 schema? Show me the record count for each table in a single query, ordered by row count descending."*

## ✅ Expected SQL
```sql
SELECT 
    TABLE_NAME,
    ROW_COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'TPCH_SF1'
AND TABLE_TYPE = 'BASE TABLE'
ORDER BY ROW_COUNT DESC;
```

## 📊 Expected Output
| TABLE_NAME | ROW_COUNT |
|---|---|
| LINEITEM | 6,001,215 |
| ORDERS | 1,500,000 |
| PARTSUPP | 800,000 |
| PART | 200,000 |
| CUSTOMER | 150,000 |
| SUPPLIER | 10,000 |
| NATION | 25 |
| REGION | 5 |

## 💡 Key Talking Points
- Cortex used INFORMATION_SCHEMA — smarter than UNION ALL COUNT(*)
- Zero table scans — near zero cost
- LINEITEM is clearly the central fact table at 6M rows
- REGION and NATION are tiny lookup tables
