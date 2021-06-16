# Adventureworks_sales_purchases_datamart
This is the final assignment from the Data Management course from the Big Data &amp; Analytics Masters @ [EAE](https://www.eae.es/) class of 2021.
This project:
* Extracts data from the famous [Microsoft SQL](https://www.microsoft.com/en-us/sql-server) demo database [Adventureworks](https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)
* Uses [Date Nager API](https://date.nager.at/) to specify holidays into the date dimension
* Uses a [simple weather csv](https://en.wikipedia.org/wiki/Season#Meteorological) to specify northern and southern hemisphere season into the date dimension
* Transforms the data  using  [Pentaho Kettle](https://community.hitachivantara.com/s/article/data-integration-kettle), as ETL tool
* Loads the data into [My SQL](https://www.mysql.com/) as RDBMS for the OLAP database of the Sales and Purchases datamarts

Professors:
* [Francesc Casado](https://www.linkedin.com/in/francesccasadopastor/)
* [Bruno Galván García](https://www.linkedin.com/in/brunogalvangarcia/)

Team: 

* Adrian Hagen
* [Jon Dale](https://www.linkedin.com/in/jon-kristian-dale-441034188/)
* [Mohamed Ashmawy](https://www.linkedin.com/in/mohamed-ashmawy-447a69120/)
* [Mostafa Ezz](https://www.linkedin.com/in/mostafa-ezz-748006198/)
* [Joseph Higaki](https://www.linkedin.com/in/josephhigaki/)

## Architecture 

![Architecture](https://user-images.githubusercontent.com/11904085/122239558-50878200-cec1-11eb-85d4-c94b59197f42.png)

## Highlights
### Star Schema
![Star Schema](https://user-images.githubusercontent.com/11904085/122240352-00f58600-cec2-11eb-8476-4688f7434d7b.png)

### Product Dimension Transformation
Implementation of SCD (Slowly Changing Dimension) type 2: add new row on history-worth-keeping attribute changes.
![Star Schema](https://user-images.githubusercontent.com/11904085/122240752-4d40c600-cec2-11eb-8ec3-530472cbb32a.png)

### Sales Fact Transformation
Use SCD type 2 appropriate version, for Product, Customer and Vendor Dimensions
![Sales Order Fact](https://user-images.githubusercontent.com/11904085/122241541-ef60ae00-cec2-11eb-8bc8-68d9415a6606.png)

### Summary 
[Summary and presentation material](https://github.com/joseph-higaki/adventureworks_sales_purchases_datamart/blob/0cb16154e47fbc307543445c5a62ab80737342a1/Adventureworks.Sales.Purchases.DataManagement.Slides.pdf)

