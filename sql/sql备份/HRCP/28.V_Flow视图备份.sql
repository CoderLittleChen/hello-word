USE [hrcp]
GO

/****** Object:  View [dbo].[V_Flow]    Script Date: 2019/10/10 9:41:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








ALTER  VIEW   [dbo].[V_Flow]  AS  
--OnSite需求申请
SELECT  ('[HRCP]'+'OnSite需求申请') AS  [SUBJECT],
(
CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=req.CreateBy)
 WHEN   0 THEN ''
 ELSE 
 (SELECT  LOWER(RegionAccount) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=req.CreateBy)
 END
) AS   ADDUSERID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=req.CreateBy)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=req.CreateBy)  
END
)  AS  ADDUSERNAME,
req.CreateTime AS  APPLYTIME,  
(
CASE  (SELECT COUNT(LOWER(RegionAccount))  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pf.CurrentPerson)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT  LOWER(RegionAccount)  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pf.CurrentPerson)  
END
)  AS  AUTHORID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pf.CurrentPerson)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pf.CurrentPerson)  
END
)  AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'OnSite/RecruitReqDetail?id='+ CONVERT(VARCHAR(100), req.ReqcruitReqApplyId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
req.ReqcruitReqApplyId  AS  DOCUNID ,
'' AS APPID,
pf.ProcessFlowId  AS PROCESSID,
wf.Name  AS  PROCESSNAME, 
(
	case  when   req.DeleteFlag=0
	then  
		CASE  pf.CurrentNode
		WHEN  '流程结束' THEN  'APPROVED'
		WHEN  '05.一级部门审批'  THEN  'APPROVING'
		ELSE    'WAITING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name='05.一级部门审批' AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
('05.一级部门审批')  AS NODENAME,
(CONVERT(varchar(100),req.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  RecruitReqApply  req
INNER  JOIN  ProcessFlow  pf   ON  req.ReqcruitReqApplyId=pf.ApprovalId --and  pf.CurrentNode='05.一级部门审批'
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
--实习生需求申请
SELECT  ('[HRCP]'+'实习生人员报批') AS  [SUBJECT],
(
CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=psa.CreateBy)
 WHEN   0 THEN ''
 ELSE 
 (SELECT  LOWER(RegionAccount) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=psa.CreateBy)
 END
) AS   ADDUSERID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=psa.CreateBy)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=psa.CreateBy)  
END
)  AS  ADDUSERNAME,
psa.CreateDate AS  APPLYTIME,  
(
CASE  (SELECT COUNT(LOWER(RegionAccount))  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pf.CurrentPerson)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT  LOWER(RegionAccount)  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pf.CurrentPerson)  
END
)  AS  AUTHORID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pf.CurrentPerson)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pf.CurrentPerson)  
END
)  AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Trainee/TraineeApprovalDetail?id='+ CONVERT(VARCHAR(100),psa.PersonSubmitApprovalId) +'&operateType=update&isforeip=true')  AS URL,
'HRCP' AS SYSTEMID , 
psa.PersonSubmitApprovalId  AS  DOCUNID ,
'' AS APPID,
pf.ProcessFlowId  AS PROCESSID,
wf.Name  AS  PROCESSNAME,  
(
	case when psa.DeleteFlag=0
	then
		CASE  pf.CurrentNode
		WHEN  '流程结束' THEN  'APPROVED'
		WHEN  '02.一级部门主管审批'  THEN  'APPROVING'
		ELSE    'WAITING'
		END
	else  'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name='02.一级部门主管审批' AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
('02.一级部门主管审批') AS  NODENAME,
(CONVERT(varchar(100),psa.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  PersonSubmitApproval  psa
INNER  JOIN  ProcessFlow  pf   ON  psa.PersonSubmitApprovalId=pf.ApprovalId --and  pf.CurrentNode='02.一级部门主管审批'
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId


UNION ALL
--项目立项申请  研发总裁 
SELECT  ('[HRCP]'+'合作项目立项申请') AS  [SUBJECT],
(
CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=ps.CreateBy)
 WHEN   0 THEN ''
 ELSE 
 (SELECT  LOWER(RegionAccount) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=ps.CreateBy)
 END
) AS   ADDUSERID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=ps.CreateBy)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=ps.CreateBy)  
END
)  AS  ADDUSERNAME,
ps.CreateDate AS  APPLYTIME,  
(
CASE  (SELECT COUNT(LOWER(RegionAccount))  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pf.CurrentPerson)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT  LOWER(RegionAccount)  FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pf.CurrentPerson)  
END
)  AS  AUTHORID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pf.CurrentPerson)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pf.CurrentPerson)  
END
)  AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) +   '/Login/SSOLogin?taburl=' +'Project/ProjectSetupDetail?id='+ CONVERT(VARCHAR(100),ps.ProjectSetupId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
ps.ProjectSetupId  AS  DOCUNID ,
'' AS APPID,
pf.ProcessFlowId  AS PROCESSID,
wf.Name  AS  PROCESSNAME, 
(
	case  when  ps.DeleteFlag=0
	then
		CASE  pf.CurrentNode
		WHEN  '流程结束' THEN  'APPROVED'
		WHEN  '07.研发总裁审批'  THEN  'APPROVING'
		ELSE    'WAITING'
		END
	else  'DELETED'
	end
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name='07.研发总裁审批' AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
('07.研发总裁审批') AS NODENAME,
(CONVERT(varchar(100),ps.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  ProjectSetup  ps
INNER  JOIN  ProcessFlow  pf   ON   ps.ProjectSetupId=pf.ApprovalId   --and  pf.CurrentNode='07.研发总裁审批'
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
----项目付款管理
SELECT  ('[HRCP]'+'项目付款管理') AS  [SUBJECT],
(
CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pr.CreateBy)
 WHEN   0 THEN ''
 ELSE 
 (SELECT  LOWER(RegionAccount) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=pr.CreateBy)
 END
) AS   ADDUSERID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pr.CreateBy)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=pr.CreateBy)  
END
)  AS  ADDUSERNAME,
pr.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name')   AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Expenses/PayConfirmDetail?payReportId='+ CONVERT(VARCHAR(100),pr.PayReportId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
pr.PayReportId  AS  DOCUNID ,
'' AS APPID,
pf.ProcessFlowId  AS PROCESSID,
wf.Name  AS  PROCESSNAME,  
(
	case  when  pr.DeleteFlag=0
	then
		CASE  pf.CurrentNode
		WHEN  '流程结束' THEN  'APPROVED'
		WHEN  '一级部门权签人审核'  THEN  'APPROVING'
		ELSE    'WAITING'
		END
	else 'DELETED'
	END
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name='一级部门权签人审核' AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
('一级部门权签人审核') AS  NODENAME,
(CONVERT(varchar(100),pr.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  PayReport  pr
INNER  JOIN  ProcessFlow  pf   ON   pr.PayReportId=pf.ApprovalId   --and  pf.CurrentNode='一级部门权签人审核'
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId

UNION  ALL
----OnSite/实习生付款管理
SELECT  ('[HRCP]'+'OnSite/实习生付款管理') AS  [SUBJECT],
(
CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=est.CreateBy)
 WHEN   0 THEN ''
 ELSE 
 (SELECT  LOWER(RegionAccount) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.Code=est.CreateBy)
 END
) AS   ADDUSERID,
(
CASE  (SELECT COUNT(Name)  FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=est.CreateBy)
	WHEN  0   THEN  ''
	ELSE  
	(SELECT Name    FROM  VEmployee  d  WHERE LOWER(d.ChnNamePY)+' '+d.Code=est.CreateBy)  
END
)  AS  ADDUSERNAME,
est.CreateDate AS  APPLYTIME,  
dbo.F_GetRegionAccount(pf.CurrentPerson,'region')  AS  AUTHORID,
dbo.F_GetRegionAccount(pf.CurrentPerson,'name')   AS  AUTHORNAME,
((select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl')) + '/Login/SSOLogin?taburl=' +'Expenses/ExpenseSettlementDetail?settlementid='+ CONVERT(VARCHAR(100),est.ExpenseSettlementDetailId) +'&operateType=update&isforeip=true') AS  URL,
'HRCP' AS SYSTEMID , 
est.ExpenseSettlementDetailId  AS  DOCUNID ,
'' AS APPID,
pf.ProcessFlowId  AS PROCESSID,
wf.Name  AS  PROCESSNAME,  
(
	case  when  est.DeleteFlag=0
	then 
		CASE  pf.CurrentNode
		WHEN  '流程结束' THEN  'APPROVED'
		WHEN  '一级部门主管审批'  THEN  'APPROVING'
		ELSE    'WAITING'
		END
	else 'DELETED'
	end
) AS Status,
( STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(wfr.Approvaler,1,1)+SUBSTRING(wfr.Approvaler,CHARINDEX(' ',wfr.Approvaler)+1,6))  ) FROM WorkFlowTask  wft  INNER  JOIN   WorkFlowRecord wfr   ON  wfr.WorkFlowTaskId=wft.WorkFlowTaskId  WHERE  wft.WorkFlowInstanceId=wfi.WorkFlowInstanceId  AND  wft.NodeName!=pf.CurrentNode    FOR XML PATH('')),1, 1, '') )AS ENDUSERID,
'' AS  ASSIGNER, 
(SELECT   wfn.NodeId   FROM  WorkFlowNode   wfn   WHERE  wfn.Name='一级部门主管审批' AND  wfn.WorkFlowId=wfi.WorkFlowId ) AS NODEID,
('一级部门主管审批') AS  NODENAME,
(CONVERT(varchar(100),est.ModificationDate,20))  AS  [TIMESTAMP],
1 AS ACCEPTTYPE,
'' AS REDIRECTURL,
0 AS ISBATCH,
0 AS isSMS
FROM  ExpenseSettlementDetail   est
INNER  JOIN  ProcessFlow  pf   ON   est.ExpenseSettlementDetailId=pf.ApprovalId   --and  pf.CurrentNode='一级部门主管审批'
INNER  JOIN  WorkFlowInstance  wfi  ON   pf.WorkFlowInstanceId=wfi.WorkFlowInstanceId
INNER  JOIN  WorkFlow  wf  ON  wfi.WorkFlowId=wf.WorkFlowId












GO


