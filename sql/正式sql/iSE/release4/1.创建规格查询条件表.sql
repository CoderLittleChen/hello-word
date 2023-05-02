USE [iSEDB]
GO

/****** Object:  Table [dbo].[specMs_CustomerSearch]    Script Date: 2020-12-21 9:53:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[specMs_CustomerSearch](
	[CusSearchId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](10) NULL,
	[ReleaseCode] [varchar](50) NULL,
	[QueryCondition] [nvarchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[CusSearchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_CustomerSearch', @level2type=N'COLUMN',@level2name=N'CusSearchId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'用户名（12345/ys2689）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_CustomerSearch', @level2type=N'COLUMN',@level2name=N'UserName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'版本Code(R/B)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_CustomerSearch', @level2type=N'COLUMN',@level2name=N'ReleaseCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'查询条件' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_CustomerSearch', @level2type=N'COLUMN',@level2name=N'QueryCondition'
GO


