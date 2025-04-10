/*
파일명 : Or15PLSQL2.sql
*/
-- 제어문(조건문) : if, case문과 같은 조건문을 학습한다.

-- 예제7] 제어문(조건문 : if)
/*
시나리오] 변수에 저장된 숫자가 홀수 or 짝수인지 판단하는 PL/SQL을 작성하시오.
*/
declare
-- 변수 선언
    num number;
begin
-- 10을 할당
    num := 10;
    
    if mod(num, 2) = 0 then
        dbms_output.put_line(num || '은 짝수');
    else
        dbms_output.put_line(num || '은 홀수');
    end if;
end;
/

-- 예제8] 제어문(조건문 : if-elsif)
/*
시나리오] 사원번호를 사용자로부터 입력받은 후 해당 사원이 어떤부서에서
근무하는지를 출력하는 PL/SQL문을 작성하시오. 단, if~elsif문을 사용하여
구현하시오.
*/
declare
-- 치환연산자를 통해 변수를 초기화
    emp_id employees.employee_id%type := &emp_id;
-- 일반변수 선언
    emp_name varchar2(50);
-- 참조변수 선언
    emp_dept employees.department_id%type;
-- 필요하다면 선운버에서 변수 선언과 동시에 초기화 할 수 있다.
    dept_name varchar2(30) := '부서정보없음';
begin
-- 치환연산자를 통해 입력받은 사원번호를 쿼리문에 적용
    select employee_id, last_name, department_id
    into emp_id, emp_name, emp_dept
    from employees
    where employee_id = emp_id;

/*
여러 조건을 사용할 경우 Java와 같이 else if를 사용하지 않고 
elsif로 기술해야 한다. 또한 중괄호 대신 then과 end if를 사용한다.
*/
    if emp_dept = 50 then
        dept_name := 'Shipping';
    elsif emp_dept = 60 then
        dept_name := 'IT';
    elsif emp_dept = 70 then
        dept_name := 'Public Relations';
    elsif emp_dept = 80 then
        dept_name := 'Sales';
    elsif emp_dept = 90 then
        dept_name := 'Executive';
    elsif emp_dept = 100 then
        dept_name := 'Finance';
    end if;
    
    dbms_output.put_line('사원번호' || emp_id || '의 정보');
    dbms_output.put_line('이름:' || emp_name ||
                        ', 부서번호:' || emp_dept ||
                        ', 부서명:' || dept_name);
end;
/

--------------------------------------------------------------------------------

/*
case문 : Java의 switch문과 비슷한 조건문
형식]
    case 변수
        when 값1 then '할당값1'
        when 값2 then '할당값2'
        ...  값N
    end;
*/

-- 예제9] 제어문(조건문 : case~when)
/*
시나리오] 앞에서 if~elsif로 작성한 PL/SQL문을 case~when문으로 변경하시오.
*/
declare
    emp_id employees.employee_id%type := &emp_id;
    emp_name varchar2(50);
    emp_dept employees.department_id%type;
    dept_name varchar2(30) := '부서정보없음';
begin
    select employee_id, last_name, department_id
    into emp_id, emp_name, emp_dept
    from employees
    where employee_id = emp_id;    
    
    /*
    case~when문이 if문과 다른점은 할당할 변수를 먼저 선언한 후 문장내에서
    조건을 판단하여 하나의 값을 할당하는 방식이다.
    따라서 변수를 중복해서 기술하지 않아도 된다.
    */
    dept_name :=
        case emp_dept
            when 50 then 'Shipping'
            when 60 then 'IT'
            when 70 then 'Public Relations'
            when 80 then 'Sales'
            when 90 then 'Executive'
            when 100 then 'Finance'
        end;
        
    dbms_output.put_line('사원번호' || emp_id || '의 정보');
    dbms_output.put_line('이름:' || emp_name ||
                        ', 부서번호:' || emp_dept ||
                        ', 부서명:' || dept_name);        
end;
/

--------------------------------------------------------------------------------

/*
반복문1 : Basic loop문
    Java의 do~while문과 같이 조건 체크없이 일단 loop로 진입한 후
    탈출조건이 될때까지 반복한다. 탈출시에는 exit를 사용한다.
*/

