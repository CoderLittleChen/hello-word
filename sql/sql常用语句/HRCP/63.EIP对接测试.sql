select    *    from   Loginfo   a   order   by   a.LogTime  desc;

select    *    from   WorkFlow  a   where   a.WorkFlowId='DE4ED03B-E423-4E73-8E06-9D1C3D1508D3';

select    *    from   ProcessFlow  a    where a.WorkFlowInstanceId  in (select    a.WorkFlowInstanceId    from   WorkFlowInstance   a   where  a.WorkFlowId='9A09986A-7DF7-4C28-8199-D77CBF4D16B1')

select    *    from   WorkFlowNode  a   where   a.WorkFlowId='9A09986A-7DF7-4C28-8199-D77CBF4D16B1';

select    dbo.F_GetRegionAccount('shengliping ys0140','region')  AS  AUTHORID;

select  CHARINDEX(',','shengliping ys0140,');

SELECT RegionAccount FROM dbo.VEmployee WHERE NotesAccount=SUBSTRING('shengliping ys0140',CHARINDEX(' ','shengliping ys0140')+1,LEN('shengliping ys0140'));

select   SUBSTRING('shengliping ys0140,',0,19);
select   SUBSTRING('shengliping ys0140',CHARINDEX(' ','shengliping ys0140')+1,LEN('shengliping ys0140'));


select   *  from    LogiInfo   a;

select   top  10 a.ApplySign,*   from   PersonInfo  a;

select   LOWER('cYS2689');

select    a.ApplySign,*   from   PersonInfo  a    where   a.PersonInfoId='AA7E0501-9DF6-4457-8F48-0ED72097D1F8';

select  CONVERT(datetime,'2019-09-09 10:50:29',20)

SELECT RegionAccount,* FROM dbo.VEmployee WHERE NotesAccount='ys0140';

select   a.CreateBy,*   from PersonInfo   a  where  a.PersonInfoId='1872ABC9-0015-472B-90D4-BDD3A92C9223';

select   *   from   PersonEvaluate    a   where  a.PersonEvaluateId='BF579075-A644-4257-B870-451D8648704E';

select   *   from   ProcessFlow  a  where  a.ApprovalId='904BB45B-6A99-410F-A4EF-96A16D2CF1FC';

select   *   from   TraineeThesis   a   where   a.TraineeThesisId='9F2A3773-F976-4CBC-A1CE-C61DC5ADCDC4';

--wudongpo 08595

select   *   from  WEBDP.dbo.WEBDP_USER  a  where  a.HUR_CODE='l03853';

select  dbo.F_GetRegionAccountByUserInfo('wudongpo 08595','region');

select   *   from  ProjectSetup  a  where  a.ProjectSetupId='86F559E6-9524-4ADF-AFF9-AF18C1638E20';

use  hrcp;
select   a.ModifierTime,*   from  ProjectCheckReport   a;

select   *   from  WorkFlowInstance   a  where  a.WorkFlowId='9A09986A-7DF7-4C28-8199-D77CBF4D16B1';

select   *   from  ProcessFlow   a   where  a.WorkFlowInstanceId='9A79D47F-72C6-4889-852F-0014C78D33A4';

--IsTrainee=0  OnSite
select   a.IsTrainee,*   from  PersonEntry   a;

select   a.CardConfirmOpinion,*   from  ProjectPersonInfo   a;

select   a.CardConfirmOpinion,*   from  ProjectPersonInfo_History   a;

select   a.CardConfirmOpinion,*   from   PersonInfo   a   where   a.PersonInfoId='1e52a1fa-4ffd-4438-a291-9f013d86f0da';

select   *   from   ProjectPersonInfo_History   a;

select   a.CardConfirmOpinion,*   from   PersonInfo  a    where  a.PersonInfoId='9d48fdd0-e4e6-4ef1-bbd3-ca7fd23eb6ec';

