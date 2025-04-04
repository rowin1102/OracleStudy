-- Q. 가장 높은 급여를 받는 직원의 이름(first_name, last_name)과 급여(salary)를 조회하는 SQL 문을 작성하시오.
select first_name, last_name, salary
    from employees
    where salary = (select max(salary) from employees);
    
