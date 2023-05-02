
/****** Object:  Table [dbo].[T_Dat_EmployeeContact]    Script Date: 2019-7-19 9:02:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[T_Dat_EmployeeContact_Tel](
	[DomainAccount] [nvarchar](150) NULL,
	[ChineseName] [nvarchar](150) NULL,
	[PingYing] [nvarchar](150) NULL,
	[EnglishName] [nvarchar](150) NULL,
	[OfficeAddress] [nvarchar](150) NULL,
	[RoomNo] [nvarchar](150) NULL,
	[Telephone] [nvarchar](150) NULL,
	[Extension] [nvarchar](150) NULL,
	[Mobile] [nvarchar](150) NULL,
	[Email] [nvarchar](100) NULL,
	[Fax] [nvarchar](150) NULL,
	[EmployeeCode] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[SyncTime] [datetime] NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_T_Dat_EmployeeContact_Tel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[T_Dat_EmployeeContact_Tel] ADD  CONSTRAINT [DF_T_Dat_EmployeeContact_SyncTime]  DEFAULT (getdate()) FOR [SyncTime]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'域账号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'DomainAccount'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'中文名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'ChineseName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'中文全拼' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'PingYing'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'英文名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'EnglishName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'办公地点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'OfficeAddress'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'房间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'RoomNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'电话号码长号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'Telephone'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'短号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'Extension'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'手机' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'Mobile'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'工号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_Dat_EmployeeContact_Tel', @level2type=N'COLUMN',@level2name=N'EmployeeCode'
GO


