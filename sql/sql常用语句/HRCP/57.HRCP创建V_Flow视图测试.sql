--{
--    "systemId": "HRCP",
--    "appid": "",
--    "docunId": "8fb7185c-f94d-4a2b-96e3-fbf05ffd56f5",
--    "subject": "[HRCP]����ս�Բ�����������OnSite��������",
--    "nodeName": "05.һ����������",
--    "nodeId": "7d26f41b-ddf6-44c0-ad34-bacef243180b",
--    "addUserId": "lkf6850",
--    "addUserName": "liuyujing",
--    "applyTime": "2019-08-14",
--    "authorId": "d06481",
--    "authorName": "�ν�",
--    "url": "http://hrcp.h3c.com/Login/SSOLogin",
--    "processId": "8e5d8253-e386-4242-9b58-2fa1902fe4ab",
--    "processName": "recruitReqApply",
--    "endUserId": "lkf6850,lkf6850,lkf6850,lkf6850",
--    "status": "������",
--    "timeStamp": "2019-09-18 17:10:01",
--    "isBatch": "0",
--    "acceptType": "1",
--    "redirectUrl": "",
--    "assigner": "",
--    "isSMS": "0"
----}

--SUBJECT	Y	varchar	N	����
--ADDUSERID	Y	varchar	N	������id�����˺ţ�
--ADDUSERNAME	Y	varchar	N	��������������������
--APPLYTIME	Y	varchar	N	����ʱ��
--AUTHORID	Y	varchar	N	��ǰ������id����ί���ˣ������˺ţ�
--AUTHORNAME	Y	varchar	N	��ǰ�����ˣ���ί���ˣ�����
--URL	Y	varchar	N	PC���ĵ���������
--SYSTEMID	Y	varchar	Y	ϵͳid����IBPM��ERP��
--DOCUNID	Y	varchar	Y	�ĵ�id������Id��
--APPID	N	varchar	N	Ӧ��id������Ӧ�÷���id��
--PROCESSID	Y	varchar	Y	����id�����̷����Ӧid��
--PROCESSNAME	Y	varchar	N	�������ƣ����̷��࣬����٣��Ӱ����̣�
--STATUS	Y	varchar	N	״̬(WAITING/APPROVING/APPROVED) (���ύ/������/���)
--ENDUSERID	Y	varchar	N	�Ѵ����û�id������û��ö��š�,���ָ��������˺ţ�
--ASSIGNER	N	varchar	N	ί����
--NODEID	Y	varchar	N	�ڵ�id
--NODENAME	Y	varchar	N	�ڵ����� ����ǰ����״̬��
--TIMESTAMP	Y	varchar	N	ʱ�����������ʱ���ַ�������ʽ��yyyy-MM-dd HH:mm:ss 
--ACCEPTTYPE	Y	varchar	N	��������    1(ֻPC��) ��2( ֻ�ƶ���)��3(PC���ƶ��˶�����)
--REDIRECTURL	Y	varchar	N	�ƶ����ض���url
--ISBATCH	Y	varchar	N	�ܷ���������1��\0��


select  *   from   WorkFlow  a;

select  *   from   ProcessFlow  a;

select  *   from   WorkFlowInstance   a;

select  a.TurnPerson,a.Dept2MgrTurnOther,a.CooMgrTurnOther,*   from   RecruitReqApply  a;

--select  case '1' as  'dsa';
Select CONVERT(varchar(100), GETDATE(), 20);
select  *   from  VEmployee   a;






