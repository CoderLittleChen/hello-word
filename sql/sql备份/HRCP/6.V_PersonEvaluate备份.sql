USE [hrcp]
GO

/****** Object:  View [dbo].[V_PersonEvaluate]    Script Date: 2019/7/30 10:24:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_PersonEvaluate]
AS 
 SELECT  pe.*,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States,
 pinfo.EmployeeName,pinfo.WorkNum,pinfo.EntryDate,pinfo.PositionName,pinfo.DeptLevel1,pinfo.Dept2Level,pinfo.Dept3Level,pinfo.DeptLevel4,pinfo.WorkPlace,
 pinfo.CooType,pinfo.CooCompany,pinfo.EvaluateMgrId,
 pinfo.EvaluateMgrName,pinfo.IsTrainee,pinfo.OnJobStatus,pinfo.NotesId,
dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,pinfo.IDCard
FROM PersonEvaluate pe 
LEFT JOIN ProcessFlow pf ON pe.PersonEvaluateId=pf.ApprovalId 
LEFT JOIN WorkFlowInstance wfi ON pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER JOIN Personinfo pinfo ON pe.PersonInfoId=pinfo.PersonInfoId AND pinfo.DeleteFlag=0
LEFT JOIN Department dept ON dept.Code=pinfo.Dept2Level
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=pinfo.Dept3Level
LEFT JOIN Department d4 ON d4.Code=pinfo.DeptLevel4
WHERE pe.DeleteFlag=0



GO


