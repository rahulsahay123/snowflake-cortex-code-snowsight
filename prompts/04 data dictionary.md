# Prompt 04 — Data Dictionary

## 🎯 Objective
Generate a complete data dictionary with business descriptions for all 8 tables.

## 💬 Prompt
> *"Generate a complete data dictionary for all tables in TPCH_SF1 schema showing table name, column name, data type, nullable flag, ordinal position and a business description for each column. Use INFORMATION_SCHEMA for structure and your knowledge of the TPCH data model to generate meaningful business descriptions. Cover all 8 tables — CUSTOMER, ORDERS, LINEITEM, PART, PARTSUPP, SUPPLIER, NATION, REGION. Order by table name and ordinal position."*

## 💡 Key Talking Points

**Naming Convention = AI Readiness**
- Column prefixes `C_`, `O_`, `L_`, `S_`, `P_`, `N_`, `R_` helped Cortex generate accurate descriptions
- In real environments, columns named `COL1`, `FLG_X` or `TEMP_FIELD` will produce poor results
- Your naming convention is the first layer of AI readiness in your data platform

**Scalability Limitation**
- CASE WHEN approach works for small schemas (under 100 tables)
- For larger schemas use `SNOWFLAKE.CORTEX.COMPLETE()` to generate descriptions row by row
- Or invest in a proper data catalog with pre-populated descriptions

**The Real Win**
- Zero documentation → full data dictionary in 2 minutes
- Structural metadata + AI business context = instant data dictionary
