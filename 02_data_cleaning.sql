select *
from listings;

describe listings;

-- Data Cleaning
-- 1.Finding Duplicates

select id,count(*) as cnt
from listings 
group by id 
having cnt>1;

-- 2.Standardizing

select price,cast(replace(replace(price,'$',''),',','') As signed)
from listings;

update listings
set price=cast(
	case 
		when price is null or price='' then 0
        else replace(replace(price,'$',''),',','') 
	end as decimal(10,2)
);

update listings
set host_is_superhost = 
case 
	when host_is_superhost='t' then 1 
	when host_is_superhost='f' then 0
    else null
end ;

select host_is_superhost
from listings;

select bathrooms_text 
from listings;

alter table listings
add column shared_baths tinyint ,
add column private_baths tinyint ,
add column baths_count decimal(3,1) ;

alter table listings
rename column baths_count to baths;


update listings
set 
	shared_baths=
		case 
			when bathrooms_text like '%shared%' then 1 
            else 0
		end,
        
        private_baths=
			case
                when bathrooms_text like '%shared%' then 0  
                when bathrooms_text like '%private%' then 1
                else 0
			end;
            
update listings
set
	baths=
		case 
			WHEN bathrooms_text LIKE '%shared%' OR bathrooms_text LIKE '%private%' THEN 0
			WHEN bathrooms_text IS NULL OR bathrooms_text='' THEN NULL
			WHEN bathrooms_text LIKE '%half%' THEN 0.5
			WHEN bathrooms_text LIKE '%1.5%' THEN 1.5
			WHEN bathrooms_text LIKE '%2.5%' THEN 2.5
			WHEN bathrooms_text LIKE '%3.5%' THEN 3.5
			WHEN bathrooms_text LIKE '%5.5%' THEN 5.5

			WHEN bathrooms_text LIKE '0%' THEN 0
			WHEN bathrooms_text LIKE '1%' THEN 1
			WHEN bathrooms_text LIKE '2%' THEN 2
			WHEN bathrooms_text LIKE '3%' THEN 3
			WHEN bathrooms_text LIKE '4%' THEN 4
			WHEN bathrooms_text LIKE '5%' THEN 5
			WHEN bathrooms_text LIKE '6%' THEN 6
			WHEN bathrooms_text LIKE '7%' THEN 7
            ELSE NULL 
		END;
        
            
            

select bathrooms_text,shared_baths,private_baths,baths
from listings;

alter table listings
drop column bathrooms_text;


update listings
set instant_bookable=
	case
		when instant_bookable ='t' then 1
        when instant_bookable='f' then 0
        else null
	end;

select instant_bookable
from listings;

alter table listings 
add column Entire_room_apt int,
add column Private_room int,
add column shared_room int;

update listings
set 
	Entire_room_apt=
		case
			when room_type like '%Entire%' then 1
            else 0
		end,
	Private_room=
		case
			when room_type like '%Private%' then 1 
            else 0
		end,
	shared_room=
		case 
			when room_type like '%Shared%' then 1 
            else 0
        end;
        

alter table listings
drop column room_type;

update listings
set neighbourhood_cleansed=lower(neighbourhood_cleansed);

update listings
set neighbourhood_cleansed=trim(neighbourhood_cleansed);

update listings
set reviews_per_month = null
where reviews_per_month = '';

update listings
set review_scores_rating  = null
where review_scores_rating  = '';


START TRANSACTION;

UPDATE listings
SET bedrooms = NULL
WHERE TRIM(bedrooms) = '';

commit;


alter table listings
modify id bigint,
modify host_id bigint,
modify host_is_superhost tinyint,
modify neighbourhood_cleansed varchar(100),
modify price decimal(10,2),
modify availability_365 int,
modify availability_30 int,
modify availability_60 int,
modify availability_90 int,
modify number_of_reviews int,
modify reviews_per_month decimal(5,2),
modify review_scores_rating decimal(5,2),
modify accommodates int,
modify minimum_nights int,
modify instant_bookable tinyint,
modify calculated_host_listings_count int,
modify baths tinyint,
modify bedrooms int;


alter table listings
add primary key(id);


    

select * 
from calendar_raw; 


create table calendar like calendar_raw;
insert into calendar 
select * 
from calendar_raw;

select * 
from calendar;

select  listing_id,count(*) cnt
from calendar
group by listing_id
having cnt>1;

SELECT listing_id,`date`,available,price,adjusted_price,minimum_nights,maximum_nights
FROM calendar
GROUP BY listing_id,`date`,available,price,adjusted_price,minimum_nights,maximum_nights
HAVING COUNT(*) > 1;


update calendar
set price=cast(
	case 
		when price is null or price='' then 0
        else replace(replace(price,'$',''),',','') 
	end as decimal(10,2)
);

update calendar
set available=
	case
		when available='f' then 0
        when available='t' then 1
        else null
	end;

select available 
from calendar
where available is null;

alter table calendar
drop column adjusted_price;

alter table calendar
modify `date` date;

alter table calendar
modify available tinyint,
modify price decimal(10,2),
modify minimum_nights int,
modify maximum_nights int;

describe calendar;

SELECT 
    MIN(`date`) AS min_date,
    MAX(`date`) AS max_date
FROM calendar;



























































