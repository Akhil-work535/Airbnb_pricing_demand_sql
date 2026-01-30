select * from listings;

select l.price,l.instant_bookable,l.availability_365
from listings l
join (
	select instant_bookable,max(price) as max_price
	from listings 
	group by instant_bookable) m
on l.instant_bookable=m.instant_bookable and l.price=m.max_price;

select reviews_per_month * (365-availability_365)/365 as Demand
from listings;

alter table listings
add column demand_score decimal(10,2);

update listings
set demand_score = round( coalesce(reviews_per_month,0)*(365-availability_365)/365,2 );

select max(price),min(price)
from listings
where demand_score=(select min(demand_score) from listings ); 

select price,demand_score
from listings 
order by demand_score desc;

select 
    round(price, -1) as price_bucket,
    count(*) as total_listings,
    round(avg(demand_score), 2) as avg_demand
from listings
where price is not null
group by round(price, -1)
order by price_bucket desc,avg_demand desc;




select price,demand_score,instant_bookable
from (
	select price,demand_score,instant_bookable,
			row_number() over(
            partition by instant_bookable order by demand_score desc,price desc) rn
	from listings) m
where rn=1;

select price,demand_score,instant_bookable
from (
	select price,demand_score,instant_bookable,
			row_number() over(
            partition by instant_bookable order by demand_score asc,price asc) rn
	from listings) m
where rn=1;

select price,instant_bookable
from listings
order by price desc;

select 
    neighbourhood_cleansed,
    round(avg(price),2) as avg_price,
    round(avg(demand_score),2) as avg_demand,
    count(*) as total_listings
from listings
where price is not null
group by neighbourhood_cleansed
order by avg_price desc;


select 
    id,
    1 - (availability_365 / 365.0) as occupancy_rate,
    demand_score,
    instant_bookable
from listings;

select 
    case
        when availability_365 <= 30 then 'Highly Booked'
        when availability_365 between 31 and 180 then 'Medium'
        else 'Mostly Empty'
    end as booking_status,
    count(*) as total_listings,
    round(avg(demand_score),2) as avg_demand
from listings
group by booking_status;


select 
    listing_id,
    count(*) as days_booked
from calendar
where available = 'f'
group by listing_id;


select 
    l.id,
    l.availability_365,
    c.days_booked
from listings l
join (
    select listing_id, count(*) as days_booked
    from calendar
    where available = 'f'
    group by listing_id
) c
on l.id = c.listing_id;


select 
    host_is_superhost,
    instant_bookable,
    count(*) as total_listings,
    round(avg(demand_score),2) as avg_demand
from listings
group by host_is_superhost, instant_bookable
order by host_is_superhost, instant_bookable;



SELECT
    CASE
        WHEN avg_demand_instant > avg_demand_non_instant THEN 1
        WHEN avg_demand_instant < avg_demand_non_instant THEN -1
        ELSE 0
    END AS relation_flag,
    avg_demand_instant AS demand_when_instant_bookable,
    avg_demand_non_instant AS demand_when_not_instant_bookable
FROM (
    SELECT
        AVG(CASE WHEN instant_bookable = 1 THEN demand_score END) AS avg_demand_instant,
        AVG(CASE WHEN instant_bookable = 0 THEN demand_score END) AS avg_demand_non_instant
    FROM listings
) t;	
 
select
    host_is_superhost,
    avg(case when instant_bookable = 1 then demand_score end) as demand_instant,
    avg(case when instant_bookable = 0 then demand_score end) as demand_non_instant
from listings
group by host_is_superhost;



WITH host_perf AS (
    SELECT 
        host_id,
        COUNT(*) AS total_listings,
        AVG(demand_score) AS avg_demand
    FROM listings
    GROUP BY host_id
    HAVING COUNT(*) > 1
),
ranked AS (
    SELECT 
        host_id,
        total_listings,
        avg_demand,
        NTILE(4) OVER (ORDER BY avg_demand) AS quartile
    FROM host_perf
)
SELECT 
    host_id,
    total_listings,
    avg_demand,
    CASE 
        WHEN quartile = 4 THEN 'Best'
        WHEN quartile = 1 THEN 'Worst'
        ELSE 'Average'
    END AS performance
FROM ranked;



select 
    room_type,
    count(*) as total_listings,
    round(avg(price),2) as avg_price,
    round(avg(demand_score),2) as avg_demand
from listings
group by room_type
order by avg_price desc;


select minimum_nights,avg(demand_score)
from listings 
group by minimum_nights
order by minimum_nights asc;