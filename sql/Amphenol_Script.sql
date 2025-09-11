-- Database creation
create database xxxxxx;
use xxxxxx;
describe invoice;

-- Renaming buggy columns 

select * from invoice_sheet;
alter table invoice_sheet
rename column ï»¿Inv_Site to Inv_Site;
alter table invoice_sheet
rename column Inv_Cust to Inv_CustNbr;
alter table invoice_sheet
rename column Inv_Item_Nbr to Inv_ItemNbr;

select * from customer_master;
alter table customer_master
rename column ï»¿Custmast_CustNbr to Custmast_CustNbr;

select * from part_status;
alter table part_status
rename column ï»¿Partstatus_Status to Partstatus_Status;

select * from SOP;
alter table SOP
rename column ï»¿SOP_nbr to SOP_Nbr;  

Select * from hpl;
Alter table hpl
rename column ï»¿HPL_code to HPL_code;

select * from cust_type;
alter table cust_type
rename column ï»¿Cust_type to Cust_type;
alter table cust_type
rename column Type_desc to Cust_Desc ;

select * from part_master;
alter table part_master 
rename column ï»¿Partmast_Itemnbr to Partmast_Itemnbr;
alter table part_master
rename column Partmast_Itemnbr to Partmast_ItemNbr;


  
-- CONSTRAINTS
select * from customer_master;
alter table customer_master
add primary key (Custmast_CustNbr); -- PRIMARY KEY IN TABLE CUSTOMER_MASTER

select * from part_master;
alter table part_master
add primary key(Partmast_ItemNbr); -- PRIMARY KEY IN TABLE PART_MASTER

select * from cust_type;
alter table cust_type
add primary key (Cust_type); -- PRIMARY KEY IN TABLE CUST_TYPE

ALTER TABLE part_master 
ADD PRIMARY KEY (Item_num);

select * from customer_master;
alter table customer_master
add foreign key (Custmast_type) references cust_type(Cust_Type); -- FOREIGN KEY IN CUSTOMER_MASTER REFERENCING CUSTOMER_TYPE

select * from invoice_sheet;
alter table invoice_sheet
add foreign key (Inv_CustNbr)  references customer_master(Custmast_CustNbr); -- FOREIGN KEY IN INVOICE_SHEET REFERENCING CUSTOMER_MASTER
alter table invoice_sheet
add foreign key (Inv_ItemNbr) references part_master(Partmast_ItemNbr); -- FOREIGN KEY IN INVOICE_SHEET REFERENCING PART_MASTER

alter table part_master
add foreign key (Partmast_HPLcode) references HPL(HPL_code); -- FOREIGN KEY IN PART_MASTER REFERENCING HPL

alter table part_master
add foreign key (Partmast_SOP) references SOP(SOP_Nbr);-- Unable to add foreign key as values  missing in part_master (edit: foreign key added referencing SOP)

alter table part_master
add foreign key (Partmast_Status) references part_status(partstatus_status);-- FOREIGN KEY IN PART_MASTER REFERENCING Part_Status

select * from hpl;
alter table hpl
add primary key (HPL_Code, HPL_desc); -- PRIMARY KEY (2 COLUMNS ) IN HPL

alter table invoice_sheet
add constraint Unique3 unique(Inv_Site, Inv_Nbr, Inv_Line); -- 3 UNIQUE COLUMNS IN INVOICE_SHEET


-- changing blanks to nulls so foreign key can be added
UPDATE part_master
SET Partmast_SOP = NULL
WHERE Partmast_SOP = '';


-- Changing text to Date format (Invoice_Sheet)
ALTER TABLE invoice_sheet ADD COLUMN New_Inv_date DATE;

UPDATE invoice_sheet
SET New_Inv_date = STR_TO_DATE(Inv_Date, '%Y%m%d');


describe invoice_sheet;
select * from invoice_sheet;
ALTER TABLE invoice_sheet DROP COLUMN Inv_date;
ALTER TABLE invoice_sheet CHANGE New_Inv_date Inv_Date DATE;


-- changing data type from text to varchar
ALTER TABLE part_master 
MODIFY COLUMN Item_num VARCHAR(255);
alter table invoice_sheet
modify column Inv_ItemNbr varchar(255);
alter table invoice_sheet
modify column Inv_Nbr varchar(255);
alter table sop
modify column SOP_Nbr varchar(255);
alter table hpl
modify column HPL_desc varchar(255);
alter table part_master
modify column Partmast_SOP varchar (255);
alter table part_status
modify column Partstatus_Status varchar(255);
alter table part_master
modify column Partmast_Status varchar(255);



