USE [hrcp]
GO

/****** Object:  View [dbo].[V_TraineeBankInfo]    Script Date: 2019/7/30 11:03:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[V_TraineeBankInfo]
as
select tb.*,
dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
FROM TraineeBankInfo tb inner join ProcessFlow pf ON tb.TraineeBankInfoId=pf.ApprovalId 
INNER join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department dept ON dept.Code=tb.Dept2Level
LEFT JOIN Department d1 ON d1.Code=tb.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=tb.Dept3Level
LEFT JOIN Department d4 ON d4.Code=tb.DeptLevel4
WHERE tb.DeleteFlag=0


GO


