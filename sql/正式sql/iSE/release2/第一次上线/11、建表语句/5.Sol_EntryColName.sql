USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_EntryColName]    Script Date: 2020-12-25 11:01:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_EntryColName](
	[ColID] [int] IDENTITY(1,1) NOT NULL,
	[BlID] [int] NULL,
	[TabID] [int] NULL,
	[BackColID] [int] NULL,
	[Name] [nvarchar](200) NULL,
	[Status] [int] NULL,
	[Type] [int] NULL,
	[Description] [nvarchar](1000) NULL,
	[CreateTime] [datetime] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
 CONSTRAINT [PK_Sol_EntryColName] PRIMARY KEY CLUSTERED 
(
	[ColID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Sol_EntryColName] ADD  CONSTRAINT [DF_Sol_EntryColName_BackColID]  DEFAULT ((0)) FOR [BackColID]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'ColID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ǩID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱԭ�е�ColID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'BackColID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����(������Ʒ������)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-2����-1�ɳ���0�ݸ�1����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1������Ʒ�� 2������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'Type'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'sh' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryColName', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO


