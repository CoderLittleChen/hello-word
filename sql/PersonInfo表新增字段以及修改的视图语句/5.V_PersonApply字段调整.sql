USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonApply]    Script Date: 2019/7/29 18:04:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_PersonApply]
AS 
SELECT 
		PersonApply.ApplyDate,
		PersonApply.ApplyReason,
		PersonApply.ApplyStatus,
		PersonApply.ApprovalPassDate,
		PersonApply.ApprovalPassSign,
		PersonApply.ApprovalPassSignTime,
		PersonApply.ApprovalSign,
		PersonApply.ApprovalSignTime,
		PersonApply.BirthDay,
		PersonApply.CooCompany,
		PersonApply.CooType,
		PersonApply.CreateBy,
		PersonApply.CreateDate,
		PersonApply.DeleteFlag,
		PersonApply.Department,
		PersonApply.DeptLevel1,
		PersonApply.Discipline,
		PersonApply.EmployeeName,
		PersonApply.ExaminationMaterial,
		PersonApply.FirstEducation,
		PersonApply.GraduateSchool,
		PersonApply.IDCard,
		PersonApply.IsTrainee,
		PersonApply.MaritalStatus,
		PersonApply.ModificationDate,
		PersonApply.Modifier,
		PersonApply.Nation,
		PersonApply.NativePlace,
		PersonApply.PersonalSecureAgreement,
		PersonApply.PersonApplyId,
		PersonApply.PersonApprovalId,
		PersonApply.PersonEntryId,
		PersonApply.PoliticalLandscape,
		PersonApply.PositionLevel,
		PersonApply.PositionName,
		PersonApply.PositionNo,
		PersonApply.PositionType,
		PersonApply.ReadyEntryDate,
		PersonApply.RecruitNo,
		PersonApply.RecruitReqId,
		PersonApply.Sex,
		PersonApply.TopEducation,
		PersonApply.WorkPlace,
		PersonApply.WorkYears
		,D1.Name AS DeptLevel1Name,Department.Name,ProcessFlow.CurrentNode,WorkFlowInstance.States 
FROM PersonApply 
LEFT JOIN Department ON Code=PersonApply.Department
LEFT JOIN dbo.Department D1 ON D1.Code=PersonApply.DeptLevel1
LEFT JOIN PersonSubmitApproval ON PersonApply.PersonApprovalId=PersonSubmitApproval.PersonSubmitApprovalId
LEFT JOIN ProcessFlow ON ProcessFlow.ApprovalId=PersonSubmitApproval.PersonSubmitApprovalId
LEFT JOIN WorkFlowInstance ON WorkFlowInstance.WorkFlowInstanceId=ProcessFlow.WorkFlowInstanceId
WHERE PersonApply.DeleteFlag=0
GO


