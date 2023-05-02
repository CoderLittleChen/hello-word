USE [hrcp]
GO

/****** Object:  View [dbo].[V_TraineeCertificate]    Script Date: 2019/7/30 11:07:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[V_TraineeCertificate]
as 
select 
		 tc.ApplyCc
		,tc.ApplyReason
		,tc.ApplySign
		,tc.ApplySignDate
		,tc.ApplyType
		,tc.AppraisalAttach
		,tc.CooCompany
		,tc.CooOpinion
		,tc.CooOpinionAttach
		,tc.CooSign
		,tc.CooSignDate
		,tc.CreateBy
		,tc.CreateDate
		,tc.DeleteFlag
		,tc.Dept2Level
		,tc.Dept3Level
		,tc.DeptLevel1
		,tc.DeptLevel4
		,tc.DeptMgrCc
		,tc.DeptMgrOpinion
		,tc.DeptMgrSign
		,tc.DeptMgrSignDate
		,tc.DeptOpinionAttach
		,tc.DirectCc
		,tc.DirectOpinion
		,tc.DirectSign
		,tc.DirectSignDate
		,tc.EmployeeName
		,tc.EntryDate
		,tc.ModificationDate
		,tc.Modifier
		,tc.PersonInfoId
		,tc.ProjectMgr
		,tc.ReceiptCc
		,tc.StampAttach
		,tc.StampDate
		,tc.SummaryAttach
		,tc.TraineeAppraisal
		,tc.TraineeCertificateId
		,tc.TraineeSummary
		,tc.WorkNum
		,tc.WorkPlace
,dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
FROM TraineeCertificate tc inner join ProcessFlow pf on tc.TraineeCertificateId=pf.ApprovalId 
INNER join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department dept ON dept.Code=tc.Dept2Level
LEFT JOIN Department d1 ON d1.Code=tc.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=tc.Dept3Level
LEFT JOIN Department d4 ON d4.Code=tc.DeptLevel4
WHERE tc.DeleteFlag=0


GO


