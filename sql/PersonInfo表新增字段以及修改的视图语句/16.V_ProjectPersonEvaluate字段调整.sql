USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectPersonEvaluate]    Script Date: 2019/7/30 10:52:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[V_ProjectPersonEvaluate]
as

select 
		 ppe.Communication
		,ppe.Compliance
		,ppe.CooEvaluateCC
		,ppe.CooEvaluateOpinion
		,ppe.CooEvaluateSign
		,ppe.CooEvaluateSignDate
		,ppe.CreateBy
		,ppe.CreateDate
		,ppe.Creative
		,ppe.DeleteFlag
		,ppe.Discipline
		,ppe.EndLineDate
		,ppe.Evaluate
		,ppe.EvaluateCc
		,ppe.EvaluateContent
		,ppe.ExtraScore
		,ppe.ExtraScoreEvent
		,ppe.Labour
		,ppe.ModificationDate
		,ppe.Modifier
		,ppe.NextStep
		,ppe.PlanFinish
		,ppe.PMSign
		,ppe.PMSignDate
		,ppe.Positivity
		,ppe.Principle
		,ppe.ProjectPersonEvaluateId
		,ppe.ProjectPersonInfoId
		,ppe.Quality
		,ppe.ReceiptCc
		,ppe.Responsibility
		,ppe.Skills
		,ppe.SolveProblem
		,ppe.TeamCoopration
		,ppe.TotalScore
		,ppe.WorkAbility
		,ppe.WorkDifficulty
		,ppe.WorkLoad
		,ppe.WorkProduct
,ppi.Name,ppi.ID,ppi.EntryDate,ppi.CooType,ppi.DeptLevel2,ppi.DeptCode2,D1.Name as Deptlevel1,ppi.DeptCode1,ppi.ApplyEntryArea,ppi.CooCompany,ppi.IdCard,ppi.ProjectCode,ppi.ProjectName,ppi.ProjectMgr,ppi.CooMgr,ppi.EvaluateMgr,ppi.WorkPlace,ppi.DeptLevel3,ppi.DeptCode3,ppi.ProjectType,ppi.IsOnDuty,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States,mf.PersonalSignDate

from ProjectPersonEvaluate ppe 

inner join ProjectPersonInfo ppi on ppi.ProjectPersonInfoId=ppe.ProjectPersonInfoId  

left join MaterialFile mf on mf.PersonInfoId=ppe.ProjectPersonInfoId  

inner join ProcessFlow pf on ppe.ProjectPersonEvaluateId=pf.ApprovalId 
inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN dbo.Department D1 ON D1.Code=PPI.DeptCode1
WHERE ppe.DeleteFlag=0
GO


