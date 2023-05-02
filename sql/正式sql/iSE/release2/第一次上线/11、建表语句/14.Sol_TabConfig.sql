USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_TabConfig]    Script Date: 2020-12-25 11:04:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_TabConfig](
	[TabID] [int] IDENTITY(1,1) NOT NULL,
	[TabName] [nvarchar](100) NULL,
	[ProCode] [nvarchar](50) NULL,
	[BlID] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
	[TypeCode] [int] NULL,
 CONSTRAINT [PK_Sol_TabConfig] PRIMARY KEY CLUSTERED 
(
	[TabID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ǩ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'TabName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʒ���������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'ProCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ͼ1 ����ҳ��2 ����ҳ��3 ����ҳ��4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_TabConfig', @level2type=N'COLUMN',@level2name=N'TypeCode'
GO


