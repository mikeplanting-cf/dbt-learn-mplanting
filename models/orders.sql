with cte_payments
as
(
    select 
    *
    from {{ ref('stg_payments') }}
)

, cte_orders
as
(
    select 
    *
    from {{ ref('stg_orders') }}
)

, cte_final
as
(
    select 
    o.order_id,
    o.customer_id,
    o.order_date,
    sum(p.amount_dollars) as amount_dollars
    from cte_orders o
        inner join cte_payments p
            using (order_id)
    where p.status = 'success'
    group by 
    o.order_id,
    o.customer_id,
    o.order_date

)

select * from cte_final