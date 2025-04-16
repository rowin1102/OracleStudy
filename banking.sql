
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

DELETE FROM banking
WHERE account = '1111';

DROP SEQUENCE seq_banking_idx;

create or replace procedure DeleteAccount (
    iaccount in varchar2,
    returnVal out number
)
is
begin
    delete from banking where account = iaccount;
    
    if sql%rowcount > 0 then
        returnVal := 1;
    else
        returnVal := 0;

    end if;    
end;
/
