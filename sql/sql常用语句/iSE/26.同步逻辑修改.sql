USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[RelatedTables_AND_DeleteData]    Script Date: 2020-11-03 19:06:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================  
-- Author:  liufeng 
-- Create date: 2016-12-28
-- Description: 同步IPlan决议  
-- =============================================  
Alter PROCEDURE [dbo].[RelatedTables_AND_DeleteDataBackUp]  
  
AS  
BEGIN  

--准备以下六个表
--1.Table [dbo].[Sync_ProductInfo] 
--2.Table [dbo].[Sync_RProject] 
--3.Table [dbo].[RDMDS_ProductInfo_TMP] 
--4.Table [dbo].[RDMDS_ProductLine_TMP]
--5.Table [dbo].[RDMDS_ReleaseInfo_TMP]
--6.Table [dbo].[RDMDS_V_Release_TMP] 

/******1. Object:  Table [dbo].[Sync_ProductInfo]    Script Date: 11/01/2012 09:58:21 ******/
IF not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sync_ProductInfo]') AND type in (N'U'))
Begin
		CREATE TABLE [dbo].[Sync_ProductInfo](
		[ProductInfoID] [uniqueidentifier] NOT NULL,
		[ProductLine_DisplayOrder] [int] NOT NULL,
		[IPMT_CODE] [nvarchar](250) NULL,
		[IPMT_NAME] [nvarchar](250) NULL,
		[ProductLine_Code] [nvarchar](250) NULL,
		[ProductLine_Name] [nvarchar](250) NULL,
		[PDT_Code] [nvarchar](250) NULL,
		[PDT_Name] [nvarchar](250) NULL,
		[Version_Code] [nvarchar](250) NULL,
		[Version_Name] [nvarchar](250) NULL,
		[Release_Code] [nvarchar](250) NOT NULL,
		[Release_Name] [nvarchar](250) NULL,
	 CONSTRAINT [PK_PRODUCTINFO] PRIMARY KEY CLUSTERED 
	(
		[ProductInfoID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'ProductInfoID'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IPMT编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'IPMT_CODE'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IPMT名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'IPMT_NAME'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品线编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'ProductLine_Code'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品线名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'ProductLine_Name'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PDT编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'PDT_Code'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PDT名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'PDT_Name'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'B版本编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'Version_Code'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'B版本名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'Version_Name'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R版本编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'Release_Code'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R版本名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'Release_Name'

	ALTER TABLE [dbo].[ProductInfo] ADD  CONSTRAINT [DF__ProductIn__Produ__6B64E1A4]  DEFAULT (newid()) FOR [ProductInfoID]
End	


/******2. Object:  Table [dbo].[Sync_RProject]    Script Date: 11/01/2012 10:31:06 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sync_RProject]') AND type in (N'U'))
Begin
	CREATE TABLE [dbo].[Sync_RProject](
		[RProjectID] [uniqueidentifier] NOT NULL,
		[ReleaseCode] [nvarchar](50) NULL,
		[ReleaseName] [nvarchar](50) NULL,
		[Status] [nvarchar](50) NULL,
		[IPDProjectTypeID] [uniqueidentifier] NULL,
		[IPDProjectSubTypeID] [uniqueidentifier] NULL,
		[StartPointName] [nvarchar](50) NULL,
		[StartDate] [datetime] NULL,
		[CurrentPoint] [uniqueidentifier] NULL,
		[CurrentPointBVersion] [nvarchar](50) NULL,
		[NextPoint] [uniqueidentifier] NULL,
		[NextPointBVersion] [nvarchar](50) NULL,
		[FinishPointName] [nvarchar](50) NULL,
		[FinishPointBVersion] [nvarchar](50) NULL,
		[BeingPhase] [uniqueidentifier] NULL,
		[ProjectPlanPeriod] [int] NULL,
		[ProjectPeriod] [int] NULL,
		[PlanPeriod] [int] NULL,
		[ActualPeriod] [int] NULL,
		[PlanProgress] [float] NULL,
		[ActualProgress] [float] NULL,
		[AccumulateDeviation] [float] NULL,
		[ProgressDeviation] [float] NULL,
		[FinishRate] [float] NULL,
		[DeliverySummary] [nvarchar](max) NULL,
		[PjPlanPeriod] [int] NULL,
		[PjAcutalPeriod] [int] NULL,
		[PjFinishRate] [float] NULL,
		[CreationDate] [datetime] NULL,
		[Creator] [nvarchar](20) NULL,
		[ModificationDate] [datetime] NULL,
		[Modifier] [nvarchar](20) NULL,
		[DeleteFlag] [int] NULL,
		[SuspendType] [nvarchar](50) NULL,
		[SuspendTime] [datetime] NULL,
		[DocUID] [nvarchar](250) NULL,
	 CONSTRAINT [PK_RPROJECT] PRIMARY KEY CLUSTERED 
	(
		[RProjectID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R版本编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ReleaseCode'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R版本名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ReleaseName'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'Status'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'IPDProjectSubTypeID'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'计划全周期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ProjectPlanPeriod'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实际全周期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ProjectPeriod'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IPD计划周期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'PlanPeriod'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目已开发IPD周期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ActualPeriod'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'计划进度' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'PlanProgress'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'实际进度' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ActualProgress'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'IPD累计偏差' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'AccumulateDeviation'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'进度偏差率（基线）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ProgressDeviation'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'当前IPD完成率' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'FinishRate'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'交付件简述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'DeliverySummary'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目计划周期，包括GA点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'PjPlanPeriod'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目已开发周期，包括GA点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'PjAcutalPeriod'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'CreationDate'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'Creator'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'ModificationDate'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'Modifier'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识：-1——已删除；0——未删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R级项目' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_RProject'
	
End

/****** Object:3.  Table [dbo].[RDMDS_ProductInfo_TMP]    Script Date: 11/01/2012 10:38:36 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RDMDS_ProductInfo_TMP]') AND type in (N'U'))
Begin

	CREATE TABLE [dbo].[RDMDS_ProductInfo_TMP](
		[IPMTCODE_CODE] [nvarchar](250) NULL,
		[IPMTCODE_NAME] [nvarchar](250) NULL,
		[ProductLineCode_Code] [nvarchar](250) NULL,
		[ProductLineCode_Name] [nvarchar](250) NULL,
		[PDTCode_Code] [nvarchar](250) NULL,
		[PDTCode_Name] [nvarchar](250) NULL,
		[VersionCode_Code] [nvarchar](250) NULL,
		[VersionCode_Name] [nvarchar](250) NULL,
		[Release_Code] [nvarchar](250) NULL,
		[Release_Name] [nvarchar](250) NULL,
		[CreationDate] [datetime] NULL,
		[Creator] [nvarchar](20) NULL,
		[ModificationDate] [datetime] NULL,
		[Modifier] [nvarchar](20) NULL,
		[DeleteFlag] [int] NULL
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ProductInfo_TMP', @level2type=N'COLUMN',@level2name=N'CreationDate'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ProductInfo_TMP', @level2type=N'COLUMN',@level2name=N'Creator'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ProductInfo_TMP', @level2type=N'COLUMN',@level2name=N'ModificationDate'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ProductInfo_TMP', @level2type=N'COLUMN',@level2name=N'Modifier'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识：-1——已删除；0——未删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ProductInfo_TMP', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
End

/****** Object:4.  Table [dbo].[RDMDS_ProductLine_TMP]    Script Date: 11/01/2012 10:41:32 ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RDMDS_ProductLine_TMP]') AND type in (N'U'))
Begin
	CREATE TABLE [dbo].[RDMDS_ProductLine_TMP](
		[Name] [nvarchar](250) NULL,
		[Code] [nvarchar](250) NOT NULL,
		[engProductLine] [nvarchar](100) NULL,
		[ProductLineOld] [nvarchar](500) NULL,
		[sStatus] [decimal](19, 0) NULL,
		[IPMTCode] [nvarchar](250) NULL,
		[IPMTCode_Name] [nvarchar](250) NULL,
		[fldcpxzj] [nvarchar](100) NULL,
		[Quality_Director_ID] [nvarchar](100) NULL,
		[PL_CCB_GROUP] [nvarchar](100) NULL,
		[Remark] [nvarchar](100) NULL,
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

/****** Object:5.  Table [dbo].[RDMDS_ReleaseInfo_TMP]    Script Date: 11/01/2012 10:43:16 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RDMDS_ReleaseInfo_TMP]') AND type in (N'U'))
Begin
		
	CREATE TABLE [dbo].[RDMDS_ReleaseInfo_TMP](
		[ReleaseCode] [nvarchar](250) NULL,
		[ReleaseName] [nvarchar](250) NULL,
		[ProjectType] [nvarchar](100) NULL,
		[ProjectStatus] [decimal](19, 0) NULL,
		[CreationDate] [datetime] NULL,
		[Creator] [nvarchar](20) NULL,
		[ModificationDate] [datetime] NULL,
		[Modifier] [nvarchar](20) NULL,
		[DeleteFlag] [int] NULL
	) ON [PRIMARY]

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R版本编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'ReleaseCode'
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R版本名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'ReleaseName'
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目大类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'ProjectType'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'ProjectStatus'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'CreationDate'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'Creator'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'ModificationDate'
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'更新者' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'Modifier'
	
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识：-1——已删除；0——未删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP', @level2type=N'COLUMN',@level2name=N'DeleteFlag'

	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'基础数据_R版本相关信息' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDMDS_ReleaseInfo_TMP'
	
End

/****** Object: 6. Table [dbo].[RDMDS_V_Release_TMP]    Script Date: 11/01/2012 10:47:12 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RDMDS_V_Release_TMP]') AND type in (N'U'))
Begin
	CREATE TABLE [dbo].[RDMDS_V_Release_TMP](
		[VersionName] [nvarchar](50) NOT NULL,
		[VersionNumber] [int] NOT NULL,
		[VersionFlag] [nvarchar](50) NULL,
		[Name] [nvarchar](250) NULL,
		[Code] [nvarchar](250) NOT NULL,
		[engRelease] [nvarchar](100) NULL,
		[ReleaseOld] [nvarchar](500) NULL,
		[sStatus] [decimal](19, 0) NULL,
		[PDTCode] [nvarchar](250) NULL,
		[PDTCode_Name] [nvarchar](250) NULL,
		[VersionCode] [nvarchar](250) NULL,
		[VersionCode_Name] [nvarchar](250) NULL,
		[Remark] [nvarchar](100) NULL,
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

delete from RDMDS_ProductInfo_TMP
delete from Sync_ProductInfo where Release_Code not in ('PR990001','PR990002','PR990003','PR990004','PR990005','PR990006','PR990007','PR990008','PR990009','PR990010',
'PR990011','PR990012','PR990013','PR990014','PR990015','PR990016','PR990017','PR990018','PR990019','PR990020','PR990021','PR990022','PR990023','PR990024','PR990025','PR990026','PR990027','PR990028','PR990029','PR990030'
,'PR990031','PR990032','PR990033','PR990034','PR990035','PR990036','PR990037','PR990038','PR990039','PR990040','PR990041')
or Release_Code not like 'PR9999%'  or BVersionCode not like 'PB99%';
delete from RDMDS_ReleaseInfo_TMP
delete from RDMDS_ProductLine_TMP
delete from RDMDS_V_Release_TMP
 
END  

GO


