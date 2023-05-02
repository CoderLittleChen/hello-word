select  *   from  GroupInfo  a;

select  *  from   GroupInfoTemp;

select  *  into  GroupInfoTemp  from  GroupInfo  where  Id>6;   


--将A表的数据插入B表的两种方法

--表名不存在
--select  *  into  GroupInfoTemp  from  GroupInfo  where  Id=1;  

--表名已存在
--insert  into  TargetTable  select   *  from     SourceTable;