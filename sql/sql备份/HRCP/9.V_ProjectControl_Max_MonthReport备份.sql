USE [hrcp]
GO

/****** Object:  View [dbo].[V_ProjectControl_Max_MonthReport]    Script Date: 2019/7/30 10:33:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW  [dbo].[V_ProjectControl_Max_MonthReport]
AS

WITH tempTableName AS(
SELECT * FROM 
(SELECT ROW_NUMBER() OVER(PARTITION BY ProjectControlId ORDER BY CreateMonth DESC) AS rownum,* FROM CooMgrMonthReport)
 AS T WHERE T.rownum = 1)
SELECT pc.*,tn.CreateMonth,
(SELECT MAX(PeriodsNum) FROM ContractStage WHERE ProjectControlId=pc.ProjectControlId AND (IsDone=1 OR FactPayMoney>0)) AS  HadPayPeriod
,(SELECT SUM(FactPayMoney) FROM ContractStage WHERE ProjectControlId=pc.ProjectControlId AND (IsDone=1 OR FactPayMoney>0)) AS HadPayMoney
,D1.Name AS DeptLevel1Name
FROM ProjectControl pc LEFT JOIN tempTableName tn ON pc.ProjectControlId=tn.ProjectControlId 
LEFT JOIN dbo.Department D1 ON D1.Code=PC.DeptLevel1
WHERE pc.DeleteFlag=0




GO


