CREATE TABLE calendar_raw (
    listing_id BIGINT,
    date TEXT,
    available TEXT,
    price TEXT,
    adjusted_price TEXT,
    minimum_nights TEXT,
    maximum_nights TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/calendar.csv'
INTO TABLE calendar_raw
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) FROM calendar_raw;
SELECT  * FROM calendar_raw;

SHOW VARIABLES LIKE 'secure_file_priv';


CREATE TABLE listings_raw (
    col1 TEXT, col2 TEXT, col3 TEXT, col4 TEXT, col5 TEXT,
    col6 TEXT, col7 TEXT, col8 LONGTEXT, col9 LONGTEXT, col10 TEXT,
    col11 TEXT, col12 TEXT, col13 TEXT, col14 TEXT, col15 TEXT,
    col16 LONGTEXT, col17 TEXT, col18 TEXT, col19 TEXT, col20 TEXT,
    col21 TEXT, col22 TEXT, col23 TEXT, col24 TEXT, col25 TEXT,
    col26 TEXT, col27 TEXT, col28 TEXT, col29 TEXT, col30 TEXT,
    col31 TEXT, col32 TEXT, col33 TEXT, col34 TEXT, col35 TEXT,
    col36 TEXT, col37 TEXT, col38 TEXT, col39 TEXT, col40 TEXT,
    col41 TEXT, col42 TEXT, col43 TEXT, col44 TEXT, col45 TEXT,
    col46 TEXT, col47 TEXT, col48 TEXT, col49 TEXT, col50 TEXT,
    col51 TEXT, col52 TEXT, col53 TEXT, col54 TEXT, col55 TEXT,
    col56 TEXT, col57 TEXT, col58 TEXT, col59 TEXT, col60 TEXT,
    col61 TEXT, col62 TEXT, col63 TEXT, col64 TEXT, col65 TEXT,
    col66 TEXT, col67 TEXT, col68 TEXT, col69 TEXT, col70 TEXT,
    col71 TEXT, col72 TEXT, col73 TEXT, col74 TEXT, col75 TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/listings.csv'
INTO TABLE listings_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;



CREATE TABLE listings_named AS
SELECT
col1  AS id,
col2  AS listing_url,
col3  AS scrape_id,
col4  AS last_scraped,
col5  AS `source`,
col6  AS `name`,
col7  AS `description`,
col8  AS neighborhood_overview,
col9  AS picture_url,
col10 AS host_id,
col11 AS host_url,
col12 AS host_name,
col13 AS host_since,
col14 AS host_location,
col15 AS host_about,
col16 AS host_response_time,
col17 AS host_response_rate,
col18 AS host_acceptance_rate,
col19 AS host_is_superhost,
col20 AS host_thumbnail_url,
col21 AS host_picture_url,
col22 AS host_neighbourhood,
col23 AS host_listings_count,
col24 AS host_total_listings_count,
col25 AS host_verifications,
col26 AS host_has_profile_pic,
col27 AS host_identity_verified,
col28 AS neighbourhood,
col29 AS neighbourhood_cleansed,
col30 AS neighbourhood_group_cleansed,
col31 AS latitude,
col32 AS longitude,
col33 AS property_type,
col34 AS room_type,
col35 AS accommodates,
col36 AS bathrooms,
col37 AS bathrooms_text,
col38 AS bedrooms,
col39 AS beds,
col40 AS amenities,
col41 AS price,
col42 AS minimum_nights,
col43 AS maximum_nights,
col44 AS minimum_minimum_nights,
col45 AS maximum_minimum_nights,
col46 AS minimum_maximum_nights,
col47 AS maximum_maximum_nights,
col48 AS minimum_nights_avg_ntm,
col49 AS maximum_nights_avg_ntm,
col50 AS calendar_updated,
col51 AS has_availability,
col52 AS availability_30,
col53 AS availability_60,
col54 AS availability_90,
col55 AS availability_365,
col56 AS calendar_last_scraped,
col57 AS number_of_reviews,
col58 AS number_of_reviews_ltm,
col59 AS number_of_reviews_l30d,
col60 AS first_review,
col61 AS last_review,
col62 AS review_scores_rating,
col63 AS review_scores_accuracy,
col64 AS review_scores_cleanliness,
col65 AS review_scores_checkin,
col66 AS review_scores_communication,
col67 AS review_scores_location,
col68 AS review_scores_value,
col69 AS license,
col70 AS instant_bookable,
col71 AS calculated_host_listings_count,
col72 AS calculated_host_listings_count_entire_homes,
col73 AS calculated_host_listings_count_private_rooms,
col74 AS calculated_host_listings_count_shared_rooms,
col75 AS reviews_per_month

FROM listings_raw;

rename table listings_named to listings_raw;

create table listings as 
select 
	id,
    host_id,
    host_is_superhost,
    neighbourhood_cleansed,
    room_type,
    price,
    availability_365,
    availability_30,
    availability_60,
    availability_90,
    number_of_reviews,
    reviews_per_month,
    review_scores_rating,
    accommodates,
    bedrooms,
    bathrooms_text,
    minimum_nights,
    instant_bookable,
    calculated_host_listings_count
FROM listings_raw;

select * from listings ;




