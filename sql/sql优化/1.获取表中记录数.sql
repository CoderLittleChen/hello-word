--当需要获取表中的记录数的时候  尽量不要用Count(*)  这样会进行全表扫描  影响速度  
select  COUNT(*)  from  GroupInfo  a;

--如下语句  不执行全表扫描也可以拿到表的记录数    但是一般不会拿到整个表的记录条数，都是分页查询
select  rows   from  sysindexes   where  id=OBJECT_ID('dbo.GroupInfo')  and  indid<2;


