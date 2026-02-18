# Prompt 03 — Documentation Check

## 🎯 Objective
Check if any tables or columns have comments or descriptions defined.

## 💬 Prompt
> *"Check if any tables or columns in TPCH_SF1 have comments or descriptions defined. Show table name, column name and the comment in a single query."*

## ✅ Expected SQL
```sql
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COMMENT
FROM SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'TPCH_SF1'
    AND COMMENT IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;
```

## 📊 Expected Output
Zero rows returned.

## 💡 Key Talking Points
- No comments, no descriptions, no documentation anywhere
- This is the reality in most enterprise environments on Day 1
- Demo narration: *"No documentation anywhere. Now watch what Cortex does with just raw metadata."*
- Sets up the data dictionary block perfectly
