drop schema if exists staging_data_management_mmjja; 
create schema staging_data_management_mmjja;
use staging_data_management_mmjja;

# Create staging date table 
drop table if exists staging_date;

CREATE TABLE staging_date
(
    date_id INT NOT NULL,
    date DATE,    
    day_of_the_week_number INT,    
    day_of_the_week_text VARCHAR(10),
    day_of_the_month_number INT,    
    day_of_the_month_text VARCHAR(10),
    month_number INT,    
    month_text VARCHAR(10),    
    day_of_the_year INT,    
    week_of_the_year INT,
    quarter_number INT,
    year_number INT,
    PRIMARY KEY(date_id)
);


# Stored procedure generating date range
DROP PROCEDURE IF EXISTS fill_staging_date_table;
DELIMITER //
CREATE PROCEDURE fill_staging_date_table(IN start_date DATE, IN end_date DATE)
begin  
  declare number_of_days bigint;
  set number_of_days = DATEDIFF( date_add(end_date, interval 1 day), start_date);
  
  -- throw error if range out of bounds
  if (number_of_days <= 0) then
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'End date should be greater than Start date';  
  end if;
  if (number_of_days > 999999) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot generate more than 10^6 days, 2739 calendar years (really nigga?) ';  
  end if;
  
  -- generate a list of sequence numbers 0 ... number_of_days
  insert into staging_date
  (
    date_id, date,
    day_of_the_week_number, day_of_the_week_text,
    day_of_the_month_number, day_of_the_month_text,
    month_number, month_text,
    day_of_the_year,    
    week_of_the_year,
    quarter_number,
    year_number
  )  
  with days as (
	  with recursive single_digit_numbers AS (
			select 0 as value UNION ALL
			select value + 1 as value
			from single_digit_numbers
			where single_digit_numbers.value < 9
	  )
	  select hundred_thousands.value * 100000 + ten_thousands.value * 10000 + thousands.value * 1000 + hundreds.value * 100 + tens.value * 10 + ones.value as day_number
	  from 
      single_digit_numbers hundred_thousands, 
      single_digit_numbers ten_thousands, 
      single_digit_numbers thousands, 
      single_digit_numbers hundreds, 
      single_digit_numbers tens, 
      single_digit_numbers ones	  
  ) 
  select   
    days.day_number,
    date_add(start_date, interval days.day_number day),
    date_format(
      date_add(start_date, interval days.day_number day),
      '%w'), -- day_of_the_week_number,    
    date_format(
      date_add(start_date, interval days.day_number day),
      '%W'), -- day_of_the_week_text,           
	date_format(
      date_add(start_date, interval days.day_number day),
      '%d'), -- day_of_the_month_number,    
	date_format(
      date_add(start_date, interval days.day_number day),
      '%D'), -- day_of_the_month_text
    date_format(
      date_add(start_date, interval days.day_number day),
      '%c'), -- month_number,    
	date_format(
      date_add(start_date, interval days.day_number day),
      '%M'), -- month_text   
    date_format(
      date_add(start_date, interval days.day_number day),
      '%j'), -- day_of_the_year,    
    date_format(
      date_add(start_date, interval days.day_number day),
      '%U'), -- week_of_the_year,    
    quarter(
      date_add(start_date, interval days.day_number day)),
    date_format(
      date_add(start_date, interval days.day_number day),
      '%Y') -- year_number,            
  from days
  order by day_number
  limit number_of_days;  

end
//