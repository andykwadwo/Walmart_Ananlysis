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
        store.store_id,
        department.dept_id,
        store.store_type,
        store.store_size,
        store.insert_dts AS insert_date,
        current_timestamp as update_date
FROM
    store
LEFT JOIN
    department
ON
    store.store_id = department.store_id

    {% if is_incremental() %}
    where insert_date >= (select max(update_date) from {{this}})
    {% endif %}
)

SELECT * FROM final
