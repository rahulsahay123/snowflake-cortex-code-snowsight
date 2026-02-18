# Prompt 00 — Context Setting

## 🎯 Objective
Set the working context before starting any exploration.

## 💬 Prompt
> *"Before I begin, set my working context: role = ACCOUNTADMIN, warehouse = COMPUTE_WH, database = SNOWFLAKE_SAMPLE_DATA, schema = TPCH_SF1. Confirm each step."*

## ✅ Expected SQL
```sql
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;
```

## 💡 Key Talking Points
- Always set context first — no ambiguity for Cortex
- "Confirm each step" forces Cortex to show output
- Short and directive — fewer tokens, cost effective
