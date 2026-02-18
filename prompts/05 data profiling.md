# Prompt 05 — Data Profiling

## 🎯 Objective
Profile the ORDERS table to understand data quality and distributions.

## 💬 Prompt
> *"Profile the ORDERS table in TPCH_SF1 schema using a single query. For each column show: column name, data type, total row count, null count, null percentage, distinct value count. For numeric columns additionally show min, max and average. For date columns show earliest and latest date. Use INFORMATION_SCHEMA to dynamically pick up column metadata — do not hardcode column names. Round all decimals to 2 places."*

## 💡 Key Talking Points
- "Do not hardcode column names" = dynamic, reusable for any table
- Null percentage more meaningful than raw null count on 1.5M row table
- Single query = one warehouse execution, cost efficient
- 1.5M rows profiled in seconds — no manual exploration needed
- Demo narration: *"Full column profile of 1.5 million rows. This would take a data engineer hours manually."*

## ⚠️ Known Limitation
Cortex may attempt wildcard aggregation (`COUNT(t.*)`) which is not valid in Snowflake.
If this happens, use the Fix feature or ask Cortex to rewrite with explicit column names.
