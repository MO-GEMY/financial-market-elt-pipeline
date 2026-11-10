
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select ticker
from "market_db"."public"."dim_assets"
where ticker is null



  
  
      
    ) dbt_internal_test