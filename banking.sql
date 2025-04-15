
create table banking (
    a_code number primary key,
    account varchar2(50) not null,
    name varchar2(50) not null,
    money number not null,
    interest number not null
);

create sequence seq_banking_idx
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;

commit;


SELECT * FROM banking;







