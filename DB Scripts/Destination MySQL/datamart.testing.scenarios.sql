/*
Escenario 1
0. Run dim_product transformation
1. Check dim_product of product id 875 at the datamart
2. Check product of product id 875 at the transactional Adventureworks
3. Update product name from product id 875 at the transactional Adventureworks
4. Check dim_product of product id 875 at the datamart, new version should've been created
*/

select  dim_product_id, product_id, 
product_name, product_category_name, product_subcategory_name, 
version_number, start_date, end_date
from dim_product
where product_id = 875


/* 
Escenario 2
0. Run first fact sales load
1. Check fact sales row a unitprice from sales order detail id 35893
2. Update a unitprice from sales order detail id 35893 at the Transactional Adventureworks
1. Check fact sales row a unitprice from sales order detail id 35893
*/
select * 
from fact_sales
where sales_order_detail_id = 35893


/* 
Escenario 3
0. Run first fact sales load
1. Insert a sales order detail to sales order id 51092 with product id 737 at the Transactional Adventureworks
2. Run jobs (or the fact_sales)
3. query and check for fact_sales record added
*/
select s.* 
from fact_sales s
join dim_product p on s.dim_product_id = p.dim_product_id
where s.sales_order_id = 51092
and p.product_id = 737

/*
Scenario 4
0. fact purchases transformation has executed
1. after initial load, including purchases, Scenario 1 was executed
2. CHeck fact_purchases for product id = 875
3. insert new purchase order detail for product id 875 at transctional adventureworks
4. update purchase order detail  order date to be after the execution of Scenario 1
5. run fact purchases transformation 
6. CHeck fact_purchases for product id = 875
*/

select po.*, p.product_name, po.product_unit_price, po.order_amount
from fact_purchases po
join dim_product  p on po.dim_product_id = p.dim_product_id 
where product_id = 875