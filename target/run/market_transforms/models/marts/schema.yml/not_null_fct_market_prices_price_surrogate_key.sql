
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select price_surrogate_key
from "market_db"."public"."fct_market_prices"
where price_surrogate_key is null



  
  
      
    ) dbt_internal_test