
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    price_date as unique_field,
    count(*) as n_records

from "market_db"."public"."dim_date"
where price_date is not null
group by price_date
having count(*) > 1



  
  
      
    ) dbt_internal_test