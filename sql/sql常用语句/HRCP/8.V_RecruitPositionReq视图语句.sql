USE [hrcp]
GO

/****** Object:  View [dbo].[V_RecruitPositionReq]    Script Date: 2019/7/18 17:23:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[V_RecruitPositionReq]
AS
select  *  from 
(
SELECT 
req.ReqcruitReqApplyId,pf.CurrentNode,req.RecruitNo,req.CooChargePerson,req.DeptLevel1,d1.Name AS DeptLevel1Name,req.DeptLevel2,Department.Name,
req.CooType,req.AddNeedNum,req.OnDutyDate,req.IsTrainee,req.CreateTime,
wr.RecruitAdvance,wr.RecruitLastPlan,wr.RecruitProblem,wr.IsSubmit,wr.AttachFile,wr.WeekReportStartTime,wr.WeekReportEndTime,
SUM(position.ApprovalPassNum) AS ApprovalPassNum,SUM(position.EntryNum) AS EntryNum,SUM(position.ReadyEntryNum) AS ReadyEntryNum,
SUM(position.NoEntryNum) AS NoEntryNum,SUM(position.ApprovalingNum) AS ApprovalingNum,SUM(position.LastRecruitNum) AS LastRecruitNum,
(CASE req.AddNeedNum - SUM(position.EntryNum) WHEN 0 THEN GETDATE() ELSE NULL END) AS FinishDate,
(CASE req.AddNeedNum - SUM(position.EntryNum) WHEN 0 THEN '完成' ELSE '进行中' END) AS RecruitStatus,
ROW_NUMBER()   over(partition by req.ReqcruitReqApplyId  order  by  wr.CreateDate desc  )  as RankNum

FROM RecruitReqApply req 
INNER JOIN RecruitPositionReq position ON position.RecruitReqApplyId=req.ReqcruitReqApplyId
INNER JOIN Department ON req.DeptLevel2=Department.Code
LEFT JOIN dbo.Department D1 ON D1.Code=req.DeptLevel1
INNER JOIN ProcessFlow AS pf ON req.ReqcruitReqApplyId=pf.ApprovalId
Left  join  RecruitWeekReport  wr  on  req.ReqcruitReqApplyId=wr.RecruitReqApplyId
WHERE req.DeleteFlag=0 AND position.DeleteFlag=0 --AND req.AddNeedNum<>0 
AND CurrentNode='流程结束'
GROUP BY req.ReqcruitReqApplyId,req.RecruitNo,pf.CurrentNode,req.CooChargePerson,req.DeptLevel1,d1.Name,req.DeptLevel2,Department.Name,
req.CooType,req.AddNeedNum,req.OnDutyDate,req.IsTrainee,req.CreateTime,
wr.RecruitAdvance,wr.RecruitLastPlan,wr.RecruitProblem,wr.IsSubmit,wr.AttachFile,wr.WeekReportStartTime,wr.WeekReportEndTime,wr.CreateDate
)  temp   where  temp.RankNum=1  --and  temp.IsTrainee=0   and  temp.RecruitNo='20180205';


GO


