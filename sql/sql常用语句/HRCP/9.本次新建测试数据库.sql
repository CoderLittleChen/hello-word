--create  database   Demo
--collate Chinese_PRC_CI_AS

select   name,collation_name  from  sys.databases   where  name='Demo';

--use Demo;
--create   table   Table1
--(
--	Id  int,
--	Name varchar(120),
--	Gender  int,
--	[Address]  varchar(20),
--	Email  varchar(20),
--	Telephone  varchar(20),
--	WorkPlace  varchar(20),
--	DomianAccount  varchar(20),
--	EmployeeCode  varchar(20)
--)

select  *  from  Table1;
