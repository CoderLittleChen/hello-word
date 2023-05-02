USE [hrcp]
GO

/****** Object:  View [dbo].[V_RecruitReqApplyList]    Script Date: 2019/7/30 11:00:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_RecruitReqApplyList]
AS
SELECT   pf.ProcessFlowId, pf.WorkFlowInstanceId, pf.Type, pf.CurrentPerson, pf.CurrentNode, pf.[Status],rra.*,wfi.States,
Department.Name  AS Name,d1.Name AS DeptLevel1Name
FROM      dbo.ProcessFlow AS pf INNER JOIN
                dbo.RecruitReqApply AS rra ON pf.ApprovalId = rra.ReqcruitReqApplyId INNER JOIN
                dbo.WorkFlowInstance AS wfi ON pf.WorkFlowInstanceId = wfi.WorkFlowInstanceId				
				LEFT JOIN Department ON Code=rra.DeptLevel2
				LEFT JOIN dbo.Department D1 ON D1.Code=RRA.DeptLevel1
WHERE   (rra.DeleteFlag = 0)

GO


