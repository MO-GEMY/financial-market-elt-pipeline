
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select close_price
from "market_db"."public"."fct_market_prices"
where close_price is null



  
  
      
    ) dbt_internal_test