-- Basic Statistics
-- Total records count from invoice sheet
select count(*) from invoice_sheet; -- 48057

-- Count of unique part numbers in invoice table
select count(distinct Inv_ItemNbr) from invoice_sheet; -- 7761

-- Count of unique customers in invoice table
select count(distinct Inv_CustNbr) from invoice_sheet; -- 207

-- count of unique invoices in invoice table
select count( distinct Inv_Nbr) from invoice_sheet; -- 35514

-- count of distinct parts transacted (in the invoice table) for each HPL 
select Partmast_HPLcode, count(distinct Partmast_ItemNbr) as distinct_parts_transacted_HPL from invoice_sheet i
join part_master p on i.Inv_ItemNbr = p.Partmast_ItemNbr 
group by Partmast_HPLcode
order by distinct_parts_transacted_HPL desc;

-- count of distinct HPL codes of part numbers transacted in the invoice
select count(distinct Partmast_HPLcode) as unique_HPL_Code from part_master p
join invoice_sheet i on i.Inv_ItemNbr = p.Partmast_ItemNbr;


-- count of distinct parts transacted (in the invoice table) for each SOP
select Partmast_SOP , count(distinct Partmast_ItemNbr) as distinct_parts_transacted_SOP  from invoice_sheet i
 join part_master p on i.Inv_ItemNbr = p.Partmast_ItemNbr 
group by Partmast_SOP
order by distinct_parts_transacted_SOP desc;  

-- count of distinct SOP codes of part numbers transacted in the invoice
select count(distinct Partmast_SOP) as unique_HPL_Code from part_master p
join invoice_sheet i on i.Inv_ItemNbr = p.Partmast_ItemNbr;

-- count of distinct parts transacted (in the invoice table) for each generic account
select Custmast_GenAcc, count(*) from invoice_sheet i
join customer_master c on i.Inv_CustNbr = c.Custmast_CustNbr
group by Custmast_GenAcc;

-- count of distinct parts transacted (in the invoice table) for customer type
select Custmast_type, count(*) from invoice_sheet i
join customer_master c on i.Inv_CustNbr = c.Custmast_CustNbr
group by Custmast_type;

-- total invoice value
select round(sum(Inv_Qty*Inv_Price),0) from invoice_sheet; -- 80,207,836

-- count of unique HPL code in partmaster
select count(distinct Partmast_HPLcode) from part_master; -- 134

-- count of unique SOP code in partmaster
select count(distinct Partmast_SOP) from part_master; -- 495

-- count of unique generic account in customer master
select count( distinct Custmast_GenAcc) from customer_master; -- 72

-- count of unique country codes in customer master
select count(distinct Custmast_CtryCode) from customer_master; -- 9



-- Total sales by customer .1
select * from invoice_sheet;
select Custmast_Name, round(sum(inv_qty*inv_price),0) as tot_sales
from invoice_sheet i
join customer_master c on i.Inv_CustNbr=c.Custmast_CustNbr
group by Inv_CustNbr
order by tot_sales desc
limit 10;

-- total sales per month for the year .2
select month(inv_date) as Month, round(sum(inv_qty*inv_price),0) as monthly_sales
from invoice_sheet
group by month(inv_date) 
order by month(inv_date);

-- Product Performance 3
select Inv_ItemNbr , round(sum(inv_qty*inv_price),0) as tot_sales
from invoice_sheet
group by Inv_ItemNbr
order by tot_sales desc
limit 10;

-- Regional Sales Distribution 4
select Custmast_CtryCode, round(sum(inv_qty*inv_price),0) as tot_sales from invoice_sheet i
join customer_master c on i.Inv_CustNbr= c.Custmast_CustNbr
group by Custmast_CtryCode;

-- customer segmentation by type 5
select Custmast_type, round(sum(inv_qty*inv_price),0) as tot_sales from invoice_sheet i
join customer_master c on i.Inv_CustNbr= c.Custmast_CustNbr
group by Custmast_type;

-- cost analysis of products 6
select Partmast_ItemNbr ,round(sum(inv_qty*Partmast_Stdcost),0) as cost_price, -- standard cost of part
		round(sum(Inv_Qty*Inv_Price),0) as Revenue from invoice_sheet i  -- revenue of part
 join part_master p on i.Inv_ItemNbr = p.Partmast_ItemNbr 
group by Partmast_ItemNbr
order by Revenue desc;

