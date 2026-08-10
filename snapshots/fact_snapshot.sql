{% snapshot fact_snapshot %}

{{
    config(
      target_database='WALMART_DB',
      target_schema='snapshots',
      unique_key="store_id || '-' || dept_id || '-' || date_id",
      strategy='timestamp',
      updated_at='update_date',
    )
}}

SELECT * FROM {{ ref('fact_transform') }}

{% endsnapshot %}