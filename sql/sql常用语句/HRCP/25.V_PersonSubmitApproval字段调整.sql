USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonSubmitApproval]    Script Date: 2019/7/30 10:31:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









ALTER VIEW [dbo].[V_PersonSubmitApproval]
AS 
SELECT 
		approval.CadreApprDate
		,approval.CadreCc
		,approval.CadreOpinion
		,approval.CadreSign
		,approval.CadreSignDate
		,approval.CreateBy
		,approval.CreateDate
		,approval.DeleteFlag
		,approval.Dept1ApprDate
		,approval.Dept1ApprSign
		,approval.Dept1ApprSignDate
		,approval.Dept1Cc
		,approval.Dept1Opinion
		,approval.HrMgrOpinion
		,approval.HrMgrSign
		,approval.HrMgrSignDate
		,approval.IsTrainee
		,approval.ModificationDate
		,approval.Modifier
		,approval.PersonApprovalNo
		,approval.PersonSubmitApprovalId
		,approval.ReceiptCc
		,approval.RecruitReqApplyId
,pf.ProcessFlowId,pf.WorkFlowInstanceId,
pf.CurrentPerson,pf.CurrentNode,wfi.States
FROM PersonSubmitApproval approval 
INNER JOIN ProcessFlow pf ON pf.ApprovalId=approval.PersonSubmitApprovalId
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId
WHERE approval.DeleteFlag=0






GO


