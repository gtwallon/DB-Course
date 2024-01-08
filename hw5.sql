-- HW 5
use information_schema;
show tables;
select * from tables
	where table_schema = 'HW_5_DW';

use HW_5_DW;

-- 1. Show a list of Customer Name, Gender, Sales Person’s Name and Sales Person's City for all
-- products sold on September 2015, whose Sales Price is more than 20 and Quantity sold is more
-- than 8
select c.customername, c.gender, s.salespersonname, s.city
	from 
		fact_productsales f, 
		dim_customer c, 
		dim_date d, 
        dim_salesperson s
	where
		f.customerid = c.customerid  
        and f.salesdatekey = d.datekey
        and f.salespersonid = s.salespersonid
        and d.month = 9
        and d.year = 2015
        and f.salesprice > 20
        and f.quantity > 8;
        
-- 2. Display the store name, city name, and product name, for products costing less than $50, sold in Boulder CO,
--  in March of 2017.
select s.storename, s.city, p.productname
	from 
		fact_productsales f,
        dim_date d,
        dim_store s,
        dim_product p 
	where 
		f.salesdatekey = d.datekey
        and f.storeid = s.storeid
        and f.productid = p.productkey
		and d.month = 3
        and d.year = 2017
        and f.productcost < 50
        and s.city = 'Boulder';
	
    
-- 3. Display the top two sales people of 2017, ranked by total revenue. 
select s.salespersonname, sum(f.quantity*f.salesprice) as 'Total Revenue'
	from 
		fact_productsales f,
		dim_date d,
        dim_salesperson s
	where
		f.salesdatekey = d.datekey
        and f.salespersonid = s.salespersonid
        and d.year = 2017
	group by 
		s.salespersonid
	order by sum(f.quantity*f.salesprice) desc
    limit 2;
    
    
-- 4. Display the customer responsible for the most total revenue in 2017. 
select c.customername, sum(f.quantity*f.salesprice) as 'Customer Total Revenue'
	from 
		fact_productsales f,
		dim_date d,
        dim_customer c
	where
		f.salesdatekey = d.datekey
        and f.customerid = c.customerid
        and d.year = 2017
	group by 
		c.customername
	order by sum(f.quantity*f.salesprice) asc
    limit 1;


-- 5. Display the total dollar amount of products sold at each store between 2010 and 2017.
select s.storename, sum(f.salesprice) as 'Total Sales Price'
	from 
		fact_productsales f, 
        dim_date d,
		dim_store s
	where
		f.salesdatekey = d.datekey
        and f.storeid = s.storeid
        and d.year between 2010 and 2017
	group by s.storename;
    

-- 6. Display the total profits each store incurred from Jasmin Rice sales in the year 2010.
select s.storename, p.productname, sum((f.quantity*f.salesprice) - (f.quantity*f.productcost)) as 'Total Profits'
	from 
        fact_productsales f,
        dim_date d,
        dim_store s,
        dim_product p 
	where
		f.salesdatekey = d.datekey
        and f.storeid = s.storeid
        and f.productid = p.productkey
        and d.year = 2010
        and p.productname like '%Jasmine Rice%'
	group by 
		s.storename, p.productname;
        

-- 7.Display Total Revenue from 'ValueMart Boulder' Store for each Quarter during 2016, sort
-- your result by Quarter in chronological order. Display Quarter as well as Total Revenue
select d.quarter, sum(f.salesprice*f.quantity) as 'Total Revenue'
	from 
		fact_productsales f,
        dim_date d,
        dim_store s
	where 
		f.salesdatekey = d.datekey
        and f.storeid = s.storeid
        and s.storename = 'ValueMart Boulder'
        and d.year = 2016
	group by d.quarter
    order by d.quarter asc;
    

-- 8. Display Customer Name and Total Sales Price for all items purchased by customers Melinda
-- Gates and Harrison Ford
select c.customername, sum(f.salesprice) as 'Total Sales Price'
	from 
		fact_productsales f,
		dim_customer c 
	where 
		f.customerid = c.customerid
        and c.customername in ('Melinda Gates', 'Harrison Ford')
	group by c.customername;


-- 9. Display Store Name, Sales Price and Quantity for all items sold in March 12th 2017.
select s.storename, f.salesprice, f.quantity 
	from 
		fact_productsales f,
        dim_date d,
        dim_store s 
	where
		f.salesdatekey = d.datekey
        and f.storeid = s.storeid
        and d.date = '2017-03-12';
        
