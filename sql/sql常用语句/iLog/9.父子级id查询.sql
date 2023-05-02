--create  table Area
--(
--	Id int primary key,
--	ParentId  int,
--	Name varchar(100)
--)

--insert   into  Area
--select   1,null,'北京市'
--union
--select   2,1,'顺义区'
--union
--select   3,1,'朝阳区'
--union
--select   4,1,'昌平区'
--union
--select   5,1,'海淀区'
--union
--select   6,1,'大兴区'
--union
--select   7,1,'石景山区'

select  *   from  Area  a;

--select  *   from  Area  a   where  a.ParentId is null  or   a.ParentId  not  in (select  id  from  Area)
