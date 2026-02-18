# Prompt 02 — Object Inventory

## 🎯 Objective
Check for existing user defined objects in the schema.

## 💬 Prompt
> *"In the current schema TPCH_SF1, show me the count of user defined views, functions and stored procedures grouped by object type in a single query."*

## ✅ Expected SQL
```sql
SELECT 
  'VIEW' AS OBJECT_TYPE,
  COUNT(*) AS COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'TPCH_SF1'
UNION ALL
SELECT 
  'FUNCTION' AS OBJECT_TYPE,
  COUNT(*) AS COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.FUNCTIONS 
WHERE FUNCTION_SCHEMA = 'TPCH_SF1'
UNION ALL
SELECT 
  'PROCEDURE' AS OBJECT_TYPE,
  COUNT(*) AS COUNT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.PROCEDURES 
WHERE PROCEDURE_SCHEMA = 'TPCH_SF1'
ORDER BY OBJECT_TYPE;
```

## 📊 Expected Output
| OBJECT_TYPE | COUNT |
|---|---|
| FUNCTION | 0 |
| PROCEDURE | 0 |
| VIEW | 0 |

## 💡 Key Talking Points
- All zero — clean slate, no objects built yet
- Demo narration: *"No views, no functions, no procedures. Nobody left me a map. Let's figure this out with Cortex Code."*
- INFORMATION_SCHEMA only — zero compute cost
