USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectSummary]    Script Date: 2019/7/30 10:58:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_ProjectSummary]
AS
SELECT 
		 ps.ApplySign
		,ps.ApplySignDate
		,ps.AuditScore
		,ps.CheckContent
		,ps.CheckDI
		,ps.CheckDIDensity
		,ps.CheckPassDate
		,ps.CheckScore
		,ps.ContractStageId
		,ps.CooCc
		,ps.CooOpinion
		,ps.CooSign
		,ps.CooSignDate
		,ps.CreateBy
		,ps.CreateDate
		,ps.DeleteFlag
		,ps.DevLanguageType
		,ps.FactCodeRows
		,ps.FactPersonMonthNum
		,ps.FactProductivity
		,ps.ModificationDate
		,ps.Modifier
		,ps.PersonLeaveFinishDate
		,ps.PlanProductivity
		,ps.ProAveScore
		,ps.ProjectControlId
		,ps.ProjectFinishSituation
		,ps.ProjectSummaryId
		,ps.ProPreblemSolution
		,ps.ReceiptCc
		,ps.ReportStatus
		,ps.ScaleVariance
		,ps.ScheduleScore
		,ps.ScheduleVariance
		,ps.SqaCc
		,ps.SqaOpinion
		,ps.SqaSign
		,ps.SqaSignDate
		,ps.Summary
,pc.ProjectName,pc.ProjectNum,pc.AgreementNum,pc.CooCompany,pc.AgreePlanStartDate,pc.AgreePlanEndDate,pc.PlanScale,pc.PersonRequire,
pc.ProjectType,pc.DeptLevel2,pc.CooMgr,pc.ProjectMgr,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States ,Department.Name AS DeptLevel2Name,D1.Name AS DeptLevel1Name
FROM ProjectSummary ps 
INNER JOIN ProjectControl pc ON ps.ProjectControlId=pc.ProjectControlId 
INNER JOIN ProcessFlow pf ON ps.ProjectSummaryId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId
JOIN Department ON Department.Code=pc.DeptLevel2 
JOIN Department D1 ON D1.Code=pc.DeptLevel1  WHERE ps.DeleteFlag=0


GO


