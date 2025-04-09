-- Java에서 JDBC 연동하기 -> education 계정

-- member 테이블 생성
create table member (
    /* 
    아이디, 비번, 이름은 문자타입으로 정의. not null로 빈값을
    허용하지 않는 컬럼으로 정의
    */
    id varchar2(30) not null,
    pass varchar2(40) not null,
    name varchar2(50) not null,
    /*
    날짜타입으로 선언. null을 허용하는 컬럼으로 정의.
    입력값이 없는 경우 현재시각을 디폴트로 입력한다.
    */
    regidate date default sysdate,
    primary key (id) -- 아웃라인 방식으로 아이디 컬럼을 PK로 지정
);
-- 테이블에 더미데이터(테스트용 데이터) 추가
insert into member (id, pass, name) values ('test', '1234', '테스트');

SELECT * FROM member;
commit;
/*
더미데이터 입력 후 commit을 실행하지 않으면 오라클 외부 프로그램에서는
새롭게 입력한 데이터를 확인할 수 없다. 입력된 레코드를 실제 테이블에
적용하기 위해 반드시 commit을 실행해야 한다.
Java와 같은 외부 프로그램을 통해 입력하는 데이터는 자동으로 commoit이 되므로
별도의 처리를 하지 않아도 된다.
*/

-- 레코드 수정하기
SELECT * FROM member;
update member set pass='99xx', name='나수정'
where id='test1';

-- 더미데이터 입력
insert into member (id, pass, name) values ('commit1', '1111', '커밋');
-- 커밋을 실행하지 않으면 Java에서 JDBC작업을 할 수 없다.
commit;

-- 레코드 삭제
delete from member where id='test';
commit;

-- 레코드 검색
SELECT * FROM member where name like '%길%';

--------------------------------------------------------------------------------

-- 게시판 테이블 생성
CREATE TABLE board
(
    num number primary key, -- 일련번호(PK지정)
    title varchar2(200) not null, -- 제목
    content varchar2(2000) not null, -- 내용
    id varchar2(30) not null, -- 회원제이므로 회원아이디
    postdate date default sysdate not null, -- 게시물 작성일
    visitcount number default 0 not null -- 게시물 조회수
);

-- 외래키 설정
/*
외래키명 : board_mem_fk
board 테이블의 id 컬럼이 member 테이블의 id 컬럼을 참조하도록 외래키를 생성
*/
alter table board -- 외래키는 자식테입르에서 설정함
    add constraint board_mem_fk foreign key (id) -- 제약명 지정
        references member (id); -- 부모테이블에 참조할 컬럼

-- 자식테이블인 board에 더미데이터 추가
/*
아이디 aaaa는 부모테이블인 member에 존재하지 않으므로 insert문 실행시
에러가 발생한다.
*/
insert into board (num, title, cnotent, id, postdate, visitcount)
    values (1, '제목', '내용', 'aaaa', sysdate, 0);

/*
2. 시퀀스명 : seq_board_num
board 테이블에 데이터를 입력시 num 컬럼이 자동증가 할 수 있도록 시퀀스를 생성
*/
create sequence  seq_board_num
-- 증가치, 시작값, 최소값을 모두 1로 지정
    increment by 1
    start with 1
    minvalue 1
-- 최대값, 사이클, 캐시메모리 사용을 모두 No로 지정
    nomaxvalue
    nocycle
    nocache;

/*
2개의 테이블이 참조관계에 있다면 데이터 입력시 부모테이블부터 입력해야 한다.
만약 자식 테이블에 먼저 입력하면 '부모키가 없다'는 에러가 발생한다.
*/
insert into member (id, pass, name) values ('kosmo', '1234', '코스모');
insert into member (id, pass, name) values ('musthave', '1234', '머스트해브');
-- 자식테이블인 board에 레코드 입력
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목1', '내용1', 'kosmo', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '제목2', '내용2', 'musthave', sysdate, 0);

-- 레코드 확인하기
SELECT * FROM member;
SELECT * FROM board;

-- 커밋
commit;

















