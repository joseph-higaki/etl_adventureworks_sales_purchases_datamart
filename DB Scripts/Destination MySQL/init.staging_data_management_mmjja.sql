use staging_data_management_mmjja;

-- CALL fill_staging_date_table('1970-01-01','2050-12-31'); 
-- If it is too broad, the date transformation will take a while to setup its holidays. 
-- In reality, adventureworks Sales & Purchases, only contain data from 2011 - 2013

-- truncate staging_date;  -- in case you don't want to recreate the schema, just truncate the staging date table

CALL fill_staging_date_table('2009-01-01','2015-12-31');
