USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectPersonEntry]    Script Date: 2019/7/30 10:49:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[V_ProjectPersonEntry]
as
select ppe.*,pc.ProjectNum,pc.ProjectName,pc.AgreePlanStartDate,pc.AgreePlanEndDate,pc.AgreementNum,pc.DeptLevel2,pc.DeptLevel1,pc.ProjectMgr,pc.CooMgr,pc.CooCompany,pc.Area,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States ,Department.Name AS DeptLevel2Name,d1.Name AS DeptLevel1Name
from ProjectPersonEntry ppe inner join ProjectControl pc on ppe.ProjectControlId=pc.ProjectControlId  
inner join ProcessFlow pf on ppe.ProjectPersonEntryId=pf.ApprovalId 
inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
JOIN Department ON pc.DeptLevel2=Department.CODE
LEFT JOIN dbo.Department d1 ON d1.Code=pc.DeptLevel1
where ppe.DeleteFlag=0


GO


