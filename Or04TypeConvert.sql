/*
파일명 : Or04TypeConvert.sql
형변환함수 / 기타함수
설명 : 자료형을 다른 타입으로 변환해햐 할때 사용하는 함수와 기타함수
*/

/*
sysdate : 현재날짜와 시간을 초 단위로 반환해준다. 주로 게시판이나 회원가입시 날짜를
    입력하기 위해 사용된다. 오라클의 기본 서식이 xx/xx/xx이므로 출력시 시간은 표시되지
    않지만, 서식문자를 초단위까지 표현할 수 있다.
*/
select sysdate from dual;

/*
날짜포맷 : 오라클은 대소문자를 구분하지 않으므로, 서식문자 역시 구분없이
    사용할 수 있다. 따라서 MM과 mm은 동일한 결과를 인출한다.
*/
select to_char(sysdate, 'yyyy/mm/dd') from dual;
select to_char(sysdate, 'YY-MM-DD') from dual;

/*
시나리오]현재날짜를 "오늘은 0000년00월00일 입니다"와 같은 형식으로 
    출력하는 쿼리문을 작성하시오.
*/
-- 날짜 형식을 인식하지 못해 에러가 발생한다.
select to_char(sysdate, '오늘은 YYYY년 MM월 DD일 입니다.') from dual;
/*
-(하이픈), /(슬러쉬)와 같은 특수기호 외에는 서식으로 인식하지 못하므로 이를 제외한 나머지
문자열은 "으로 묶어줘야 한다. 서식문자를 감싸는게 아니므로 작성에 주의해야 한다.
*/
select to_char(sysdate, '"오늘은 "YYYY"년 "MM"월 "DD"일 입니다."') from dual;

/*
시나리오] 사원테이블에서 사원의 입사일을 다음과 같이 출력할 수 있는 
    쿼리문을 작성하시오. 
    출력] 0000년 00월 00일 0요일
*/
select first_name, hire_date,
    to_char(hire_date, 'yyyy"년 "mm"월 "dd"일 "dy"요일"')
    from employees;

select
    to_char(sysdate, 'day') "요일(월요일)",
    to_char(sysdate, 'dy') "요일(월)",
    to_char(sysdate, 'mon') "월(1월)",
    to_char(sysdate, 'mm') "월(01)",
    to_char(sysdate, 'month'),
    to_char(sysdate, 'ddd') "1년 중 몇 번째 일" 
    from dual;

/*
숫자포맷
    0 : 숫자의 자리수를 나타내며 자리수가 맞지 않는 경우 0으로 자리를 채운다.
    9 : 0과 동일하지만, 자리수가 맞지 않는 경우 공백으로 채운다.
*/
select
    to_char(123, '0000'), to_char(123, '9999'),
    trim(to_char(123, '9999'))
    from dual;

/*
숫자에 세자리마다 컴파 표시하기 : 자리수가 확실히 보장된다면 0을 사용하고,
    자리수가 확실치 않은 경우에는 9를 사용한다. 대신 공백은 trim으로 제거하면 된다.
*/
select 12345,
    to_char(12345, '000,000'), to_char(12345, '999,999'), ltrim(to_char(12345, '999,999')),
    ltrim(to_char(12345, 'L999,999'))
    from dual;

/*
숫자변환함수
    to_number() : 문자형 데이터를 숫자형으로 변환한다.
*/
-- 2개의 문자가 숫자로 변환되어 덧셈의 결과를 인출한다.
select to_number('123') + to_number('456') from dual;
-- 숫자가 아닌 문자가 포함되어 에러가 발생한다. 수치가 부적합함.
select to_number('123a') + to_number('456') from dual;

/*
시나리오] '123,000'이라는 문자열이 주어졌을때 숫자로 변환한 후
    10을 더한 결과를 출력하는 쿼리문을 작성하시오. 
*/
-- 문자열 사이에 콤마가 포함되어 있으므로 숫자로 변환할 수 없어 에러 발생
select to_number('123,000') + 10 from dual;
-- replace()로 콤마를 제거한 후 숫자로 변환하고 덧셈을 진행한다.
select to_number(replace('123,000', ',', '')) + 10 from dual;

/*
to_date()
    문자열 데이터를 날짜형식으로 변환해서 출력해본다. 기본서식은 년/월/일 순으로 지정된다.
*/
-- 하이픈, 슬러쉬와 같은 문자로 구분되어 있는 경우 기본서식으로 인식한다.
-- 따라서 별도의 서식문자 없이도 날짜로 인식할 수 있다.
select 
    to_date('2025-04-02'), 
    to_date('2025/04/02'),
    to_date('20250402')
    from dual;
    
-- 문자 형식의 날짜인 경우 아래와 같이 연산이 불가능하다.
select '2025-04-02' + 1 from dual; -- 에러발생
/*
날짜를 통해 연산을 하고 싶다면 아래와 같이 날짜 변환함수를 사용해야 한다.
날짜에 1을 더하는 것은 내일의 날짜를 인출한다.
*/
select to_date('2025-04-02') + 1 from dual;
/*
아래와 같이 날짜포맷이 년-월-일이 아닌 경우에는 오라클이 인식하지 못하므로 에러가 발생한다.
이때는 날짜서식을 이용해서 오라클이 날짜로 인식할 수 있도록 처리해야 한다.
*/
select to_date('02-04-2025') from dual; -- 에러발생

