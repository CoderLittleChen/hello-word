USE [hrcp]
GO

/****** Object:  View [dbo].[V_CooperationToFormal]    Script Date: 2019/7/29 17:21:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[V_CooperationToFormal]
as
select cf.*,(SELECT Name FROM Department WHERE Code=cf.Dept1Code) AS Dept1Name,
(SELECT Name FROM Department WHERE Code=cf.OldDept2Code) AS OldDept2Name,
(SELECT Name FROM Department WHERE Code=cf.NewDept2Code) AS NewDept2Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
from CooperationToFormal cf 
inner join ProcessFlow pf on cf.CooperationToFormalId=pf.ApprovalId 
inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
where cf.DeleteFlag=0

GO



