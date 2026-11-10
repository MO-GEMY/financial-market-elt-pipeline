
    
    

select
    price_surrogate_key as unique_field,
    count(*) as n_records

from "market_db"."public"."fct_market_prices"
where price_surrogate_key is not null
group by price_surrogate_key
having count(*) > 1


