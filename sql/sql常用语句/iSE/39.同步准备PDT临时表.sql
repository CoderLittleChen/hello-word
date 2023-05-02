----Sync_RDMDS_V_PDT_TMP---
if not exists (select * from sysobjects where xtype='u' and name='Sync_RDMDS_V_PDT_TMP')
begin
	CREATE TABLE [dbo].[Sync_RDMDS_V_PDT_TMP] (
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RDMDS_V_PDT_TMP]') AND type in (N'U'))
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