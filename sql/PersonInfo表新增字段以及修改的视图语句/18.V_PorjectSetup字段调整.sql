USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectSetup]    Script Date: 2019/7/30 10:56:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_ProjectSetup]
AS
SELECT 
		 ps.AddAgreement
		,ps.ApplyCC
		,ps.ApplySign
		,ps.ApplySignDate
		,ps.Area
		,ps.CooCC
		,ps.CooCompany
		,ps.CooDevelopContent
		,ps.CooDevelopCredible
		,ps.CooMgr
		,ps.CooMgrSign
		,ps.CooMgrSignDate
		,ps.CooOpinion
		,ps.CooOther
		,ps.CooReady
		,ps.CooReviewCC
		,ps.CooReviewOpinion
		,ps.CooReviewOther
		,ps.CooReviewSign
		,ps.CooReviewSignDate
		,ps.CreateBy
		,ps.CreateDate
		,ps.CurrencyType
		,ps.DeleteFlag
		,ps.Dept2MgrCC
		,ps.Dept2MgrOpinion
		,ps.Dept2MgrOther
		,ps.Dept2MgrSign
		,ps.Dept2MgrSignDate
		,ps.DeptLevel1
		,ps.DeptLevel2
		,ps.DevideNum
		,ps.IsDelay
		,ps.IsPreProject
		,ps.IsStop
		,ps.ModificationDate
		,ps.Modifier
		,ps.PdtCC
		,ps.PdtOpinion
		,ps.PdtSign
		,ps.PdtSignDate
		,ps.PersonRequire
		,ps.PlanScale
		,ps.PreProLink
		,ps.PreProNum
		,ps.ProjectMgr
		,ps.ProjectName
		,ps.ProjectNum
		,ps.ProjectSetupId
		,ps.ProjectStatus
		,ps.ProjectType
		,ps.ProPlanEndDate
		,ps.ProPlanMoney
		,ps.ProPlanStartDate
		,ps.RdCEOCC
		,ps.RdCEOOPinion
		,ps.RdCEOOther
		,ps.RdCEOSign
		,ps.RdCEOSignDate
		,ps.ReceiptCc
		,ps.Remark
		,ps.SetupMaterial
		,ps.SetupMaterialAttach
		,ps.SetupStatus
		,ps.SQA
		,ps.SqaCC
		,ps.SqaOpinion
		,ps.SqaOther
		,ps.SqaSign
		,ps.SqaSignDate
,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States ,Department.Name AS DeptLevel2Name,D1.Name AS DeptLevel1Name,PC.ProjectControlId
FROM ProjectSetup ps INNER JOIN ProcessFlow pf ON ps.ProjectSetupId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department ON ps.DeptLevel2=Department.CODE
LEFT JOIN dbo.Department D1 ON D1.Code=PS.DeptLevel1
LEFT JOIN dbo.ProjectControl PC ON PS.ProjectSetupId=PC.ProjectSetupId

WHERE ps.DeleteFlag=0




GO