-- Display HPL names having profitability less than 25%
select HPL_desc, round(((sum(Inv_Qty*Inv_Price))-(sum(inv_qty*Partmast_Stdcost)))/(sum(Inv_Qty*Inv_Price)),3)  as Profitability  from invoice_sheet i
join part_master p on i.Inv_ItemNbr=p.Partmast_ItemNbr
join hpl h on p.Partmast_HPLcode= h.HPL_code
group by HPL_desc
having  ((sum(Inv_Qty*Inv_Price))-(sum(inv_qty*Partmast_Stdcost)))/(sum(Inv_Qty*Inv_Price)) < 0.25 ;

-- 7. Monthly sales trend by customer type
select Custmast_type, month(Inv_Date), round(sum(Inv_Qty*Inv_Price),0) as Tot_sales from invoice_sheet i
join customer_master c on i.Inv_CustNbr= c.Custmast_CustNbr
group by Custmast_type, month(Inv_Date)
order by Custmast_type, month(Inv_Date);

-- 8. Identify the top 10 customers based on total revenue and their contribution to overall sales.
SELECT 
    Custmast_Name,
    tot_sales,
    SUM(tot_sales) OVER () AS Tot_Rev,
    ROUND((tot_sales / SUM(tot_sales) OVER ()) * 100, 2) AS Contribution_Percent
    from
(select Custmast_Name,
round(sum(inv_qty*inv_price),0) as tot_sales
from invoice_sheet i
join customer_master c on i.Inv_CustNbr=c.Custmast_CustNbr
group by Inv_CustNbr) as Cust_sales
order by tot_sales desc
limit 10;

-- 9 Assess the contribution of each HPL Code  to total sales revenue 
-- ## Identify the top HPL’s contributing to 30 % of the sales ##
-- ## Identify the top HPL’s contributing to 30 % of the Profit ##

select HPL_code, HPL_desc,tot_sales,
		 ROUND((tot_sales / SUM(tot_sales) OVER ()) * 100, 2) AS Contribution_Percent
from
(select HPL_code, HPL_desc, round(sum(Inv_Qty*Inv_Price),2) as tot_sales
 from invoice_sheet i 
join part_master p on i.Inv_ItemNbr = p.Partmast_ItemNbr
join hpl h on h.HPL_code = p.Partmast_HPLcode
group by HPL_code, HPL_desc) as cust_sales
order by tot_sales desc;


--  Assess the contribution of each HPL Code  to total Profit
select HPL_code, HPL_desc,
		 ROUND((tot_profit / SUM(tot_profit) OVER ()) * 100, 2) AS Contribution_Percent_to_totProfit
from
(select HPL_code, HPL_desc, round(sum(Inv_Qty*Inv_Price) - sum(Inv_Qty*Partmast_Stdcost),2) as tot_profit
 from invoice_sheet i 
join part_master p on i.Inv_ItemNbr = p.Partmast_ItemNbr
join hpl h on h.HPL_code = p.Partmast_HPLcode
group by HPL_code, HPL_desc) as cust_sales
order by tot_profit desc;


-- 10 Identify the top 10 HPL’s  having the highest average monthly qty sold

select Partmast_HPLcode, HPL_desc,   /*count(distinct month(Inv_Date)) as Distinct_Months*/ ((sum( Inv_Qty))/12) as avg_qty_sold_by12
from part_master p
join invoice_sheet i on p.Partmast_ItemNbr = i.Inv_ItemNbr
join hpl h on h.HPL_code= p.Partmast_HPLcode
group by Partmast_HPLcode,HPL_desc
order by avg_qty_sold_by12 desc
limit 10;

select * from customer_master
where Custmast_Name like '%AVNET ASIA PTE LTD%';


-- Display the custoemrs name in sequence of highest profitability to lowest profitability
-- customer name, total invoice value, total profit and total profit contribution.
-- hpl having the highest contri, find customer name, hpl,  hpl code,  total sales for hpl,total sales for customer and total profit for hpl and total profit for cust
-- and the hpl total contribution and total profit contri
select * from invoice_sheet;
select * from part_master;
select * from customer_master;
select * from hpl;

with CTE as (Select HPL_code ,
	Inv_val,
	tot_profit,
     ROUND((tot_profit / SUM(tot_profit) OVER ()) * 100, 2) AS contribution
From
(select HPL_code,
	round(sum(Inv_Price*Inv_Qty),2) as Inv_val,
    round(sum(Inv_Qty*Inv_Price) - sum(Inv_Qty*Partmast_Stdcost),2) as tot_profit
    
from customer_master cm
join invoice_sheet i
on i.Inv_CustNbr = cm.Custmast_CustNbr
join part_master pm
on pm.Partmast_ItemNbr = i.Inv_ItemNbr
JOIN hpl h
on h.HPL_code = pm.Partmast_HPLcode
group by HPL_code)Subquery
order by contribution desc
limit 1)

