USE [PersonalInput]
GO

/****** Object:  Index [Idx_HourInfoDetailHistory_Creator]    Script Date: 2019/12/23 13:43:33 ******/
CREATE NONCLUSTERED INDEX [Idx_HourInfoDetailHistory_Creator] ON [dbo].[HourInfoDetailHistory]
(
	[Creator] ASC,
	[Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


