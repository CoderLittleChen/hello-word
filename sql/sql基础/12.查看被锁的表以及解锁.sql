
--查看被锁的表
select request_session_id spid,OBJECT_NAME(resource_associated_entity_id) tableName 
from sys.dm_tran_locks where resource_type='OBJECT';

--解锁
declare @spid int 
Set @spid = 98 --锁表进程
declare @sql varchar(1000)
set @sql='kill '+cast(@spid as varchar)
exec(@sql);


--查询正在执行的事务
select * from sys.dm_tran_session_transactions;

KILL 117 WITH STATUSONLY;