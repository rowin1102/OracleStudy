/*
파일명 : Or16SubProgram.sql
서브프로그램
설명 : 저장프로시저, 함수 그리고 자동으로 실행되는 프로시저인
    트리거를 학습한다.
*/

/*
서브프로그램(Sub Program)
- PL/SQL에서는 프로시저와 함수라는 두 가지 유형의 서브프로그램이 있다.
- select를 포함해서 모든 DML문을 이용하여 프로그래밍적인 요소를 통해
    사용 가능하다.
- 프로시저 : 외부프로그램에서 호출하기 위해 정의한다. 따라서 Java, JSP 등에서
    간단하 호출로 복잡한 쿼리를 실행할 수 있다.
- 함수 : 쿼리문의 일부분으로 사용하기 위해 정의한다. 즉, 외부 프로그램에서
    호출하는 경우는 거의 없다.
- 트리거 : 프로시저의 일종으로 특정 테이블에 레코드의 변화가 있을 경우
    자동으로 실행된다. 즉, 직접 호출하지 않는다.
*/

/*
1. 저장 프로시저(Stored Procedure)
- 프로시저는 return문이 없는 대신 out파라미터를 통해 값을 반환한다.
- 보안성을 높일 수 있고, 네트워크의 부하를 줄일 수 있다.
형식]
    create [or replace] procedure 프로시저명
        [(매개변수 in 자료형, 매개변수 out 자료형)]
        is 변수선언
        begin
            실행문장;
        end;
※ 매개변수 설정시 자료형만 명시하고, 크기는 명시하지 않는다.
*/

-- 예제1] 사원의 급여를 가져와서 출력하는 프로시저 생성
/*
시나리오] 100번 사원의 급여를 select하여 출력하는 저장프로시저를 생성하시오.
*/
-- 프로시저는 생성시 or replace를 추가하는 것이 좋다.
-- 매개변수는 필요없는 경우 생략할 수 있다.
create or replace procedure pcd_emp_salary
is
/*
PL/SQL에서는 declare 절에 변수를 선언하지만, 프로시저에서는 is절에 선언한다.
만약 선언할 변수가 없다면 내용을 생략할 수 있다.
*/
    v_salary employees.salary%type;
begin
-- 100번 사원의 급여를 into를 이용해서 변수에 저장
    select salary into v_salary
    from employees
    where employee_id = 100;
    
    -- 결과를 내부에서 출력
    dbms_output.put_line('사원번호100의 급여는:' || v_salary || '입니다.');
end;
/
-- 실행하면 데이터 사전에 저장만 되고 실행결과가 출력되진 않는다.

/*
데이터 사전에서 확인할때는 '대문자'로 저장되므로 아래와 같이 upper함수를
사용해야 한다.
*/
SELECT * FROM user_source where name like upper('%pcd_emp_salary%');
-- 만약 첫 실행이라면 최초 한번 실행해 준다.
set serveroutput on;
-- 프로시저의 호출은 호스트환경에서 execute 명령을 이용한다.
execute pcd_emp_salary;

--------------------------------------------------------------------------------

-- 예제2] IN파라미터 사용하여 프로시저 생성
/*
시나리오] 사원의 이름을 매개변수로 받아서 사원테이블에서 레코드를 조회한후
해당사원의 급여를 출력하는 프로시저를 생성 후 실행하시오.
해당 문제는 in파라미터를 받은후 처리한다.
사원이름(first_name) : Bruce, Neena
*/
-- 프로시저 생성시 in파라미터를 설정. first_name 컬럼을 참조하는 형식
create or replace procedure pcd_in_param_salary
    (param_name in employees.first_name%type)
is
    valSalary number(10);
begin
    select salary into valSalary
    from employees where first_name = param_name;
    dbms_output.put_line(param_name || '의 급요는 ' || valSalary || '입니다.');
end;
/

-- 데이터 사전에서 확인하기(대문자로 저장되므로 변환 필요)
SELECT * FROM user_source where name like upper('%pcd_in_param_salary%');

-- execute 명령으로 프로시저 실행
execute pcd_in_param_salary('Bruce');
execute pcd_in_param_salary('Neena');

--------------------------------------------------------------------------------

