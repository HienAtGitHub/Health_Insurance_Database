/* -------------------------------------------------------------------*/
/* ----------------------------Hien Dang -----------------------------*/
/* This part is to create all tables of the Health Insurance Database */
/* -------------------------------------------------------------------*/

drop table person cascade constraints purge;
drop table physician cascade constraints purge;
drop table visit cascade constraints purge;
drop table claim cascade constraints purge;
drop table employer cascade constraints purge;
drop table insurer cascade constraints purge;
drop table hospital cascade constraints purge;
drop table emp_insurer cascade constraints purge;
drop table phy_insurer cascade constraints purge;
drop table affiliation cascade constraints purge;


create table person
  (ssn  char(9) primary key,
   name varchar2(100) not null,
   phone varchar2(100),
   address varchar2(100),
   employer varchar2(100) not null,
   insurer varchar2(100) not null,
   pcp char(6) not null
   );

create table physician
  (pid char(6) primary key,
   name varchar2(100) not null,
   specialty varchar2(100) not null,
   address varchar2(100),
   phone varchar2(100)
   );

create table visit
  (ssn char(9) not null,
   pid char(6) not null,
   v_date date not null,
   diagnosis varchar2(100) not null,
   pcp_or_not char(1) not null,
   primary key (ssn, pid, v_date)
   );

create table claim
  (cid char(6) primary key,
   amount decimal(10,2),
   file_date date not null,
   paid_date date not null,
   ssn char(9) not null,
   pid char(6) not null,
   v_date date not null,
   insurer varchar2(100) not null
   );

create table employer
  (name varchar2(100) primary key,
   address varchar2(100) not null,
   phone varchar2(100) not null
   );

create table insurer
  (name varchar2(100) primary key,
   address varchar2(100) not null,
   phone varchar2(100) not null
   );

create table hospital
  (name varchar2(100) primary key,
   address varchar2(100) not null,
   phone varchar2(100) not null
   );

create table emp_insurer
  (emp_name varchar2(100) not null,
   ins_name varchar2(100) not null,
   primary key (emp_name, ins_name),
   constraint fk_emp_name foreign key (emp_name) references employer(name) on delete cascade,
    constraint fk_insurer_name  foreign key (ins_name) references insurer(name) on delete cascade
    );

create table phy_insurer
  (pid char(6) not null,
   ins_name varchar2(100) not null,
   primary key (pid, ins_name),
   constraint fk_p_id foreign key (pid) references physician(pid) on delete cascade,
   constraint fk_ins_name foreign key (ins_name) references insurer(name) on delete cascade
  );

create table affiliation
  (pid char(6) not null,
   hospital_name varchar2(100) not null,
   primary key (pid, hospital_name),
   constraint fk_pid_phy foreign key (pid) references physician(pid) on delete cascade,
   constraint fk_hos_name foreign key (hospital_name) references hospital(name) on delete cascade
 );

alter table person add constraint fk_emp foreign key (employer) references employer(name) on delete cascade;
alter table person add constraint fk_ins foreign key (insurer) references insurer(name)on delete cascade;
alter table person add constraint fk_pcp foreign key (pcp) references physician(pid)on delete cascade;

alter table visit add constraint fk_ssn foreign key (ssn) references person(ssn) on delete cascade;
alter table visit add constraint fk_pid foreign key (pid) references physician(pid) on delete cascade;

alter table claim add constraint fk_ssn_pid_v_date foreign key (ssn, pid, v_date) references visit(ssn, pid, v_date) on delete cascade;
alter table claim add constraint fk_insurer foreign key (insurer) references insurer(name) on delete cascade;


/* -------------------------------------------------------------------------------*/
/* This part is to populate tuples in all tables of the Health Insurance Database */
/* -------------------------------------------------------------------------------*/

delete from person;
delete from physician;
delete from visit;
delete from claim;
delete from employer;
delete from insurer;
delete from hospital;
delete from emp_insurer;
delete from phy_insurer;
delete from affiliation;

insert into employer values ('Casper Inc', '55425 Continental Road', '916-864-3398');
insert into employer values ('Dickinson Group', '726 Sachtjen Point', '881-152-1114');
insert into employer values ('Kirlin Ltd', '3 Acker Drive', '916-359-3394');
insert into employer values ('DuBuque Corporation', '40 Summit Trail', '338-213-0900');
insert into employer values ('Kohler Inc', '29 Maple Wood Pass', '430-404-8359');

insert into insurer values ('Aetna Group', '151 Farmington Avenue', '877-480-4161');
insert into insurer values ('Cigna Health Group', '900 Cottage Grove Road', '1-800-433-5768' );
insert into insurer values ('Metropolitan Group', '500 Atlantic Ave # 17E','617-946-3300');

