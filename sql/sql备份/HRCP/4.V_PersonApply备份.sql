USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonApply]    Script Date: 2019/7/29 18:05:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_PersonApply]
AS 
SELECT PersonApply.*,D1.Name AS DeptLevel1Name,Department.Name,ProcessFlow.CurrentNode,WorkFlowInstance.States 
FROM PersonApply 
LEFT JOIN Department ON Code=PersonApply.Department
LEFT JOIN dbo.Department D1 ON D1.Code=PersonApply.DeptLevel1
LEFT JOIN PersonSubmitApproval ON PersonApply.PersonApprovalId=PersonSubmitApproval.PersonSubmitApprovalId
LEFT JOIN ProcessFlow ON ProcessFlow.ApprovalId=PersonSubmitApproval.PersonSubmitApprovalId
LEFT JOIN WorkFlowInstance ON WorkFlowInstance.WorkFlowInstanceId=ProcessFlow.WorkFlowInstanceId
WHERE PersonApply.DeleteFlag=0
GO