-- 예제3] OUT파라미터 사용하여 프로시저 생성
/*
시나리오] 위 문제와 동일하게 사원명을 매개변수로 전달받아서 급여를 조회하는
프로시저를 생성하시오. 단, 급여는 out파라미터를 사용하여 반환후 출력하시오
*/

/*
두 가지 형식의 파라미터를 정의. 일반변수, 참조변수를 사용해서 선언함.
파라미터는 용도에 따라 in, out을 명시한다. 단, 크기는 별도로 명시하지 않는다.
*/

create or replace procedure pcd_out_param_salary
    (param_name in varchar2,
    param_salary out employees.salary%type)
is
/*
select한 결과를 out파라미터에 저장할 것이므로 별도의 변수가 필요하지 않아
is절을 비워둔다.
*/
begin
/*
in파라미터는 where절의 조건으로 사용하고, select한 결과는 into절에서
out파라미터에 저장한다.
*/
    select salary into param_salary
    from employees where first_name = param_name;
/*
프로시저에서는 별도로 return을 명시하지 않는다. 실행이 종료되면 out파라미터에
할당된 값이 자동으로 반환된다.
*/
end;
/

-- 호스트 환경에서 바인드 변수를 선언한다.(variable도 사용 가능)
var v_salary varchar2(30);

/*
프로시저 호출시 각각의 파라미터를 사용한다. 특히 바인드 변수는 :을 붙여야 한다.
Out파라미터인 param_salary에 저장된 값이 v_salary로 전달된다.
*/
execute pcd_out_param_salary('Matthew', :v_salary);

-- 프로시저 실행 후 out파라미터를 통해 전달된 값을 출력한다.
print v_salary;

--------------------------------------------------------------------------------

/*
프로시저에서 update문 실행을 위해 employees테이블을 레코드까지 모두 복사한 후
진행한다.
복사할 테이블명 : zcopy_employees
*/
create table zcopy_employees
as
select * from employees where 1=1;
-- 테이블 확인
desc zcopy_employees;
-- 복사된 레코드 확인
select * from zcopy_employees;

/*
시나리오] 사원번호와 급여를 매개변수로 전달받아 해당사원의 급여를 수정하고, 
실제 수정된 행의 갯수를 반환받아서 출력하는 프로시저를 작성하시오.
*/

/*
in파라미터는 사원번호, 급여를 전달받는다. out파라미터는 update가 적용된
행의 갯수를 반환하는 용도로 선언
*/
create or replace procedure pcd_update_salary
    (
        p_empid in number,
        p_salary in number,
        rCount out number
    )
is -- 추가적인 변수 선이 필요없으므로 생략
begin
-- 실제 없데이트를 처리하는 쿼리문으로 in파라미터를 통해 값 설정
    update zcopy_employees 
        set salary = p_salary
        where employee_id = p_empid;
    
/*
SQL%notfound : 쿼리실행 후 적용된 행이 없을 경우 true를 반환한다.
    Found는 반대의 경우를 반환함.
SQL%RowCount : 쿼리 실행 후 실제 적용된 행의 갯수를 반환한다.
*/    
    if SQL%notfound then
        dbms_output.put_line(p_empid || '은(는) 없는 사원입니다.');
    else
        dbms_output.put_line(SQL%rowcount || '명의 자료가 수정되었습니다.');

-- 실제 적영된 행의 갯수를 반환하여 Out파라미터에 할당
        rCount := sql%rowcount;
    end if;
/*
행의 변화가 있는 insert, update, delet 퀄리를 실행하는 경우 반드시 commit해야
실제 테이블에 적용되어 Oracle외부에서 확인할 수 있다.
*/
    commit;
end;
/

-- 프로시저 실행을 위해 바인드 변수 생성
variable r_count number;
-- 100번 사원의 이름과 급여 확인
select first_name, salary from zcopy_employees where employee_id=100;
-- 프로시저 실행. 급여를 30000으로 업데이트
execute pcd_update_salary(100, 30000, :r_count);
-- update가 적용된 행의 갯수 확인
print r_count;

--------------------------------------------------------------------------------

