USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_AgreeRecord]    Script Date: 2020-12-25 10:59:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_AgreeRecord](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RelID] [nvarchar](500) NULL,
	[AgreeContent] [nvarchar](500) NULL,
	[optionUser] [nvarchar](50) NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL,
 CONSTRAINT [PK_Sol_AgreeRecord] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


