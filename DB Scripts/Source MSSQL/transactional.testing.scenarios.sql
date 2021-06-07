/*
Escenario 1
0. Run dim_product transformation
1. Check dim_product of product id 875 at the datamart
2. Check product of product id 875 at the transactional Adventureworks
3. Update product name from product id 875 at the transactional Adventureworks
4. Check dim_product of product id 875 at the datamart, new version should've been created
*/
select p.ProductID, p.Name,
pc.Name as CategoryName, ps.Name as SubCategoryName
from Production.Product p
join Production.ProductSubcategory ps 
	on p.ProductSubcategoryID = ps.ProductSubcategoryID
join Production.ProductCategory pc 
	on ps.ProductCategoryID = pc.ProductCategoryID
where ProductID = 875 

update Production.Product
 -- set Name = 'Racing Socks, L' -- ORIGINAL NAME 
 set Name = 'Amazing and Aerodynamic Racing Socks, L' -- MODIFIED NAME
where ProductID = 875;




/* 
Escenario 2
0. Run first fact sales load
1. Check fact sales row a unitprice from sales order detail id 35893
2. Update a unitprice from sales order detail id 35893 at the Transactional Adventureworks
1. Check fact sales row a unitprice from sales order detail id 35893
*/
update Sales.SalesOrderDetail 
--set UnitPrice = 3
 set UnitPrice = 6.5
where SalesOrderDetailID = 35893


/* 
Escenario 3
0. Run first fact sales load
1. Insert a sales order detail to sales order id 51092 with product id 737 to the Transactional Adventureworks
2. Run jobs (or the fact_sales)
3. query and check for fact_sales record added
*/
INSERT INTO [Sales].[SalesOrderDetail]
           ([SalesOrderID]           ,[CarrierTrackingNumber]           ,[OrderQty]           ,[ProductID]           ,[SpecialOfferID]           ,[UnitPrice]           ,[UnitPriceDiscount]     )
     VALUES
           (51092
           , 'FB68-47B7-9D '
           , 4
           , 737
           , 1
           , 500
           , 0
           )
go

select 
sod.ProductID, sod.UnitPrice, sod.OrderQty, sod.LineTotal, 
sod.*
from Sales.SalesOrderDetail sod
where sod.SalesOrderId = 51092
and ProductID = 737
go

/* rollback 
delete Sales.SalesOrderDetail 
where SalesOrderId = 51092
and ProductID = 737
*/

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


INSERT INTO [Purchasing].[PurchaseOrderDetail]
           ([PurchaseOrderID]
           ,[DueDate]
           ,[OrderQty]
           ,[ProductID]
           ,[UnitPrice]
           ,[ReceivedQty]
           ,[RejectedQty])
     VALUES
           (4003
           ,getdate()
           ,500
           ,875
           ,35
           , 200
           , 300)
GO

/*rollback 
delete [Purchasing].[PurchaseOrderDetail]
where [PurchaseOrderID] = 4003
and [ProductID] = 875
*/


select po.OrderDate, po.SHipDate, pod.ProductID, pod.*
from Purchasing.PurchaseOrderHeader po
join Purchasing.PurchaseOrderDetail pod on po.PurchaseOrderID  = pod.PurchaseOrderID
 where po.PurchaseOrderID = 4003 
and pod.ProductID = 875



update Purchasing.PurchaseOrderHeader
--set OrderDate = '2014-05-14' -- original dates
--, ShipDate = '2014-06-08'
 set OrderDate = Getdate() -- modified current date to match modified product name
 , ShipDate = GetDate()
where PurchaseOrderID = 4003 
