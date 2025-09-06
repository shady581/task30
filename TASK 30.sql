create database CompanyDB
use test19
go
create schema salles
go
--    3
create sequence i
As int 
start with 1
increment by 1
go
select next value for i
CREATE TABLE Sales.employees (
    employee_id INT DEFAULT (next value for i) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10,2)
)
--    4
alter table  Sales.employees
add hire_date date

    --  5
	insert into sales.employees (first_name, last_name, salary, hire_date) values
('john', 'smith', 60000, '2020-05-12'),
('jane', 'doe', 48000, '2020-08-20'),
('michael', 'scott', 75000, '2019-03-10'),
('sarah', 'simons', 52000, '2021-06-01'),
('tom', 'anderson', 45000, null)

   -- 1
select *
from sales.employees
     --2
select first_name, last_name
from sales.employees;
   --3

   select first_name + ' ' + last_name full_name
from sales.employees;
 -- 4 average salary
select avg(salary) as avg_salary from sales.employees

-- 5 employees with salary > 50000
select * from sales.employees where salary > 50000

-- 6 employees hired in 2020
select * from sales.employees where year(hire_date) = 2020

-- 7 last names starting with 's'

select  last_name 
from sales.employees 
where last_name like '%s'
-- 8 top 10 highest paid employees
select top 10 *
from sales.employees
order by salary desc;
-- 9 salary between 40000 and 60000
select salary
from sales.employees
where salary between 40000 and 60000
-- 10 names containing 'man'
select * from sales.employees 
where first_name like '%man%' or last_name like '%man%'
-- 11 employees with null hire_date
select * from sales.employees where hire_date is null

-- 12 salary in (40000, 45000, 50000)
select * from sales.employees where salary in (40000, 45000, 50000)
-- 13 employees hired between 2020-01-01 and 2021-01-01
select * from sales.employees 
where hire_date between '2020-01-01' and '2021-01-01'

-- 14 salaries in descending order
select * from sales.employees order by salary desc
-- 15 first 5 employees ordered by last_name asc
select top 5 * from sales.employees order by last_name asc
-- 16 salary > 55000 and hired in 2020
select * from sales.employees 
where salary > 55000 and year(hire_date) = 2020;

-- 17 first name is john or jane
select * from sales.employees where first_name in ('john', 'jane')

-- 18 salary <= 55000 and hire_date > 2022-01-01
select * from sales.employees 
where salary <= 55000 and hire_date > '2022-01-01'

-- 19 salary greater than average salary
select * from sales.employees 
where salary > (select avg(salary) from sales.employees);
-- 20 3rd to 7th highest paid employees
select * from sales.employees
order by salary desc
offset 2 rows fetch next 5 rows only

-- 21 employees hired after 2021-01-01 in alphabetical order
select * from sales.employees 
where hire_date > '2021-01-01'
order by last_name asc
-- 22 salary > 50000 and last name not starting with 'a'
select * from sales.employees 
where salary > 50000 and last_name not like 'a%'

-- 23 salary not null
select * from sales.employees where salary is not null;

-- 24 names with 'e' or 'i' and salary > 45000
select * from sales.employees
where (first_name like '%e%' or first_name like '%i%' 
    or last_name like '%e%' or last_name like '%i%')
  and salary > 45000
  -- 1
  create table sales.departments (
    department_id int primary key,
    department_name varchar(100),
    manager_id int references sales.employees(employee_id)
)
alter table sales.employees
add department_id int;

alter table sales.employees
add constraint fk_department
foreign key (department_id) references sales.departments(department_id);


select e.employee_id, e.first_name, e.last_name, d.department_name
from sales.employees e
inner join sales.departments d
    on e.department_id = d.department_id

select e.employee_id, e.first_name, e.last_name, d.department_name
from sales.employees e
left join sales.departments d
    on e.department_id = d.department_id
where d.department_id is null

select d.department_name, count(e.employee_id) as employee_count
from sales.departments d
left join sales.employees e
    on e.department_id = d.department_id
group by d.department_name

select d.department_name, e.first_name, e.last_name, e.salary
from sales.employees e
inner join sales.departments d
    on e.department_id = d.department_id
where e.salary = (
    select max(salary) 
    from sales.employees 
    where department_id = d.department_id
)