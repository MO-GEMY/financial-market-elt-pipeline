
    
    

select
    asset_id as unique_field,
    count(*) as n_records

from "market_db"."public"."dim_assets"
where asset_id is not null
group by asset_id
having count(*) > 1


