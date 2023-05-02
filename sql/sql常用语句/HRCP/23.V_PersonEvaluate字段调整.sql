USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonEvaluate]    Script Date: 2019/7/30 10:25:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_PersonEvaluate]
AS 
 SELECT  
		 pe.ApplySign
		,pe.ApplySignDate
		,pe.Communication
		,pe.Compliance
		,pe.CooEvaluateCC
		,pe.CooEvaluateOpinion
		,pe.CooEvaluateSign
		,pe.CooEvaluateSignDate
		,pe.CreateBy
		,pe.CreateDate
		,pe.Creative
		,pe.DeleteFlag
		,pe.Discipline
		,pe.EndLineDate
		,pe.Evaluate
		,pe.EvaluateContent
		,pe.ExtraScore
		,pe.ExtraScoreEvent
		,pe.Labour
		,pe.ModificationDate
		,pe.Modifier
		,pe.NextStep
		,pe.PersonEvaluateId
		,pe.PersonInfoId
		,pe.PlanFinish
		,pe.PmCc
		,pe.PMSign
		,pe.PMSignDate
		,pe.PMToOther
		,pe.Positivity
		,pe.Principle
		,pe.Quality
		,pe.ReceiptCc
		,pe.Responsibility
		,pe.Skills
		,pe.SolveProblem
		,pe.TeamCoopration
		,pe.TotalScore
		,pe.WorkAbility
		,pe.WorkDifficulty
		,pe.WorkLoad
		,pe.WorkProduct
		,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States,
 pinfo.EmployeeName,pinfo.WorkNum,pinfo.EntryDate,pinfo.PositionName,pinfo.DeptLevel1,pinfo.Dept2Level,pinfo.Dept3Level,pinfo.DeptLevel4,pinfo.WorkPlace,
 pinfo.CooType,pinfo.CooCompany,pinfo.EvaluateMgrId,
 pinfo.EvaluateMgrName,pinfo.IsTrainee,pinfo.OnJobStatus,pinfo.NotesId,
dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,pinfo.IDCard
FROM PersonEvaluate pe 
LEFT JOIN ProcessFlow pf ON pe.PersonEvaluateId=pf.ApprovalId 
LEFT JOIN WorkFlowInstance wfi ON pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER JOIN Personinfo pinfo ON pe.PersonInfoId=pinfo.PersonInfoId AND pinfo.DeleteFlag=0
LEFT JOIN Department dept ON dept.Code=pinfo.Dept2Level
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=pinfo.Dept3Level
LEFT JOIN Department d4 ON d4.Code=pinfo.DeptLevel4
WHERE pe.DeleteFlag=0



GO


