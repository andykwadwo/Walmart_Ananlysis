with 

source as (

    select * from {{ source('bronze', 'department_raw') }}

),

renamed as (

    select
        store as store_id,
        dept as dept_id,
        date,
        weekly_sales,
        isHoliday,
        current_timestamp as insert_dts

    from source

)

select * from renamed