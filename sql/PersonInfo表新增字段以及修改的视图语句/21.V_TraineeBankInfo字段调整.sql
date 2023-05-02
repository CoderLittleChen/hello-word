USE [hrcp]
GO

/****** Object:  View [dbo].[V_TraineeBankInfo]    Script Date: 2019/7/30 11:05:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [dbo].[V_TraineeBankInfo]
as
select 
		 tb.Address
		,tb.AddressSign
		,tb.AddressSignDate
		,tb.BankInfo
		,tb.BankInfoSign
		,tb.BankInfoSignDate
		,tb.BankNum
		,tb.CooCC
		,tb.CooOpinion
		,tb.CooSign
		,tb.CooSignDate
		,tb.Cotenant
		,tb.CreateBy
		,tb.CreateDate
		,tb.DeleteFlag
		,tb.Dept2Level
		,tb.Dept3Level
		,tb.DeptLevel1
		,tb.DeptLevel4
		,tb.EmergencePerson
		,tb.EmergenceTel
		,tb.EmployeeName
		,tb.EntryDate
		,tb.IDCard
		,tb.ModificationDate
		,tb.Modifier
		,tb.NativePlace
		,tb.PersonalTel
		,tb.PersonEntryId
		,tb.PositionName
		,tb.TraineeBankInfoId
		,tb.WorkNum
		,tb.WorkPlace
,dept.Name AS Dept2Name,d1.Name AS DeptLevel1Name,d3.Name AS Dept3Name,d4.Name AS DeptLevel4Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
FROM TraineeBankInfo tb inner join ProcessFlow pf ON tb.TraineeBankInfoId=pf.ApprovalId 
INNER join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
LEFT JOIN Department dept ON dept.Code=tb.Dept2Level
LEFT JOIN Department d1 ON d1.Code=tb.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=tb.Dept3Level
LEFT JOIN Department d4 ON d4.Code=tb.DeptLevel4
WHERE tb.DeleteFlag=0


GO


