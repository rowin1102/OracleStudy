/*
파일명 : Or14View.sql
View(뷰)
설명 : View는 테이블로부터 생성된 가상의 테이블로 물리적으로는 존재하지
    않고, 논리적으로 존재하는 테이블이다.
*/

-- HR계정에서 학습

/*
select 쿼리문 실행시 해당 테이블이 존재하지 않는다면 "테이블 또는 뷰가
존재하지 않음"이라는 오류 메세지가 뜨게 된다.
*/
select * from member;

/*
View 생성
형식] create [or replace] view 뷰이름 [(컬럼1, 컬럼2 ... N)]
    as
    select * from 테이블명 조건 정렬 등;
    혹은 join이나 grop by가 포함된 모든 select문 가능함.
*/

/*
시나리오] hr계정의 사원테이블에서 담당업무가 ST_CLERK인 사원의 정보를
        조회할 수 있는 View를 생성하시오.
        출력항목 : 사원아이디, 이름, 직무아이디, 입사일, 부서아이디
*/
-- 1. 시나리오의 조건대로 select문 생성
select
    employee_id, first_name, last_name, job_id, hire_date, department_id
from employees where job_id = 'ST_CLERK';

-- 2. View 저장하기
create view view_employees
as
    select
        employee_id, first_name, last_name, job_id, hire_date, department_id
    from employees where job_id = 'ST_CLERK';

-- 3. View 실행하기
SELECT * FROM view_employees; -- 긴 쿼리문은 View로 간단히 실행할 수 있다.

-- 4. 데이터 사전에서 확인
SELECT * FROM user_views;

--------------------------------------------------------------------------------

/*
View 수정하기 : 뷰 생성 문장에 or replace만 추가하면 된다.
    해당 뷰가 존재하면 수정되고, 만약 존재하지 않으면 새롭게 생성된다.
    따라서 최초로 뷰를 생성할 때 사용해도 무방하다.
*/

/*
시나리오] 앞에서 생성한 뷰를 다음과 같이 수정하시오.
    기존 컬럼인 employee_id, first_name, job_id, hire_date, department_id를
    id, fname, jobid, hdate, deptid 로 수정하여 뷰를 생성하시오.
*/
create or replace view view_employees (id, fname, jobid, hdate, deptid)
as
    select employee_id, first_name, job_id, hire_date, department_id
    from employees where job_id='ST_CLERK';
/*
뷰 생성시 기존테이블의 컬럼명을 변경해서 출력하고 싶다면 위와 같이
변경할 컬럼명을 뷰이름 뒤에 소괄호로 명시해주면 된다.
*/
SELECT * FROM view_employees;

/*
퀴즈] 담당업무 아이디가 ST_MAN인 사원의 사원번호, 이름, 이메일, 매니져아이디를
    조회할 수 있도록 작성하시오.
    뷰의 컬럼명은 e_id, name, email, m_id로 지정한다. 단, 이름은 
    first_name과 last_name이 연결된 형태로 출력하시오.
	뷰명 : emp_st_man_view
*/
create or replace view emp_st_man_view (e_id, name, email, m_id)
as
    select employee_id, concat(first_name||' ', last_name), email, manager_id
    from employees where job_id='ST_MAN';

SELECT * FROM emp_st_man_view;

/*
퀴즈] 사원번호, 이름, 연봉을 계산하여 출력하는 뷰를 생성하시오.
컬럼의 이름은 emp_id, l_name, annual_sal로 지정하시오.
연봉계산식 -> (급여+(급여*보너스율))*12
뷰이름 : v_emp_salary
단, 연봉은 세자리마다 컴마가 삽입되어야 한다. 
*/

/*
1. select문 작성. null이 있는 경우 사칙연산이 되지 않으므로 nvl()함수를
통해 0으로 변환한 후 연산식을 작성해야 한다.
2. 뷰 생성
*/
create or replace view v_emp_salary (emp_id, l_name, annual_sal)
as
    select 
        employee_id, last_name, 
        ltrim(to_char((salary+(salary*nvl(commission_pct, 0)))*12, '999,000'))
    from employees;

SELECT * FROM v_emp_salary;

/*
뷰 생성시 연산식이 추가되어 논리적인 컬럼이 생성되는 경우에는 반드시
별칭으로 컬럼명을 명시해야 한다. 그렇지 않으면 뷰 생성시 에러가 발생한다.
*/
create or replace view v_emp_salary
as
    select employee_id, last_name, 
    ltrim(to_char((salary+(salary*nvl(commission_pct, 0)))*12, '999,000'))
    from employees;









