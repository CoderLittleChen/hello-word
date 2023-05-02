USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_Features]    Script Date: 2020-12-25 11:02:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Sol_Features](
	[FeaID] [int] IDENTITY(1,1) NOT NULL,
	[ColID] [int] NULL,
	[BlID] [int] NULL,
	[TabID] [int] NULL,
	[RelID] [int] NULL,
	[IsSupport] [char](1) NULL,
	[Status] [int] NULL,
	[CreateTime] [datetime] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
 CONSTRAINT [PK_Sol_Features] PRIMARY KEY CLUSTERED 
(
	[FeaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'FeaID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ��չ��ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'ColID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ǩID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ��ϵ��ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'RelID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'֧�����(N,Y)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'IsSupport'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-2����-1�ɳ���0�ݸ�1����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Features', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO


