-- HW 4
use HW_4_SQL;

select * from hwemployees;

select * from hwemployees
where upper(lastname) like '%N';

select distinct lastname from hwemployees;


-- 1: Show a list the Company Name and Country for all Suppliers located in Japan or Germany.
select companyname, country
	from hwsuppliers
	where country in ('Japan', 'Germany');

-- 2: Show a list of Product Name, Quantity per Unit and Unit Price for products with a UnitPrice less than $7 but more than $4. 
select productname, quantityperunit, unitprice
	from hwproducts
    where unitprice>4 and unitprice<7;
    
-- 3: Show a list of Company Name, City and Country for Customers whose Country is USA and City is Portland, OR Country is Canada and City is Vancouver. 
select companyname, city, country
	from hwcustomers
    where (country='USA' and city='Portland') 
		or (country='Canada' and city='Vancouver');

-- 4: Show a list the Contact Name and Contact Title for all Suppliers with a SupplierID from 5 to 8 (inclusive) and sort in descending order by ContactName.
select contactname, contacttitle
	from hwsuppliers
    where supplierid between 5 and 8
    order by contactname desc;
    
-- 5: Show a product name and unit price of the least expensive product (i.e., lowest unit price). You MUST use a Sub Query.
select productname, unitprice 
	from hwproducts
	where unitprice = 
		(select min(unitprice) from hwproducts);

-- 6: Display Ship Country and their Order Count for all Ship Country except USA for ShippedDate between May 4th and 10th 2015 whose Order Count is greater than 3.
select shipcountry, count(orderid) as 'Order Count'
	from hworders
    where (shipcountry != 'USA') and (shippeddate between '2015-05-04' and '2015-05-10')
    group by shipcountry
    having count(orderid) > 3;

-- 7: Show a list of all employees with their first name, last name and hiredate (formated to mm/dd/yyyy) who are NOT living in the USA and have been employed for at least 5 years. 
select firstname, lastname, date_format(hiredate, '%m/%d/%Y') as 'hiredate'
	from hwemployees
	where (country != 'USA') and ((datediff(current_date(), hiredate)/365) >= 5);

-- 8: Show a list of Product Name and their 'Inventory Value' (Inventory Value = units in stock multiplied by 
-- their unit price) for products whose 'Inventory Value' is over 3000 but less than 4000.
select productname, sum(unitprice*unitsinstock) as 'Inventory Value'
	from hwproducts
    group by productname
    having sum(unitprice*unitsinstock) > 3000 and sum(unitprice*unitsinstock) < 4000;

-- 9: Show a list of Products' product Name, Unit in Stock and ReorderLevel level whose
-- Product Name starts with 'S' that are currently in stock (i.e., at least one Unit in Stock) and Unit in
-- Stock is at or below the reorder level. 
select productname, unitsinstock, reorderlevel
	from hwproducts
	where (upper(productname) like 'S%') and (unitsinstock>=1) and (unitsinstock<=reorderlevel);

-- 10: Show a list of Product Name, Unit Price and Quantity Per Unit for all products, whose
-- Quantity Per Unit has/measure in 'box' that have been discontinued (i.e., discontinued = 1).
select productname, unitprice, quantityperunit
	from hwproducts 
	where (upper(quantityperunit) like '%BOX%') and (discontinued=1);

-- 11: Show a list of Product Name and their TOTAL inventory value (inventory value =
-- UnitsInStock * UnitPrice) for Supplier's Country from Japan.
select productname, sum(unitprice*unitsinstock) as 'Inventory Value'
	from hwproducts
    where supplierid in  
		(select supplierid from hwsuppliers where country='Japan')
    group by productname;
    
    
-- 12: Show a list of customer's country and their count that is greater than 8.
select country, count(*) as 'cust. count'
	from hwcustomers
	group by country
	having count(*) > 8;


-- 13: Show a list of Orders' Ship Country, Ship City and their Order count for Ship Country
-- 'Austria' or 'Argentina'.
select shipcountry, shipcity, count(orderid) as 'Country Order Count' 
	from hworders
    where shipcountry in ('Austria', 'Argentina')
	group by shipcountry, shipcity;


-- 14: Show a list of Supplier's Company Name and Product's Product Name for supplier's
-- country from Spain.
select s.companyname, p.productname
	from hwsuppliers s
	inner join hwproducts p on s.supplierid = p.supplierid
	where country = 'Spain';

-- 15: What is the 'Average Unit Price' (rounded to two decimal places) of all the products whose
-- ProductName ends with 'T'?
select avg(unitprice) as 'Avg. unitprice'
	from hwproducts 
	where upper(productname) like '%T';


