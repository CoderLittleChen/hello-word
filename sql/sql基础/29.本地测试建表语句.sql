--Sol_Entry
--create table Sol_Entry
--(
--	EntryId int primary key identity(1,1),
--	EntryName nvarchar(20),
--	Status int
--)

--create table  Sol_EntryRelation
--(
--	RelId  int primary key identity(1,1),
--	EntryId int
--)

--insert   into   Sol_Entry
--select '规格1',0
--union all
--select '规格2',0
--union all
--select '规格3',1

--insert  into  Sol_EntryRelation
--select 1
--union all
--select 2
--union all
--select 3

select  *  from  Sol_Entry;

select  *  from  Sol_EntryRelation  a;

select  *  from  Sol_EntryRelation  a 
inner join  Sol_Entry  b  on  a.EntryId=a.EntryId
where b.Status=1;

--delete  from  Sol_EntryRelation 
--WHERE exists(select  1  from  Sol_Entry  a  where  a.EntryId=Sol_EntryRelation.EntryId  and a.Status=1)