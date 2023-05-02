USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectPersonInfoDetail]    Script Date: 2019/7/30 10:53:53 ******/
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
(SELECT *  FROM CooMgrMonthReport T1 
WHERE ProjectControlId IS NOT NULL AND 
 T1.CreateMonth>= ALL (SELECT CreateMonth FROM CooMgrMonthReport T2 WHERE T2.ProjectControlId IS NOT NULL AND T1.ProjectControlId=T2.ProjectControlId) ) CooMgrMonthReport ON ProjectControl.ProjectControlId=CooMgrMonthReport.ProjectControlId
WHERE  ProjectControl.DeleteFlag=0    AND ProjectStatus IN ('在研/进行中','在研/进行中/待验收') AND CHARINDEX('-',ProjectNum)<1

GO


