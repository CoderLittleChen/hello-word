USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_Permission]    Script Date: 2020-12-25 11:03:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_Permission](
	[PermID] [int] IDENTITY(1,1) NOT NULL,
	[UserType] [int] NULL,
	[UserName] [nvarchar](50) NULL,
	[DataSetID] [int] NULL,
	[RCode] [nvarchar](50) NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
 CONSTRAINT [PK_Sol_Permission] PRIMARY KEY CLUSTERED 
(
	[PermID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'PermID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1-�û�2-Ⱥ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'UserType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�û���(����)/Ⱥ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'UserName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʒ��ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'DataSetID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'RCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Permission', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO


