-- Create table GroupInfo([Id] int,[GroupName] nvarchar(50),[ParentGroupId] int)

--Insert GroupInfo

--select 0,'某某大学',null union all

--select 1,'外语学院',0 union all
--select 2,'英语专业',1 union all
--select 3,'日语专业',1 union all
--select 4,'英语专业一班',2 union all
--select 5,'英语专业二班',2 union all
--select 6,'日语专业一班',3 union all
--select 7,'日语专业二班',3 union all

--select 8, '法学院',0 union all
--select 9, '刑法学专业',8 union all
--select 10,'经济法学专业',8 union all
--select 11,'刑法学专业一班',9 union all
--select 12,'刑法学专业二班',9 union all
--select 13,'经济法学专业一班',10 union all
--select 14,'经济法学专业二班',10

select  *   from   GroupInfo  a ;

--根据指定节点   向下获取所有节点
with
CTE
as
(
    select * from GroupInfo where Id=1
    union all
    select G.* from CTE inner join GroupInfo as G
    on CTE.Id=G.ParentGroupId
)
select * from CTE order by Id;


--根据指定节点  向上获取所有节点
with
CTE
as
(
    select * from GroupInfo where Id=14
	--union all
	--select * from GroupInfo where Id=13
    union all
    select G.* from CTE inner join GroupInfo as G
    on CTE.ParentGroupId=G.Id 
)
select * from CTE  order by Id;

select * from GroupInfo where exists (select  *  from GroupInfo  a  where  a.Id=1);

