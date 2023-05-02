USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_BaseLine]    Script Date: 2020-12-25 11:00:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_BaseLine](
	[BlID] [int] IDENTITY(1,1) NOT NULL,
	[ProCode] [nvarchar](50) NULL,
	[Title] [nvarchar](100) NULL,
	[CurVer] [nvarchar](100) NULL,
	[PreBlId] [int] NULL,
	[PreVer] [nvarchar](100) NULL,
	[Status] [int] NULL,
	[Description] [nvarchar](1000) NULL,
	[CurEditStatus] [int] NULL,
	[CurEditor] [nvarchar](50) NULL,
	[Ip] [nvarchar](50) NULL,
	[DeleteFlag] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
	[ApplyID] [uniqueidentifier] NULL,
	[FlowStatus] [int] NULL,
 CONSTRAINT [PK_Sol_BaseLine] PRIMARY KEY CLUSTERED 
(
	[BlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'外键 解决方案版本树Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'ProCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标题' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'当前版本' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CurVer'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'前序版本ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'PreBlId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'前序版本名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'PreVer'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1 可撤消 0草稿1基线' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0未编辑1编辑 当前编辑状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CurEditStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'编辑人 域帐号 当前编辑人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CurEditor'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改基线人员登录的IP地址' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Ip'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识 0正常 1删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'归档' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'ApplyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 上传组网图  2  维护部件产品  3 维护每期版本号  4 导出模板 5 导入模板 6 其他（规格维护 规格确认 基线化）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'FlowStatus'
GO


