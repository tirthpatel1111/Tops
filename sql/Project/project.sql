create database if not exists  coffee;
use coffee;
create table city(city_id int primary key ,city_name varchar(20),population int,estimated_rent int,city_rank int);
create table customers(customer_id int primary key ,customer_name varchar(35), city_id INT,foreign key(city_id) references city(city_id));
create table products(product_id int primary key,product_name varchar(75),price int);
create table sales(sale_id int primary key,sale_date date,product_id INT,customer_id INT,total float,rating int,foreign key(product_id) references products(product_id),foreign key(customer_id) references customers(customer_id));

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.1\\Uploads\\city.csv"
INTO TABLE city
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.1\\Uploads\\customers.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.1\\Uploads\\products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 0;
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.1\\Uploads\\sales.csv"
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SET FOREIGN_KEY_CHECKS = 1;
select * from customers;
select * from products;
select * from city;
select * from sales;


-- total sale of each prodcut in different city
select distinct s.total,c.city_name,p.product_name from products p join sales s on s.product_id=p.product_id join customers cm on cm.customer_id=s.customer_id join city c on c.city_id=cm.city_id order by city_name;
-- give product_name,total_sales by quterly 
select distinct YEAR(s.sale_date) as year,monthname(s.sale_date) as month_name,quarter(s.sale_date) as quarter,p.product_name,sum(s.total) as sum_quaterly  from sales s  join products p on p.product_id=s.product_id group by YEAR(s.sale_date),quarter(s.sale_date), MONTHNAME(s.sale_date),p.product_name order by year,quarter;
-- how many customers sare repeted
SELECT DISTINCT count(s1.customer_id) FROM sales s1 left join customers cu on cu.customer_id=s1.customer_id JOIN sales s2 ON s1.customer_id = s2.customer_id AND YEAR(s1.sale_date) = YEAR(s2.sale_date) - 1;
-- give list of customer in who are repeted in 2024
SELECT customer_id, sale_date 
FROM sales 
WHERE customer_id IN (
    SELECT DISTINCT customer_id 
    FROM sales 
    WHERE YEAR(sale_date) = 2024
) 
AND YEAR(sale_date) <> 2024;  
-- give sale of last qurter of 2023
WITH qd AS (
    SELECT DISTINCT 
        ci.city_name, 
        SUM(s.total) AS total, 
        YEAR(s.sale_date) AS year, 
        QUARTER(s.sale_date) AS quarter
    FROM sales s 
    JOIN customers c ON c.customer_id = s.customer_id 
    JOIN city ci ON ci.city_id = c.city_id 
    GROUP BY ci.city_name, YEAR(s.sale_date), QUARTER(s.sale_date)
)
SELECT * 
FROM qd 
WHERE quarter = 4 AND year = 2023;
-- give curn rate given data
WITH previous_customers AS (
    SELECT DISTINCT customer_id
    FROM sales
    WHERE YEAR(sale_date) <> 2024
),
current_customers AS (
    SELECT DISTINCT customer_id
    FROM sales
    WHERE YEAR(sale_date) = 2024
),
churned_customers AS (
    SELECT pc.customer_id
    FROM previous_customers pc
    LEFT JOIN current_customers cc ON pc.customer_id = cc.customer_id
    WHERE cc.customer_id IS NULL
)
SELECT 
    COUNT(churned_customers.customer_id) AS churned_customers,
    COUNT(previous_customers.customer_id) AS total_previous_customers,
    ROUND(
        (COUNT(churned_customers.customer_id) * 100.0) / NULLIF(COUNT(previous_customers.customer_id), 0), 2
    ) AS churn_rate
FROM previous_customers
LEFT JOIN churned_customers ON previous_customers.customer_id = churned_customers.customer_id;
-- What are the top 3 selling products in each city based on sales volume?
with product_sales as (
    select c.city_name, p.product_name, sum(s.total) as total_sales,
    rank() over (partition by c.city_name order by sum(s.total) desc) as sales_rank
    from sales s
    join products p on p.product_id = s.product_id
    left join customers cu on cu.customer_id = s.customer_id
    left join city c on c.city_id = cu.city_id
    group by c.city_name, p.product_name
) 
select city_name, product_name, total_sales from product_sales where sales_rank <= 3 order by city_name, sales_rank;
-- Average Sales Amount per City
select c.city_name, avg(s.total) as avg_sales 
from sales s 
left join customers cu on cu.customer_id = s.customer_id 
left join city c on c.city_id = cu.city_id 
group by c.city_name 
order by avg_sales desc;
-- provide a list of cities along with their populations and estimated coffee consumers.
select c.city_name, c.population, count(distinct cu.customer_id) as coffee_consumers 
from city c 
left join customers cu on cu.city_id = c.city_id 
left join sales s on s.customer_id = cu.customer_id 
left join products p on p.product_id = s.product_id 
where lower(p.product_name) like '%coffee%' 
group by c.city_name, c.population 
order by coffee_consumers desc;
-- What are the top 3 selling products in each city based on sales volume?
with product_sales as (
    select c.city_name, p.product_name, sum(s.total) as total_sales,
    rank() over (partition by c.city_name order by sum(s.total) desc) as sales_rank
    from sales s
    join products p on p.product_id = s.product_id
    left join customers cu on cu.customer_id = s.customer_id
    left join city c on c.city_id = cu.city_id
    group by c.city_name, p.product_name
) 
select city_name, product_name, total_sales 
from product_sales 
where sales_rank <= 3 
order by city_name, sales_rank;
-- rating of each product in different citys
select s.rating,c.city_name,p.product_name from sales s join products p on s.product_id=p.product_id join customers cu on cu.customer_id=s.customer_id join city c on c.city_id=cu.city_id;
-- How many units of each coffee product have been sold?
select count(s.product_id) as product,p.product_name from sales s join products p on p.product_id=s.product_id group by s.product_id;
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly).
select  month(sale_date),
case 
	 when lag(sum(total)) over(order by month(sale_date))/sum(total) >1 then concat(lag(sum(total)) over(order by month(sale_date))/sum(total),"loss")
     else lag(sum(total)) over(order by month(sale_date))/sum(total)*100
     end as pr
    from sales group by month(sale_date) order by month(sale_date);
-- find which city consume chepest product how many times
select c.city_name,p.price,count(c.city_name)  as count_of_consume_product from products p join sales s on s.product_id=p.product_id join customers cu on cu.customer_id=s.customer_id join city c on c.city_id=cu.city_id where p.price=(select max(price) from products) group by p.price,c.city_name;
-- give ratio of total sale and population in different cities
select sum(c.population)/sum(p.price),c.city_name as ratio from products p join sales s on s.product_id=p.product_id join customers cu on cu.customer_id=s.customer_id join city c on c.city_id=cu.city_id group by c.city_id;