USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectControlMonthReport]    Script Date: 2019/7/30 10:39:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW  [dbo].[V_ProjectControlMonthReport]
AS
SELECT cmr.*,pc.ProjectName,pc.ProjectNum,pc.DeptLevel2,pc.ProjectType,pc.CooCompany,pc.Area,pc.CooMgr,pc.ProjectMgr,pc.AgreePlanStartDate,pc.AgreePlanEndDate ,Department.Name AS DeptLevel2Name,D1.Name AS DeptLevel1Name
FROM CooMgrMonthReport cmr INNER JOIN ProjectControl pc ON cmr.ProjectControlId=pc.ProjectControlId 
JOIN Department ON Department.Code=pc.DeptLevel2
INNER JOIN dbo.Department D1 ON D1.Code=PC.DeptLevel1
WHERE cmr.DeleteFlag=0


GO


