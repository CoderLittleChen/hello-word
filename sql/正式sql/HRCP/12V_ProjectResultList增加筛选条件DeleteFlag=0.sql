USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectResultList]    Script Date: 2019/8/27 14:04:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_ProjectResultList]
AS
SELECT ProjectResultListId,ContractStage.ContractStageId,ProjectControl.ProjectControlId,ProjectName,AgreementNum,CooCompany,ProjectStage,BelongProduct,ContractStageNum,
PeriodsNum,ProjectMgr,ProjectResultList.CreateDate,
ProjectResultList.CreateBy,ProjectResultList.Modifier,ProjectResultList.ModifierTime,ProjectResultList.DeleteFlag,ProjectResultList.ReportStatus,ProjectResultList.ProMgrSign,ProjectResultList.ProMgrSignTime
FROM ProjectResultList JOIN ContractStage ON  ProjectResultList.ContractStageId=ContractStage.ContractStageId
JOIN ProjectControl  ON ContractStage.ProjectControlId=ProjectControl.ProjectControlId
where  ProjectResultList.DeleteFlag=0

GO


