{{ config({ "materialized":'table',

 "transient":true,

 "schema": 'SILVER'

})}}

WITH department AS (
    SELECT * FROM {{ ref('stg_bronze__department_raw') }}
),

fact AS (
    SELECT * FROM {{ ref('stg_bronze__fact_raw') }}
),

final AS (
    SELECT
        department.store_id,
        department.dept_id,
        department.weekly_sales,
        fact.fuel_price,
        fact.store_temperature,
        (CASE WHEN fact.unemployment = 'NA' THEN 0 ELSE fact.unemployment END) AS unemployment,
        (CASE WHEN fact.cpi = 'NA' THEN 0 ELSE fact.cpi END) AS cpi,
        (CASE WHEN fact.markdown1 = 'NA' THEN 0 ELSE fact.markdown1 END) AS Markdown1,
        (CASE WHEN fact.markdown2 = 'NA' THEN 0 ELSE fact.markdown2 END) AS Markdown2,
        (CASE WHEN fact.markdown3 = 'NA' THEN 0 ELSE fact.markdown3 END) AS Markdown3,
        (CASE WHEN fact.markdown4 = 'NA' THEN 0 ELSE fact.markdown4 END) AS Markdown4,
        (CASE WHEN fact.markdown5 = 'NA' THEN 0 ELSE fact.markdown5 END) AS Markdown5,
        department.insert_dts AS insert_date,
        current_timestamp() as update_date
    
    FROM
        department
    JOIN
        fact
    ON
        department.store_id = fact.store_id
)

SELECT * FROM final