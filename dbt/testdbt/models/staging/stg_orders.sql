{{
  config(
    materialized = 'view'
  )
}}

with source as (
    select * from {{ source('tpch', 'ORDERS') }}
),

renamed as (
    select
        -- ids
        o_orderkey          as order_id,
        o_custkey           as customer_id,

        -- dates
        cast(o_orderdate as date) as order_date,

        -- strings
        o_orderstatus       as order_status,
        o_orderpriority     as order_priority,
        o_clerk             as clerk_name,
        o_comment           as comment,

        -- numerics
        cast(o_totalprice as decimal(15,2)) as total_price,
        o_shippriority      as shipping_priority,

        -- metadata
        current_timestamp() as dbt_loaded_at

    from source
)

select * from renamed
