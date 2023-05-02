USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonSubmitApproval]    Script Date: 2019/7/30 10:30:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









ALTER VIEW [dbo].[V_PersonSubmitApproval]
AS 
SELECT approval.*,pf.ProcessFlowId,pf.WorkFlowInstanceId,
pf.CurrentPerson,pf.CurrentNode,wfi.States
FROM PersonSubmitApproval approval 
INNER JOIN ProcessFlow pf ON pf.ApprovalId=approval.PersonSubmitApprovalId
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId
WHERE approval.DeleteFlag=0






GO


