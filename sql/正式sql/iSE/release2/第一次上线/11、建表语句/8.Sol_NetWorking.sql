USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_NetWorking]    Script Date: 2020-12-25 11:02:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Sol_NetWorking](
	[NetID] [int] IDENTITY(1,1) NOT NULL,
	[BlID] [int] NULL,
	[NetName] [nvarchar](200) NULL,
	[FilePath] [nvarchar](1000) NULL,
	[FileSize] [varchar](20) NULL,
	[Remark] [nvarchar](max) NULL,
	[DeleteFlag] [int] NULL,
	[CreateTime] [datetime] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
	[NetOrderNo] [nvarchar](100) NULL,
 CONSTRAINT [PK_Sol_NetWorking] PRIMARY KEY CLUSTERED 
(
	[NetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'NetID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'基线ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'组网名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'NetName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'组网图路径' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'FilePath'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'删除标识 0正常 1删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO


