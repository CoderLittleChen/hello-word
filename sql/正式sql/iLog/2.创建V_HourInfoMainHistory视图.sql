USE [PersonalInput]
GO

/****** Object:  View [dbo].[V_HourInfoMainHistory]    Script Date: 2019/12/9 15:58:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[V_HourInfoMainHistory]
AS
		SELECT a.id,
			   a.BillNo ,	          
	           a.Status ,
	           a.IsFrozen ,
	           a.DeptCode ,
	           a.CreateTime ,
	           a.Creator ,
	           a.Modifier ,
	           a.ModifyTime ,
	           a.DeleteFlag ,
	           a.UserCode ,
	           a.UserName ,
	           a.Mon_IsBack ,
	           a.Tu_IsBack ,
	           a.Wed_IsBack ,
	           a.Th_IsBack ,
	           a.Fri_IsBack ,
	           a.Sat_IsBack ,
	           a.Sun_IsBack,
			   f.DeptName ,
			   CASE a.STATUS WHEN 0 THEN '未提交' WHEN 1 THEN '已提交' WHEN 2 THEN '返回修改' END  FillState
	    FROM HourInfoMainHistory a 
		LEFT JOIN dbo.Department f ON a.DeptCode = f.DeptCode;



GO


