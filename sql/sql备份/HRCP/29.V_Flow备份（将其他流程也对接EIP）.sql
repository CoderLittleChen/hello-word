USE [hrcp]
GO

/****** Object:  View [dbo].[V_Flow]    Script Date: 2019/10/12 9:32:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER  VIEW   [dbo].[V_Flow]  AS  
---------------------------------------------------OnSite需求申请
SELECT  ('[HRCP]'+'OnSite需求申请') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(req.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(req.CreateBy,'name')  AS  ADDUSERNAME,
req.CreateTime AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'OnSite/RecruitReqDetail?id='+ CONVERT(VARCHAR(100), req.ReqcruitReqApplyId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
req.ReqcruitReqApplyId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId  AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case  when   req.DeleteFlag=0
	then  
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top 1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE    wfn.WorkFlowId=wfi.WorkFlowId  and  wfn.Name=pf.CurrentNode) AS NODEID,
pf.CurrentNode  AS NODENAME,
(CONVERT(datetime,req.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  RecruitReqApply  req
INNER  JOIN  ProcessFlow  pf   ON  req.ReqcruitReqApplyId=pf.ApprovalId 
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
--------------------------------------------------------实习生人员报批
SELECT  ('[HRCP]'+'实习生人员报批') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(psa.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(psa.CreateBy,'name')  AS  ADDUSERNAME,
psa.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeApprovalDetail?id='+ CONVERT(VARCHAR(100),psa.PersonSubmitApprovalId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
psa.PersonSubmitApprovalId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when psa.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,psa.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  PersonSubmitApproval  psa
INNER  JOIN  ProcessFlow  pf   ON  psa.PersonSubmitApprovalId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
--------------------------------------------------------OnSite人员入项
SELECT  ('[HRCP]'+'OnSite人员入项') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
pe.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'OnSite/PersonEntryDetail?id='+ CONVERT(VARCHAR(100),pe.PersonEntryId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
pe.PersonEntryId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when pe.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  PersonEntry  pe
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEntryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=0

UNION  ALL
--------------------------------------------------------实习生人员入项
SELECT  ('[HRCP]'+'实习生人员入项') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
pe.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeEntryDetail?id='+ CONVERT(VARCHAR(100),pe.PersonEntryId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
pe.PersonEntryId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when pe.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  PersonEntry  pe   
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEntryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=1

UNION  ALL
--------------------------------------------------------OnSite人员离项   涉及同意环节多人处理  
SELECT  ('[HRCP]'+'OnSite人员离项') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'name')  AS  ADDUSERNAME,
personInfo.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'OnSite/PersonInfoDetail?id='+ CONVERT(VARCHAR(100),personInfo.PersonInfoId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
personInfo.PersonInfoId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when personInfo.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top 1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,personInfo.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  PersonInfo  personInfo
INNER  JOIN  ProcessFlow  pf   ON  personInfo.PersonInfoId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where personInfo.IsTrainee=0

UNION  ALL
--------------------------------------------------------实习生人员离项   涉及同意环节多人处理  
SELECT  ('[HRCP]'+'实习生人员离项') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'name')  AS  ADDUSERNAME,
personInfo.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeInfoDetail?id='+ CONVERT(VARCHAR(100),personInfo.PersonInfoId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
personInfo.PersonInfoId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when personInfo.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top 1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,personInfo.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  PersonInfo  personInfo
INNER  JOIN  ProcessFlow  pf   ON  personInfo.PersonInfoId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where personInfo.IsTrainee=1


UNION  ALL
--------------------------------------------------------OnSite人员考评
SELECT  ('[HRCP]'+'OnSite人员考评') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
pe.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'OnSite/PersonEvaluateDetail?id='+ CONVERT(VARCHAR(100),pe.PersonEvaluateId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
pe.PersonEvaluateId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when pe.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  V_PersonEvaluate  pe
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEvaluateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=0

UNION  ALL
--------------------------------------------------------实习生人员考评
SELECT  ('[HRCP]'+'实习生人员考评') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
pe.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeInfoDetail?id='+ CONVERT(VARCHAR(100),pe.PersonEvaluateId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
pe.PersonEvaluateId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when pe.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  V_PersonEvaluate  pe
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEvaluateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=1



UNION  ALL
--------------------------------------------------------实习生论文审批
SELECT  ('[HRCP]'+'实习生论文审批') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(tt.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(tt.CreateBy,'name')  AS  ADDUSERNAME,
tt.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeThesisDetail?id='+ CONVERT(VARCHAR(100),tt.TraineeThesisId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
tt.TraineeThesisId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,   
(
	case when tt.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,tt.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  TraineeThesis  tt
INNER  JOIN  ProcessFlow  pf   ON  tt.TraineeThesisId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


--UNION  ALL
----------------------------------------------------------实习生银行信息
--SELECT  ('[HRCP]'+'实习生银行信息') AS  [SUBJECT],
--(
--CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.NotesAccount=pe.CreateBy)
-- WHEN   0 THEN ''
-- ELSE 
-- (SELECT  LOWER(RegionAccount) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.NotesAccount=pe.CreateBy)
-- END
--) AS   ADDUSERID,
--(
--CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.NotesAccount=pe.CreateBy)
--	WHEN  0   THEN  ''
--	ELSE  
--	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.NotesAccount=pe.CreateBy)  
--END
--)  AS  ADDUSERNAME,
--pe.CreateDate AS  APPLYTIME,  
--(
--CASE  (SELECT COUNT(LOWER(RegionAccount))  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.NotesAccount=pf.CurrentPerson)
--	WHEN  0   THEN  ''
--	ELSE  
--	(SELECT  LOWER(RegionAccount)  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.NotesAccount=pf.CurrentPerson)  
--END
--)  AS  AUTHORID,
--(
--CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.NotesAccount=pf.CurrentPerson)
--	WHEN  0   THEN  ''
--	ELSE  
--	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.NotesAccount=pf.CurrentPerson)  
--END
--)  AS  AUTHORNAME,
--((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeBankInfoDetail?id='+ CONVERT(VARCHAR(100),pe.PersonEvaluateId) +'&operateType=update&isforeip=true')  AS URL,
--'HRCP' AS SYSTEMID , 
--pe.PersonEvaluateId  AS  DOCUNID ,
--'' AS APPID,
--wf.WorkFlowId AS PROCESSID,
--wf.Name  AS  PROCESSNAME,  
--(
--	case when pe.DeleteFlag=0
--	then
--		CASE  
--		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
--		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
--		ELSE    'APPROVING'
--		END
--	else  'DELETED'
--	END
--) AS Status,
--( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
--'' AS  ASSIGNER, 
--(SELECT   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
--pf.CurrentNode AS  NODENAME,
--(CONVERT(datetime,pe.ModificationDate,20))  AS  [TIMESTAMP],   
--1 AS ACCEPTTYPE,
--'' AS REDIRECTURL,
--0 AS ISBATCH,
--0 AS isSM
--FROM  PersonEvaluate  pe
--INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEvaluateId=pf.ApprovalId
--INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
--INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
--------------------------------------------------------实习生证明办理
SELECT  ('[HRCP]'+'实习生证明办理') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(tc.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(tc.CreateBy,'name')  AS  ADDUSERNAME,
tc.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeCertificateDetail?id='+ CONVERT(VARCHAR(100),tc.TraineeCertificateId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
tc.TraineeCertificateId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when tc.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,tc.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  TraineeCertificate  tc
INNER  JOIN  ProcessFlow  pf   ON  tc.TraineeCertificateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION ALL
------------------------------------------------------------合作项目立项申请  
SELECT  ('[HRCP]'+'合作项目立项申请') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'name')  AS  ADDUSERNAME,
ps.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) +   '/Login/SSOLogin?taburl=' +'Project/ProjectSetupDetail?id='+ CONVERT(VARCHAR(100),ps.ProjectSetupId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
ps.ProjectSetupId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId  AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case  when  ps.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' or  pf.CurrentNode='立项不通过'  or  pf.CurrentNode='立项关闭'  or pf.CurrentNode='立项异常中止' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	end
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name=pf.CurrentNode AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS NODENAME,
(CONVERT(datetime,ps.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  ProjectSetup  ps
INNER  JOIN  ProcessFlow  pf   ON   ps.ProjectSetupId=pf.ApprovalId   
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
--------------------------------------------------------请假申请
SELECT  ('[HRCP]'+'请假申请') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(afl.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(afl.CreateBy,'name')  AS  ADDUSERNAME,
afl.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Attendance/ShowAskForLeaveDetail?askforleaveId='+ CONVERT(VARCHAR(100),afl.AskForLeaveId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
afl.AskForLeaveId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,  
(
	case when afl.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,afl.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  AskForLeave  afl
INNER  JOIN  ProcessFlow  pf   ON  afl.AskForLeaveId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
--------------------------------------------------------加班申请
SELECT  ('[HRCP]'+'加班申请') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(afo.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(afo.CreateBy,'name')  AS  ADDUSERNAME,
afo.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Attendance/ShowAskForOvertimeDetail?overtimeId='+ CONVERT(VARCHAR(100),afo.AskForOvertimeId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
afo.AskForOvertimeId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when afo.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,afo.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  AskForOvertime  afo
INNER  JOIN  ProcessFlow  pf   ON  afo.AskForOvertimeId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
--------------------------------------------------------工作日异常反馈
SELECT  ('[HRCP]'+'工作日异常反馈') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ar.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ar.CreateBy,'name')  AS  ADDUSERNAME,
ar.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Attendance/AbnormalDetail?abnormalId='+ CONVERT(VARCHAR(100),ar.AbnormalRecordId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
ar.AbnormalRecordId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when ar.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,ar.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  AbnormalRecord  ar
INNER  JOIN  ProcessFlow  pf   ON  ar.AbnormalRecordId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
------------------------------------------------------------------项目总结报告
SELECT  ('[HRCP]'+'项目总结报告') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'name')  AS  ADDUSERNAME,
ps.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Project/ProjectSummaryDetail?id='+ CONVERT(VARCHAR(100),ps.ProjectSummaryId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
ps.ProjectSummaryId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,  
(
	case when ps.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,ps.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  ProjectSummary  ps
INNER  JOIN  ProcessFlow  pf   ON  ps.ProjectSummaryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
----------------------------------------------------------项目异常中止
SELECT  ('[HRCP]'+'项目异常中止') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pee.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pee.CreateBy,'name')  AS  ADDUSERNAME,
pee.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Project/ProjectExceptionEndDetail?id='+ CONVERT(VARCHAR(100),pee.ProjectExceptionEndId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
pee.ProjectExceptionEndId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,  
(
	case when pee.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,pee.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  ProjectExceptionEnd  pee
INNER  JOIN  ProcessFlow  pf   ON  pee.ProjectExceptionEndId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
-----------------------------------------------------------进入研发区申请
SELECT  ('[HRCP]'+'进入研发区申请') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'name')  AS  ADDUSERNAME,
ppe.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Project/ProPersonEntryDetail?id='+ CONVERT(VARCHAR(100),ppe.ProjectPersonEntryId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
ppe.ProjectPersonEntryId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,   
(
	case when ppe.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,ppe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM    ProjectPersonEntry  ppe
INNER  JOIN  ProcessFlow  pf   ON  ppe.ProjectPersonEntryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
----------------------------------------------------------------项目人员离项
SELECT  ('[HRCP]'+'项目人员离项') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ppi.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ppi.CreateBy,'name')  AS  ADDUSERNAME,
ppi.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Project/ProPersonInfoDetail?id='+ CONVERT(VARCHAR(100),ppi.ProjectPersonInfoId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
ppi.ProjectPersonInfoId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,   
(
	case when ppi.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,ppi.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  ProjectPersonInfo  ppi
INNER  JOIN  ProcessFlow  pf   ON  ppi.ProjectPersonInfoId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION  ALL
----------------------------------------------------------------项目人员考评
SELECT  ('[HRCP]'+'项目人员考评') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'name')  AS  ADDUSERNAME,
ppe.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Project/ProPersonEvaluateDetail?id='+ CONVERT(VARCHAR(100),ppe.ProjectPersonEvaluateId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
ppe.ProjectPersonEvaluateId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,  
(
	case when ppe.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,ppe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  ProjectPersonEvaluate  ppe
INNER  JOIN  ProcessFlow  pf   ON  ppe.ProjectPersonEvaluateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
------------------------------------------------------------------项目验收报告
SELECT  ('[HRCP]'+'项目检查报告') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pcr.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pcr.CreateBy,'name')  AS  ADDUSERNAME,
pcr.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Project/CooperateProjectCheck?checkreportId='+ CONVERT(VARCHAR(100),pcr.ProjectCheckReportId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
pcr.ProjectCheckReportId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case when pcr.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  pf.CurrentNode=wfn.Name AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode AS  NODENAME,
(CONVERT(datetime,pcr.ModifierTime,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM
FROM  ProjectCheckReport  pcr
INNER  JOIN  ProcessFlow  pf   ON  pcr.ProjectCheckReportId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId



UNION  ALL
---------------------------------------------------------------------项目付款管理
SELECT  ('[HRCP]'+'项目付款管理') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pr.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pr.CreateBy,'name')  AS  ADDUSERNAME,
pr.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name')   AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Expenses/PayConfirmDetail?payReportId='+ CONVERT(VARCHAR(100),pr.PayReportId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
pr.PayReportId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId  AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,   
(
	case  when  pr.DeleteFlag=0
	then
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else 'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name=pf.CurrentNode AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode  AS  NODENAME,
(CONVERT(datetime,pr.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  PayReport  pr
INNER  JOIN  ProcessFlow  pf   ON   pr.PayReportId=pf.ApprovalId   
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
-------------------------------------------------------实习生付款管理 
SELECT  ('[HRCP]'+'实习生付款管理') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(est.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(est.CreateBy,'name')  AS  ADDUSERNAME,
est.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name')   AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Expenses/ExpenseSettlementDetail?settlementid='+ CONVERT(VARCHAR(100),est.ExpenseSettlementDetailId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
est.ExpenseSettlementDetailId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME,  
(
	case  when  est.DeleteFlag=0
	then 
		CASE  
		WHEN  pf.CurrentNode='流程结束' or  pf.CurrentNode= '流程关闭' THEN  'APPROVED'
		WHEN  CHARINDEX('01',pf.CurrentNode)>0    THEN  'WAITING'
		ELSE    'APPROVING'
		END
	else 'DELETED'
	end
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT  top  1  wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name=pf.CurrentNode AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
pf.CurrentNode  AS  NODENAME,
(CONVERT(datetime,est.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  ExpenseSettlementDetail   est
INNER  JOIN  ProcessFlow  pf   ON   est.ExpenseSettlementDetailId=pf.ApprovalId   
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId














GO


