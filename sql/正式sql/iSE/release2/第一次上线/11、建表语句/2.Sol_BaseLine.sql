USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_BaseLine]    Script Date: 2020-12-25 11:00:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_BaseLine](
	[BlID] [int] IDENTITY(1,1) NOT NULL,
	[ProCode] [nvarchar](50) NULL,
	[Title] [nvarchar](100) NULL,
	[CurVer] [nvarchar](100) NULL,
	[PreBlId] [int] NULL,
	[PreVer] [nvarchar](100) NULL,
	[Status] [int] NULL,
	[Description] [nvarchar](1000) NULL,
	[CurEditStatus] [int] NULL,
	[CurEditor] [nvarchar](50) NULL,
	[Ip] [nvarchar](50) NULL,
	[DeleteFlag] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
	[ApplyID] [uniqueidentifier] NULL,
	[FlowStatus] [int] NULL,
 CONSTRAINT [PK_Sol_BaseLine] PRIMARY KEY CLUSTERED 
(
	[BlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��� ��������汾��Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'ProCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ǰ�汾' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CurVer'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ǰ��汾ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'PreBlId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ǰ��汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'PreVer'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1 �ɳ��� 0�ݸ�1����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0δ�༭1�༭ ��ǰ�༭״̬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CurEditStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�༭�� ���ʺ� ��ǰ�༭��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CurEditor'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸Ļ�����Ա��¼��IP��ַ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'Ip'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ɾ����ʶ 0���� 1ɾ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'DeleteFlag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�鵵' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'ApplyID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 �ϴ�����ͼ  2  ά��������Ʒ  3 ά��ÿ�ڰ汾��  4 ����ģ�� 5 ����ģ�� 6 ���������ά�� ���ȷ�� ���߻���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'FlowStatus'
GO


