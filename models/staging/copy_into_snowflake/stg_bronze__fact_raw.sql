with 

source as (

    select * from {{ source('bronze', 'fact_raw') }}

),

renamed as (

    select
        store as store_id,
        date,
        temperature AS store_temperature,
        fuel_price,
        markdown1,
        markdown2,
        markdown3,
        markdown4,
        markdown5,
        cpi,
        unemployment,
        isholiday,
        current_timestamp as insert_dts

    from source

)

select * from renamed