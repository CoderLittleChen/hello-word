USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_DataIDSet]    Script Date: 2020-12-25 11:01:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_DataIDSet](
	[DataSetID] [int] IDENTITY(1,1) NOT NULL,
	[SrcID] [nvarchar](50) NULL,
	[SrcPID] [nvarchar](50) NULL,
	[SrcName] [nvarchar](50) NULL,
	[IDLevel] [int] NULL,
	[OrderNo] [int] NULL,
	[Status] [int] NULL,
	[DeleteFlag] [int] NULL,
	[Show] [int] NULL,
 CONSTRAINT [PK_Sol_DataIDSet] PRIMARY KEY CLUSTERED 
(
	[DataSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'DataSetID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ԴID(���㼶����)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'SrcID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����Դ��ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'SrcPID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����Դ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'SrcName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�㼶' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'IDLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ʾ˳��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'OrderNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�汾״̬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ɾ����ʶ 0���� 1ɾ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 ��ʾ��-1 ����ʾ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_DataIDSet', @level2type=N'COLUMN',@level2name=N'Show'
GO


