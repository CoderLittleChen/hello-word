USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectPersonRecord]    Script Date: 2019/8/13 11:23:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_ProjectPersonRecord]
AS
SELECT ppr.ProjectPersonRecordId,ppi.ProjectPersonInfoId,ppi.Name,ppi.Sex,ppi.IdCard,ppi.WorkPlace,ppi.ProDirector,ppi.EvaluateMgr,ppi.DirectMgr,ppi.FirstEntryDate,
ppi.ProjectCode,ppi.ProjectName,ppi.ProjectType,D1.Name AS DeptLevel1,ppi.DeptCode1,D2.Name AS DeptLevel2,ppi.DeptCode2,D3.Name AS DeptLevel3,ppi.DeptCode3,
ppi.CooCompany,ppi.CooMgr,ppi.ProjectMgr,ppi.AgreeStartDate,
ppi.AgreeEndDate,ppi.PlanEndDate,ppi.IsTurnNext,ppi.ReleaseTime,ppi.IsOnDuty,ppi.PersonalSecrecyAgreement,ppi.IsWarn,ppi.IsFinishFile,ppi.CreateDate,
ppi.CreateBy,ppi.ReleaseType,ppi.ProMgrReleaseDate,ppi.ArchiveTime,ppi.PersonStatus,ppi.LeaveDate,ppi.LeaveType,ppi.InfoSaveCheck,ppi.CheckResult,
ppi.Area,ppi.ApplyEntryArea,ppi.IsInField,ppi.ApplyType,ppi.IsApplyId,ppi.Id,ppi.EntryDate,ppi.ExpiryDate,ppi.AttendanceClass,ppi.LeaveFieldDate,ppi.ReleaseOpinion,
mf.MaterialFileId,mf.InterviewFile ,mf.InterviewFileDate ,mf.InterviewExpDate ,mf.InterviewSign ,mf.InterviewSignDate ,mf.InterviewRemark ,mf.WrittenFile ,mf.WrittenFileDate
 ,mf.WrittenExpDate ,mf.WrittenSign ,mf.WrittenSignDate ,mf.WrittenRemark ,mf.PersonalAgreeFile ,mf.PersonalSignDate ,mf.PersonalAgreeFileDate ,mf.PersonalAgreeExpDate ,mf.PersonalAgreeSign
  ,mf.PersonalAgreeSignDate ,mf.PersonalAgreeRemark ,mf.ItAgreeFile ,mf.ItAgreeFileDate ,mf.ItAgreeExpDate ,mf.ItAgreeSign ,mf.ItAgreeSignDate ,mf.ItAgreeRemark ,mf.PhysicalCopyFile ,mf.PhysicalCopyFileDate 
  ,mf.PhysicalCopyExpDate ,mf.PhysicalCopySign ,mf.PhysicalCopySignDate ,mf.PhysicalCopyRemark ,mf.IdCardCopyFile ,mf.IdCardCopyFileDate ,mf.IdCardCopyExpDate ,mf.IdCardCopySign ,mf.IdCardCopySignDate 
  ,mf.IdCardCopyRemark ,mf.CvCopyFile ,mf.CvCopyFileDate ,mf.CvCopyExpDate ,mf.CvCopySign ,mf.CvCopySignDate ,mf.CvCopyRemark ,mf.GraduateCopyFile ,mf.GraduateCopyFileDate ,mf.GraduateCopyExpDate 
  ,mf.GraduateCopySign ,mf.GraduateCopySignDate ,mf.GraduateCopyRemark ,mf.LeaveAgreeFile ,mf.LeaveAgreeFileDate ,mf.LeaveAgreeExpDate ,mf.LeaveAgreeSign ,mf.LeaveAgreeSignDate ,mf.LeaveAgreeRemark 
   ,mf.PersonEntryId ,mf.AttachUrl ,mf.MaterialFileNo ,mf.CooOpinion ,mf.CooSign ,mf.CooSignDate ,mf.FileStatus 
  ,mf.AttachLeaveUrl ,mf.ThreeAgreeFile ,mf.ThreeAgreeFileDate ,mf.ThreeAgreeExpDate ,mf.ThreeAgreeSign ,mf.ThreeAgreeSignDate ,mf.ThreeAgreeReMark ,mf.ReNewAgreeFile ,mf.ReNewAgreeFileDate 
  ,mf.ReNewAgreeExpDate ,mf.ReNewAgreeSign ,mf.ReNewAgreeSignDate ,mf.ReNewAgreeReMark ,mf.AheadLeaveFile ,mf.AheadLeaveFileDate ,mf.AheadLeaveExpDate ,mf.AheadLeaveSign ,mf.AheadLeaveSignDate 
  ,mf.AheadLeaveReMark ,mf.LeaveConfirmOpinion ,mf.LeaveConfirmSign
 ,mf.LeaveConfirmSignDate ,mf.LeaveCooSign ,mf.LeaveCooSignDate ,mf.EntryCooSign ,mf.EntryCooSignDate ,mf.Person,