select hpl_code,
	Custmast_Name,
    inv_val,
    tot_profit
from cte
join part_master p
on p.Partmast_HPLcode = cte.HPL_code
group by hpl_code, Custmast_Name;








-- ----------------------------------------------------------
WITH CTE AS (
  -- Find the HPL with the highest contribution
  SELECT HPL_code,
         ROUND((tot_profit / SUM(tot_profit) OVER ()) * 100, 2) AS contribution
  FROM (
    -- Calculate total sales and total profit for each HPL
    SELECT HPL_code,
           ROUND(SUM(Inv_Price * Inv_Qty), 2) AS Inv_val,
           ROUND(SUM(Inv_Qty * Inv_Price) - SUM(Inv_Qty * Partmast_Stdcost), 2) AS tot_profit
    FROM customer_master cm
    JOIN invoice_sheet i ON i.Inv_CustNbr = cm.Custmast_CustNbr
    JOIN part_master pm ON pm.Partmast_ItemNbr = i.Inv_ItemNbr
    JOIN hpl h ON h.HPL_code = pm.Partmast_HPLcode
    GROUP BY HPL_code
  ) AS Subquery
  ORDER BY contribution DESC
  LIMIT 1
)

SELECT 
    cte.HPL_code,
    i.Inv_CustNbr ,  -- Now we can use Custmast_Name since we're joining cm
    ROUND(SUM(i.Inv_Price * i.Inv_Qty), 2) AS customer_sales,
    ROUND(SUM(i.Inv_Qty * i.Inv_Price) - SUM(i.Inv_Qty * pm.Partmast_Stdcost), 2) AS customer_profit
FROM CTE
JOIN part_master pm ON pm.Partmast_HPLcode = cte.HPL_code
join invoice_sheet i on i.Inv_ItemNbr = pm.Partmast_ItemNbr
   -- cm.Custmast_CustNbr  -- Add this join to customer_master
-- JOIN customer_master cm ON cm.Custmast_CustNbr = i.Inv_CustNbr  -- Correctly join customer_master table

GROUP BY cte.HPL_code,  i.Inv_CustNbr
ORDER BY customer_sales DESC;


-- ------------------------------------------------------------------
WITH CTE AS (
  -- Find the HPL with the highest contribution
  SELECT HPL_code,
         ROUND((tot_profit / SUM(tot_profit) OVER ()) * 100, 2) AS contribution
  FROM (
    -- Calculate total sales and total profit for each HPL
    SELECT HPL_code,
           ROUND(SUM(Inv_Price * Inv_Qty), 2) AS Inv_val,
           ROUND(SUM(Inv_Qty * Inv_Price) - SUM(Inv_Qty * Partmast_Stdcost), 2) AS tot_profit
    FROM customer_master cm
    JOIN invoice_sheet i ON i.Inv_CustNbr = cm.Custmast_CustNbr
    JOIN part_master pm ON pm.Partmast_ItemNbr = i.Inv_ItemNbr
    JOIN hpl h ON h.HPL_code = pm.Partmast_HPLcode
    GROUP BY HPL_code
  ) AS Subquery
  ORDER BY contribution DESC
  LIMIT 1
)

SELECT 
    cte.HPL_code,
    cm.Custmast_Name,  -- Now we can use Custmast_Name since we're joining cm
    ROUND(SUM(i.Inv_Price * i.Inv_Qty), 2) AS customer_sales,
    ROUND(SUM(i.Inv_Qty * i.Inv_Price) - SUM(i.Inv_Qty * pm.Partmast_Stdcost), 2) AS customer_profit
FROM CTE
JOIN part_master pm ON pm.Partmast_HPLcode = cte.HPL_code
join invoice_sheet i on i.Inv_ItemNbr = pm.Partmast_ItemNbr
join customer_master cm on cm.Custmast_CustNbr= i.Inv_CustNbr

   -- cm.Custmast_CustNbr  -- Add this join to customer_master
-- JOIN customer_master cm ON cm.Custmast_CustNbr = i.Inv_CustNbr  -- Correctly join customer_master table

GROUP BY cte.HPL_code,  cm.Custmast_Name
ORDER BY customer_sales DESC;



