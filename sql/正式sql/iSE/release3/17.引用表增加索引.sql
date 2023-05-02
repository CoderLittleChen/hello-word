--引用表[specMS_TabRefBaseLine]增加索引

USE [iSEDB]
GO
CREATE NONCLUSTERED INDEX [Index_tabID]
ON [dbo].[specMS_TabRefBaseLine] ([tabID])

GO

--drop  index  Index_tabID on specMS_TabRefBaseLine