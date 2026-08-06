with 

source as (

    select * from {{ source('bronze', 'stores_raw') }}

),

renamed as (

    select
        store AS store_id,
        type AS store_type,
        size AS store_size,
        current_timestamp as insert_dts

    from source

)

select * from renamed