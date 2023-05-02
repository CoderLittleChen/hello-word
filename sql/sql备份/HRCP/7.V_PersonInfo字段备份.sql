USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonInfo]    Script Date: 2019/7/30 10:27:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_PersonInfo]
AS 
SELECT  pinfo.*,mf.MaterialFileId,mf.InterviewFile,mf.InterviewFileDate,mf.InterviewExpDate,mf.InterviewSign,mf.InterviewSignDate,
mf.InterviewRemark,mf.WrittenFile,mf.WrittenFileDate,mf.WrittenExpDate,
mf.WrittenSign,mf.WrittenSignDate,mf.WrittenRemark,mf.PersonalAgreeFile,mf.PersonalAgreeFileDate,mf.PersonalAgreeExpDate,mf.PersonalAgreeSign,
mf.PersonalAgreeSignDate,mf.PersonalAgreeRemark,mf.ItAgreeFile,mf.ItAgreeFileDate,mf.ItAgreeExpDate,mf.ItAgreeSign,mf.ItAgreeSignDate,mf.ItAgreeRemark,
mf.PhysicalCopyFile,mf.PhysicalCopyFileDate,mf.PhysicalCopyExpDate,mf.PhysicalCopySign,mf.PhysicalCopySignDate,mf.PhysicalCopyRemark,
mf.IdCardCopyFile,mf.IdCardCopyFileDate,mf.IdCardCopyExpDate,mf.IdCardCopySign,mf.IdCardCopySignDate,mf.IdCardCopyRemark,mf.CvCopyFile,
mf.CvCopyFileDate,mf.CvCopyExpDate,mf.CvCopySign,mf.CvCopySignDate,mf.CvCopyRemark,mf.GraduateCopyFile,mf.GraduateCopyFileDate,mf.GraduateCopyExpDate,
mf.GraduateCopySign,mf.GraduateCopySignDate,mf.GraduateCopyRemark,mf.LeaveAgreeFile,mf.LeaveAgreeFileDate,mf.LeaveAgreeExpDate,mf.LeaveAgreeSign,
mf.LeaveAgreeSignDate,mf.LeaveAgreeRemark,mf.AttachUrl,mf.MaterialFileNo,mf.FileStatus,mf.AttachLeaveUrl,mf.ThreeAgreeFile,mf.ThreeAgreeFileDate,mf.ThreeAgreeExpDate,
mf.ThreeAgreeSign,mf.ThreeAgreeSignDate,mf.ThreeAgreeReMark,mf.ReNewAgreeFile,mf.ReNewAgreeFileDate,mf.ReNewAgreeExpDate,mf.ReNewAgreeSign,
mf.ReNewAgreeSignDate,mf.ReNewAgreeReMark,mf.AheadLeaveFile,mf.AheadLeaveFileDate,mf.AheadLeaveExpDate,mf.AheadLeaveSign,mf.AheadLeaveSignDate,
mf.AheadLeaveReMark,mf.LeaveConfirmOpinion,mf.LeaveConfirmSign,mf.LeaveConfirmSignDate,mf.LeaveCooSign,mf.LeaveCooSignDate,mf.Person,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States,d1.Name AS DeptLevel1Name,dept.Name,d3.Name AS dept3Name,d4.Name AS DeptLevel4Name ,V_TraineeThesis.CompanyThesis
FROM PersonInfo pinfo 
LEFT JOIN MaterialFile mf ON pinfo.PersonInfoId=mf.PersonInfoId
LEFT JOIN PersonEntry pe ON pinfo.PersonEntryId=pe.PersonEntryId
LEFT JOIN Department dept ON dept.Code=pinfo.Dept2Level
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=pinfo.Dept3Level
LEFT JOIN Department d4 ON d4.Code=pinfo.DeptLevel4
LEFT JOIN V_TraineeThesis  ON V_TraineeThesis.WorkNum=pinfo.WorkNum
INNER JOIN ProcessFlow pf ON pinfo.PersonInfoId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
WHERE pinfo.DeleteFlag=0 --AND  dept.DeleteFlag=0



GO


