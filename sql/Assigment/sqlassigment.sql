use hrdb;
select e.*,d.* from employees e join departments d on d.department_id=e.department_id;
select hire_date,concat(first_name," ",last_name)as name from employees;
select concat(first_name," ",last_name," ",job_id) as employee_and_title from employees;
select hire_date,concat(first_name," ",last_name)as name,department_id from employees;
select concat(employee_id," ",first_name," ",last_name," ",email," ",phone_number," ",hire_date," ",job_id," ",salary," ",commission_pct," ",manager_id," ",department_id)as "THE OUTPUT" from employees; 
select concat(first_name," ",last_name)as name,salary from employees where salary>2000;
select concat(first_name," ",last_name)as name,hire_date as "Start Date" from employees ;
select concat(first_name," ",last_name)as name,hire_date as "Start Date" from employees order by hire_date;
select concat(first_name," ",last_name)as name,salary from employees order by salary desc;
select concat(first_name," ",last_name)as name,department_id,salary from employees where commission_pct is not null order by salary desc;
select e.last_name,j.job_title from employees e join jobs j on j.job_id=e.job_id where e.manager_id is null;
select last_name,job_id,salary from employees where job_id in("SA_REP","SH_CLERK") and salary not in(2500,3500,5000);
-- select last_name,job_id,salary from employees;
select max(salary),min(salary),avg(salary),max(commission_pct),min(commission_pct),avg(commission_pct) from employees;
select department_id,sum(salary),sum(commission_pct) from employees group by department_id;
select department_id,sum(employee_id) from employees group by department_id;
select department_id,sum(salary) from employees group by department_id;
select concat(first_name," ",last_name)as name from employees where commission_pct is null order by 1;
select concat(first_name," ",last_name)as name,department_id, case when commission_pct is null then 'No commission'else commission_pct end as commision from employees;
select concat(first_name," ",last_name)as name,salary, case when commission_pct is null then 'No commission'else 2*commission_pct end as commision from employees;
select e1.first_name,e1.department_id from employees e1 join employees e2 on e1.first_name=e2.first_name and e1.department_id=e2.department_id and e1.employee_id <> e2.employee_id;
select sum(salary) from employees where manager_id is not null group by manager_id;
-- 10
select concat(e.first_name,' ',e.last_name)as name,e.department_id,e.salary,concat(m.first_name,' ',m.last_name) as manager_name,e.last_name from employees e join employees m on m.manager_id=e.manager_id where e.last_name like '_a%' order by manager_name;
-- 12
select max(salary),department_id from employees group by department_id;
select case 	when commission_pct is not null then salary*0.1
				when commission_pct is null then 1 else commission_pct end as commision from employees;
SELECT CONCAT(
    UPPER(LEFT(SUBSTRING(last_name, 2, 4), 1)), 
    LOWER(SUBSTRING(last_name, 3, 3))
) AS Extracted_Last_Name
FROM employees;
select concat(first_name,"-",last_name) as name,monthname(hire_date) as moj from employees;
select last_name,case when (salary/2)>10000 then salary+salary*0.1
					  else salary*0.115
                      end as "updated salary",
                      1500 as "Bounes Amount" from employees;
select employee_id from employees;
select concat(substring(e.employee_id,1,2),"00",substring(e.employee_id,3,3),'E') as "updated_eid",e.department_id,e.salary,upper(replace(concat(m.first_name," ",m.last_name),'Z','$')) as "upadeted_mid" from employees e join employees m on e.manager_id=m.manager_id;
select concat(upper(left(last_name,1)),substring(last_name,2,length(last_name)))as last_name ,case when last_name like "%j%"or"%A%"OR"%M%" then length(last_name)
													else last_name end as col_len from employees order by last_name;
select last_name,lpad(salary,15,"$")as salary from employees;
select first_name from employees where first_name=reverse(first_name);
select concat(upper(left(first_name,1)),substring(first_name,2,length(first_name)))as first_name from employees;
-- p 3 9
select lower(concat(substring(first_name,1,1),last_name,"@systechusa.com")) as emailaddress from employees;
select concat(e.first_name," ",e.last_name)as name ,j.job_title from employees e join jobs j on j.job_id=e.job_id where e.job_id=(select job_id from employees where first_name="Trenna");
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = (SELECT city 
                FROM locations 
                WHERE location_id = (SELECT d.location_id 
                                     FROM employees e
                                     JOIN departments d ON e.department_id = d.department_id
                                     WHERE e.first_name = 'Trenna'));
