
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select price_date
from "market_db"."public"."dim_date"
where price_date is null



  
  
      
    ) dbt_internal_test