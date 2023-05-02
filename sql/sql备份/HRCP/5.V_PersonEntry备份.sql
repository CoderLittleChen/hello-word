USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonEntry]    Script Date: 2019/7/30 10:24:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_PersonEntry]
AS
SELECT pe.*,d1.Name AS DeptLevel1Name,dept.Name,d3.Name AS DeptLevel3Name,d4.Name AS DeptLevel4Name,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
FROM PersonEntry pe 
INNER JOIN ProcessFlow pf ON pe.PersonEntryId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
INNER JOIN Department dept ON dept.Code=pe.Dept2Level
INNER JOIN Department d1 ON d1.Code=pe.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=pe.Dept3Level
LEFT JOIN Department d4 ON d4.Code=pe.DeptLevel4
WHERE pe.DeleteFlag=0 

GO



