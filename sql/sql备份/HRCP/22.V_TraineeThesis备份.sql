USE [hrcp]
GO

/****** Object:  View [dbo].[V_TraineeThesis]    Script Date: 2019/7/30 11:09:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[V_TraineeThesis]
as
select tt.*,
dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States
 from TraineeThesis tt 
 INNER join ProcessFlow pf on tt.TraineeThesisId=pf.ApprovalId 
 INNER join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department dept ON dept.Code=tt.Dept2Level
LEFT JOIN Department d1 ON d1.Code=tt.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=tt.Dept3Level
LEFT JOIN Department d4 ON d4.Code=tt.DeptLevel4
WHERE tt.DeleteFlag=0


GO


