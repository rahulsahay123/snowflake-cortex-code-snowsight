# Prompt 07 — dbt Pipeline

## 🎯 Objective
Build a 3 layer dbt pipeline using Cortex Code in Snowsight.

---

## Pre-requisites

### Create Target Database
```sql
CREATE DATABASE IF NOT EXISTS DBT_TPCH_ANALYTICS;
```

### Config Files

**profiles.yml**
```yaml
testdbt:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT_IDENTIFIER
      authenticator: oauth
      role: ACCOUNTADMIN
      database: DBT_TPCH_ANALYTICS
      warehouse: COMPUTE_WH
      schema: PUBLIC
      threads: 4
```

**dbt_project.yml**
```yaml
name: testdbt
version: 1.0.0
profile: testdbt
model-paths: ["models"]
seed-paths: ["seeds"]
test-paths: ["tests"]
analysis-paths: ["analysis"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]
clean-targets:
  - "target"
  - "dbt_packages"
vars:
  source_database: SNOWFLAKE_SAMPLE_DATA
models:
  testdbt:
    staging:
      +materialized: view
    intermediate:
      +materialized: view
    mart:
      +materialized: table
```

---

## sources.yml Prompt

### 💬 Prompt
> *"Generate a dbt sources.yml file named sources.yml to be placed under models/staging/ folder. This file should support 3 dbt models — stg_orders, int_orders_enriched and mart_revenue_by_segment. Define SNOWFLAKE_SAMPLE_DATA as the database, TPCH_SF1 as the schema. Include all source tables used across the 3 models — ORDERS, CUSTOMER, NATION, LINEITEM, REGION. Add a brief description for each table and each column."*

---

## Model 1 — stg_orders

### 💬 Prompt
> *"Create a dbt staging model named stg_orders.sql inside the models/staging/ folder. Refer to sources.yml in the same models/staging/ folder — use source name 'tpch' and table name 'ORDERS'. Clean and cast all columns, remove O_ prefix, rename to meaningful business names, materialize as view and add dbt_loaded_at metadata column."*

### 📁 Location
`models/staging/stg_orders.sql`

---

## Model 2 — int_orders_enriched

### 💬 Prompt
> *"Create a dbt intermediate model named int_orders_enriched.sql inside the models/intermediate/ folder. Use ref('stg_orders') as the base model. Join with SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER, SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION and SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION to add customer name, market segment, nation name and region name. Materialize as view."*

### 📁 Location
`models/intermediate/int_orders_enriched.sql`

---

## Model 3 — mart_revenue_by_segment

### 💬 Prompt
> *"Create a dbt mart model named mart_revenue_by_segment.sql inside the models/mart/ folder. Use ref('int_orders_enriched') as the base model. Join with SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM to calculate total net revenue after discount, total orders and average order value grouped by market segment and region name. Materialize as table."*

### 📁 Location
`models/mart/mart_revenue_by_segment.sql`

---

## Run Command

### 💬 Prompt
> *"Execute dbt run command for all models in testdbt project. Use dbt run not dbt compile."*

### ✅ Expected Output
```
PASS=3 WARN=0 ERROR=0 SKIP=0 TOTAL=3
stg_orders              → view    SUCCESS
int_orders_enriched     → view    SUCCESS
mart_revenue_by_segment → table   SUCCESS
```

---

## 💡 Key Talking Points
- Full 3 layer pipeline generated from plain english prompts
- sources.yml created with table and column descriptions automatically
- Model dependencies managed via ref() — Cortex understood DAG ordering
- Runs in DBT_TPCH_ANALYTICS — separate from source database
- Demo narration: *"Staging cleans, intermediate enriches, mart delivers. Three layers, three prompts, one pipeline."*

## ⚠️ Known Issues & Fixes

| Issue | Fix |
|---|---|
| `source not found` error | Ensure sources.yml is inside models/staging/ folder |
| `database property not allowed` | Remove top level database from dbt_project.yml |
| `SNOWFLAKE_SAMPLE_DATA view creation not allowed` | Use DBT_TPCH_ANALYTICS as target database |
| `account is required` with oauth | Add account from `SELECT CURRENT_ACCOUNT()` |
| `dbt compile` runs instead of `dbt run` | Explicitly say "use dbt run not dbt compile" in prompt |
