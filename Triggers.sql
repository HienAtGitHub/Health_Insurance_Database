/* ----------------------------------------------------------------------------------------*/
/* -----------------------------------------Hien Dang -------------------------------------*/
/* This part is to pratice implemeting triggers functions in the Health Insurance Database */
/* ----------------------------------------------------------------------------------------*/


/*------------------------------First Trigger---------------------------------*/
/* This trigger is used to track deleted records from PERSON table */
/*----------------------------------------------------------------------------*/
insert into person values ('281530797', 'John Smith', '354-316-7539', '39 Green Lane', 'Casper Inc', 'Cigna Health Group', '325607');

create table PERSON_DEL_LOG
  (ssn char(9),
   name varchar2(100),
   delete_time timestamp,
   delete_user varchar2(100)
 );

create or replace trigger person_after_delete
after delete on person
for each row
begin
  insert into PERSON_DEL_LOG
  values (:old.ssn, :old.name, SYSTIMESTAMP, USER);
end;

/* Test */
delete from person
  where name = 'John Smith';

select * from person_del_log;

/* --------------------------Second Trigger-----------------------------------*/
/* When inserting a tuple into the PERSON table, */
/* the PCP must be a physician who has a contract with the insurance company */
/* that has a contract with the employer of the person. */
/* If not, issue an error message and do not perform the insert. */
/*----------------------------------------------------------------------------*/
create or replace trigger persons_pcp_rule
  before insert on person
  for each row
  declare
    num_pcp_contract natural;
  begin
    select count(*) into num_pcp_contract
    from person p, emp_insurer e, phy_insurer phy
    where e.emp_name = :new.employer and e.ins_name = :new.insurer
    and phy.pid = :new.pcp and e.ins_name = phy.ins_name;
    if num_pcp_contract <= 0
      then
      raise_application_error(-20001,('The PCP of this employee must have a contract with the insurance company that has a contract with his/her company'));
    end if;
  end;

/* Test 1: Inserted successfully - physician '528236' has contract with Aetna Group which has a contract with Kirlin Ltd*/
insert into person values ('369034090', 'Daniel Berry', '129-827-4928', '4835 2nd Place', 'Kirlin Ltd','Aetna Group', '528236');

/* Test 2 - throwing an error - physician '528236' has contract with Aetna Group which doesnt have a contract with Kohler Inc */
insert into person values ('773165355', 'Kevin Jones', '621-199-8245', '13 Sauthoff Circle', 'Kohler Inc', 'Aetna Group', '528236');


/*--------------------------Third Trigger-------------------------------------*/
/* When updating the “Paid_date” column of the CLAIM table, */
/* make sure that the paid date is later than the filed date. */
/* If an update would violate this constraint, */
/* block the execution of the update statement and issue an error message.*/
/*----------------------------------------------------------------------------*/
create or replace trigger paid_date_rule
  before
  update of paid_date
    on claim
  for each row
  begin
    if :new.paid_date < :old.file_date then
      raise_application_error(-20001, ('Paid Date cannot be before Filed Date'));
    end if;
  end;

/* Test 1 - throwing error - file_date is '11-jun-2018'*/
update claim
  set paid_date = '05-may-2018'
  where cid = '606788';

/* Test 2 - updated successfully - file_date is '11-jun-2018' */
update claim
  set paid_date = '05-july-2018'
  where cid = '606788';

/*-------------------------------Fourth Trigger-------------------------------*/
/* This constraint is about a limit on the number of visits */
/* a patient can make to his/her PCP. The constraint is: The interval between */
/* two consecutive visits to a patient’s PCP should be greater than 30 days. */
/* For example, if I visited my PCP on January 1st, 2013, */
/* I am not allowed to visit him until February 1st or later. */
/* This constraint must be enforced when a new tuple is inserted into the VISIT table. */
/* If an insert would violate this constraint, */
/* block the execution of the insert statement and issue an error message.*/
/*----------------------------------------------------------------------------*/
create or replace trigger pcp_visit_rule
  before insert on visit
  for each row
  declare
  num_visits natural;
  begin
    select count(*) into num_visits
    from visit
    where ssn = :new.ssn and pid = :new.pid and :new.pcp_or_not = 'Y' and (:new.v_date - v_date) <= 30;
    if num_visits > 0 then
      raise_application_error(-20001, ('Employee' || :new.ssn || 'cannot visit the his/her pcp within 30 days'));
    end if;
  end;

/* Test 1 - inserted successfully - 1st v_date was 25-feb-2018*/
insert into visit values ('262382678', '775297', '25-apr-2018', 'Healthy', 'Y');

/* Test 2 - throwing error - 1st v_date was 25-feb-2018 */
insert into visit values ('262382678', '775297', '10-mar-2018', 'Healthy', 'Y');
