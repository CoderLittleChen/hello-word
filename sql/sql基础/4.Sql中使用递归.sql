-- Create table GroupInfo([Id] int,[GroupName] nvarchar(50),[ParentGroupId] int)

--Insert GroupInfo

--select 0,'ĳĳ��ѧ',null union all

--select 1,'����ѧԺ',0 union all
--select 2,'Ӣ��רҵ',1 union all
--select 3,'����רҵ',1 union all
--select 4,'Ӣ��רҵһ��',2 union all
--select 5,'Ӣ��רҵ����',2 union all
--select 6,'����רҵһ��',3 union all
--select 7,'����רҵ����',3 union all

--select 8, '��ѧԺ',0 union all
--select 9, '�̷�ѧרҵ',8 union all
--select 10,'���÷�ѧרҵ',8 union all
--select 11,'�̷�ѧרҵһ��',9 union all
--select 12,'�̷�ѧרҵ����',9 union all
--select 13,'���÷�ѧרҵһ��',10 union all
--select 14,'���÷�ѧרҵ����',10

select  *   from   GroupInfo  a ;

--����ָ���ڵ�   ���»�ȡ���нڵ�
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


--����ָ���ڵ�  ���ϻ�ȡ���нڵ�
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

