USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectExceptionEnd]    Script Date: 2019/7/30 10:46:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[V_ProjectExceptionEnd]
as
select 
		 pe.ApplyCc
		,pe.ApplySign
		,pe.ApplySignDate
		,pe.CooCompany
		,pe.CooMgr
		,pe.CooMgrCc
		,pe.CooMgrOpinion
		,pe.CooMgrSign
		,pe.CooMgrSignDate
		,pe.CreateBy
		,pe.CreateDate
		,pe.DeleteFlag
		,pe.DeptLevel2
		,pe.DeptMgrCc
		,pe.DeptMgrOpinoin
		,pe.DeptMgrSign
		,pe.DeptMgrSignDate
		,pe.ExceptionEndContent
		,pe.ModificationDate
		,pe.Modifier
		,pe.PdtCc
		,pe.PdtOpinion
		,pe.ProjectControlId
		,pe.ProjectExceptionEndId
		,pe.ProjectMgr
		,pe.ProjectName
		,pe.ProjectNum
		,pe.ProjectType
		,pe.ReceiptCc
		,pe.SqaCc
		,pe.SqaOpinion
		,pe.SqaSign
		,pe.SqaSignDate
,pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States ,Department.Name AS DeptLevel2Name
from ProjectExceptionEnd pe inner join ProcessFlow pf on pe.ProjectExceptionEndId=pf.ApprovalId 
inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
JOIN Department ON pe.DeptLevel2=Department.CODE

where pe.DeleteFlag=0

GO