-- 예제10] 제어문(반복문 : basic loop)

declare
    num number := 0;
begin
    loop
        dbms_output.put_line(num);
        -- 변수를 1씩 증가시킨 후 10을 초과하면 loop를 탈출
        num := num + 1;
        exit when (num>10);
    end loop;
end;
/

-- 예제11] 제어문(반복문 : basic loop)
/*
시나리오] Basic loop문으로 1부터 10까지의 정수의 합을 구하는 
프로그램을 작성하시오.
*/
declare
    -- 반복을 위한 변수
    i number := 1;
/*
누적합을 저장하기 위한 변수로, Java에서는 보통 sum이라는 변수명을 사용하지만,
Oracle에서는 그룹함수 sum()이 있으므로 변수명으로 사용할 수 없다.
*/
    sumNum number := 0;
begin
    loop
-- 증가하는 변수 i를 누적해서 더한다
        sumNum := sumNum + i;
-- 변수 i를 1씩 증가시킨다.
        i := i + 1;
-- 10을 초과하면 loop를 탈출한다.
        exit when (i>10);
    end loop;
    dbms_output.put_line('1~10까지의합은:' || sumNum);
end;
/

--------------------------------------------------------------------------------

/*
반복문2 : while문
    Basic loop와는 다르게 조건을 먼저 확인한 후 실행한다.
    즉, 조건에 맞지 않는다면 한번도 실행되지 않을 수 있다.
    반복의 조건이 있으므로 특별한 경우가 아니라면 exit를 사용하지
    않아도 된다.
*/

-- 예제12] 제어문(반복문 : while)
DECLARE
    num1 number := 0;
begin
-- while문 진입 전 조건을 먼저 확인
    while num1 < 11 loop
-- 0~10까지 출력
        dbms_output.put_line('이번숫자는:' || num1);
        num1 := num1 + 1;
    end loop;
end;
/

-- 예제13] 제어문(반복문 : while)
/*
시나리오] while loop문으로 다음과 같은 결과를 출력하시오.
*
**
***
****
*****
*/
declare
-- *를 누적해서 연결할 문자형 변수 선언
    starStr varchar2(100);
-- 반복을 위한 변수
    i number := 1;
begin
    while i <= 5 loop
-- 반복문 내에서 *를 문자열에 연결
        starStr := starStr || '*';
        dbms_output.put_line(starStr);
-- i를 1씩 증가
        i := i + 1;
    end loop;
end;
/

-- 예제14] 제어문(반복문 : while)
/*
시나리오] while loop문으로 1부터 10까지의 정수의 합을 구하는 
프로그램을 작성하시오. 
*/
declare
    i number := 1;
    sumNum number := 0;
begin
    while i<=10 loop
        sumNum := sumNum + i;
        i := i + 1;
    end loop;
    dbms_output.put_line('1~10까지의 합은:' || sumNum);
end;
/

--------------------------------------------------------------------------------

/*
반복문3 : for문
    반복의 횟수를 지정하여 사용할 수 있는 반복문으로 반복을 위한 변수를
    별도로 선언하지 않아도 된다. 따라서 특별한 이유가 없다면 선언부(declare)를
    기술하지 않아도 된다.
*/

--예제15] 제어문(반복문 : for)
declare
-- 선언부에 선언한 변수가 없다.
begin
    for num2 in 0 .. 10 loop
        dbms_output.put_line('for문짱인듯:' || num2);
    end loop;
end;
/

/*
변수선언이 필요없다면 declare는 생략할 수 있다.
*/
begin
    for num3 in reverse 0 .. 10 loop
        dbms_output.put_line('거꾸로for문 짱인듯:' || num3);
    end loop;
end;
/

-- 예제16] 제어문(반복문 : for)
/*
퀴즈] for loop문으로 구구단을 출력하는 프로그램을 작성하시오. 
*/

declare
begin
    for i in 2 .. 9 loop
        dbms_output.put_line(i || '단');
        
        for j in 1 .. 9 loop
            dbms_output.put_line(i || ' * ' || j || ' = ' || i*j);
        end loop;   
        
    end loop;
end;
/

declare
    str varchar2(100);
