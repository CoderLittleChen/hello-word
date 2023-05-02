USE [iSEDB]
GO

/****** Object:  Table [dbo].[specMs_SpecModuleHistory]    Script Date: 2020-12-21 11:09:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:cys2689
-- Create date: 2020.11.15
-- Description:模块历史表  除主键外 其余字段与模块表一致
-- =============================================
CREATE TABLE [dbo].[specMs_SpecModuleHistory](
	[smHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[blId] [int] NULL,
	[smId] [int] NULL,
	[smPid] [int] NULL,
	[smName] [nvarchar](200) NULL,
	[smLvl] [int] NULL,
	[mCode] [nvarchar](50) NULL,
	[explain] [nvarchar](200) NULL,
	[fspecNum] [int] NULL,
	[type] [int] NULL,
	[verTreeCode] [nvarchar](50) NULL,
	[mmanagerID] [nvarchar](1000) NULL,
	[mmanager] [nvarchar](1000) NULL,
	[orderNo] [float] NULL,
	[createBy] [nvarchar](50) NULL,
	[createTime] [datetime] NULL,
	[smSort] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[smHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


