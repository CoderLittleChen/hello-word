USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectEvaluateReport]    Script Date: 2019/7/30 10:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_ProjectEvaluateReport]
AS
SELECT pe.*,ps.DevLanguageType,
pc.ProjectName,pc.ProjectNum,pc.AgreementNum,pc.CooCompany,pc.AgreePlanStartDate,pc.AgreePlanEndDate,pc.PlanScale,pc.PersonRequire,
pc.ProjectType,pc.DeptLevel2,pc.CooMgr,pc.ProjectMgr,pc.ProSignMoney,Department.Name AS DeptLevel2Name,D1.Name AS DeptLevel1Name
FROM ProjectEvaluateReport pe 
INNER JOIN ProjectSummary ps ON pe.ProjectSummaryId=ps.ProjectSummaryId
INNER JOIN ProjectControl pc ON ps.ProjectControlId=pc.ProjectControlId 
JOIN Department ON Department.Code=pc.DeptLevel2
JOIN Department D1 ON D1.Code=pc.DeptLevel1
WHERE pe.DeleteFlag=0


GO