insert into hospital values ('St. Elizabeths Medical Center', '736 Cambridge St', '617-789-3000');
insert into hospital values ('Lemuel Shattuck Hospital', '170 Morton St', '617-522-8110');
insert into hospital values ('Boston Medical Center', 'One Boston Medical Center Pl', '617-638-6800');
insert into hospital values ('Massachusetts General Hospital', '55 Fruit St', '617-726-2000');
insert into hospital values ('Brigham and Womens Hospital', '45 Francis St', '617-732-5500');


insert into emp_insurer values ('Casper Inc', 'Cigna Health Group');
insert into emp_insurer values ('Dickinson Group', 'Aetna Group');
insert into emp_insurer values ('Kirlin Ltd','Aetna Group');
insert into emp_insurer values ('DuBuque Corporation', 'Cigna Health Group');
insert into emp_insurer values ('Kohler Inc', 'Metropolitan Group');
insert into emp_insurer values ('Kirlin Ltd','Metropolitan Group');

insert into physician values ('548482', 'Reggis Dollard', 'Abdominal Radiology', '785 Orin Place', '499-630-1907');
insert into physician values ('139397', 'Spence Brigge', 'Addiction Psychiatry', '83689 Harper Street', '726-170-4876');
insert into physician values ('489863', 'De Dashwood', 'Dermatology', '377 Fairview Pass', '142-685-7214');
insert into physician values ('360794', 'Douglass Davenhall', 'Psychiatry', '561 Fordem Park', '310-729-9968');
insert into physician values ('775297', 'Iolande Hanshawe', 'Pediatrics', '64758 Sachtjen Drive', '791-355-9672');
insert into physician values ('528236', 'Leilah Lyddon', 'Family Practice', '97234 Esch Circle', '493-599-2334');
insert into physician values ('218021', 'Claiborn Durtnel', 'Emergency Medicine', '39900 West Point', '607-324-2756');
insert into physician values ('939138', 'Welbie Loveridge', 'Optometrists', '48 Prairieview Crossing', '512-459-5401');
insert into physician values ('325607', 'Frederigo Soda', 'Gynecologic Oncology', '94702 Anniversary Park', '570-881-2369');
insert into physician values ('714492', 'Marv Wettern', 'Orthopedic Surgery', '2593 Lindbergh Terrace', '473-781-1755');

insert into person values ('866126374', 'Ekaterina Matton', '466-925-9629', '86 Darwin Road', 'Dickinson Group', 'Aetna Group', '548482');
insert into person values ('496709409', 'Giffy Tomasutti', '483-573-8451', '592 Moland Way', 'Dickinson Group', 'Aetna Group', '139397');
insert into person values ('570603884', 'Dorita Grishanin', '344-704-3994', '90542 Rockefeller Center', 'DuBuque Corporation', 'Cigna Health Group', '489863');
insert into person values ('313791714', 'Brod Hiorn', '835-352-4548', '292 Dayton Lane', 'Kohler Inc', 'Metropolitan Group', '489863');
insert into person values ('262382678', 'Roger Robbey', '876-334-6573', '3795 Riverside Court', 'Kohler Inc', 'Metropolitan Group', '775297');
insert into person values ('649988039', 'Jerry Grunwald', '838-851-3239', '82 Maryland Point', 'Kirlin Ltd','Aetna Group', '528236');
insert into person values ('350963232', 'Amie Hundley', '977-745-4321', '85 Village Green Parkway', 'Dickinson Group', 'Aetna Group', '939138');
insert into person values ('824663447', 'Dalia Ellsbury', '749-258-9171', '5423 Cardinal Parkway', 'Kirlin Ltd','Aetna Group', '218021');
insert into person values ('749312622', 'Ardith Blann', '671-670-4039', '03 Northland Drive', 'Casper Inc', 'Cigna Health Group', '325607');
insert into person values ('366025429', 'Eudora Harold', '598-690-9984', '04 Weeping Birch Circle', 'Kohler Inc', 'Metropolitan Group', '714492');
insert into person values ('281530797', 'John Smith', '354-316-7539', '39 Green Lane', 'Casper Inc', 'Cigna Health Group', '325607');


insert into visit values ('866126374', '548482', '27-jan-2018', 'Normal-pressure', 'Y');
insert into visit values ('866126374', '939138', '27-jan-2018', 'Nearsighted', 'N');
insert into visit values ('366025429', '714492', '12-jul-2018', 'Healthy', 'Y');
insert into visit values ('350963232', '528236', '10-jul-2018', 'High Blood Pressure', 'N');
insert into visit values ('570603884', '489863', '11-mar-2018', 'Rosacea', 'Y');
insert into visit values ('749312622', '489863', '03-jan-2018', 'Nuts Allergy', 'N');
insert into visit values ('262382678', '775297', '25-feb-2018', 'Healthy', 'Y');
insert into visit values ('649988039', '528236', '11-jul-2018', 'Healthy', 'Y');
insert into visit values ('496709409', '218021', '27-may-2018', 'Diabetes', 'N');
insert into visit values ('313791714', '489863', '06-apr-2018', 'High Blood Sugar', 'Y');
insert into visit values ('313791714', '775297', '08-jun-2018', 'Asthma', 'N');