select * -- s.storename, f.salesprice, f.quantity 
	from 
		fact_productsales f,
        dim_date d,
        dim_store s 
	where
		f.salesdatekey = d.datekey
        and f.storeid = s.storeid
        and d.date = '2017-03-12';


-- 10. Display Sales Person’s Name and Total Revenue for the best performing Sales Person, i.e.,
-- the Sales Person with the HIGHEST Total Revenue.
select s.salespersonname, sum(f.salesprice*f.quantity) as 'Total Revenue'
	from 
		fact_productsales f,
        dim_date d,
        dim_salesperson s
	where
		f.salesdatekey = d.datekey
        and f.salespersonid = s.salespersonid
	group by s.salespersonname
    order by sum(f.salesprice*f.quantity) desc
    limit 1;


-- 11. Display the Top 3 Product Name by their HIGHEST Total Profit. Display product name as
-- well as total profit
select p.productname, sum((f.quantity*f.salesprice) - (f.quantity*f.productcost)) as TotalProfit
	from 
		fact_productsales f,
        dim_product p
	where
		f.productid = p.productkey
	group by p.productname
    order by TotalProfit desc
    limit 3;
    
select * -- p.productname, sum((f.quantity*f.salesprice) - (f.quantity*f.productcost)) as TotalProfit
	from 
		fact_productsales f,
        dim_product p
	where
		f.productid = p.productkey
	;



-- 12. Display Year, MonthName and Total Revenue for the 1st 3 months (i.e. January, February
-- and March) of 2017
select d.year, d.monthname, sum(f.salesprice*f.quantity) as 'Total Revenue'
	from 
		fact_productsales f,
        dim_date d
	where
		f.salesdatekey = d.datekey
        and d.year = 2017
        and d.month between 1 and 3
	group by d.year, d.monthname;

select d.year, d.monthname, sum(f.salesprice*f.quantity) as 'Total Revenue'
	from 
		fact_productsales f,
        dim_date d
	where
		f.salesdatekey = d.datekey
	group by d.year, d.monthname
    having d.year = 2017 and d.monthname in ('January', 'February', 'March');
    


-- 13. Display Product Name, average product cost and average sales price for the products sold
-- in 2017. Show averages rounded to 2 decimal places.
select p.productname, 
	round(sum(f.productcost)/count(*),2) as 'Average Product Cost',
    round(sum(f.salesprice)/count(*),2) as 'Average Sales Price'
	from 
		fact_productsales f,
        dim_date d,
        dim_product p
	where
		f.salesdatekey = d.datekey
        and f.productid = p.productkey
        and d.year = 2017
	group by p.productname;

select p.productname, 
	round(avg(f.productcost),2) as 'Average Product Cost',
    round(avg(f.salesprice),2) as 'Average Sales Price'
	from 
		fact_productsales f,
        dim_date d,
        dim_product p
	where
		f.salesdatekey = d.datekey
        and f.productid = p.productkey
        and d.year = 2017
	group by p.productname;
    
select p.productname, 
	avg(f.productcost) as 'average transaction Product Cost per unit'
	from 
		fact_productsales f,
        dim_date d,
        dim_product p
	where
		f.salesdatekey = d.datekey
        and f.productid = p.productkey
        and d.year = 2017
	group by p.productname;
    
select p.productname, f.salesprice, f.productcost, f.quantity
	from 
		fact_productsales f,
        dim_date d,
        dim_product p
	where
		f.salesdatekey = d.datekey
        and f.productid = p.productkey
        and d.year = 2017
        and p.productname like '%jasm%';


-- 14. Display Customer Name, average sales price and average quantity for all items purchased
-- by customer Melinda Gates. Show averages rounded to 2 decimal places
select c.customername, 
	round(sum(f.salesprice)/count(*),2) as 'Average Sales Price',
    round(sum(f.quantity)/count(*),2) as 'Average Quantity'
	from 
		fact_productsales f,
        dim_customer c
	where 
		f.customerid = c.customerid
        and c.customername = 'Melinda Gates';


-- 15. Display Store Name, Maximum sales price and Minimum sales price for store located in
-- 'Boulder' city. Show MIN / MAX rounded to 2 decimal places
select s.storename, 
	round(max(f.salesprice),2) as 'Max. sales price', 
	round(min(f.salesprice),2) as 'Min. sales price'
	from 
		fact_productsales f,
        dim_store s
	where
		f.storeid = s.storeid
        and s.city = 'Boulder'
	group by s.storename;
    


select * from dim_customer
where customername like '%linda%'
;

select * from dim_customer;



























