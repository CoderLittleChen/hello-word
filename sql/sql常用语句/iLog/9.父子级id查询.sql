--create  table Area
--(
--	Id int primary key,
--	ParentId  int,
--	Name varchar(100)
--)

--insert   into  Area
--select   1,null,'������'
--union
--select   2,1,'˳����'
--union
--select   3,1,'������'
--union
--select   4,1,'��ƽ��'
--union
--select   5,1,'������'
--union
--select   6,1,'������'
--union
--select   7,1,'ʯ��ɽ��'

select  *   from  Area  a;

--select  *   from  Area  a   where  a.ParentId is null  or   a.ParentId  not  in (select  id  from  Area)
