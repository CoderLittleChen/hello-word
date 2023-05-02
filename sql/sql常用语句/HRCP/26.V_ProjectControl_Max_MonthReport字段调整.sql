USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectControl_Max_MonthReport]    Script Date: 2019/7/30 10:34:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW  [dbo].[V_ProjectControl_Max_MonthReport]
AS

WITH tempTableName AS
(
	SELECT * FROM 
	(
		SELECT ROW_NUMBER() OVER(PARTITION BY ProjectControlId ORDER BY CreateMonth DESC) AS rownum,
				 cmmr.BjPersonNum
				,cmmr.BjTotalPersonNum
				,cmmr.CdPersonNum
				,cmmr.CdTotalPersonNum
				,cmmr.CompanyTotalNum
				,cmmr.CooMgrMonthReportId
				,cmmr.CreateBy
				,cmmr.CreateDate
				,cmmr.CreateMonth
				,cmmr.CurrentProcess
				,cmmr.DeleteFlag
				,cmmr.HfPersonNum
				,cmmr.HfTotalPersonNum
				,cmmr.HzPersonNum
				,cmmr.HzTotalPersonNum
				,cmmr.ModificationDate
				,cmmr.Modifier
				,cmmr.OtherPersonNum
				,cmmr.OtherTotalPersonNum
				,cmmr.PlanCostMoney
				,cmmr.PlanProjectPersonNum
				,cmmr.ProjectControlId
				,cmmr.Remark
				,cmmr.TotalPersonNum
				,cmmr.ZzPersonNum
				,cmmr.ZzTotalPersonNum
		FROM CooMgrMonthReport  cmmr
	)	AS T WHERE T.rownum = 1
)
SELECT 
		 pc.AcceptanceTable
		,pc.AccountCompanyName
		,pc.AddAgreement
		,pc.AgreementCode
		,pc.AgreementLink
		,pc.AgreementNum
		,pc.AgreePlanEndDate
		,pc.AgreePlanStartDate
		,pc.ApplySign
		,pc.ApplySignDate
		,pc.Area
		,pc.BankNum
		,pc.ContractStageNum
		,pc.CooCompany
		,pc.CooMgr
		,pc.CostType
		,pc.CreateBy
		,pc.CreateDate
		,pc.CurrencyType
		,pc.DeleteFlag
		,pc.DeptLevel1
		,pc.DeptLevel2
		,pc.DeptLevel2Name
		,pc.FactInputPersonNum
		,pc.FactTotalMoney
		,pc.IsDelay
		,pc.IsException
		,pc.IsExpensesAdvance
		,pc.IsFinishPay
		,pc.IsParticularlTrackPro
		,pc.IsSideAgreement
		,pc.IsSpecialPro
		,pc.IsWarn
		,pc.ModificationDate
		,pc.Modifier
		,pc.MonthlyInputPersonNum
		,pc.OpeningBank
		,pc.ParticularCostType
		,pc.PayCompanyName
		,pc.PersonRequire
		,pc.PlanScale
		,pc.ProCloseSign
		,pc.ProCloseSignDate
		,pc.ProDelayLink
		,pc.ProDelayMoney
		,pc.ProFinishSign
		,pc.ProFinishSignDate
		,pc.ProjectControlId
		,pc.ProjectFinishDate
		,pc.ProjectMgr
		,pc.ProjectName
		,pc.ProjectNum
		,pc.ProjectPlan
		,pc.ProjectSetupId
		,pc.ProjectStatus
		,pc.ProjectType
		,pc.ProSignMoney
		,pc.RelatePerson
		,pc.ReportiCycles
		,pc.SpecialRemarks
		,pc.Sqa
,tn.CreateMonth,
(SELECT MAX(PeriodsNum) FROM ContractStage WHERE ProjectControlId=pc.ProjectControlId AND (IsDone=1 OR FactPayMoney>0)) AS  HadPayPeriod
,(SELECT SUM(FactPayMoney) FROM ContractStage WHERE ProjectControlId=pc.ProjectControlId AND (IsDone=1 OR FactPayMoney>0)) AS HadPayMoney
,D1.Name AS DeptLevel1Name
FROM ProjectControl pc LEFT JOIN tempTableName tn ON pc.ProjectControlId=tn.ProjectControlId 
LEFT JOIN dbo.Department D1 ON D1.Code=PC.DeptLevel1
WHERE pc.DeleteFlag=0




GO


