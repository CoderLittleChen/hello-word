USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectSetup]    Script Date: 2019/7/30 10:56:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_ProjectSetup]
AS
SELECT ps.*,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States ,Department.Name AS DeptLevel2Name,D1.Name AS DeptLevel1Name,PC.ProjectControlId
FROM ProjectSetup ps INNER JOIN ProcessFlow pf ON ps.ProjectSetupId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department ON ps.DeptLevel2=Department.CODE
LEFT JOIN dbo.Department D1 ON D1.Code=PS.DeptLevel1
LEFT JOIN dbo.ProjectControl PC ON PS.ProjectSetupId=PC.ProjectSetupId

WHERE ps.DeleteFlag=0




GO


