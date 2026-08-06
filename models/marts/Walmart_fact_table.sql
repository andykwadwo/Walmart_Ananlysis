{{ config({ "materialized":'table',
 "schema": 'GOLD'

})}}

WITH final AS (
    SELECT * FROM {{ ref('fact_snapshot') }}
)

SELECT * FROM final