/*
시나리오] 2개의 정수를 전달받아서 두 정수사이의 모든수를 더해서 
결과를 반환하는 함수를 정의하시오.
실행예) 2, 7 -> 2+3+4+5+6+7 = ??
*/

-- 함수는 in파라미터만 있으므로 in은 주로 생략한다.
create or replace function calSumBetween (
    num1 in number,
    num2 number
)
return -- 함수는 반환값이 필수이므로 반환타입을 명시해야 한다.
    number
is -- 변수 선언(선택사항 : 필요없는 경우 생략 가능)
    sumNum number;
begin
    sumNum := 0;
    
-- for 루프문으로 숫자사이의 합을 계산한 후 반환
    for i in num1 .. num2 loop
        sumNum := sumNum + i;
    end loop;
    
    return sumNum; -- 결과 반환
end;
/

-- 실행방법1 : 쿼리문의 일부로 사용(권장하는 방법)
select calSumBetween(1, 10) from dual;

-- 실행방법2 : 바인드변수를 통한 실행명령으로 주로 디버깅용으로 사용
var hapText varchar2(100);
execute :hapText := calSumBetween(1, 100);
print hapText;

--------------------------------------------------------------------------------

/*
퀴즈] 주민번호를 전달받아서 성별을 판단하는 함수를 정의하시오.
999999-1000000 -> '남자' 반환
999999-2000000 -> '여자' 반환
단, 2000년 이후 출생자는 3이 남자, 4가 여자임.
함수명 : findGender()
*/

-- in파라미터로 주민번호를 받아야 함으로 문자타입으로 선언
create or replace function findGender (
    str varchar2
)
return
    varchar2
is
    genderTxt varchar2(1);
    result varchar2(20);
begin
    genderTxt := substr(str, 8, 1);
    
    if genderTxt = '1' or genderTxt = '3' then
        result := '남자';
    elsif genderTxt = '2' or genderTxt = '4'then
        result := '여자';
    else
        result := '알수없음';
    end if;

    return result;
end;
/

select findGender('999999-1000000') from dual; 
select findGender('999999-2000000') from dual;
select findGender('999999-3000000') from dual;
select findGender('999999-4000000') from dual;
-- 한글은 보통 한글자에 3byte로 표현되므로 변수의 크기는 넉넉하게 설정.
select findGender('999999-5000000') from dual;

--------------------------------------------------------------------------------

/*
시나리오] 사원의이름(first_name)을 매개변수로 전달받아서  
부서명(department_name)을 반환하는 함수를 작성하시오.
함수명 : func_deptName
*/
-- 1단계 : 2개의 테이블을 조인해서 결과확인
select
    first_name, last_name, department_id, department_name
from employees
    inner join departments using(department_id)
where first_name = 'Nancy';

-- 2단계 : 함수 작성(사원의 이름을  인파라미터로 설정)
create or replace function func_deptName (
-- 사원의 이름을 받아야 하므로 문자타입으로 선정
    param_name varchar2
)
return
-- 부서명을 반환해야 하므로 문자타입으로 선언
    varchar2
is
-- 부서테이블의 부서명을 참조하는 참조변수 선언
    return_deptname departments.department_name%type;
begin
-- using을 사용한 내부조인을 통해 부서명을 인출하여 변수에 저장
    select
        department_name into return_deptname
    from employees
        inner join departments using(department_id)
    where first_name = param_name;
-- 인출된 부서명을 반환    
    return return_deptname;
end;
/

select func_deptName('Nancy') from dual;
select func_deptName('Diana') from dual;

--------------------------------------------------------------------------------

/*
3. 트리거(Trigger) : 자동으로 실행되는 프로시저로 직접 실행은 불가능하다.
    주로 테이블에 저장된 레코드의 변화가 있을때 자동으로 실행된다.
*/

-- 트리거 실습을 위해 '부서'테이블을 복사한다.
-- 오리지날 테이블은 레코드까지 모두 복사
create table trigger_dept_original
as
SELECT * FROM departments where 1=1;

-- 백업 테이블은 레코드 없이 스키마(구조)만 복사
create table trigger_dept_backup
as
SELECT * FROM departments where 1=0;

