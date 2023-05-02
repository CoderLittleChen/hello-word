USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_PermissionLog]    Script Date: 2021/1/20 15:46:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_PermissionLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[BlID] [int] NULL,
	[TabID] [int] NULL,
	[ColID] [int] NULL,
	[UserType] [int] NULL,
	[UserName] [nvarchar](20) NULL,
	[DataSetID] [int] NULL,
	[RCode] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'LogID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TabID(����/����)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��չ��ID(������Ʒ)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'ColID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�û�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'UserType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�û����ƣ�12345/ys2689��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'UserName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�汾��ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'DataSetID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PermissionLog', @level2type=N'COLUMN',@level2name=N'RCode'
GO


