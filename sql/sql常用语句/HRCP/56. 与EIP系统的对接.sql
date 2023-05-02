--问题：
--2、这里拼接url很关键  用户要通过这个来进行跳转审批  
--4、查询员工姓名 速度很慢   函数重载  或者重新写一个  
--6、插入日志有问题   原因不明
--8、用户跳转审批结束之后  调用接口  更新待办数据   同时调用js  关闭当前页面  返回审批结果
--9、OnSite做完之后 还有实习生   项目立项申请   付款管理  这个几个表单都需要写
--10、怎样判断js调用是否成功？ PM.Send()    主要是在Pubjs.js中获取链接中的参数
--13、视图中也需要添加url   拼接    完成   
--14、点击链接可以跳转到详情页面，但是链接中的参数变了 是为什么？无法知道是不是从eip跳转过来    解决参数错误的问题   就可以拿到链接中的值    
--然后调用eip.js  回传消息    
--15、当进行转其他人处理的时候  也需要调用接口  更新数据    
--17、包括转其他人处理  以及  返回申请人  都要进行处理   
--18、五个表单  加上对ModifyDate的更新  
--19、修改视图中的url地址  以及TIMESTAMP的值  
--20、Over中加order  by和  在sql语句末尾加order  by  的区别




--1、流程涉及到一级部门主管   生成待办记录   
--05.一级部门审批

select  *  from  WorkFlow  a;
select   a.DeptLevel2,a.CreateBy,*  from  RecruitReqApply   a;
select  *  from  ProcessFlow  a;
select  *  from  WorkFlowNode   a;
select  *  from  V_RecruitReqApplyList   a;
select  a.EmployeeName,a.NotesId,a.WorkNum,*  from  PersonInfo  a;
select  *  from VEmployee a  where  a.Code='kf6850';
select  *  from  Loginfo  a  order by  a.LogTime desc;
select  *  from  V_FlowRecord a;
select  *  from  Department  a  where  a.Code='50041364';
select  *  from  RecruitReqApply  a  where  a.ReqcruitReqApplyId='c7e11c26-ef2a-433f-9e2d-f4ff4718df85';
select  *  from  ProcessFlow   a   where  a.ApprovalId='c7e11c26-ef2a-433f-9e2d-f4ff4718df85';
select  *  from  WorkFlow  a  where   a.WorkFlowId='695774A3-C997-4B7C-A68F-F71646CC43AD';
select  a.DeptLevel2,*  from  ProjectSetup a;
select  *  from  WorkFlowNode  a   where   a.WorkFlowId='2545F8A1-9920-4464-97E5-50790393663F';
select  *  from  WorkFlowNode  a   where   a.Name='02.一级部门主管审批';

select  *  from  ProcessFlow   a  where  a.ApprovalId='8fb7185c-f94d-4a2b-96e3-fbf05ffd56f5';
select  *  from  WorkFlowInstance  a   where   a.WorkFlowInstanceId='3E55389E-32B5-48C8-B513-83E17E17B0D2';
select  *  from  WorkFlowTask  a  where  a.WorkFlowInstanceId='3E55389E-32B5-48C8-B513-83E17E17B0D2'  for  xml path;
select  *  from  PayReport  a  ;
select  a.ModificationDate,a.Modifier,*  from  RecruitReqApply   a  where  a.RecruitNo='20190050';

select  a.CurrentLevel,*   from   PersonInfo    a;

--duanjin 06481
--huanglanting kf7324

select   LOWER(SUBSTRING('duanjin 06481',1,1)+SUBSTRING('duanjin 06481',CHARINDEX(' ','duanjin 06481')+1,6))
select   SUBSTRING('duanjin 06481',CHARINDEX(' ','duanjin 06481')+1,5)
d06481
--STUFF
--(
--	(
--		SELECT   ',' + lower(s.RegionAccount)   FROM 
--		(select distinct isnull(AgentAccount,OwnerAccount) RegionAccount from  CTS_LNK.CTS_BPM.dbo.BPMInstProcSteps where TASKID = WHR.TASKID and HumanStep = 1 AND FinishAt IS not NULL) s  FOR XML PATH('')
--	), 1, 1, ''
--)  as ENDUSERID,
 
