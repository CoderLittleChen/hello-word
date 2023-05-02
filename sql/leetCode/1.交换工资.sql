--use demo;
--create table  salary
--(
--	id  tinyint  primary key  identity(1,1),
--	name  nvarchar(10),
--	sex nvarchar(10),
--	salary int
--)

--insert  into  salary
--select 'A','m',2500
--union all
--select 'B','f',1500
--union all
--select 'C','m',5500
--union all
--select 'D','f',500

--truncate  table  salary;
select  *  from  salary  a;

--update  salary  set  sex=(case  sex  when  'm'  then 'f'  when 'f'  then 'm' end)

select *   from   salary 
where  id%2>0;