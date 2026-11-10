WITH distinct_dates AS (
    SELECT DISTINCT price_date FROM "market_db"."public"."stg_market_prices"
)

SELECT
    TO_CHAR(price_date, 'YYYYMMDD')::integer AS date_id,
    price_date,
    EXTRACT(YEAR FROM price_date)::integer AS year,
    EXTRACT(MONTH FROM price_date)::integer AS month,
    EXTRACT(DAY FROM price_date)::integer AS day,
    TRIM(TO_CHAR(price_date, 'Day')) AS day_name,
    EXTRACT(QUARTER FROM price_date)::integer AS quarter
FROM distinct_dates