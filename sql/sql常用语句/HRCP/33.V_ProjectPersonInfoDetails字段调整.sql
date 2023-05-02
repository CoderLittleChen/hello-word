USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectPersonInfoDetail]    Script Date: 2019/7/30 10:54:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[V_ProjectPersonInfoDetail]
AS 
SELECT NEWID() PrimaryKey,ProjectControl.ProjectControlId,DeptLevel2Name,ProjectStatus,ProjectNum,ProjectType,ProjectName,CooCompany,
Area,ProjectMgr,CooMgr,case AddAgreement when 1 then '是' else '否'end AddAgreement,ProSignMoney,AgreePlanStartDate,AgreePlanEndDate,
ContractStageNum,
(SELECT MAX(PeriodsNum) FROM ContractStage WHERE ProjectControlId=ProjectControl.ProjectControlId AND (IsDone=1 OR FactPayMoney>0)) AS  HadPayPeriod
,(SELECT SUM(FactPayMoney) FROM ContractStage WHERE ProjectControlId=ProjectControl.ProjectControlId AND (IsDone=1 OR FactPayMoney>0)) AS HadPayMoney,
case IsFinishPay when 1 then '是' else '否'end IsFinishPay,case IsWarn when 1 then '是' else '否'end IsWarn,AgreementNum,CAST(CreateMonth AS VARCHAR(7)) CreateMonth ,FactInputPersonNum,MonthlyInputPersonNum,BjPersonNum,
HzPersonNum,CdPersonNum,ZzPersonNum,HfPersonNum,OtherPersonNum,TotalPersonNum,PlanCostMoney,PlanProjectPersonNum,
case IsException when 1 then '是' else '否'end IsException,
case IsDelay when 1 then '是' else '否' end IsDelay,case IsSideAgreement when 1 then '是' else '否'end IsSideAgreement,ProDelayMoney,AgreementCode,ProjectFinishDate,DeptLevel2
FROM ProjectControl  LEFT JOIN 
(SELECT 
		 T1.BjPersonNum
		,T1.BjTotalPersonNum
		,T1.CdPersonNum
		,T1.CdTotalPersonNum
		,T1.CompanyTotalNum
		,T1.CooMgrMonthReportId
		,T1.CreateBy
		,T1.CreateDate
		,T1.CreateMonth
		,T1.CurrentProcess
		,T1.DeleteFlag
		,T1.HfPersonNum
		,T1.HfTotalPersonNum
		,T1.HzPersonNum
		,T1.HzTotalPersonNum
		,T1.ModificationDate
		,T1.Modifier
		,T1.OtherPersonNum
		,T1.OtherTotalPersonNum
		,T1.PlanCostMoney
		,T1.PlanProjectPersonNum
		,T1.ProjectControlId
		,T1.Remark
		,T1.TotalPersonNum
		,T1.ZzPersonNum
		,T1.ZzTotalPersonNum
FROM CooMgrMonthReport T1 
WHERE ProjectControlId IS NOT NULL AND 
 T1.CreateMonth>= ALL (SELECT CreateMonth FROM CooMgrMonthReport T2 WHERE T2.ProjectControlId IS NOT NULL AND T1.ProjectControlId=T2.ProjectControlId) ) CooMgrMonthReport ON ProjectControl.ProjectControlId=CooMgrMonthReport.ProjectControlId
WHERE  ProjectControl.DeleteFlag=0    AND ProjectStatus IN ('在研/进行中','在研/进行中/待验收') AND CHARINDEX('-',ProjectNum)<1

GO