-- 레코드 확인
SELECT * FROM trigger_dept_original; -- 레코드 27개 확인
SELECT * FROM trigger_dept_backup; -- 레코드 없음

-- 예제1] trig_dept_backup
/*
시나리오] 테이블에 새로운 데이터가 입력되면 해당 데이터를 백업테이블에 저장하는
트리거를 작성해보자.
*/

create or replace trigger tring_dept_backup
    after -- 타이밍 : after이므로 이벤트 발생 후
    INSERT -- 이벤트 : 레코드 입력 후 발생됨
    on trigger_dept_original -- 트리거를 적용할 테이블명
/*
행단위 트리거를 정의. 즉, 하나의 행이 변화할때마다 트리거가 실행된다.
만약 테이블(문장)단위 트리거로 정의하고 싶다면 해당 문장을 제거한다.
이 경우 쿼리를 실행하면 트리거도 딱 한번만 실행된다.
*/
    for each row
begin
-- insert 이벤트가 발생되면 true를 반환하여 if문이 실행된다.
    if INSERTING then
        dbms_output.put_line('insert 트리거 발생됨');
        
/*
새로운 레코드가 입력되었으므로 임시테이블 :new에 저장되고 해당 레코드를
통해 backup 테이블에 입력할 수 있다.
이와 같이 임시테이블은 행단위 트리거에서만 사용할 수 있다.
*/
        insert into trigger_dept_backup
        values (
            :new.department_id,
            :new.department_name,
            :new.manager_id,
            :new.location_id
        );
    end if;
end;
/

-- 오리지날 테이블에 레코드 삽입
insert into trigger_dept_original values (101, '개발팀', 10, 100);
insert into trigger_dept_original values (102, '전산팀', 20, 100);
insert into trigger_dept_original values (103, '영업팀', 30, 100);
-- 삽입된 레코드 확인
select * from trigger_dept_original;
-- 트리거를 통해 자동으로 백업된 레코드 확인
select * from trigger_dept_backup;

--------------------------------------------------------------------------------

-- 예제2] trig_dept_delete
/*
시나리오] 원본테이블에서 레코드가 삭제되면 백업테이블의 레코드도 같이
삭제되는 트리거를 작성해보자.
*/

create or replace trigger tring_dept_delete
/*
'오리지날 테이블'에서 레코드를 '삭제'한 '이후' '행단위'로 트리거를 적용한다.
*/
    after
    delete
    on trigger_dept_original
    for each row
begin
    dbms_output.put_line('delete 트리거 발생됨');

/*
레코드가 삭제된 후 이벤트가 발생되어 트리거가 호출되므로 :old 임시테이블을
사용한다.
*/
    if deleting then
        delete from trigger_dept_backup
            where department_id = :old.department_id;
    
    end if;
end;
/

-- 레코드 확인하기
select * from trigger_dept_original;
select * from trigger_dept_backup;

-- 아래와 같이 레코드를 삭제하면 트리거가 자동 호출된다.
delete from trigger_dept_original where department_id=101;

select * from trigger_dept_original;
select * from trigger_dept_backup;

--------------------------------------------------------------------------------

-- 예제3] trigger_update_test

/*
for each row 옵션에 따른 트리거 실행횟수 테스트
생성 1 : 오리지날 테이블에 업데이트 이후 행단위로 발생되는 트리거 생성
*/
create or replace trigger trigger_update_test
    after update
    on trigger_dept_original
    for each row
begin
    if updating then
        dbms_output.put_line('update 트리거 발생됨');
        insert into trigger_dept_backup
        values (
            :old.department_id,
            :old.department_name,
            :old.manager_id,
            :old.location_id
        );
    end if;
end;
/

-- 5개의 레코드를 인출하는 select문 작성
SELECT * FROM trigger_dept_original
    where department_id>=10 and department_id<= 50;

-- 위 조건을 그대로 update에 적용하여 실행
update trigger_dept_original set department_name='5개 업데이트'
    where department_id>=10 and department_id<= 50;

-- 레코드 확인하기    
select * from trigger_dept_original;
select * from trigger_dept_backup;
/*
한번의 쿼리문 실행으로 5개의 레코드가 수정되었으므로, 백업테이블에도 5개의
레코드가 입력된다.
즉, 행단위 트리거는 적용된 행의 갯수만큼 반복 실행된다.
*/


