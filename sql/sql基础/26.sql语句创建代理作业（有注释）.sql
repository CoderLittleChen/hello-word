use master
go
--定义创建作业
DECLARE @jobid uniqueidentifier, @jobname sysname
SET @jobname = N'testInterval'

IF EXISTS(SELECT * FROM msdb.dbo.sysjobs WHERE name=@jobname)
EXEC msdb.dbo.sp_delete_job @job_name=@jobname

EXEC msdb.dbo.sp_add_job
@job_name = @jobname,
@job_id = @jobid OUTPUT

--定义作业步骤
DECLARE @sql nvarchar(4000),@dbname sysname
SELECT @dbname=DB_NAME(),  --作业步骤在当前数据库中执行
@sql=N'--作业步骤内容'  --一般定义的是使用TSQL处理的作业,这里定义要执行的Transact-SQL语句
EXEC msdb.dbo.sp_add_jobstep
@job_id = @jobid,
@step_name = N'步骤一',
@subsystem = 'TSQL', --步骤的类型,一般为TSQL
@database_name=@dbname,
@command = @sql

--创建调度(使用后面专门定义的几种作业调度模板)
EXEC msdb..sp_add_jobschedule
@job_id = @jobid,
@name = N'第一个调度',
@freq_type=8,                --执行的频率 周
@freq_interval=4,            --在星期二执行
@freq_subday_type=0x8,       --重复方式,0x1=在指定的时间,0x4=多少分钟,0x8=多少小时执行一次。0x1和@active_start_time一起使用，@active_start_time指定开始执行的时间，代表在@freq_type指定的频率间隔内只执行一次
                             --若是0x4或0x8，只要指定@freq_subday_interval， @freq_subday_interval代表每多少分钟（当@freq_subday_type=0x4）或小时（当@freq_subday_type=0x8）执行的次数
@freq_subday_interval=2,     --重复周期数,这里每小时执行一次
@active_start_date = NULL,   --作业执行的开始日期,为NULL时表示当前日期,格式为YYYYMMDD
@active_end_date = 99991231, --作业执行的停止日期,默认为99991231,格式为YYYYMMDD
@active_start_time = 020000,  --作业执行的开始时间,格式为HHMMSS
@active_end_time = 030000,    --作业执行的停止时间,格式为HHMMSS
@freq_recurrence_factor = 2   --执行间隔 两周

--参考
--http://www.cnblogs.com/lijun198504/articles/1352558.html
--http://msdn.microsoft.com/zh-cn/library/ms366342.aspx

-- 添加目标服务器
EXEC msdb.dbo.sp_add_jobserver 
@job_id = @jobid,
@server_name = N'(local)'