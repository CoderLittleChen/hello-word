--{
--    "systemId": "HRCP",
--    "appid": "",
--    "docunId": "8fb7185c-f94d-4a2b-96e3-fbf05ffd56f5",
--    "subject": "[HRCP]竞争战略部（蓝军部）OnSite需求申请",
--    "nodeName": "05.一级部门审批",
--    "nodeId": "7d26f41b-ddf6-44c0-ad34-bacef243180b",
--    "addUserId": "lkf6850",
--    "addUserName": "liuyujing",
--    "applyTime": "2019-08-14",
--    "authorId": "d06481",
--    "authorName": "段锦",
--    "url": "http://hrcp.h3c.com/Login/SSOLogin",
--    "processId": "8e5d8253-e386-4242-9b58-2fa1902fe4ab",
--    "processName": "recruitReqApply",
--    "endUserId": "lkf6850,lkf6850,lkf6850,lkf6850",
--    "status": "审批中",
--    "timeStamp": "2019-09-18 17:10:01",
--    "isBatch": "0",
--    "acceptType": "1",
--    "redirectUrl": "",
--    "assigner": "",
--    "isSMS": "0"
----}

--SUBJECT	Y	varchar	N	主题
--ADDUSERID	Y	varchar	N	申请人id（域账号）
--ADDUSERNAME	Y	varchar	N	申请人姓名（中文名）
--APPLYTIME	Y	varchar	N	申请时间
--AUTHORID	Y	varchar	N	当前处理人id（被委托人）（域账号）
--AUTHORNAME	Y	varchar	N	当前处理人（被委托人）姓名
--URL	Y	varchar	N	PC端文档访问链接
--SYSTEMID	Y	varchar	Y	系统id（如IBPM、ERP）
--DOCUNID	Y	varchar	Y	文档id（主键Id）
--APPID	N	varchar	N	应用id（流程应用分类id）
--PROCESSID	Y	varchar	Y	流程id（流程分类对应id）
--PROCESSNAME	Y	varchar	N	流程名称（流程分类，如请假，加班流程）
--STATUS	Y	varchar	N	状态(WAITING/APPROVING/APPROVED) (待提交/审批中/完成)
--ENDUSERID	Y	varchar	N	已处理用户id（多个用户用逗号“,”分隔）（域账号）
--ASSIGNER	N	varchar	N	委托人
--NODEID	Y	varchar	N	节点id
--NODENAME	Y	varchar	N	节点名称 （当前办理状态）
--TIMESTAMP	Y	varchar	N	时间戳（最后更新时间字符串）格式：yyyy-MM-dd HH:mm:ss 
--ACCEPTTYPE	Y	varchar	N	接入类型    1(只PC端) ，2( 只移动端)，3(PC和移动端都可以)
--REDIRECTURL	Y	varchar	N	移动端重定向url
--ISBATCH	Y	varchar	N	能否批量处理（1是\0否）


select  *   from   WorkFlow  a;

select  *   from   ProcessFlow  a;

select  *   from   WorkFlowInstance   a;

select  a.TurnPerson,a.Dept2MgrTurnOther,a.CooMgrTurnOther,*   from   RecruitReqApply  a;

--select  case '1' as  'dsa';
Select CONVERT(varchar(100), GETDATE(), 20);
select  *   from  VEmployee   a;






