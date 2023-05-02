USE [hrcp]
GO

/****** Object:  View [dbo].[V_RecruitReqApplyList]    Script Date: 2019/8/14 11:10:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[V_RecruitReqApplyList]
AS
SELECT   pf.ProcessFlowId, pf.WorkFlowInstanceId, pf.Type, pf.CurrentPerson, pf.CurrentNode, pf.[Status],
		 rra.AddNeedNum
		,rra.AddPersonPermission
		,rra.AddPersonView
		,rra.AddReason
		,rra.CadreApprDate
		,rra.CadreCc
		,rra.CadreOpinion
		,rra.CadreSign
		,rra.CadreSignTime
		,rra.CalledPerson
		,rra.CooChargePerson
		,rra.CooMgrCc
		,rra.CooMgrOpinion
		,rra.CooMgrSign
		,rra.CooMgrSignTime
		,rra.CooMgrTurnOther
		,rra.CooType
		,rra.CreateBy
		,rra.CreateTime
		,rra.DeleteFlag
		,rra.Dept1ApprDate
		,rra.Dept1Opinion
		,rra.Dept1Sign
		,rra.Dept1SignTime
		,rra.Dept2MgrCc
		,rra.Dept2MgrOpinion
		,rra.Dept2MgrSign
		,rra.Dept2MgrSignTime
		,rra.Dept2MgrTurnOther
		,rra.DeptLevel1
		,rra.DeptLevel2
		,rra.IsTrainee
		,rra.JobRequire
		,rra.ModificationDate
		,rra.Modifier
		,rra.OnDutyDate
		,rra.OtherReason
		,rra.PeopleNum
		,rra.PositionNum
		,rra.PositionRequireReason
		,rra.ProMgrSign
		,rra.ProMgrSignTime
		,rra.ReceiptCc
		,rra.RecruitNo
		,rra.ReplacePerson
		,rra.ReqcruitReqApplyId
		,rra.StatusFlag
		,rra.TurnPerson
		,rra.WorkPlace,
		rra.RecruitReqApplyAttach
,wfi.States,
Department.Name  AS Name,d1.Name AS DeptLevel1Name
FROM      dbo.ProcessFlow AS pf INNER JOIN
                dbo.RecruitReqApply AS rra ON pf.ApprovalId = rra.ReqcruitReqApplyId INNER JOIN
                dbo.WorkFlowInstance AS wfi ON pf.WorkFlowInstanceId = wfi.WorkFlowInstanceId				
				LEFT JOIN Department ON Code=rra.DeptLevel2
				LEFT JOIN dbo.Department D1 ON D1.Code=RRA.DeptLevel1
WHERE   (rra.DeleteFlag = 0)


GO


