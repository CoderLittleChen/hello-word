USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_Entry]    Script Date: 2020-12-25 11:01:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_Entry](
	[EntryID] [int] IDENTITY(1,1) NOT NULL,
	[EntryPID] [int] NULL,
	[BlID] [int] NULL,
	[NetID] [int] NULL,
	[TabID] [int] NULL,
	[Lvl] [int] NULL,
	[IsLeaf] [int] NULL,
	[EntryCName] [nvarchar](400) NULL,
	[EntryEName] [nvarchar](400) NULL,
	[PriorityLevel] [int] NULL,
	[Remark] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreateTime] [datetime] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
	[Status] [int] NULL,
	[OptType] [int] NULL,
	[DeleteFlag] [int] NULL,
	[EntryOrder] [float] NULL,
	[EntryTreeOrder] [nvarchar](4000) NULL,
	[IDCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_Sol_Entry] PRIMARY KEY CLUSTERED 
(
	[EntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'EntryID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'父ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'EntryPID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'基线ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'具体的tabID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'级别 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'Lvl'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0非叶，1叶子节点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'IsLeaf'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'条目中文' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'EntryCName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'条目英文（预留）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'EntryEName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'优先级(高、中、低)，使用系统字典中的主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'PriorityLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'说明,描述' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-2备份-1可撤销0草稿1基线' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1增2删3改' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'OptType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识 0正常 1删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO


