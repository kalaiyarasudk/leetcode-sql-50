
Problem Statement

Find the top 3 highest-paid employees in each department who have worked on more than 1 project**, along with:
 - Department Name
 - Employee Name
 - Salary
 - Number of Projects they have worked on
 - Total Hours Worked

Results should be ordered by:
 - Department Name (ascending)
 - Salary (descending)


-- Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary INT,
    hire_date DATE
);

-- Departments Table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Projects Table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE
);

-- EmployeeProjects Table
CREATE TABLE EmployeeProjects (
    employee_id INT,
    project_id INT,
    hours_worked INT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);


Solution:

with total_project_hrs as (
select e.employee_id, e.name, count(ep.project_id) as total_project , sum(ep.hours_worked ) as total_hrs_worked
from Employees e 
join EmployeeProjects ep 
on e.employee_id = ep.employee_id
group by 1,2
having count(ep.project_id) > 1
), 
 high_salary_tbl as (
select e.employee_id, e.department_id, d.department_name, e.salary,
dense_rank() over(partition by d.department_id order by e.salary desc) as high_salary
from Employees e
join Departments d 
on e.department_id = d.department_id
)

select hsb.department_name,tp.name,  hsb.salary,  tp.total_project, tp.total_hrs_worked
from total_project_hrs tp 
join high_salary_tbl hsb 
on tp.employee_id = hsb.employee_id
where hsb.high_salary <=3
order by hsb.department_name asc, hsb.salary desc 

