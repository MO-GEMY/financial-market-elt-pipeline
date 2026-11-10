WITH base AS (
    SELECT * FROM "market_db"."public"."stg_market_prices"
),

assets AS (
    SELECT * FROM "market_db"."public"."dim_assets"
),

dates AS (
    SELECT * FROM "market_db"."public"."dim_date"
)

SELECT
    MD5(b.ticker || '_' || b.price_date::text) AS price_surrogate_key,
    a.asset_id,
    d.date_id,
    b.open_price,
    b.high_price,
    b.low_price,
    b.close_price,
    b.trading_volume,
    ROUND(((b.close_price - LAG(b.close_price, 1) OVER (PARTITION BY b.ticker ORDER BY b.price_date)) 
        / NULLIF(LAG(b.close_price, 1) OVER (PARTITION BY b.ticker ORDER BY b.price_date), 0) * 100), 2) AS daily_return_pct,
    ROUND(AVG(b.close_price) OVER (PARTITION BY b.ticker ORDER BY b.price_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7d
FROM base b
JOIN assets a ON b.ticker = a.ticker
JOIN dates d ON b.price_date = d.price_date