select concat(first_name," ",last_name)as name from employees where salary=(select min(salary) from employees);
select concat(first_name," ",last_name)as name from employees where salary<>(select min(salary) from employees);
select e.last_name,e.department_id,d.department_name from employees e join departments d on e.department_id=d.department_id;
select distinct(j.job_title),l.city from jobs j join employees e on e.job_id=j.job_id join departments d on d.department_id =e.department_id join locations l on l.location_id =d.location_id where e.department_id=4;
select e.last_name,d.department_name,d.location_id,l.city from employees e join departments d on d.department_id=e.department_id join locations l on d.location_id=l.location_id where e.commission_pct is not null;
select e.last_name,d.department_name from employees e join departments d on d.department_id=e.department_id where last_name like "%a%";
select e.last_name,j.job_title,e.department_id,d.department_name from employees e join departments d on e.department_id = d.department_id join jobs j on j.job_id=e.job_id join locations l on l.location_id=d.location_id where l.city="ATLANTA";
select e.last_name,e.employee_id,e.manager_id,m.last_name from employees e join employees m on m.manager_id=e.manager_id;
select e.last_name,e.employee_id,e.manager_id,m.last_name from employees e left join employees m on m.manager_id=e.manager_id;
select e.last_name,e.department_id,e2.last_name from employees e join employees e2 on e.department_id=e2.department_id where e.employee_id <> e2.employee_id;
select concat(e.first_name," ",e.last_name)as name,e.job_id,d.department_name,e.salary,case when e.salary=50000 then 'A' when e.salary between 50000 and 30000 then 'B' else 'c' END as grade from employees e join departments d on e.department_id=d.department_id;
select concat(e.first_name," ",e.last_name) as ename,e.hire_date as emp_hire_date,concat(m.first_name," ",m.last_name) as mname,m.hire_date as manager_hire_date from employees e join employees m on e.manager_id=m.manager_id where e.hire_date<m.hire_date;
select e.last_name,e.hire_date from employees e join departments d on d.department_id = e.department_id where d.department_name="SALES";
select employee_id,last_name,salary from employees where salary>(select avg(salary) from employees)order by salary asc;
select distinct employee_id,last_name from employees where department_id in(select department_id from employees where last_name like "%u%");
-- SELECT DISTINCT e1.employee_id, e1.last_name
-- FROM employees e1
-- JOIN employees e2 ON e1.department_id = e2.department_id
-- WHERE e2.last_name LIKE '%u%';
select e.last_name,e.department_id,e.job_id from employees e join departments d on d.department_id=e.department_id join locations l on l.location_id=d.location_id where l.city="atlanta";
-- p6 5
select e.department_id,e.last_name,e.job_id from employees e join departments d on d.department_id=e.department_id where d.department_name="Operations";
select employee_id,last_name,salary from employees where salary>(select avg(salary) from employees) and department_id in(select department_id from employees where last_name like "%u%");
select concat(first_name," ",last_name) as name from employees e join jobs j on j.job_id=e.job_id where j.job_title in (select j.job_title from jobs j join employees e on e.job_id=j.job_id join departments d on d.department_id=e.department_id where d.department_name="Sales");
select employee_id,salary, case
							when department_id in (1,3) then "5% raise"  
					        when department_id=2 then "10% raise" 
							when department_id in (4,5) then "15% raise"
                            when department_id = 6 then "no % raise" 
                            else "not given raise"
                            end as raise_percentage from employees;
create view top_3_earners as select last_name,salary from employees order by salary desc;
select * from top_3_earners limit 3;
select concat(first_name," ",last_name) salary, case when commission_pct is null then 0
								else commission_pct end as commision from employees;
create view top_3_manager as select concat(m.first_name," ",m.last_name)as name,e.salary,e.department_id,d.department_name from employees e join employees m on m.manager_id=e.manager_id join departments d on d.department_id=e.department_id;                              
select * from top_3_manager limit 3;
create table if not exists date_function(Emp_ID int primary key not null auto_increment,hire_date date,Resignation_Date Date);
INSERT INTO date_function (hire_date, Resignation_Date) 
VALUES 
    ('2000-01-01', '2013-07-10'),
    ('2003-12-04', '2017-08-03'),
    ('2012-09-22', '2015-06-21'),
    ('2015-04-13', NULL),
    ('2016-06-03', NULL),
    ('2017-08-08', NULL),
    ('2016-11-13', NULL);
select timestampdiff(day,hire_date,Resignation_Date) as day,timestampdiff(month,hire_date,Resignation_Date)%12 as month,timestampdiff(year,hire_date,Resignation_Date) as year from date_function;
select date_format(hire_date,'%m/%d/%y') as hire_date,ifNULL(date_format(Resignation_Date,'%b %e, %y') ,'Dec 01th, 1900') as Regination_date from date_function;
SELECT 
    CONCAT(
        IFNULL(TIMESTAMPDIFF(YEAR, hire_date, Resignation_Date), TIMESTAMPDIFF(YEAR, hire_date, CURDATE())), " year ",
        IFNULL(TIMESTAMPDIFF(MONTH, hire_date, Resignation_Date) % 12, TIMESTAMPDIFF(MONTH, hire_date, CURDATE()) % 12), " month"
    ) AS experience
FROM date_function;
SELECT 
    TIMESTAMPDIFF(DAY, 
        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 3 MONTH), 
        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 0 MONTH)
    ) AS days_in_previous_quarter;
SELECT 
    DATE_ADD(
        DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 3 MONTH), 
        INTERVAL 7 DAY
    ) AS second_week_first_day_previous_quarter;
SELECT 
    DATE_FORMAT(
        DATE_ADD(
            STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-04-01'), '%Y-%m-%d'), 
            INTERVAL (15 - 1) WEEK
        ), 
        '%a %d %Y'
    ) AS first_day_15th_week,
    
    DATE_FORMAT(
        DATE_ADD(
            DATE_ADD(
                STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-04-01'), '%Y-%m-%d'), 
                INTERVAL (15 - 1) WEEK
            ),
            INTERVAL 6 DAY
        ), 
        '%a %d %Y'
    ) AS last_day_15th_week;
WITH last_day_january_2015 AS (
    SELECT '2015-01-31' AS last_day
)
SELECT 
    DATE_SUB(last_day, INTERVAL (DAYOFWEEK(last_day) + 1) % 7 DAY) AS last_saturday_january_2015
FROM last_day_january_2015;







