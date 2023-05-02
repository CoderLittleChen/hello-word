USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_PartProductAttribute]    Script Date: 2020-12-25 11:03:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Sol_PartProductAttribute](
	[AttrID] [int] IDENTITY(1,1) NOT NULL,
	[ColID] [int] NULL,
	[BlID] [int] NULL,
	[TabID] [int] NULL,
	[RelID] [int] NULL,
	[IsSupport] [char](1) NULL,
	[IsAgree] [char](1) NULL,
	[DefectFeedBack] [nvarchar](2000) NULL,
	[OtherFeedBack] [nvarchar](2000) NULL,
	[Status] [int] NULL,
	[CreateTime] [datetime] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
 CONSTRAINT [PK_Sol_PartProductAttribute] PRIMARY KEY CLUSTERED 
(
	[AttrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'AttrID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'条目扩展列ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'ColID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'基线' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标签ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'条目关系表ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'RelID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'支持情况(N,Y)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'IsSupport'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否同意(N,Y)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'IsAgree'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'缺陷与限制反馈' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'DefectFeedBack'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'其他反馈' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'OtherFeedBack'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-2备份-1可撤销0草稿1基线' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PartProductAttribute', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO


