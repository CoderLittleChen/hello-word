USE [hrcp]
GO

/****** Object:  View [dbo].[V_TraineeThesis]    Script Date: 2019/7/30 11:09:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[V_TraineeThesis]
as
select 
		 tt.AnswerDate
		,tt.ApprovalSign
		,tt.ApprovalSignDate
		,tt.CompanyThesis
		,tt.CooCC
		,tt.CooCompany
		,tt.CooOpinion
		,tt.CooSign
		,tt.CooSignDate
		,tt.CooType
		,tt.CreateBy
		,tt.CreateDate
		,tt.DeleteFlag
		,tt.Dept2Level
		,tt.Dept3Level
		,tt.DeptLevel1
		,tt.DeptLevel4
		,tt.EmployeeName
		,tt.EntryDate
		,tt.IDCard
		,tt.Instruction
		,tt.IsCompanyThsis
		,tt.LeaveDate
		,tt.ModificationDate
		,tt.Modifier
		,tt.Nation
		,tt.NativePlace
		,tt.PesonEntryId
		,tt.PositionName
		,tt.ReceiptCc
		,tt.SchoolTutorName
		,tt.SchTutorWorkArea
		,tt.StudentThesis
		,tt.ThesisApprovalCC
		,tt.ThesisApprovalOpinion
		,tt.ThesisCotent
		,tt.ThesisSkills
		,tt.ThesisSloveProblem
		,tt.TraineeSign
		,tt.TraineeSignDate
		,tt.TraineeThesisId
		,tt.TutorId
		,tt.TutorName
		,tt.TutorSign
		,tt.TutorSignDate
		,tt.TutorWriteCC
		,tt.WorkNum
		,tt.WorkPlace
,dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States
 from TraineeThesis tt 
 INNER join ProcessFlow pf on tt.TraineeThesisId=pf.ApprovalId 
 INNER join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department dept ON dept.Code=tt.Dept2Level
LEFT JOIN Department d1 ON d1.Code=tt.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=tt.Dept3Level
LEFT JOIN Department d4 ON d4.Code=tt.DeptLevel4
WHERE tt.DeleteFlag=0


GO


