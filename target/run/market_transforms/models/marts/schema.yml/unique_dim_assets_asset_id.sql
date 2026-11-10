
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    asset_id as unique_field,
    count(*) as n_records

from "market_db"."public"."dim_assets"
where asset_id is not null
group by asset_id
having count(*) > 1



  
  
      
    ) dbt_internal_test