select   a.CardConfirmOpinion,*   from   ProjectPersonInfo   a   where   a.ProjectPersonInfoId='6b6a1c70-e9db-40bb-acc4-28bbff588b48';

select   *   from  V_PeronsInfo_ForDataMP   a;

select   a.ModificationDate,*   from  PersonInfo   a;

select  top   1  a.OnJobStatus,a.AttendEndDate,*   from   PersonInfo   a   where   a.EmployeeName='张莉莉';

select    a.OnJobStatus,a.AttendEndDate,*   from   PersonInfo   a   where   a.OnJobStatus=1;

select  a.Telephone,*  from   PersonInfo  a;

--e6e2ca8e-3e72-48ae-9d00-2f13fa337448

select  *   from  BenefitProDivide   a  where  a.PayReportId='8526038C-D166-421B-B43C-F91F3C0BE5A3';

select  CONVERT(datetime,GETDATE(),20);

select  *   from  V_Flow  a;

select  *   from  WEBDP.DBO.WEBDP_USER   where  HUR_MEMO='maweihai';

select  *   from  Department  a   where   a.DeptCOACode='482000'  and  a.DeleteFlag=0;
--50040542

select  *   from  Department  a   where   a.Code='50042428'  and  a.DeleteFlag=0;

select  a.Dept3Level,*   from  PersonInfo     a   where   a.DeleteFlag=0  and  Dept3Level='50041407';

select  *  from  Loginfo  a  order by  a.LogTime  desc;

select  *  from  BenefitProDivide  a  where  a.DeptLevel2='固网产品研发管理部';

select  *  from  Department   a  where  a.Name='固网产品研发管理部';

select * from RecruitReqApply where ReqcruitReqApplyId=(select  distinct  RecruitReqId  from   PersonApply    a   where   a.PersonApprovalId='f628a558-f2ad-4d29-acd4-02db72bb8e18'  and  a.DeleteFlag=0 and  a.IsTrainee=1 ) and DeleteFlag=0 and IsTrainee=1;

--95dec30c-ec6a-4b4c-975a-d3efb0231308

select  *   from  RecruitReqApply  a  where   a.ReqcruitReqApplyId='95dec30c-ec6a-4b4c-975a-d3efb0231308';
select * from RecruitReqApply where ReqcruitReqApplyId='95dec30c-ec6a-4b4c-975a-d3efb0231308' and DeleteFlag=0 and IsTrainee=0

--TraineeRequireRepository

--qiuminna 05058,,

select  *   from  WorkFlowInstance   a;

select  *   from  ProcessFlow  a where  a.ApprovalId='f8fb1d35-0790-479e-80b1-7ce21741871c';

select  *   from  WorkFlowTask  a  where  a.WorkFlowInstanceId='4E903B96-0415-4302-A0D1-C121C150B610';

select  *   from  V_FlowRecord  a  where  a.WorkFlowInstanceId='4E903B96-0415-4302-A0D1-C121C150B610';

select  a.DocCheckCloseCc,a.Dept2Level,*  from  PersonInfo  a  where  a.EmployeeName='张强林';

select  a.CreateBy,a.*   from  PersonEntry  a;

select   dbo.F_GetRegionAccountByCNName('陈丽');

select  *   from   ProjectPersonEvaluate;

select  *   from   ProjectPersonInfo   a;

--50042521

select  *    from  WorkFlow  a  ;

--人员入项   流程中有入项归档和入项归档确认
select  *    from  WorkFlowNode    a   where   a.WorkFlowId='DAEBED2D-D300-4161-AD31-9141CF42A06A'  order  by  a.Code;
--人员离项   离项归档和离项归档确认 不在流程中 
select  *    from  WorkFlowNode    a   where   a.WorkFlowId='9A09986A-7DF7-4C28-8199-D77CBF4D16B1'  order  by  a.Code;


--问题
--1、如果归档确认和离项分开写   则这两个需要单独指定一个ProcessFlowdId，因为EIP需要根据这个id来对流程进行分来 目前两者对应的流程都是PersonLeave
--2、                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   