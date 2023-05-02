USE [iSEDB]
GO

/****** Object:  Table [dbo].[Sol_Reference]    Script Date: 2020-12-25 11:04:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Sol_Reference](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CurBlID] [int] NULL,
	[RefBlID] [int] NULL,
	[RefTabID] [int] NULL,
	[CreateBy] [nvarchar](50) NULL,
	[CreateTime] [datetime] NULL
) ON [PRIMARY]

GO


