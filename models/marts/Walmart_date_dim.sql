{{
    config(
        materialized='incremental',
        schema="SILVER",
        incremental_strategy = 'delete+insert',
        unique_key='date_id'
    )
}}

WITH store AS (
    SELECT * FROM {{ ref('stg_bronze__stores_raw') }}
),

department AS (
    SELECT * FROM {{ ref('stg_bronze__department_raw') }}
),

final AS (
    SELECT
        (EXTRACT(DAY, department.date) + EXTRACT(MONTH, department.date) + EXTRACT(YEAR, department.date)) AS  date_id,
        department.date AS Store_Date,
        department.isHoliday,
        department.insert_dts AS insert_date,
        current_timestamp as update_date

FROM department

    {% if is_incremental() %}
    where insert_date >= (select max(update_date) from {{this}})
    {% endif %}


)

SELECT * FROM final