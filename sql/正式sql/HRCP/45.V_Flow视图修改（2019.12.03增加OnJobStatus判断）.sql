USE [hrcp]
GO

/****** Object:  View [dbo].[V_Flow]    Script Date: 2019/12/3 17:25:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER  VIEW   [dbo].[V_Flow]  AS  
---------------------------------------------------OnSite��������
SELECT  ('[HRCP]'+'OnSite��������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(req.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(req.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),req.CreateTime,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),req.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  RecruitReqApply  req
INNER  JOIN  ProcessFlow  pf   ON  req.ReqcruitReqApplyId=pf.ApprovalId 
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  req.IsTrainee=0  and  req.DeleteFlag=0  and pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------ʵϰ����������--------------
SELECT  ('[HRCP]'+'ʵϰ����������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(req.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(req.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),req.CreateTime,20)) AS  APPLYTIME,  
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccountByUserInfo(pf.CurrentPerson,'name') AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'OnSite/TraineeRequireDetail?id='+ CONVERT(VARCHAR(100), req.ReqcruitReqApplyId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
req.ReqcruitReqApplyId  AS  DOCUNID ,
'' AS APPID,
wf.WorkFlowId  AS PROCESSID,
dbo.F_GetWorkFlowCNName(wf.Name)  AS  PROCESSNAME, 
(
	case  when   req.DeleteFlag=0
	then  
		CASE  
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),req.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  RecruitReqApply  req
INNER  JOIN  ProcessFlow  pf   ON  req.ReqcruitReqApplyId=pf.ApprovalId 
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  req.IsTrainee=1  and  req.DeleteFlag=0  and pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------OnSite��Ա����
SELECT  ('[HRCP]'+'OnSite��Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pe.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  PersonEntry  pe
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEntryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=0  and  pe.DeleteFlag=0  and pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------ʵϰ����Ա����
SELECT  ('[HRCP]'+'ʵϰ����Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pe.CreateDate,20))  AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  PersonEntry  pe   
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEntryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=1 and pe.DeleteFlag=0  and  pf.DeleteFlag=0


UNION  ALL
--------------------------------------------------------OnSite��Ա����   �漰ͬ�⻷�ڶ��˴���  
SELECT  ('[HRCP]'+'OnSite��Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),personInfo.CreateDate,20))  AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),personInfo.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  PersonInfo  personInfo
INNER  JOIN  ProcessFlow  pf   ON  personInfo.PersonInfoId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where personInfo.IsTrainee=0  and personInfo.DeleteFlag=0   and  personInfo.OnJobStatus=1  and  pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------ʵϰ����Ա����   �漰ͬ�⻷�ڶ��˴���  
SELECT  ('[HRCP]'+'ʵϰ����Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(personInfo.ApplySign,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),personInfo.CreateDate,20))  AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),personInfo.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  PersonInfo  personInfo
INNER  JOIN  ProcessFlow  pf   ON  personInfo.PersonInfoId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where personInfo.IsTrainee=1  and personInfo.DeleteFlag=0   and  personInfo.OnJobStatus=1  and  pf.DeleteFlag=0


UNION  ALL
--------------------------------------------------------OnSite��Ա����
SELECT  ('[HRCP]'+'OnSite��Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pe.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  V_PersonEvaluate  pe
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEvaluateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=0 and pe.DeleteFlag=0   and pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------ʵϰ����Ա����
SELECT  ('[HRCP]'+'ʵϰ����Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pe.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pe.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  V_PersonEvaluate  pe
INNER  JOIN  ProcessFlow  pf   ON  pe.PersonEvaluateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pe.IsTrainee=1  and pe.DeleteFlag=0   and  pf.DeleteFlag=0



UNION  ALL
--------------------------------------------------------ʵϰ����������
SELECT  ('[HRCP]'+'ʵϰ����������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(tt.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(tt.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),tt.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(20),tt.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  TraineeThesis  tt
INNER  JOIN  ProcessFlow  pf   ON  tt.TraineeThesisId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  tt.DeleteFlag=0  and pf.DeleteFlag=0

--UNION  ALL
----------------------------------------------------------ʵϰ��������Ϣ
--SELECT  ('[HRCP]'+'ʵϰ��������Ϣ') AS  [SUBJECT],
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
--		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
--------------------------------------------------------ʵϰ��֤������
SELECT  ('[HRCP]'+'ʵϰ��֤������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(tc.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(tc.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),tc.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),tc.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  TraineeCertificate  tc
INNER  JOIN  ProcessFlow  pf   ON  tc.TraineeCertificateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where tc.DeleteFlag=0   and pf.DeleteFlag=0

UNION ALL
------------------------------------------------------------������Ŀ��������  
SELECT  ('[HRCP]'+'������Ŀ��������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),ps.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' or  pf.CurrentNode='���ͨ��'  or  pf.CurrentNode='����ر�'  or pf.CurrentNode='�����쳣��ֹ' THEN  'APPROVED'
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
(CONVERT(varchar(50),ps.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  ProjectSetup  ps
INNER  JOIN  ProcessFlow  pf   ON   ps.ProjectSetupId=pf.ApprovalId   
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  ps.DeleteFlag=0   and  pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------�������
SELECT  ('[HRCP]'+'�������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(afl.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(afl.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),afl.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),afl.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  AskForLeave  afl
INNER  JOIN  ProcessFlow  pf   ON  afl.AskForLeaveId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where afl.DeleteFlag=0   and  pf.DeleteFlag=0 

UNION  ALL
--------------------------------------------------------�Ӱ�����
SELECT  ('[HRCP]'+'�Ӱ�����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(afo.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(afo.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),afo.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),afo.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  AskForOvertime  afo
INNER  JOIN  ProcessFlow  pf   ON  afo.AskForOvertimeId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where afo.DeleteFlag=0   and pf.DeleteFlag=0

UNION  ALL
--------------------------------------------------------ʵϰ����Ա����
SELECT  ('[HRCP]'+'ʵϰ����Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(psa.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(psa.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),psa.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),psa.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  PersonSubmitApproval  psa
INNER  JOIN  ProcessFlow  pf   ON  psa.PersonSubmitApprovalId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  psa.DeleteFlag=0   and  pf.DeleteFlag=0  and  psa.IsTrainee=1


UNION  ALL
--------------------------------------------------------�������쳣����
SELECT  ('[HRCP]'+'�������쳣����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ar.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ar.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),ar.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),ar.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  AbnormalRecord  ar
INNER  JOIN  ProcessFlow  pf   ON  ar.AbnormalRecordId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
INNER JOIN AttendanceAbnormalDetail aa ON ar.AbnormalRecordId=aa.AbnormalRecordId
where  ar.DeleteFlag=0  and  ar.DayType=1    and   pf.DeleteFlag=0   and aa.CancelStatus=0

UNION  ALL
------------------------------------------------------------------��Ŀ�ܽᱨ��
SELECT  ('[HRCP]'+'��Ŀ�ܽᱨ��') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ps.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),ps.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),ps.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  ProjectSummary  ps
INNER  JOIN  ProcessFlow  pf   ON  ps.ProjectSummaryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  ps.DeleteFlag=0  and pf.DeleteFlag=0


UNION  ALL
----------------------------------------------------------��Ŀ�쳣��ֹ
SELECT  ('[HRCP]'+'��Ŀ�쳣��ֹ') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pee.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pee.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pee.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pee.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  ProjectExceptionEnd  pee
INNER  JOIN  ProcessFlow  pf   ON  pee.ProjectExceptionEndId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where pee.DeleteFlag=0   and  pf.DeleteFlag=0


UNION  ALL
-----------------------------------------------------------�����з�������
SELECT  ('[HRCP]'+'�����з�������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),ppe.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),ppe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM    ProjectPersonEntry  ppe
INNER  JOIN  ProcessFlow  pf   ON  ppe.ProjectPersonEntryId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where   ppe.DeleteFlag=0   and pf.DeleteFlag=0  


UNION  ALL
----------------------------------------------------------------��Ŀ��Ա����
SELECT  ('[HRCP]'+'��Ŀ��Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ppi.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ppi.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),ppi.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),ppi.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  ProjectPersonInfo  ppi
INNER  JOIN  ProcessFlow  pf   ON  ppi.ProjectPersonInfoId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  ppi.DeleteFlag=0  and  ppi.IsOnDuty=0  and pf.DeleteFlag=0


UNION  ALL
----------------------------------------------------------------��Ŀ��Ա����
SELECT  ('[HRCP]'+'��Ŀ��Ա����') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(ppe.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),ppe.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),ppe.ModificationDate,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  ProjectPersonEvaluate  ppe
INNER  JOIN  ProcessFlow  pf   ON  ppe.ProjectPersonEvaluateId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where ppe.DeleteFlag=0   and  pf.DeleteFlag=0

UNION  ALL
------------------------------------------------------------------��Ŀ���ձ���
SELECT  ('[HRCP]'+'��Ŀ��鱨��') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pcr.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pcr.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pcr.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pcr.ModifierTime,20))  AS  [TIMESTAMP],   
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSM,
'' As  MAILDAILY
FROM  ProjectCheckReport  pcr
INNER  JOIN  ProcessFlow  pf   ON  pcr.ProjectCheckReportId=pf.ApprovalId
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where   pcr.DeleteFlag=0   and pf.DeleteFlag=0


UNION  ALL
---------------------------------------------------------------------��Ŀ�������
SELECT  ('[HRCP]'+'��Ŀ�������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(pr.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(pr.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),pr.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),pr.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  PayReport  pr
INNER  JOIN  ProcessFlow  pf   ON   pr.PayReportId=pf.ApprovalId   
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  pr.DeleteFlag=0  and  pf.DeleteFlag=0


UNION  ALL
-------------------------------------------------------ʵϰ��������� 
SELECT  ('[HRCP]'+'ʵϰ���������') AS  [SUBJECT],
dbo.F_GetRegionAccountByUserInfo(est.CreateBy,'region') AS   ADDUSERID,
dbo.F_GetRegionAccountByUserInfo(est.CreateBy,'name')  AS  ADDUSERNAME,
(CONVERT(varchar(50),est.CreateDate,20)) AS  APPLYTIME,  
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
		WHEN  pf.CurrentNode='���̽���' or  pf.CurrentNode= '���̹ر�' THEN  'APPROVED'
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
(CONVERT(varchar(50),est.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS,
'' As  MAILDAILY
FROM  ExpenseSettlementDetail   est
INNER  JOIN  ProcessFlow  pf   ON   est.ExpenseSettlementDetailId=pf.ApprovalId   
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId
where  est.DeleteFlag=0   and pf.DeleteFlag=0


GO


