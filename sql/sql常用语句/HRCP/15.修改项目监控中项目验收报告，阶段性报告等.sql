--9A407EFB-8E5E-4ACF-8410-2AE24F9CAA90
select  *   from   ProjectControl  a  where   a.ProjectName='无线移动通信RRU3184产品委托开发项目';

select  *   from   ProjectSetup  a    where  a.ProjectSetupId='3AC5347A-C07D-46F2-8525-220EF6D94978';

select  *   from   ContractStage  a  where  a.ProjectControlId='9A407EFB-8E5E-4ACF-8410-2AE24F9CAA90'
and   (a.PeriodsNum=9  or  a.PeriodsNum=10);

--update  ContractStage  set CheckReport=1,StageReport=1,ResultList=1,SummaryReport=1,EvaluateReport=1,WithOutNecessaryAttach=0
--where ProjectControlId='9A407EFB-8E5E-4ACF-8410-2AE24F9CAA90'  and  PeriodsNum=9;

select  *  from  V_MyToDo  a  where   a.CurrentPerson  like '%liuyujing%';

select  *   from   ProjectControl  a  where   a.ProjectName   like    '%陈敏%';
--BDDAD774-2162-4827-984E-A9410EECD92A

select  *  from   ContractStage  a  where  a.ProjectControlId='BDDAD774-2162-4827-984E-A9410EECD92A';

--update  ContractStage  set CheckReport=1,StageReport=0,ResultList=0,SummaryReport=0,EvaluateReport=0,WithOutNecessaryAttach=1
--where ProjectControlId='BDDAD774-2162-4827-984E-A9410EECD92A';


--
select  *  from  ContractStage   a;

select  *   from  PayReport  a   order  by   a.CreateDate  desc;

select *,ROW_NUMBER() over(order by CreateDate DESC) as Num  from V_PayReportDetail where DeleteFlag=0  AND ( IsBorrow = 0 OR IsBorrow=-1 );

select  *  from PersonInfo  a;

-- update  PersonInfo   set  AttendEndDate='2019-08-06'  where  PersonInfoId='27e070cc-6200-436a-94c2-4fca79c076b4'   

select *  from  PersonInfo  a  where   a.PersonInfoId='27e070cc-6200-436a-94c2-4fca79c076b4';

select   a.LeaveDate,a.LeaveCommitment,a.OnJobStatus,a.WorkNum,a.EmployeeName  from  PersonInfo  a;

--OnJobStatus  1 表示已启动离项流程  
select   *  from  V_PersonInfo  a;

select  *   from  Loginfo  a   order  by   a.LogTime  desc;

select  a.CostType,a.ParticularCostType   from  PayReport  a;

 --update  PayReport  set CostType='CollaborationCosts',ParticularCostType='Csxmwb'  where  PayReportId='7df3a6c3-4e7b-4111-9a82-cbe10c31dec7';
 --如何判断当前合同分期是否已经创建了付款报告？是要根据ProjectContract   
 select   *   from   ContractStage   a;

 select   a.PayReportId,a.ContractStageId,b.ContractStageId,   from   PayReport  a    left join  ContractStage  b  on  a.ContractStageId=b.ContractStageId;

 --首先  未创建付款去确认报告的 才可以点击修改必备流程按钮  需要加判断     我们之间的距离
 select   *  from  PayReport  a;

 select  a.ProjectName,a.ProjectNum,b.IsDone  from  ProjectControl  a   
 inner  join  ContractStage  b  on  a.ProjectControlId=b.ProjectControlId
 inner  join  PayReport   c on  b.ProjectControlId=c.ProjectControlId
 where b.IsDone=1;

 select   a.ContractStageId  from  ContractStage   a   
 inner join  PayReport   b  on  a.ContractStageId=b.ContractStageId 
 where a.IsDone=1;

 select   *  from  V_PayReportDetail  a;

 select  a.ProjectName,a.ProjectNum,b.IsDone  from  ProjectControl  a   
 inner  join  ContractStage  b  on  a.ProjectControlId=b.ProjectControlId
 where  b.ContractStageId  not in( select   a.ContractStageId  from  ContractStage   a   
 inner join  PayReport   b  on  a.ContractStageId=b.ContractStageId );

 --如何拿到每一条合同对应的ConstractStageid     

 --ProjectControlId  9A407EFB-8E5E-4ACF-8410-2AE24F9CAA90
 --ContractStageId  34b0f101-5cc1-496b-ba96-a61a78208046
 select   *   from  ProjectControl    a    where   a.ProjectNum='RD20181206';
 select   a.CheckReport,a.StageReport,a.ResultList,a.SummaryReport,a.EvaluateReport,a.WithOutNecessaryAttach,a.*   from  ContractStage    a    where   a.ProjectControlId='9a407EFB-8E5E-4ACF-8410-2AE24F9CAA90'  order by PeriodsNum;

 --越是憧憬 越要风雨兼程   

  --update  ContractStage  set  CheckReport=1,StageReport=0,ResultList=0,SummaryReport=0,EvaluateReport=0,WithOutNecessaryAttach=0  where  ContractStageId='ef50db10-9c08-41e0-af3d-617c5e314fad'  

  select  *  from  PayReport  a   where  a.ProjectControlId='9A407EFB-8E5E-4ACF-8410-2AE24F9CAA90';

  select  *  from  ExpenseSettlementDetail   a ;

  select  *  from  ExpenseDetail  a;

--update  ExpenseSettlementDetail  set CostType='合作费',ParticularCostType='人力外包'  where  ExpenseSettlementDetailId='fd697b22-164a-4def-9a97-eed675365b1a' ;
--update  ExpenseSettlementDetail  set CostType='合作费',ParticularCostType='人力外包'  where  ExpenseSettlementDetailId='fd697b22-164a-4def-9a97-eed675365b1a'  
select    a.CostType,a.ParticularCostType  from ExpenseSettlementDetail   a where    ExpenseSettlementDetailId='fd697b22-164a-4def-9a97-eed675365b1a' ;

select   a.MaterialFileNo   from   V_ProjectPersonRecord  a;

--select   a.m   from   ProjectPersonInfo  a;

select  name  from  syscolumns  a   where   a.id=(select   a.id   from  sysobjects  a   where    a.name='ProjectPersonInfo');

select  *  from  MaterialFile  a;


select    a.PersonStatus   from   V_ProjectPersonRecord   a;

select   a.ProjectStatus   from  ProjectSetup   a;

select   *   from   V_ProjectSetup   a;

select   a.SetupStatus   from   ProjectSetup   a;

select   *   from   ProjectPersonRecord  a;

select   a.PersonStatus  from   ProjectPersonInfo  a;

select   a.PersonStatus   from   V_ProjectPersonRecord  a;

select   *   from  PersonInfo    a;







