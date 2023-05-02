USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonEntry]    Script Date: 2019/7/30 10:20:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_PersonEntry]
AS
SELECT 
		 pe.AddReader
		,pe.AddReaderSign
		,pe.AddReaderSignDate
		,pe.ApplyCardCc
		,pe.ApplyCardDate
		,pe.ApplyCardOpinion
		,pe.ApplyCardSign
		,pe.ApplyNumCc
		,pe.ApplyWorkNumOpinion
		,pe.ApplyWorkNumSign
		,pe.ApplyWorkNumSignDate
		,pe.BirthDay
		,pe.CardPhoto
		,pe.CardSendDate
		,pe.CMOId
		,pe.CMOName
		,pe.CooCompany
		,pe.CooSign
		,pe.CooSignDate
		,pe.CooType
		,pe.CreateBy
		,pe.CreateDate
		,pe.CurrentLevel
		,pe.DeleteFlag
		,pe.Dept2Level
		,pe.Dept3Level
		,pe.DeptLevel1
		,pe.DeptLevel4
		,pe.DeptSecretaryCc
		,pe.DeptSecretaryId
		,pe.DeptSecretaryName
		,pe.DeptSecretarySign
		,pe.DeptSecretarySignDate
		,pe.DirectorMgrId
		,pe.DirectorMgrName
		,pe.Discipline
		,pe.Domains
		,pe.EmployeeName
		,pe.EntryDate
		,pe.EntryFileCc
		,pe.EntryStartLevel
		,pe.EntryType
		,pe.EvaluateMgrId
		,pe.EvaluateMgrName
		,pe.ExaminationMaterial
		,pe.FirstEducation
		,pe.GraduateDate
		,pe.GraduateSchool
		,pe.IDCard
		,pe.InfoSaveCheck
		,pe.InfoSaveCheckLink
		,pe.InfoSaveCheckOpinion
		,pe.InfoSaveCheckSign
		,pe.InfoSaveCheckSignDate
		,pe.IsTrainee
		,pe.MatricalStatus
		,pe.ModificationDate
		,pe.Modifier
		,pe.Nation
		,pe.NativePlace
		,pe.NotesId
		,pe.OfficeLocation
		,pe.PDM
		,pe.PersonalSecureAgreement
		,pe.PersonApplyId
		,pe.PersonEntryId
		,pe.PoliticalLandscape
		,pe.PositionName
		,pe.PositionNo
		,pe.PositionType
		,pe.ProEntryDate
		,pe.ReceiptCc
		,pe.RecruitNo
		,pe.Remark
		,pe.SapCc
		,pe.SAPOpinion
		,pe.SAPSign
		,pe.SAPSignDate
		,pe.SAPToOther
		,pe.SaveCheckCc
		,pe.Sex
		,pe.Telephone
		,pe.TopEducation
		,pe.TraineeEndDate
		,pe.TutorId
		,pe.TutorName
		,pe.WorkNum
		,pe.WorkPlace
	    ,d1.Name AS DeptLevel1Name,dept.Name,d3.Name AS DeptLevel3Name,d4.Name AS DeptLevel4Name,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
FROM PersonEntry pe 
INNER JOIN ProcessFlow pf ON pe.PersonEntryId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
INNER JOIN Department dept ON dept.Code=pe.Dept2Level
INNER JOIN Department d1 ON d1.Code=pe.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=pe.Dept3Level
LEFT JOIN Department d4 ON d4.Code=pe.DeptLevel4
WHERE pe.DeleteFlag=0 

GO


