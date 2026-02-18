{{
  config(
    materialized = 'table'
  )
}}

with line_items as (
    select
        l_orderkey                                              as order_id,
        sum(l_quantity * l_extendedprice * (1 - l_discount))   as net_revenue
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
    group by 1
),

final as (
    select
        o.market_segment,
        o.region_name,
        count(distinct o.order_id)                              as total_orders,
        sum(l.net_revenue)                                      as total_net_revenue,
        avg(l.net_revenue)                                      as avg_order_value
    from {{ ref('int_orders_enriched') }} o
    inner join line_items l on o.order_id = l.order_id
    group by 1, 2
)

select * from final