/*
생성2 : 오리지날 테이블에 업데이트 이후 테이블(문장) 단위로 발생되는 트리거 생성
*/
create or replace trigger trigger_update_test
    after update
    on trigger_dept_original
    /*** for each row ***/
begin
    if updating then
        dbms_output.put_line('update 트리거 발생됨');
        insert into trigger_dept_backup
        values (
        /***
            테이블 단위 트리거에서는 임시테이블을 사용할 수 없다.
            따라서 임의의 값을 사용해야 한다. 사용시 에러가 발생된다.
            :old.department_id,
            :old.department_name,
            :old.manager_id,
            :old.location_id ***/
            999, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), 99, 9
        );
    end if;
end;
/

-- 위 조건을 그대로 update에 적용하여 실행
update trigger_dept_original set department_name='5개 업데이트2nd'
    where department_id>=60 and department_id<= 100;

-- 레코드 확인하기    
select * from trigger_dept_original;
/*
오리지날 테이블에서 5개의 레코드가 수정되었지만 테이블 단위 트리거이므로
백업테이블에는 1개의 레코드만 삽입된다.
*/
select * from trigger_dept_backup;

--------------------------------------------------------------------------------

create table sh_product_code (
    p_code number(10) primary key,
    category_name varchar2(50) not null
);

create table sh_goods (
    g_idx number(10) primary key,
    goods_name varchar2(50) not null,
    goods_price number not null,
    regidate date not null,
    p_code number not null
        references sh_product_code (p_code)
);

create table sh_goods_log (
    log_idx number primary key,
    goods_name varchar2(50) not null,
    goods_idx number not null,
    p_action varchar2(10) not null
        check(p_action in ('Insert', 'Delete')) 
);

create sequence seq_total_idx
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;

insert into sh_product_code values (seq_total_idx.nextval, '가전');
insert into sh_product_code values (seq_total_idx.nextval, '도서');
insert into sh_product_code values (seq_total_idx.nextval, '의류');
insert into sh_product_code values (seq_total_idx.nextval, '식품');

insert into sh_goods values (seq_total_idx.nextval, '냉장고', 2000000, 
    to_date('2025-04-13', 'yyyy-mm-dd'), 1);
insert into sh_goods values (seq_total_idx.nextval, '세탁기', 1500000, 
    to_date('2025-04-12', 'yyyy-mm-dd'), 1);

insert into sh_goods values (seq_total_idx.nextval, '사피엔스', 20000, 
    to_date('2025-04-11', 'yyyy-mm-dd'), 2);
insert into sh_goods values (seq_total_idx.nextval, '총균쇠', 30000, 
    to_date('2025-04-10', 'yyyy-mm-dd'), 2);

insert into sh_goods values (seq_total_idx.nextval, '롱패딩', 200000, 
    to_date('2025-04-09', 'yyyy-mm-dd'), 3);
insert into sh_goods values (seq_total_idx.nextval, '레깅스', 40000, 
    to_date('2025-04-08', 'yyyy-mm-dd'), 3);

insert into sh_goods values (seq_total_idx.nextval, '라면', 10000, 
    to_date('2025-04-07', 'yyyy-mm-dd'), 4);
insert into sh_goods values (seq_total_idx.nextval, '김치', 50000, 
    to_date('2025-04-06', 'yyyy-mm-dd'), 4);

SELECT * FROM sh_goods;

create or replace procedure ShopUpdateGoods (
    g_  name in varchar2,
    price in number,
    code in number,
    idx number,
    returnVal out number
)
is
begin
    update sh_goods
    set 
        goods_name = g_name,
        goods_price = price,
        p_code = code
    where
        g_idx = idx;

    if sql%rowcount > 0 then
        returnVal := 1;
    else
        returnVal := 0;
    
    commit;
    
    end if;
end;
/

create or replace procedure ShopDeleteGoods (
    idx in number,
    returnVal out number
)
is
begin
    delete from sh_goods where g_idx = idx;
    
    if sql%rowcount > 0 then
        returnVal := 1;
    else
        returnVal := 0;

    end if;
end;
/
