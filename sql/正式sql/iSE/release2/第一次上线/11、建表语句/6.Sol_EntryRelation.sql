USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_EntryRelation]    Script Date: 2020-12-25 11:02:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_EntryRelation](
	[RelID] [int] IDENTITY(1,1) NOT NULL,
	[EntryID] [int] NULL,
	[BackEntryID] [int] NULL,
 CONSTRAINT [PK_Sol_EntryRelation] PRIMARY KEY CLUSTERED 
(
	[RelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Sol_EntryRelation] ADD  CONSTRAINT [DF_Sol_EntryRelation_BackEntryID]  DEFAULT ((0)) FOR [BackEntryID]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryRelation', @level2type=N'COLUMN',@level2name=N'RelID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'条目ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryRelation', @level2type=N'COLUMN',@level2name=N'EntryID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备份的条目ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_EntryRelation', @level2type=N'COLUMN',@level2name=N'BackEntryID'
GO


