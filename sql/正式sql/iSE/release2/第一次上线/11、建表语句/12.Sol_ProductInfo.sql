USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_ProductInfo]    Script Date: 2020-12-25 11:04:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_ProductInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductLine_Code] [nvarchar](50) NULL,
	[ProductLine_Name] [nvarchar](200) NULL,
	[iSplanPLine_Code] [nvarchar](50) NULL,
	[PDT_Code] [nvarchar](50) NULL,
	[PDT_Name] [nvarchar](200) NULL,
	[iSplanPDT_Code] [nvarchar](50) NULL,
	[SolutionCode] [nvarchar](50) NULL,
	[SolutionName] [nvarchar](200) NULL,
	[Release_Code] [nvarchar](50) NULL,
	[Release_Name] [nvarchar](200) NULL,
	[iSplanRelease_Code] [nvarchar](50) NULL,
	[B_Code] [nvarchar](50) NULL,
	[B_Name] [nvarchar](200) NULL,
	[D_Code] [nvarchar](50) NULL,
	[D_Name] [nvarchar](200) NULL,
	[STDArch] [nvarchar](200) NULL,
	[STDMgr] [nvarchar](200) NULL,
	[SecondDeptMgr] [nvarchar](200) NULL,
	[ThirdDeptMgr] [nvarchar](200) NULL,
 CONSTRAINT [PK_Sol_ProductInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'ID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʒ�߱���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'ProductLine_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʒ������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'ProductLine_Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'iSplan�Ĳ�Ʒ�߱���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'iSplanPLine_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PDT����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'PDT_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PDT����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'PDT_Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'iSplan��PDT����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'iSplanPDT_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'SolutionCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'SolutionName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R�汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'Release_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'R�汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'Release_Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' iSplan��Release����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'iSplanRelease_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'B�汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'B_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'B�汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'B_Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'D�汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'D_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'D�汾����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'D_Name'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'STD�ܹ�ʦ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'STDArch'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'STD����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'STDMgr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����������������������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'SecondDeptMgr'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����������������������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'ThirdDeptMgr'
GO


