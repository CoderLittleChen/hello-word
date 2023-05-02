USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectPersonEvaluate]    Script Date: 2019/7/30 10:52:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[V_ProjectPersonEvaluate]
as

select ppe.*,ppi.Name,ppi.ID,ppi.EntryDate,ppi.CooType,ppi.DeptLevel2,ppi.DeptCode2,D1.Name as Deptlevel1,ppi.DeptCode1,ppi.ApplyEntryArea,ppi.CooCompany,ppi.IdCard,ppi.ProjectCode,ppi.ProjectName,ppi.ProjectMgr,ppi.CooMgr,ppi.EvaluateMgr,ppi.WorkPlace,ppi.DeptLevel3,ppi.DeptCode3,ppi.ProjectType,ppi.IsOnDuty,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States,mf.PersonalSignDate

from ProjectPersonEvaluate ppe 

inner join ProjectPersonInfo ppi on ppi.ProjectPersonInfoId=ppe.ProjectPersonInfoId  

left join MaterialFile mf on mf.PersonInfoId=ppe.ProjectPersonInfoId  

inner join ProcessFlow pf on ppe.ProjectPersonEvaluateId=pf.ApprovalId 
inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN dbo.Department D1 ON D1.Code=PPI.DeptCode1
WHERE ppe.DeleteFlag=0
GO