--2、SSO登录验证   在拼接url的时候  直接调用SSOLogin()方法     来进行验证          
--例如  --http://icms-test.h3c.com:8000/Login/SSOLogin?taburl=ImportantBureau/MajorBureau/MajorBureauDetail?Process=update&Type=Detail&taskid=2164&isforeip=true
--OnSite  PositionCopyLink()  方法 
--liqianqian 12284
--http://hrcp.h3c.com/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=82371bca-7e2d-437e-8d38-c96145d28334&operateType=create&isforeip=true
--10.18.192.250/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=82371bca-7e2d-437e-8d38-c96145d28334&operateType=create&isforeip=true
--taburl  operatetype   tabtitle   webtitle

select  *  from  PersonSubmitApproval  a;
select  *  from  PayReport  a  where  a.ProjectId='RD20181206';

--drop  view  V_Flow  ;

select   *   from  V_Flow ;

select   a.DeleteFlag,*   from  RecruitReqApply  a    where  a.DeleteFlag=1;



--localhost:2731/Login/SSOLogin?taburl=Project/ProjectSetupDetail?id=8fb7185c-f94d-4a2b-96e3-fbf05ffd56f5' +'&operateType=create&isforeip=true

--localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=8fb7185c-f94d-4a2b-96e3-fbf05ffd56f5&operateType=create&isforeip=true

select   *   from    PrjectPersonRDODC  a;

select   *   from    WorkFlow  a  ;

select   *   from   PayReport   a ;

select   *   from    V_GeneralPayReport  a

select   *   from    V_ExpenseSettlementDetail  a;

--WorkFlowID
--8E5D8253-E386-4242-9B58-2FA1902FE4AB		  OnSite需求申请 
--695774A3-C997-4B7C-A68F-F71646CC43AD     实习生需求申请
--D477D130-7482-4D60-9B17-1C8FD0DA0059     合作项目立项
--2545F8A1-9920-4464-97E5-50790393663F	       付款确认
select   *   from    WorkFlowNode   a   where  a.WorkFlowId='2545F8A1-9920-4464-97E5-50790393663F';


--drop  view   V_Flow ;
--l06533,lkf6850,w04755,w04755,,z00870,z06324
select   *   from   V_Flow   a;

select   *   from   ProcessFlow  a   where  a.ProcessFlowId='5094BAE9-EAFC-46D8-9BDB-C2EB2AE9079D';

--770D1192-5221-4C6C-A6D5-5F6E829E592A

select  *  from    WorkFlowTask a   where  a.WorkFlowInstanceId='770D1192-5221-4C6C-A6D5-5F6E829E592A'   and  a.Owner!='';

