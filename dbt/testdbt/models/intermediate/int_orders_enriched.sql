{{
  config(
    materialized = 'view'
  )
}}

with customers as (
    select
        c_custkey           as customer_id,
        c_name              as customer_name,
        c_mktsegment        as market_segment,
        c_nationkey         as nation_id
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
),

nations as (
    select
        n_nationkey         as nation_id,
        n_name              as nation_name,
        n_regionkey         as region_id
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION
),

regions as (
    select
        r_regionkey         as region_id,
        r_name              as region_name
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION
),

final as (
    select
        -- order details from stg_orders
        o.order_id,
        o.order_date,
        o.order_status,
        o.order_priority,
        o.clerk_name,
        o.total_price,
        o.shipping_priority,

        -- customer details
        o.customer_id,
        c.customer_name,
        c.market_segment,

        -- geography details
        n.nation_name,
        r.region_name,

        -- metadata
        o.dbt_loaded_at

    from {{ ref('stg_orders') }} o
    left join customers c on o.customer_id = c.customer_id
    left join nations   n on c.nation_id   = n.nation_id
    left join regions   r on n.region_id   = r.region_id
)

select * from final
