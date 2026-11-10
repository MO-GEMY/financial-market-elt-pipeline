
  
    

  create  table "market_db"."public"."dim_assets__dbt_tmp"
  
  
    as
  
  (
    WITH distinct_tickers AS (
    SELECT DISTINCT ticker FROM "market_db"."public"."stg_market_prices"
)

SELECT
    ROW_NUMBER() OVER (ORDER BY ticker) AS asset_id,
    ticker,
    CASE 
        WHEN ticker LIKE '%-USD' THEN 'Cryptocurrency'
        WHEN ticker = 'SPY' THEN 'Equity ETF'
        WHEN ticker = 'GLD' THEN 'Commodity ETF'
        ELSE 'Other'
    END AS asset_class,
    'USD' AS currency
FROM distinct_tickers
  );
  