insert into claim values ('337251', '1603.38', '29-jan-2018', '02-feb-2018', '866126374', '548482', '27-jan-2018', 'Aetna Group');
insert into claim values ('988696', '1075.19', '30-jan-2018', '05-feb-2018', '866126374', '939138', '27-jan-2018', 'Aetna Group');
insert into claim values ('186073', '1963.20', '16-jul-2018', '20-jul-2018', '366025429', '714492', '12-jul-2018', 'Metropolitan Group');
insert into claim values ('532148', '730.36', '13-jul-2018', '19-jul-2018', '350963232', '528236', '10-jul-2018', 'Aetna Group');
insert into claim values ('140940', '1536.23', '11-mar-2018', '13-mar-2018', '570603884', '489863', '11-mar-2018', 'Cigna Health Group');
insert into claim values ('279146', '1320.91', '03-jan-2018', '04-jan-2018', '749312622', '489863', '03-jan-2018', 'Cigna Health Group');
insert into claim values ('319899', '194.54', '25-feb-2018', '27-feb-2018', '262382678', '775297', '25-feb-2018', 'Metropolitan Group');
insert into claim values ('270069', '279.61', '16-jul-2018', '23-jul-2018', '649988039', '528236', '11-jul-2018', 'Aetna Group');
insert into claim values ('547809', '1749.15', '29-may-2018', '03-jun-2018', '496709409', '218021', '27-may-2018', 'Aetna Group');
insert into claim values ('116126', '1045.74', '08-apr-2018', '10-apr-2018', '313791714', '489863', '06-apr-2018', 'Cigna Health Group');
insert into claim values ('606788', '861.25', '11-jun-2018', '15-jun-2018', '313791714', '775297', '08-jun-2018', 'Metropolitan Group');

insert into phy_insurer values ('548482', 'Aetna Group');
insert into phy_insurer values ('139397', 'Aetna Group');
insert into phy_insurer values ('489863', 'Cigna Health Group');
insert into phy_insurer values ('360794', 'Cigna Health Group');
insert into phy_insurer values ('775297', 'Metropolitan Group');
insert into phy_insurer values ('528236', 'Aetna Group');
insert into phy_insurer values ('218021', 'Aetna Group');
insert into phy_insurer values ('939138', 'Aetna Group');
insert into phy_insurer values ('325607', 'Cigna Health Group');
insert into phy_insurer values ('714492', 'Metropolitan Group');
insert into phy_insurer values ('528236', 'Cigna Health Group');

insert into affiliation values ('548482', 'St. Elizabeths Medical Center');
insert into affiliation values ('139397', 'St. Elizabeths Medical Center');
insert into affiliation values ('489863', 'Lemuel Shattuck Hospital');
insert into affiliation values ('360794', 'Lemuel Shattuck Hospital');
insert into affiliation values ('775297', 'Boston Medical Center');
insert into affiliation values ('528236', 'Boston Medical Center');
insert into affiliation values ('218021', 'Massachusetts General Hospital');
insert into affiliation values ('939138', 'Massachusetts General Hospital');
insert into affiliation values ('325607', 'Brigham and Womens Hospital');
insert into affiliation values ('714492', 'Brigham and Womens Hospital');

/* -------------------------------------------------------------------------------*/
/* ------This part includes four SQL queries in the Health Insurance Database ----*/
/* -------------------------------------------------------------------------------*/

/* Show the list of all insurance companies with which physician Leilah Lyddon has a contract.*/
select i.*
from insurer i , phy_insurer phyi, physician p
where i.name = phyi.ins_name and phyi.pid = p.pid and p.name = 'Leilah Lyddon';

/* Show the list of all visits by Ekaterina Matton between
 1/1/2018 and 3/31/2018. For each visit, display the date, doctor’s name, PCP
 or not, and diagnosis */
select v.v_date, phy.name, v.pcp_or_not, v.diagnosis
from person p, physician phy, visit v
where p.ssn = v.ssn and v.pid = phy.pid and p.name = 'Ekaterina Matton'
and v.v_date between '01-jan-2018' and '31-mar-2018';

/* Show the list of all insurance companies which have contract with Dalia Ellsbury's employer */
select i.*
from insurer i, emp_insurer ei, person p
where i.name = ei.ins_name and ei.emp_name = p.employer
and p.name = 'Dalia Ellsbury';

/* Among the claims filed by doctor Leilah Lyddon, show the
list of those that were not paid yet. Here, we assume that all claims are filed
by physicians. */
select c.cid, c.amount, c.file_date, c.paid_date
from claim c, visit v, physician phy
where c.ssn = v.ssn and c.pid = v.pid and c.v_date = v.v_date
and v.pid = phy.pid and phy.name = 'Leilah Lyddon'
and c.paid_date > CURRENT_DATE;