/*
시나리오] 다음에 주어진 날짜형식의 문자열을 실제 날짜로 인식할 수 있도록
    쿼리문을 구성하시오. 
    '14-10-2021' => 2021-10-14로 인식
    '04-19-2022' => 2022-04-19로 인식
*/
select
    to_date('14-10-2021', 'dd-mm-yyyy') + 1 "1일 후",
    to_date('04-19-2022', 'mm-dd-yyyy') + 7 "1주일 후"
    from dual;

/*
퀴즈1] '2020-10-14 15:30:21'와 같은 형태의 문자열을 날짜로 인식할수 
    있도록 쿼리문을 작성하시오. 
*/ 
-- 시간까지 있으므로 인식되지 않아 에러발생
select to_date('2020-10-14 15:30:21') from dual;
/*
방법1 : 날짜형식의 문자열을 substr()로 날짜부분만 잘라낸 후 사용한다.
    주어진 문자열은 년-월-일 형식이므로 별도의 서식 없이도 인식된다.
*/
select
    to_date(substr('2020-10-14 15:30:21', 1, 10))
    from dual;

/*
방법2 : 날짜와 시간의 서식을 적용한다. 특히 시간은 15시이므로 
    24시간제인 서식을 이용해야 한다.
*/    
select
    to_date('2020-10-14 15:30:21', 'yyyy-mm-dd hh24:mi:ss')
    from dual;

/*
퀴즈2] 문자열 '2021년01월01일'은 어떤 요일인지 변환함수를 통해 출력해보시오.
    단 문자열은 임의로 변경할 수 없습니다. 
*/
-- 날짜 형식을 알 수 없어 에러 발생됨
select to_date('2021년01월01일') from dual;

select 
    to_date('2021년01월01일', 'yyyy"년"mm"월"dd"일"'),
    to_char(to_date('2021년01월01일', 'yyyy"년"mm"월"dd"일"'), 'day')
    from dual;

/*
내가 만든 코드
select
    to_char(to_date(replace(replace(replace('2021년01월01일', '년', '-'), '월', '-'), '일', ''), 
    'yyyy/mm/dd'), 'yyyy/mm/dd day')
    from dual;
*/

/*
nvl() : null 값을 다른 데이터로 변경하는 함수
    형식] nvl(컬럼명, 대체할 값)
아래와 같이 덧셈연산을 하면 영업사원이 아닌 경우에는 급여가 null로 계산된다.
따라서 null값을 가진 컬럼은 별도의 처리가 필요하다.
*/
select salary + commission_pct from employees;
-- null을 0으로 대체한 후 연산을 하면 정상적인 결과를 볼 수 없다.
select salary + nvl(commission_pct, 0) from employees;

/*
decode()
: Java의 switch문과 비슷하게 특정값에 해당하는 출력문이 있는 경우 사용한다. 
형식] decode(컬럼명,
                값1, 결과1, 값2, 결과2, ... ,
                기본값)
※내부적인 코드값을 문자열로 변환하여 출력할때 많이 사용된다.
*/
/*
시나리오] 사원테이블에서 각 부서번호에 해당하는 부서명을 출력하는 쿼리문을
    decode()를 이용해서 작성하시오. 
*/
select
    first_name, department_id,
    decode(
        department_id, -- 컬럼명 지정
        30,	'Purchasing', -- 조건 start
        50,	'Shipping',
        60,	'IT',
        90,	'Executive',
        100, 'Finance', -- 조건 end
        '부서명확인안됨' -- default값으로 조건에 적용되지 않는 나머지
        ) as dep_name
    from employees;

/*
case() : Java의 if~else와 비슷한 역할을 하는 함수
    형식] case
            when 조건1 then 값1
            when 조건2 then 값2
            ...
            else 기본값
        end
*/
select
    first_name, department_id,
    case
        when department_id = 30 then 'Purchasing'
        when department_id = 50	then 'Shipping'
        when department_id = 60 then 'IT'
        when department_id = 90	then 'Executive'
        when department_id = 100 then 'Finance'
        else '부서명확인안됨'
        end as dep_name
    from employees;
    
--------------------------------------------------------------------------------

-- 1.
select substr(hiredate, 1, 5) from emp;

-- 2.
select ename, hiredate from emp where substr(hiredate, 4, 2) = 04;

-- 3.
select ename, empno from emp where mod(empno, 2) = 0;

-- 4.
select to_char(hiredate, 'yy/mon/dy') from emp;

-- 5.
select sysdate - to_date('01-01-2025', 'dd-mm-yyyy') from dual;

-- 6.
select nvl(mgr, 0) from emp;

--7.
select job, sal,
    decode (
    job,
    'CLERK', sal + 200,
    'SALESMAN', sal + 180,
    'MANAGER', sal + 150,
    'PRESIDENT', sal + 100,
    sal
    ) as "급여인상"
from emp;