(SELECT(STUFF
		((SELECT ','+ProjectName FROM ProjectControl pc 
		INNER JOIN ProjectControl_Person_Relation relation 
		ON pc.ProjectControlId =relation.ProjectControlId 
		WHERE relation.ProPersonId=ppi.ProjectPersonInfoId AND relation.IsCurrent=0 FOR XML PATH('')),1,1,''))) AS ProjectNames,
(SELECT(STUFF
		((SELECT ','+ SUBSTRING(CONVERT(varchar(100), CreateDate, 23),0,8)+':'+Evaluate 
		FROM V_ProjectPersonEvaluate 
		WHERE ProjectPersonInfoId=ppi.ProjectPersonInfoId and DeleteFlag=0 and CreateDate between DATEADD(DAY,-365,GETDATE()) and GETDATE() 
		ORDER BY CreateDate ASC FOR XML PATH('')),1,1,''))) AS YearEvaluate,
(SELECT(STUFF
		((SELECT ','+CheckContent 
		FROM ProjectSummary 
		WHERE ProjectControlId IN 
			(SELECT ProjectControlId FROM ProjectControl_Person_Relation 
			WHERE ProPersonId=ppi.ProjectPersonInfoId and IsCurrent=0) FOR XML PATH('')),1,1,''))) AS CheckContent,
(SELECT COUNT(relation.ControlPersonRelationId) 
	FROM ProjectControl pc inner join ProjectControl_Person_Relation relation 
	ON pc.ProjectControlId =relation.ProjectControlId 
	WHERE relation.ProPersonId=ppi.ProjectPersonInfoId AND relation.IsCurrent=0) AS ProjectCount,ppr.ByMonthAccount,ppr.CooDealBaseInfoSign,ppr.CooDealBaseInfoSignTime,
	ppr.CooMgrUploadEntryDataSign,ppr.CooMgrUploadEntryDataSignTime,ppr.DocAdminSureEntryDataSign,ppr.DocAdminSureEntryDataSignTime,ppr.ProMgrSureReleaseDateSign,
	ppr.ProMgrSureReleaseDateSignTime,ppr.CooMgrUploadReleaseDataSign,ppr.CooMgrUploadReleaseDataSignTime,ppr.DocAdminSureReleaseDataSign,ppr.DocAdminSureReleaseDataSignTime,
	ppr.DocAdminSureEntryOpinion,ppr.DocAdminSureReleaseOpinion,ppr.CooMgrUploadEntryOpinion,ppr.CooMgrUploadReleaseOpinion,ppr.NoMaterial,ppr.IsStopMaterial,
	pr.DocAdminSureEntryDataSign AS EntryFile,pr.DocAdminSureReleaseDataSign AS LeaveFile
FROM  ProjectPersonInfo ppi 
INNER JOIN ProjectPersonRecord ppr ON ppr.ProjectPersonInfoId=ppi.ProjectPersonInfoId
LEFT JOIN ProjectPersonRecord pr on pr.ProjectPersonInfoId=ppi.ProjectPersonInfoId
LEFT JOIN MaterialFile mf ON ppi.ProjectPersonInfoId=mf.PersonInfoId
LEFT JOIN Department D2 ON D2.Code=ppi.DeptCode2
LEFT JOIN Department d1 ON d1.Code=ppi.DeptCode1
LEFT JOIN Department d3 ON d3.Code=ppi.DeptCode3

where ppi.DeleteFlag=0


GO