-- 16: Show a list of employee's full name (i.e., firstname, lastname, e.g., Harrison Ford), title
-- and their Order count for employees who has more than 120 orders.
select e.firstname, e.lastname, e.title, count(o.orderid) as 'Order Count'
	from hwemployees e
	left outer join hworders o on e.employeeid = o.employeeid
	group by e.firstname, e.lastname, e.title
    having count(o.orderid)>120;
    

select e.firstname, e.lastname, e.title, count(o.orderid) as 'Order Count'
	from hwemployees e, hworders o
	where e.employeeid = o.employeeid
	group by e.firstname, e.lastname, e.title;    

select * -- e.firstname, e.lastname, e.title, count(o.orderid) as 'Order Count'
	from hwemployees e, hworders o
	where e.employeeid = o.employeeid;


    
-- 17: Show a list customer's company Name and their country who has NO Orders on file (i.e., NULL Orders).
select companyname, country
	from hwcustomers
	where customerid not in 
			(select customerid from hworders);
        

-- 18: Show a list of Category Name and Product Name for all products that are currently out of 
-- stock (i.e. UnitsInStock = 0).
select c.categoryname, p.productname
	from hwcategories c
	inner join hwproducts p on c.categoryid = p.categoryid
	where p.unitsinstock=0;


-- 19: Show a list of products' Product Name and Quantity Per Unit, which are measured in 'pkg'
-- or 'pkgs' or 'jars' for a supplier’s country from Japan.
select productname, quantityperunit
	from hwproducts
	where ((upper(quantityperunit) like '%PKG%') or (upper(quantityperunit) like '%PKGS%') 
		or (upper(quantityperunit) like '%JARS%')) and supplierid in 
			(select supplierid from hwsuppliers where country='Japan');


-- 20: Show a list of customer's company name, Order’s ship name and total value of all their
-- orders (rounded to 2 decimal places) for customers from Mexico. (value of order = (UnitPrice *
-- Quantity) less discount. Discount is given in % e.g., 0.10 means 10%).
select c.companyname, o.shipname, round(SUM(d.unitprice * d.quantity * (1 - d.discount)),2) as 'total value'
	from hwcustomers c 
	inner join hworders o on c.customerid = o.customerid
	inner join hworderdetails d on o.orderid = d.orderid
	where c.country = 'Mexico'
    group by c.companyname, o.shipname;
    
    
-- 21: Show a list of products' Product Name and suppliers' Region whose product name starts with
-- 'L' and Region is NOT blank/empty.
select p.productname, s.region 
	from hwsuppliers s
	inner join hwproducts p on s.supplierid = p.supplierid
	where (upper(p.productname) like 'L%') and (s.region != '');


-- 22: Show a list of Order's Ship Country, Ship Name and Order Date (formatted as MonthName
-- and Year, e.g. March 2015) for all Orders from 'Versailles' Ship City whose Customer's record
-- doesn't exists in Customer table.
select o.shipcountry, o.shipname, date_format(o.orderdate, '%M %Y') as 'Order Date'
	from hwcustomers c
	right outer join hworders o on c.customerid = o.customerid
	where (o.shipcity='Versailles') and (c.customerid is null);


-- 23: Show a list of products' Product Name and Units In Stock whose Product Name starts with 'F'
-- and Rank them based on UnitsInStock from highest to lowest (i.e., highest UnitsInStock rank = 1,
-- and so on). Display rank number as well.
select productname, unitsinstock, 
	rank() over(order by unitsinstock desc) as 'units rank' 
		from hwproducts
		where (upper(productname) like 'F%');


-- 24: Show a list of products' Product Name and Unit Price for ProductID from 1 to 5 (inclusive)
-- and Rank them based on UnitPrice from lowest to highest. Display rank number as well.
select productname, unitprice, rank() over(order by unitprice asc) as 'price rank'
	from hwproducts
	where productid between 1 and 5;


-- 25: Show a list of employees' first name, last name, country and date of birth (formatted to
-- mm/dd/yyyy) who were born after 1984 and Rank them by date of birth (oldest employee rank
-- 1st, and so on) for EACH country i.e., Rank number should reset/restart for EACH country. Display
-- rank number as well.
select firstname, lastname, country, date_format(birthdate, '%m/%d/%Y') as birthdate,
	rank() over (partition by country order by birthdate) as 'rank'
		from hwemployees
		where year(birthdate) > 1984;
        
        