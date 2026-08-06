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
        departmant.store_id,
        department.dept_id,
        department.weekly_sales,
        fact.fuel_price,
        fact.store_temperature,
        fact.unemployment,
        fact.cpi,
        (CASE WHEN fact.markdown1 = "NA" THEN 0 ELSE fact.markdown1 END) AS Mardown1,
        (CASE WHEN fact.markdown2 = "NA" THEN 0 ELSE fact.markdown2 END) AS Mardown2,
        (CASE WHEN fact.markdown3 = "NA" THEN 0 ELSE fact.markdown3 END) AS Mardown3,
        (CASE WHEN fact.markdown4 = "NA" THEN 0 ELSE fact.markdown4 END) AS Mardown4,
        (CASE WHEN fact.markdown5 = "NA" THEN 0 ELSE fact.markdown1 END) AS Mardown5,
        department.insert_dts AS insert_date,
        current_timestamp as update_date
    
    FROM
        department
    JOIN
        fact
    ON
        department.store_id = fact.store_id
)

SELECT * FROM final