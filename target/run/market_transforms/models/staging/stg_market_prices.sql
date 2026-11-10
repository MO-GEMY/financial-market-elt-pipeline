
  create view "market_db"."public"."stg_market_prices__dbt_tmp"
    
    
  as (
    WITH source AS (
    SELECT * FROM "market_db"."public"."raw_market_prices"
)

SELECT
    ticker,
    date::date AS price_date,
    open::numeric(18, 4) AS open_price,
    high::numeric(18, 4) AS high_price,
    low::numeric(18, 4) AS low_price,
    close::numeric(18, 4) AS close_price,
    volume::bigint AS trading_volume
FROM source
WHERE date IS NOT NULL
  );