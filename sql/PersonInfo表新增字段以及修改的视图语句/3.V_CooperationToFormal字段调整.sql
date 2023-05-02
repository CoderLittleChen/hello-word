USE [hrcp]
GO

/****** Object:  View [dbo].[V_CooperationToFormal]    Script Date: 2019/7/29 17:19:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[V_CooperationToFormal]
as
select 
		cf.ApplyPerson,
		cf.ApplyReason,
		cf.ApplySign,
		cf.ApplySignDate,
		cf.CadreOpinion,
		cf.CadreSign,
		cf.CadreSignDate,
		cf.CooDirectorConfirm,
		cf.CooDirectorOpinion,
		cf.CooDirectorSign,
		cf.CooDirectorSignDate,
		cf.CooMgrSign,
		cf.CooMgrSignDate,
		cf.CooMgrUploadUrl,
		cf.CooperationToFormalId,
		cf.CreateBy,
		cf.CreateDate,
		cf.DeleteFlag,
		cf.Dept1Code,
		cf.Evaluate10B,
		cf.HROpinion,
		cf.HROption,
		cf.HRSign,
		cf.HRSignDate,
		cf.isSubmitCadre,
		cf.ModificationDate,
		cf.Modifier,
		cf.NewDept2Code,
		cf.NewDeptMgrOpinion,
		cf.NewDeptMgrOption,
		cf.NewDeptMgrSign,
		cf.NewDeptMgrSignDate,
		cf.OldDept2Code,
		cf.OldDeptMgrOpinion,
		cf.OldDeptMgrOption,
		cf.OldDeptMgrSign,
		cf.OldDeptMgrSignDate
,(SELECT Name FROM Department WHERE Code=cf.Dept1Code) AS Dept1Name,
(SELECT Name FROM Department WHERE Code=cf.OldDept2Code) AS OldDept2Name,
(SELECT Name FROM Department WHERE Code=cf.NewDept2Code) AS NewDept2Name,
pf.ProcessFlowId,pf.WorkFlowInstanceId,pf.CurrentPerson,pf.CurrentNode,wfi.States 
from CooperationToFormal cf 
inner join ProcessFlow pf on cf.CooperationToFormalId=pf.ApprovalId 
inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
where cf.DeleteFlag=0

GO


