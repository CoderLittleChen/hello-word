USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_PageConfig]    Script Date: 2020-12-25 11:03:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_PageConfig](
	[ConfigID] [int] IDENTITY(1,1) NOT NULL,
	[BlID] [int] NULL,
	[TabID] [int] NULL,
	[ColID] [int] NULL,
	[DataSetID] [int] NULL,
	[ProCode] [nvarchar](50) NULL,
	[ProductLine_Code] [nvarchar](50) NULL,
	[PDT_Code] [nvarchar](50) NULL,
	[PDTManager] [nvarchar](500) NULL,
	[InterfaceManager] [nvarchar](500) NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
	[Modifier] [nvarchar](50) NULL,
	[ModifyTime] [datetime] NULL,
 CONSTRAINT [PK_Sol_PageConfig] PRIMARY KEY CLUSTERED 
(
	[ConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'ConfigID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'基线' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'BlID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标签页ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'TabID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'部件产品ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'ColID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品树编码外键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'ProCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品线编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'ProductLine_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PDT编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'PDT_Code'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PDT经理' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'PDTManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品接口人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'InterfaceManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_PageConfig', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO


