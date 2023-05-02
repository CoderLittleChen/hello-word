USE [msdb]
GO

/****** Object:  Job [iSE_SyncDataFromMDS]    Script Date: 2020-11-27 9:54:20 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2020-11-27 9:54:20 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'iSE_SyncDataFromMDS', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'同步源：SQL2008CS1\SQL1  RD_MDS
   View:V_Employee 员工信息
   V_Group 群组信息
   V_GroupEmployeeRelation 员工群组关系
   V_Self_PI_PL_PT_PV_PR 产品R版本树

 同步目标：SQL2008CS1\SQL1 iSEDB
   dbo.Sync_Employee
   dbo.Sync_Group
   dbo.Sync_GroupEmployeeRelation
   dbo.Sync_Self_PI_PL_PT_PV_PR     
', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Prepare Tables]    Script Date: 2020-11-27 9:54:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Prepare Tables', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Create below tables if not exists and truncate data in these tables.
 --  dbo.Sync_Employee
 --  dbo.Sync_Group
 --  dbo.Sync_GroupEmployeeRelation
 --  dbo.Sync_Self_PI_PL_PT_PV_PR
 
----Sync_Employee---
if not exists (select * from sysobjects where xtype=''u'' and name=''Sync_Employee'')
begin
	 CREATE TABLE [dbo].[Sync_Employee] (
	[VersionName] nvarchar(50) NOT NULL,
	[VersionNumber] int NOT NULL,
	[VersionFlag] nvarchar(50),
	[Name] nvarchar(250),
	[Code] nvarchar(250) NOT NULL,
	[DeptCode] nvarchar(250),
	[DeptCode_Name] nvarchar(250),
	[ManpowerType] decimal(19,0),
	[ChnNamePY] nvarchar(100),
	[EngName] nvarchar(100),
	[RegionAccount] nvarchar(100),
	[NotesAccount] nvarchar(100),
	[NotesEmail] nvarchar(100),
	[Email] nvarchar(100),
	[EmployeeRemark] nvarchar(100),
	[EnterDateTime] datetime2(3) NOT NULL,
	[EnterUserName] nvarchar(100),
	[EnterVersionNumber] int,
	[LastChgDateTime] datetime2(3) NOT NULL,
	[LastChgUserName] nvarchar(100),
	[LastChgVersionNumber] int,
	[ValidationStatus] nvarchar(250)
	)
end
go

----Sync_Group---
if not exists (select * from sysobjects where xtype=''u'' and name=''Sync_Group'')
begin
	CREATE TABLE [dbo].[Sync_Group] (
	[VersionName] nvarchar(50) NOT NULL,
	[VersionNumber] int NOT NULL,
	[VersionFlag] nvarchar(50),
	[Name] nvarchar(250),
	[Code] nvarchar(250) NOT NULL,
	[GroupRemark] nvarchar(500),
	[CreateUser] nvarchar(100),
	[CreateDate] datetime2(3),
	[ModifyUser] nvarchar(100),
	[ModifyDate] datetime2(3),
	[GroupDel] decimal(19,0),
	[EnterDateTime] datetime2(3) NOT NULL,
	[EnterUserName] nvarchar(100),
	[EnterVersionNumber] int,
	[LastChgDateTime] datetime2(3) NOT NULL,
	[LastChgUserName] nvarchar(100),
	[LastChgVersionNumber] int,
	[ValidationStatus] nvarchar(250)
	)
end
go

----Sync_GroupEmployeeRelation---
if not exists (select * from sysobjects where xtype=''u'' and name=''Sync_GroupEmployeeRelation'')
begin
	CREATE TABLE [dbo].[Sync_GroupEmployeeRelation] (
	[VersionName] nvarchar(50) NOT NULL,
	[VersionNumber] int NOT NULL,
	[VersionFlag] nvarchar(50),
	[Name] nvarchar(250),
	[Code] nvarchar(250) NOT NULL,
	[GroupCode] nvarchar(100),
	[RegionAccount] nvarchar(100),
	[EnterDateTime] datetime2(3) NOT NULL,
	[EnterUserName] nvarchar(100),
	[EnterVersionNumber] int,
	[LastChgDateTime] datetime2(3) NOT NULL,
	[LastChgUserName] nvarchar(100),
	[LastChgVersionNumber] int,
	[ValidationStatus] nvarchar(250)
	)
end
go

----Sync_Self_PI_PL_PT_PV_PR---
if not exists (select * from sysobjects where xtype=''u'' and name=''Sync_Self_PI_PL_PT_PV_PR'')
begin
	CREATE TABLE [dbo].[Sync_Self_PI_PL_PT_PV_PR] (
	[VersionName] nvarchar(50) NOT NULL,
	[VersionNumber] int NOT NULL,
	[VersionFlag] nvarchar(50) NOT NULL,
	[ROOT] varchar(4) NOT NULL,
	[IPMTCode_Code] nvarchar(250) NOT NULL,
	[IPMTCode_Name] nvarchar(250),
	[ProductLineCode_Code] nvarchar(250),
	[ProductLineCode_Name] nvarchar(250),
	[PDTCode_Code] nvarchar(250),
	[PDTCode_Name] nvarchar(250),
	[VersionCode_Code] nvarchar(250),
	[VersionCode_Name] nvarchar(250),
	[Release_Code] nvarchar(250),
	[Release_Name] nvarchar(250)
	)
end
go

----Sync_Self_Project---
if not exists (select * from sysobjects where xtype=''u'' and name=''Sync_Self_Project'')
begin
	CREATE TABLE [dbo].[Sync_Self_Project](
		[VersionName] [nvarchar](50) NOT NULL,
		[VersionNumber] [int] NOT NULL,
		[VersionFlag] [nvarchar](50) NULL,
		[Name] [nvarchar](250) NULL,
		[Code] [nvarchar](250) NOT NULL,
		[engProject] [nvarchar](100) NULL,
		[ReleaseCode] [nvarchar](250) NULL,
		[ReleaseCode_Name] [nvarchar](250) NULL,
		[ProjectType] [nvarchar](100) NULL,
		[ProjectStatus] [decimal](19, 0) NULL,
		[ProjectJX] [nvarchar](999) NULL,
		[ProjectJFJ] [nvarchar](999) NULL,
		[ProjectDH] [nvarchar](100) NULL,
		[ProjectRemark] [nvarchar](100) NULL,
		[POP_ID] [nvarchar](100) NULL,
		[Product_Mnger] [nvarchar](500) NULL,
		[RNDPDT_ID] [nvarchar](500) NULL,
		[Sales_Mnger] [nvarchar](100) NULL,
		[FINPDT_ID] [nvarchar](100) NULL,
		[Purchase_Mnger] [nvarchar](100) NULL,
		[Manufacture_Mnger] [nvarchar](100) NULL,
		[PPPDT_ID] [nvarchar](100) NULL,
		[TechSupport_Mnger] [nvarchar](100) NULL,
		[Quality_Mnger] [nvarchar](100) NULL,
		[System_Mnger] [nvarchar](100) NULL,
		[softmg] [nvarchar](100) NULL,
		[hardmg] [nvarchar](100) NULL,
		[Documents_Mnger] [nvarchar](100) NULL,
		[Equipment_Mnger] [nvarchar](100) NULL,
		[SQA] [nvarchar](100) NULL,
		[HQA] [nvarchar](100) NULL,
		[TQA] [nvarchar](100) NULL,
		[fldPDE] [nvarchar](100) NULL,
		[CMO_ID] [nvarchar](100) NULL,
		[Testing_Mnger] [nvarchar](100) NULL,
		[HardwareTM] [nvarchar](100) NULL,
		[MarketMnger] [nvarchar](100) NULL,
		[SoftPlatformJKR] [nvarchar](100) NULL,
		[OMC_Mnger] [nvarchar](100) NULL,
		[OMC_SE] [nvarchar](100) NULL,
		[FF_ID] [nvarchar](100) NULL,
		[PilotProduction_Mnger] [nvarchar](100) NULL,
		[CreateUser] [nvarchar](100) NULL,
		[CreateDate] [datetime2](3) NULL,
		[ModifyUser] [nvarchar](100) NULL,
		[ModifyDate] [datetime2](3) NULL,
		[Del] [decimal](19, 0) NULL,
		[EnterDateTime] [datetime2](3) NOT NULL,
		[EnterUserName] [nvarchar](100) NULL,
		[EnterVersionNumber] [int] NULL,
		[LastChgDateTime] [datetime2](3) NOT NULL,
		[LastChgUserName] [nvarchar](100) NULL,
		[LastChgVersionNumber] [int] NULL,
		[ValidationStatus] [nvarchar](250) NULL
	) ON [PRIMARY]
End 
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[RDMDS_V_PDT_TMP]'') AND type in (N''U''))
Begin
	CREATE TABLE [dbo].[RDMDS_V_PDT_TMP](
		[Member_ID] [int] NOT NULL,
		[VersionName] [nvarchar](50) NOT NULL,
		[VersionNumber] [int] NOT NULL,
		[VersionFlag] [nvarchar](50) NULL,
		[Name] [nvarchar](250)  NULL,
		[Code] [nvarchar](250) NOT NULL,
		[ChangeTrackingMask] [int] NOT NULL,
		[engPDT] [nvarchar](100) NULL,
		[PDTOld] [nvarchar](500) NULL,
		[sStatus] [numeric](38,0) NULL,
		[ProductLineCode_Code] [nvarchar](250) NULL,
		[ProductLineCode_Name] [nvarchar](250) NULL,
		[ProductLineCode_ID] [int] NULL,
		[PDT_Manager] [nvarchar](100) NULL,
		[CMJKR_ID] [nvarchar](100) NULL,
		[SCJKR_ID] [nvarchar](100) NULL,
		[HCJKR_ID] [nvarchar](100) NULL,
		[AbroadJKR_ID] [nvarchar](100)  NULL,
		[IPJKR_ID] [nvarchar](100)  NULL,
		[OrderDecom] [nvarchar](100) NULL,
		[Quality_Mnger_ID] [nvarchar](100) NULL,
		[PDT_Group] [nvarchar](100)  NULL,
		[PND_Group] [nvarchar](100) NULL,
		[Remark] [nvarchar](100) NULL,
		[CreateUser] [nvarchar](100) NULL,
		[CreateDate] [datetime2](3) NULL,
		[ModifyUser] [nvarchar](100) NULL,
		[ModifyDate] [datetime2](3) NULL,
		[Del] [numeric](36,2) NULL,
		[EnterDateTime] [datetime2](3) NOT NULL,
		[EnterUserName] [nvarchar](100) NULL,
		[EnterVersionNumber] [int] NULL,
		[LastChgDateTime] [datetime2](3)NOT NULL,
		[LastChgUserName] [nvarchar](100) NULL,
		[LastChgVersionNumber] [int] NULL,
		[ValidationStatus] [nvarchar](250) NULL

	) ON [PRIMARY]

End
go', 
		@database_name=N'iSEDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Sync Data from MDS]    Script Date: 2020-11-27 9:54:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Sync Data from MDS', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec [dbo].[Sync_DataFromMDS]  ', 
		@database_name=N'iSEDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Sync_ProjectManager]    Script Date: 2020-11-27 9:54:21 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Sync_ProjectManager', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec [dbo].[SyncProjManager]', 
		@database_name=N'iSEDB', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SyncDatafromMDS', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170110, 
		@active_end_date=99991231, 
		@active_start_time=3500, 
		@active_end_time=235959, 
		@schedule_uid=N'91d37638-3d79-4e83-85f4-fa191581da1f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