--wuliang 04755,zhangxiaowei 00870
--STUFF((SELECT DISTINCT(','+ LOWER(SUBSTRING(Owner,1,1)+SUBSTRING(Owner,CHARINDEX(' ',Owner)+1,6))
select    (SELECT DISTINCT(','+ LOWER(SUBSTRING(Owner,1,1)+SUBSTRING(Owner,CHARINDEX(' ',Owner)+1,6);

select CHARINDEX(' ','wuliang 04755,zhangxiaowei 00870');

select   SUBSTRING('wuliang 04755,zhangxiaowei 00870',CHARINDEX(' ','wuliang 04755,zhangxiaowei 00870')+1,6)

select  *   from  WorkFlowRecord  a;

select  *   from  RecruitReqApply  a where  a.ReqcruitReqApplyId='380076c9-0287-47d9-adbb-bb6dbb45d92d';

select  *   from  PrjectPersonRDODC  a;

--CreateTime  8.27   768f632b-ae44-4c2e-a522-fef7b03a9c74    
select  *   from  RecruitReqApply  a   where   a.ReqcruitReqApplyId='768f632b-ae44-4c2e-a522-fef7b03a9c74';

--bb01d836-b3c6-4dd3-928a-17a867ea356b
select  *   from  RecruitReqApply  a   where   a.ReqcruitReqApplyId='bb01d836-b3c6-4dd3-928a-17a867ea356b';

--http://10.18.193.200:16362/Home/IframeApprove?eip_title=%5BHRCP%5DOnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&url=localhost:2371/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=380076c9-0287-47d9-adbb-bb6dbb45d92d&operateType=update&tabtitle=OnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&webtitle=%E7%A0%94%E5%8F%91%E5%90%88%E4%BD%9C%E4%B8%9A%E5%8A%A1%E7%AE%A1%E7%90%86%E5%B9%B3%E5%8F%B0&isforeip=true&source=EIP
--http://10.18.193.200:16362/Home/IframeApprove?eip_title=%5BHRCP%5DOnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&url=http%3a%2f%2f10.18.192.250%2fLogin%2fSSOLogin%3ftaburl%3dOnSite%2fRecruitReqDetail%3fid%3d614c23a7-8267-4bd5-a115-ee111b9a5136%26operateType%3dupdate%26tabtitle%3dOnSite%e9%9c%80%e6%b1%82%e7%94%b3%e8%af%b7%26webtitle%3d%e7%a0%94%e5%8f%91%e5%90%88%e4%bd%9c%e4%b8%9a%e5%8a%a1%e7%ae%a1%e7%90%86%e5%b9%b3%e5%8f%b0%26isforeip%3dtrue%26source%3dEIP
--http://localhost:2371/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=380076c9-0287-47d9-adbb-bb6dbb45d92d
--http://10.18.193.200:16362/Home/IframeApprove?eip_title=%E9%80%9A%E7%94%A8%E8%AF%84%E5%AE%A1%E7%94%B5%E5%AD%90%E6%B5%81&url=http%3a%2f%2fdev3.h3c.com%3a8080%2fbpm%2frule%3fwf_num%3dR_S003_B036%26wf_docunid%3dbb500e610d334049330b562051eb9b3c4531%26source%3dEIP

--可正常访问 
--http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=c7e11c26-ef2a-433f-9e2d-f4ff4718df85&operateType=update&isforeip=true 
--http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=380076c9-0287-47d9-adbb-bb6dbb45d92d&operateType=update&tabtitle=OnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&webtitle=%E7%A0%94%E5%8F%91%E5%90%88%E4%BD%9C%E4%B8%9A%E5%8A%A1%E7%AE%A1%E7%90%86%E5%B9%B3%E5%8F%B0&isforeip=true&source=EIP
--localhost%3a2731%2fLogin%2fSSOLogin%3ftaburl%3dOnSite%2fRecruitReqDetail%3fid%3dbb01d836-b3c6-4dd3-928a-17a867ea356b%26operateType%3dupdate%26tabtitle%3dOnSite需求申请%26webtitle%3d研发合作业务管理平台%26isforeip%3dtrue%26source%3dEIP
--localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=bb01d836-b3c6-4dd3-928a-17a867ea356b&operateType=update&tabtitle=OnSite需求申请&webtitle=研发合作业务管理平台&isforeip=true&source=EIP

--http://10.18.193.200:16362/Home/IframeApprove?eip_title=HRCPOnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&url=localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=bb01d836-b3c6-4dd3-928a-17a867ea356b&operateType=update&tabtitle=OnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&webtitle=%E7%A0%94%E5%8F%91%E5%90%88%E4%BD%9C%E4%B8%9A%E5%8A%A1%E7%AE%A1%E7%90%86%E5%B9%B3%E5%8F%B0&isforeip=true&source=EIP
--http://10.18.193.200:16362/Home/IframeApprove?eip_title=%5BHRCP%5DOnSite%E9%9C%80%E6%B1%82%E7%94%B3%E8%AF%B7&url=http%3a%2f%2flocalhost%3a2731%2fLogin%2fSSOLogin%3ftaburl%3dOnSite%2fRecruitReqDetail%3fid%3d768f632b-ae44-4c2e-a522-fef7b03a9c74%26operateType%3dupdate%26tabtitle%3dOnSite%e9%9c%80%e6%b1%82%e7%94%b3%e8%af%b7%26webtitle%3d%e7%a0%94%e5%8f%91%e5%90%88%e4%bd%9c%e4%b8%9a%e5%8a%a1%e7%ae%a1%e7%90%86%e5%b9%b3%e5%8f%b0%26isforeip%3dtrue%26source%3dEIP

--跳转到详情页的正确url  
--http://localhost:2731/OnSite/RecruitReqDetail?id=77e9c777-ad7e-4674-b1e0-a4739cfab67a&operateType=update
--{"systemId":"HRCP","appId":"","docunId":"52e96413-1838-4e65-ac06-9be03cd46cb7","subject":"[HRCP]OnSite需求申请2019/9/23 17:41:57","nodeName":"05.一级部门审批","nodeId":"7d26f41b-ddf6-44c0-ad34-bacef243180b","addUserId":"cys2689","addUserName":"chenmin","applyTime":"2019-09-23","authorId":"cys2689","authorName":"陈敏","url":"http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=52e96413-1838-4e65-ac06-9be03cd46cb7&operateType=update&tabtitle=OnSite需求申请&webtitle=研发合作业务管理平台&isforeip=true","processId":"8e5d8253-e386-4242-9b58-2fa1902fe4ab","processName":"recruitReqApply","endUserId":"cys2689","status":"APPROVING","timeStamp":"2019-09-23 17:42:15","isBatch":"0","acceptType":"1","redirectUrl":"","assigner":"","isSMS":"0"}

select   a.PROCESSID   from  V_Flow  a  group  by   a.PROCESSID  ;
select   *   from  V_Flow   a;
select   *   from  ProcessFlow   a;
select   *   from   VEmployee  a  where  a.RegionAccount='y10203';

select   a.ModificationDate,*   from   PayReport  a;

select   a.ModificationDate,a.Modifier,*   from  ProjectSetup  a  where  a.ProjectNum='RD20181210';

select  *   from  Loginfo  a  order   by   a.LogTime desc  ;

(select Text from AppConstantValue where AppConstantId = (select AppConstantId from AppConstant where Code ='HrcpUrl'));

select  *   from  ProjectPersonRecord   order  by  CreateDate desc;   

select   a.CreateDate,*,ROW_NUMBER()OVER(ORDER BY  CreateDate   DESC)Num from V_ProjectPersonRecord  a where 1=1  order  by  a.CreateDate  desc;

select   a.CreateDate,*  from  ProjectPersonInfo   a  where   a.Name='无敌'  order  by   a.CreateDate  desc;

select   a.CreateDate,*   from  ProjectPersonInfo  a  where    a.CreateDate  is  null;  

select  a.ModificationDate,*   from  RecruitReqApply  a where  a.ReqcruitReqApplyId='51821fbe-28fe-4d6b-868d-675b08bcd8fb';
--实习生报批  项目付款管理      OnSite/实习生付款管理

--请求数据：{"subject":"[HRCP]项目付款管理","addUserId":"lkf6850","addUserName":"liuyujing","applyTime":"2019-09-26T11:31:22","authorId":null,"authorName":null,"url":"http://localhost:2731/Login/SSOLogin?taburl=Expenses/PayConfirmDetail?payReportId=436E3039-1395-410B-85F9-790153C4F8A9&operateType=update&isforeip=true","systemId":"HRCP","docunId":"436e3039-1395-410b-85f9-790153c4f8a9","appId":"","processId":"71a88cd3-323b-48d3-a4fb-d44126ce1069","processName":"PayConfirmDetail","status":"APPROVING","endUserId":"f02139,lkf6850","assigner":"","nodeId":"86676aec-4a04-43d0-9b8a-e63012b697f4","nodeName":"一级部门权签人审核","timesTamp":null,"acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}

--请求数据：{"subject":"[HRCP]OnSite需求申请","addUserId":"lkf6850","addUserName":"liuyujing","applyTime":"2019-09-26T10:56:06","authorId":"lkf6850","authorName":"liuyujing","url":"http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=C5E79E94-F9D6-484E-9BBA-A9342309552A&operateType=update&isforeip=true","systemId":"HRCP","docunId":"c5e79e94-f9d6-484e-9bba-a9342309552a","appId":"","processId":"740c9a55-5da8-48a6-abb6-0729020bea0d","processName":"recruitReqApply","status":"APPROVING","endUserId":"lkf6850","assigner":"","nodeId":"7d26f41b-ddf6-44c0-ad34-bacef243180b","nodeName":"05.一级部门审批","timesTamp":"2019-09-26 10:59:46","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}


select  a.CreateTime,*   from RecruitReqApply a  order  by  a.CreateTime  desc;

select  *  from  PayReport   a  order  by  a.CreateDate desc;

select  *  from  ProcessFlow   a   where  a.ApprovalId='436E3039-1395-410B-85F9-790153C4F8A9';

select  *  from  ProcessFlow   a   where   a.CurrentPerson is  not null    and  a.CurrentPerson!='' and  a.CurrentPerson!='system';

select   dbo.F_GetRegionAccount('liuyujing kf6850,chenmin ys2689,zhaiguoxiu 19644,','region');

select   dbo.F_GetRegionAccount('wangnan 07770','region');

select  CHARINDEX(',','liuyujing kf6850,chenmin ys2689,zhaiguoxiu 19644,');
select  LEN('dsad陈');    

select  a.ReqcruitReqApplyId,*  from   RecruitReqApply  a  order  by  a.CreateTime desc;
--F231F265-B0E8-49AA-9B24-20D33BEF3897

select   *  from  V_Flow  a   where  a.TIMESTAMP>='2019-01-01'

select   *  from  RecruitReqApply   a  where   a.ReqcruitReqApplyId='b7676b2e-92b7-40ba-8b07-556098cfc666'

select   *  from  PersonSubmitApproval  a  where  a.PersonSubmitApprovalId='b7676b2e-92b7-40ba-8b07-556098cfc666';

select   a.Dept1Cc,a.Dept1ApprSign,a.Dept1ApprDate,*  from  V_PersonSubmitApproval  a;

select   a.RecruitNo,a.RecruitReqId,*   from   PersonApply  a;

select   *   from   PersonSubmitApproval  a  where  a.PersonApprovalNo='20190003'

select  a.ReqcruitReqApplyId,*   from  RecruitReqApply  a   where  a.RecruitNo='20160030'

select *,ROW_NUMBER() OVER(ORDER BY RecruitStatus ASC,RecruitNo DESC)Num from V_RecruitPositionReq where IsTrainee=1;

--RecruitReqApply req = TraineeServiceAction.GetRecruitByRecruitNo(recruitno);

select   convert(varchar(4),Getdate(),112);

select  distinct    a.PersonApprovalId  from  PersonApply  a  where  a.PersonApprovalId is not  null    and  a.PersonApprovalId!='00000000-0000-0000-0000-000000000000';

select   *  from  PersonApply   a   where   a.RecruitNo='20190003';

select   *  from  PersonSubmitApproval    a;

select   text  from  AppConstantValue  a  where   a.AppConstantId=(select   a.AppConstantId  from  AppConstant  a  where  a.Code='HrcpUrl');

--hrcp_rd_cadre		hrcp_rd_hrmgr


select  ','+a.UserId   from  Loginfo  a  order   by   a.LogTime desc   for  xml path('qwe'); 


--from  
--join
--on
--where  
--group  by 
--having 
--distinct 
--order by 
--top 
--select    


select   a.CardConfirm,*   from   PersonInfo   a;

select   *   from   Loginfo  a   order by  a.LogTime desc;

select   *   from   ProjectPersonEntry   a;

select   a.DeleteFlag,*   from   ProjectPersonInfo_History  a;

select   a.DeleteFlag,*   from   ProjectPersonInfo   a;

select   a.StatusFlag,*   from   RecruitReqApply   a  where   a.ReqcruitReqApplyId='dc67dec9-1299-42d3-a513-67f22f2b6aaa';

select    *   from  ProcessFlow  a  where  a.ApprovalId='dc67dec9-1299-42d3-a513-67f22f2b6aaa';

select    *   from  WorkFlowNode   a    where  a.NodeId='08AA3369-A849-415F-A0DF-B04D59F439EA';

--Name   SectionName       
    
select   *   from   WorkFlow   a   where   a.WorkFlowId='DAEBED2D-D300-4161-AD31-9141CF42A06A';

select   *   from   WorkFlowInstance  a;

select   *   from   WorkFlowTask   a;    

select   *   from   WorkFlowTransition   a;

select   *   from   RecruitReqApply    a   where  a.ReqcruitReqApplyId='77E9C777-AD7E-4674-B1E0-A4739CFAB67A';

select   *   from   ProcessFlow   a  where  a.CurrentNode  like '%01%';  

select   *   from   V_ProjectPersonInfo   a;

SELECT CONVERT(datetime,'11/1/2003',20);

select   a.ModificationDate,*  from  RecruitReqApply   a   where  a.ModificationDate is   null;
select   a.ModificationDate,*  from  PersonSubmitApproval   a   where  a.ModificationDate is  null;
select   a.ModificationDate,*  from  ProjectSetup   a   where  a.ModificationDate is  null;
select   a.ModificationDate,*  from  PayReport  a  where  a.ModificationDate is  null;
select   a.ModificationDate,*  from  ExpenseSettlementDetail   a   where  a.ModificationDate is  null;

select   *   from    WorkFlow  a;
--60B2C6E9-B6D0-400B-9228-DEF38AA44DD5  ProjectPersonEntry;

select   *   from   WorkFlowNode  a  where  a.WorkFlowId='11581B56-6900-4EFE-90A5-315C980E0EAB'  order  by  Code;

select   *   from   WorkFlowNode  a  where  a.Name='07.文档管理员确认离项材料';

select   *   from   WorkFlowInstance  a  where  a.WorkFlowId='11581B56-6900-4EFE-90A5-315C980E0EAB'


select   top   1 *  from  V_Flow a   ;

--select  upper   
select   upper(CAST('dsa' as  varchar(200)));

select  a.AddReason,*   from  RecruitReqApply  a   order  by   a.RecruitNo  desc;

select    *   from    LogInfo   a    order  by    a.LogTime  desc;

select   *   from   PersonEntry  a  where  a.EmployeeName='王柏翔';

select   *   from   AskForOverTime  a;

select   *   from   AbnormalRecord  a;

--请求数据：{"subject":"[HRCP]OnSite/实习生人员离项","addUserId":"l06533","addUserName":"李霞","applyTime":"2018-06-26T14:50:50","authorId":"cys2689","authorName":"chenmin","url":"http://localhost:2731/Login/SSOLogin?taburl=Trainee/TraineeApprovalDetail?id=29E1604B-2F45-4154-AF14-DF86B6F18258&operateType=update&isforeip=true","systemId":"HRCP","docunId":"29E1604B-2F45-4154-AF14-DF86B6F18258","appId":"","processId":"9A09986A-7DF7-4C28-8199-D77CBF4D16B1","processName":"PersonLeave","status":"APPROVING","endUserId":"l06533,lkf6850","assigner":"","nodeId":"2143F958-86CC-4BD0-97B1-5F513F2FFE36","nodeName":"02.文档查阅电子流关闭环节","timesTamp":"2019/10/23 9:30:00","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}
--请求数据：{"subject":"[HRCP]OnSite/实习生人员离项","addUserId":"l06533","addUserName":"李霞","applyTime":"2018-06-26T14:50:50","authorId":"l12470","authorName":"梁静晶","url":"http://localhost:2731/Login/SSOLogin?taburl=Trainee/TraineeApprovalDetail?id=29E1604B-2F45-4154-AF14-DF86B6F18258&operateType=update&isforeip=true","systemId":"HRCP","docunId":"29E1604B-2F45-4154-AF14-DF86B6F18258","appId":"","processId":"9A09986A-7DF7-4C28-8199-D77CBF4D16B1","processName":"PersonLeave","status":"APPROVING","endUserId":"l06533,lkf6850","assigner":"","nodeId":"2143F958-86CC-4BD0-97B1-5F513F2FFE36","nodeName":"02.文档查阅电子流关闭环节","timesTamp":"2019/10/23 9:29:15","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}
--请求数据：{"subject":"[HRCP]OnSite/实习生人员离项","addUserId":"l06533","addUserName":"李霞","applyTime":"2018-06-26T14:50:50","authorId":"","authorName":"","url":"http://localhost:2731/Login/SSOLogin?taburl=Trainee/TraineeApprovalDetail?id=29E1604B-2F45-4154-AF14-DF86B6F18258&operateType=update&isforeip=true","systemId":"HRCP","docunId":"29E1604B-2F45-4154-AF14-DF86B6F18258","appId":"","processId":"9A09986A-7DF7-4C28-8199-D77CBF4D16B1","processName":"PersonLeave","status":"WAITING","endUserId":"l06533","assigner":"","nodeId":"7080CBA4-E63A-47BE-92FE-78BD5E54EAC6","nodeName":"01.电子文档归档确认","timesTamp":"2019/10/23 9:28:55","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}





--优秀合作员工转正    目前表中没数据
select   *   from  CooperationToFormal;

select  *  from  V_MyToDo;

select  a.LogContent   from  Loginfo  a  
where  a.ModelId='SavePayConfirmDetail'
order   by   a.LogTime desc;

select   *   from   PayReport  a   where  a.PayReportId='0df3eb9a-27d7-45fb-878e-175eb421d8f1';

select   a.DeptLevel1,a.DeptLevel1Code,a.DeptLevel2,a.DeptLevel2Code,*   from   BenefitProDivide  a  where  a.PayReportId='0df3eb9a-27d7-45fb-878e-175eb421d8f1';

select   a.DeptLevel1,a.DeptLevel1Code,a.DeptLevel2,a.DeptLevel2Code,*   from   BenefitProDivide  a  where  a.DeptLevel2='交换机产品线';

--29e1604b-2f45-4154-af14-df86b6f18258

--03.资产物料确认环节
select  *   from  ProcessFlow  a    where    a.ApprovalId='29e1604b-2f45-4154-af14-df86b6f18258';

select  *   from  WorkFlowInstance    a    where   a.WorkFlowInstanceId='A4C3A0C0-B90B-458E-9404-E0F00212DEF3';

select  *   from  WorkFlowNode  a  where   a.WorkFlowId='9A09986A-7DF7-4C28-8199-D77CBF4D16B1'  and  a.Name='03.资产物料确认环节' order  by  a.Code;

--请求数据：{"subject":"[HRCP]OnSite需求申请","addUserId":"lkf6850","addUserName":"liuyujing","applyTime":"2019-10-22T16:31:55","authorId":"","authorName":"","url":"http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=95066C3D-40E0-4017-8EFC-DB6F3FD84758&operateType=update&isforeip=true","systemId":"HRCP","docunId":"95066C3D-40E0-4017-8EFC-DB6F3FD84758","appId":"","processId":"8E5D8253-E386-4242-9B58-2FA1902FE4AB","processName":"recruitReqApply","status":"APPROVED","endUserId":"lkf6850","assigner":"","nodeId":"9B826C92-DFEC-45F1-9D16-5BA1C0022B28","nodeName":"流程结束","timesTamp":"2019/10/22 16:34:07","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}

--CCEEA24F-4758-437D-BCE9-FBDA64E496CA
--C67F3105-E7D0-45D8-9A57-FA8671020E39
select   *   from   ExpenseSettlementDetail  a where  a.ExpenseSettlementDetailId='C67F3105-E7D0-45D8-9A57-FA8671020E39';

select   *   from   PersonEvaluate   a;

select   *   from   V_Flow    a;


select   a.CreateBy,*   from   PayReport   a   where   a.PayReportId='D5A6A4C1-166C-43C8-AA2D-CBB27FBF4851';

select   
(
CASE (SELECT  COUNT(LOWER(RegionAccount)) FROM  VEmployee  emp  WHERE LOWER(emp.ChnNamePY)+' '+emp.NotesAccount='lufeng 04901')
 WHEN   0 THEN ''
 ELSE 
 (SELECT  LOWER(HUR_CODE) FROM  WEBDP.DBO.WEBDP_USER  webdpUser  WHERE LOWER(webdpUser.ChnNamePY)+' '+webdpUser.NotesAccount='lufeng 04901')
 END
) AS   ADDUSERID;



select   LOWER(emp.ChnNamePY)+' '+emp.Code,*    from     VEmployee     emp   where  LOWER(emp.ChnNamePY)+' '+emp.Code='zhaopengfei kf7556';

--lufeng 04901					l04901
--geyuanyuan kf5594		gkf5594


select  *   from   VEmployee  emp  where  emp.ChnNamePY like '%geyuanyuan%';
select  *   from   VEmployee  emp  where  emp.RegionAccount='gkf5994';

select  HUR_NAME   from   WEBDP.DBO.WEBDP_USER a  group   by(a.HUR_NAME)  having(COUNT(a.HUR_NAME)>1);

select  *   from  WEBDP.DBO.WEBDP_USER  a  where   a.HUR_NAME='冯凯';

select   dbo.F_GetRegionAccount('liuyujing kf6850,lixia 06533,','region')
select  substring('liuyujing kf6850',2,1)

select  dbo.F_GetRegionAccountByUserInfo('liuyujing kf6850','name');

select  *   from   Loginfo  order by  LogTime desc;

请求数据：{"subject":"[HRCP]OnSite需求申请","addUserId":"lkf6850","addUserName":"liuyujing","applyTime":"2019-10-17 11:07:05","authorId":"lkf6850","authorName":"liuyujing","url":"http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=74FE04F8-CB1F-4A1D-9460-9090C4B5200D&operateType=update&isforeip=true","systemId":"HRCP","docunId":"74FE04F8-CB1F-4A1D-9460-9090C4B5200D","appId":"","processId":"8E5D8253-E386-4242-9B58-2FA1902FE4AB","processName":"OnSite/实习生需求申请","status":"APPROVING","endUserId":"lkf6850","assigner":"","nodeId":"7D26F41B-DDF6-44C0-AD34-BACEF243180B","nodeName":"05.一级部门审批","timesTamp":"2019-11-08 14:39:44","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}
select  CONVERT(varchar,GETDATE(),20)
请求数据：{"subject":"[HRCP]OnSite需求申请","addUserId":"lkf6850","addUserName":"liuyujing","applyTime":"2019-10-17T11:26:43","authorId":"lkf6850","authorName":"liuyujing","url":"http://localhost:2731/Login/SSOLogin?taburl=OnSite/RecruitReqDetail?id=31210584-3D5F-4A0A-BFCC-B4D5745FE952&operateType=update&isforeip=true","systemId":"HRCP","docunId":"31210584-3D5F-4A0A-BFCC-B4D5745FE952","appId":"","processId":"8E5D8253-E386-4242-9B58-2FA1902FE4AB","processName":"OnSite/实习生需求申请","status":"APPROVING","endUserId":"lkf6850","assigner":"","nodeId":"23C760AF-52F4-4949-9128-A3E72C320758","nodeName":"04.干部部审批","timesTamp":"2019-11-08T10:29:09","acceptType":"1","redirectUrl":"","isBatch":"0","isSMS":"0"}
