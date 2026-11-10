
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select date_id
from "market_db"."public"."fct_market_prices"
where date_id is null



  
  
      
    ) dbt_internal_test