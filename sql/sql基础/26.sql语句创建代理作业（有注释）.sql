use master
go
--���崴����ҵ
DECLARE @jobid uniqueidentifier, @jobname sysname
SET @jobname = N'testInterval'

IF EXISTS(SELECT * FROM msdb.dbo.sysjobs WHERE name=@jobname)
EXEC msdb.dbo.sp_delete_job @job_name=@jobname

EXEC msdb.dbo.sp_add_job
@job_name = @jobname,
@job_id = @jobid OUTPUT

--������ҵ����
DECLARE @sql nvarchar(4000),@dbname sysname
SELECT @dbname=DB_NAME(),  --��ҵ�����ڵ�ǰ���ݿ���ִ��
@sql=N'--��ҵ��������'  --һ�㶨�����ʹ��TSQL�������ҵ,���ﶨ��Ҫִ�е�Transact-SQL���
EXEC msdb.dbo.sp_add_jobstep
@job_id = @jobid,
@step_name = N'����һ',
@subsystem = 'TSQL', --���������,һ��ΪTSQL
@database_name=@dbname,
@command = @sql

--��������(ʹ�ú���ר�Ŷ���ļ�����ҵ����ģ��)
EXEC msdb..sp_add_jobschedule
@job_id = @jobid,
@name = N'��һ������',
@freq_type=8,                --ִ�е�Ƶ�� ��
@freq_interval=4,            --�����ڶ�ִ��
@freq_subday_type=0x8,       --�ظ���ʽ,0x1=��ָ����ʱ��,0x4=���ٷ���,0x8=����Сʱִ��һ�Ρ�0x1��@active_start_timeһ��ʹ�ã�@active_start_timeָ����ʼִ�е�ʱ�䣬������@freq_typeָ����Ƶ�ʼ����ִֻ��һ��
                             --����0x4��0x8��ֻҪָ��@freq_subday_interval�� @freq_subday_interval����ÿ���ٷ��ӣ���@freq_subday_type=0x4����Сʱ����@freq_subday_type=0x8��ִ�еĴ���
@freq_subday_interval=2,     --�ظ�������,����ÿСʱִ��һ��
@active_start_date = NULL,   --��ҵִ�еĿ�ʼ����,ΪNULLʱ��ʾ��ǰ����,��ʽΪYYYYMMDD
@active_end_date = 99991231, --��ҵִ�е�ֹͣ����,Ĭ��Ϊ99991231,��ʽΪYYYYMMDD
@active_start_time = 020000,  --��ҵִ�еĿ�ʼʱ��,��ʽΪHHMMSS
@active_end_time = 030000,    --��ҵִ�е�ֹͣʱ��,��ʽΪHHMMSS
@freq_recurrence_factor = 2   --ִ�м�� ����

--�ο�
--http://www.cnblogs.com/lijun198504/articles/1352558.html
--http://msdn.microsoft.com/zh-cn/library/ms366342.aspx

-- ���Ŀ�������
EXEC msdb.dbo.sp_add_jobserver 
@job_id = @jobid,
@server_name = N'(local)'