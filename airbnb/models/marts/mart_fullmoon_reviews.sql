{{
    config(
        materialized = 'table'
    )
}}

WITH fct_reviews AS (
    SELECT *
    FROM {{ ref('fct_reviews') }}
),
full_moon_dates AS (
    SELECT *
    FROM {{ ref('seed_full_moon_dates') }}
)
SELECT r.*,
    CASE
        WHEN fm.full_moon_date is null then 'not full moon'
        else 'full moon'
    END as is_full_moon
FROM fct_reviews r
LEFT JOIN full_moon_dates fm
    ON TO_DATE(r.review_date) = DATEADD(Day, 1, fm.full_moon_date)
