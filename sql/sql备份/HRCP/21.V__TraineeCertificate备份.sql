USE [hrcp]
GO

/****** Object:  View [dbo].[V_TraineeCertificate]    Script Date: 2019/7/30 11:07:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[V_TraineeCertificate]
as 
select tc.*,
dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
FROM TraineeCertificate tc inner join ProcessFlow pf on tc.TraineeCertificateId=pf.ApprovalId 
INNER join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department dept ON dept.Code=tc.Dept2Level
LEFT JOIN Department d1 ON d1.Code=tc.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=tc.Dept3Level
LEFT JOIN Department d4 ON d4.Code=tc.DeptLevel4
WHERE tc.DeleteFlag=0


GO


