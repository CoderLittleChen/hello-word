USE [hrcp]
GO

/****** Object:  View [dbo].[V_ContractStageAndAttach]    Script Date: 2019/7/29 16:36:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_ContractStageAndAttach]
AS
SELECT 
		ContractStage.*,
		ProjectCheckReportId,ProjectStageReportId,ProjectResultListId,ProjectSummary.ProjectSummaryId,ProjectEvaluateReportId,
ProjectCheckReport.ReportStatus AS CheckReportStatus,ProjectStageReport.ReportStatus AS StageReportStatus,ProjectResultList.ReportStatus AS ResultReportStatus
,ProjectEvaluateReport.ReportStatus AS EvaluateReportStatus,ProjectSummary.ReportStatus AS SummaryReportStatus
FROM ContractStage   LEFT JOIN ProjectCheckReport ON ContractStage.ContractStageId=ProjectCheckReport.ContractStageId
	LEFT JOIN ProjectStageReport ON ContractStage.ContractStageId=ProjectStageReport.ContractStageId
	LEFT JOIN ProjectResultList ON ContractStage.ContractStageId=ProjectResultList.ContractStageId
	LEFT JOIN ProjectSummary ON ContractStage.ContractStageId=ProjectSummary.ContractStageId
	LEFT JOIN ProjectEvaluateReport ON ProjectSummary.ProjectSummaryId=ProjectEvaluateReport.ProjectSummaryId

GO


