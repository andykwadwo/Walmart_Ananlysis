{{
    config(
        materialized='incremental',
        incremental_strategy = 'delete + insert',
        unique_key='store_id'
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
        to_char(department.order_date, 'MMDDYYYY')::int as date_id,
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