begin
    for i in 2 .. 9 loop
    
        for j in 1 .. 9 loop
            str := str || i || ' * ' || j || ' = ' || i*j || ' ';
        end loop;
        
    dbms_output.put_line(str);
    str := null;
    end loop;
end;
/

--------------------------------------------------------------------------------

/*
커서(Cursor) : select 쿼리에 의해 여러행디 반환되는 경우 각 행에 접근하기 위한
    객체
선언방법]
    Cursor 커서명 Is
        select쿼리문. 단 into절이 없는 형태로 기술한다.
        
    Open 커서명 : 쿼리를 실행하라는 의미. 즉, Open할때 Cursor선언시 select문이
        실행되어 결과셋을 얻게된다. Cursor는 그 결과셋의 첫번째행에
        위치하게 된다.
    Fetch~Into~ : 결과셋에서 하나의 행을 읽어들이는 작업으로 결과셋의 
        인출(Fethc)후에 Cursor는 다음행으로 이동한다.
    Close 커서명 : 커서 닫기로 결과셋의 자원을 반납한다. select문장이 모두
        처리된 후 Cursor를 닫아준다.
    
    Cursor의 속성
        %Found : 가장 최근의 인출(Fetch)이 행을 반환하면 True, 아니면 False 반환
        %NotFound : %Found의 반대의 값을 반환한다.
        %RowCount : 지금까지 반환된 행의 갯수를 반환한다.
*/

-- 예제17] Cursor
/*
시나리오] 부서테이블의 레코드를 Cursor를 통해 출력하는 PL/SQL문을 작성하시오.
*/

declare
-- 부서테이블의 전체컬럼을 참조하는 참조변수 선언
    v_dept departments%rowtype;
/*
커서선언 : 부서테이블의 모든 레코드를 조회하는 select문으로 into절이
    없는 형태로 작성. 쿼리의 실행결과가 cur1에 저장된되.
*/
    cursor cur1 is
        select
            department_id, department_name, location_id
        from departments;
begin
/*
해당 쿼리문을 수행해서 결과셋(ResultSet)을 얻어온다. 결과셋이란 쿼리문을
실행한 후 반환되는 레코드의 결과를 말한다.
*/
    open cur1;
    
/*
결과셋의 갯수는 조건에 따라 다를 수 있으므로 Basic loop를 통해 반복
인출한다.
*/
    loop
-- 한 행씩 인출(Fetch)하여 참조변수에 각각 into(저장)한다.
        fetch cur1 into
            v_dept.department_id,
            v_dept.department_name,
            v_dept.location_id;
        
-- 탈출조건으로 더 이상 인출할 행이 없으면 exit가 실행된다.
        exit when cur1%notfound;
        
-- 모든 인출이 완료되면 갯수를 출력
        dbms_output.put_line(v_dept.department_id || ' ' ||
                            v_dept.department_name || ' ' ||
                            v_dept.location_id);
    end loop;
    
-- 커서를 닫아 자원반납한다.
    close cur1;
-- 총 27개의 행이 출력된다.
end;
/

-- 예제18] Cursor
/*
시나리오] Cursor를 사용하여 사원테이블에서 커미션이 null이 아닌 사원의 
사원번호, 이름, 급여를 출력하시오. 출력시에는 이름의 오름차순으로 정렬하시오.
*/
select * from employees where commission_pct is not null;

declare
-- 선언부에서 쿼리문을 기반으로 커서 생성
    cursor curEmp is
        select employee_id, last_name, salary
        from employees
        where commission_pct is not null
        order by last_name asc;
-- 사원테이블의 전체 컬럼을 참조하는 참조변수 생성
    varEmp employees%rowType;
begin
-- 커서를 오픈해서 쿼리문 실행
    open curEmp;
    
-- Basic 루프문으로 커서에 저장된 결과셋 인출
    loop
-- 인출한 정보를 참조변수에 저장
        fetch curEmp
            into varEmp.employee_id, varEmp.last_name, varEmp.salary;
        exit when curEmp%notFound; -- 인출할 정보가 없으면 루프 탈출
        
        dbms_output.put_line(varEmp.employee_id || ' ' || 
                            varEmp.last_name || ' ' ||
                            varEmp.salary);
    end loop;
    
    close curEmp;
end;
/

--------------------------------------------------------------------------------
