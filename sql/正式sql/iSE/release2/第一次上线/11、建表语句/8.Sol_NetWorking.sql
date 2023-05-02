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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'NetID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'NetName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ͼ·��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'FilePath'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ע' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ɾ����ʶ 0���� 1ɾ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_NetWorking', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO


