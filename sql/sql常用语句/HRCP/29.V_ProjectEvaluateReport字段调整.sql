USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectEvaluateReport]    Script Date: 2019/7/30 10:44:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_ProjectEvaluateReport]
AS
SELECT 
		 pe.AuditScore
		,pe.AuditScoreWeight
		,pe.CheckContent
		,pe.CheckPassDate
		,pe.CheckScore
		,pe.CheckScoreWeight
		,pe.CompanyAttitudeScore
		,pe.CompanyAttitudeScoreWeight
		,pe.CompanyEvaluateScore
		,pe.CompanyEvaluateScoreWeight
		,pe.CompanyInfoSaveScore
		,pe.CompanyInfoSaveScoreWeight
		,pe.CompanyIntimeScore
		,pe.CompanyIntimeScoreWeight
		,pe.CompanyStableScore
		,pe.CompanyStableScoreWeight
		,pe.ContractStageId
		,pe.CreateBy
		,pe.CreateDate
		,pe.DeleteFlag
		,pe.FactCodeRows
		,pe.InOutEfficiency
		,pe.InOutScore
		,pe.InOutScoreWeight
		,pe.ModificationDate
		,pe.Modifier
		,pe.ProjectControlId
		,pe.ProjectEvaluateReportId
		,pe.ProjectSummaryId
		,pe.ReportStatus
		,pe.SignName
		,pe.SignTime
		,pe.TogetherScore
		,ps.DevLanguageType,
pc.ProjectName,pc.ProjectNum,pc.AgreementNum,pc.CooCompany,pc.AgreePlanStartDate,pc.AgreePlanEndDate,pc.PlanScale,pc.PersonRequire,
pc.ProjectType,pc.DeptLevel2,pc.CooMgr,pc.ProjectMgr,pc.ProSignMoney,Department.Name AS DeptLevel2Name,D1.Name AS DeptLevel1Name
FROM ProjectEvaluateReport pe 
INNER JOIN ProjectSummary ps ON pe.ProjectSummaryId=ps.ProjectSummaryId
INNER JOIN ProjectControl pc ON ps.ProjectControlId=pc.ProjectControlId 
JOIN Department ON Department.Code=pc.DeptLevel2
JOIN Department D1 ON D1.Code=pc.DeptLevel1
WHERE pe.DeleteFlag=0


GO


