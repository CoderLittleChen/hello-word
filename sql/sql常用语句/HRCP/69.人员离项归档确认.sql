
--��Ա����鵵
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '��Ա����鵵ȷ��' AS FlowType, 
                'OnSite��������||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                info.ProcessFlowId, '��Ա����鵵ȷ��' AS CurrentNode,(SELECT OnSiteFileConfirm FROM AreaConfig WHERE WorkPlace=info.WorkPlace) AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����' and ISNULL(LeaveConfirmSign,'')='' and ISNULL(LeaveCooSign,'')!='' and IsTrainee=0

UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '��Ա����鵵' AS FlowType, 
                'OnSite��������||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                info.ProcessFlowId, '��Ա����鵵' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����' and ISNULL(LeaveAgreeSign,'')='' and IsTrainee=0



--��Ա����鵵ȷ��   
SELECT   NEWID() AS Id, pinfo.PersonInfoId AS ToDoId, pinfo.EmployeeName AS Content, 'OnSite��Ա����' AS FlowType, 
                'OnSite��������||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, pf.CurrentNode, 
                pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonInfo pinfo ON pf.ApprovalId = pinfo.PersonInfoId
WHERE   pinfo.IsTrainee = 0 AND pinfo.DeleteFlag = 0 AND pinfo.OnJobStatus = 1 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pinfo.PersonInfoId AS ToDoId, pinfo.EmployeeName AS Content, 'ʵϰ����Ա����' AS FlowType, 
                'ʵϰ����������||Trainee/TraineeInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonInfo pinfo ON pf.ApprovalId = pinfo.PersonInfoId
WHERE   pinfo.IsTrainee = 1 AND pinfo.DeleteFlag = 0 AND pinfo.OnJobStatus = 1 AND pf.DeleteFlag = 0


SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, 'ʵϰ������鵵' AS FlowType, 
                'ʵϰ�����Ϲ鵵||Trainee/TraineeDocumentDetail?id=hrcpid' AS FlowUrl, 
                info.ProcessFlowId, 'ʵϰ������鵵' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����'  and IsTrainee=1


select  a.ApplySign,a.CreateBy,*   from  PersonInfo a  where    a.IsTrainee=0;

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