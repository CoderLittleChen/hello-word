--人员入离职  OnSite/实习生

--OnSite/实习生入职
select   *   from   PersonEntry  a;
--OnSite/实习生信息    其中OnJobStatus=0表示在职  1表示离职  
select   *   from   PersonInfo  a;
--OnSite/实习生考评表   按季度  3个月考评一次
select   *   from   PersonEvaluate  a;


--项目管理模块
--立项表
select   *   from  ProjectSetup  a;
--监控表    项目立项之后  需要通过项目评审才能创建项目监控  
select   *   from  ProjectControl  a;
--项目监控表中的合同分期表  
--合同分期   每一期都可能会涉及到项目验收报告  阶段性报告等 
--项目分期表中   有几个字段   
--值=1  涉及
--值=0  不涉及
--CheckReport							验收报告
--StageReport							阶段性报告
--ResultList								成果移交清单
--SummaryReport						项目总结报告  
--EvaluateReport						项目评价报告
--WithOutNecessaryAttach			如果前面几项都为0 则该值为1，若都为1 则该值为0  
select   *   from  ContractStage  a;
--项目人员记录   使用较少
select   *   from  ProjectPersonInfo  a;
--项目验收报告
select   *   from  ProjectCheckReport  a;
--阶段性报告
select   *   from  ProjectStageReport  a;
--成果移交清单
select   *   from  ProjectResultList   a;
--项目总结报告
select   *   from  ProjectSummary  a;
--项目评价报告
select   *   from  ProjectEvaluateReport  a;


--付款管理
--项目付款主表
select  *  from   PayReport  a;
--人力付款主表(OnSite/实习生)
select  *  from   ExpenseSettlementDetail  a;

--收益分摊表
select  *  from   BenefitProDivide  a; 

--我的工作台
select  *  from   V_MyToDo  a;

--OnSite需求申请表
select   *  from  V_RecruitReqApplyList  a;
select   *  from  RecruitReqApply  a  where  a.RecruitNo='20180050';

--OnSite需求申请进展表
select   *  from  RecruitReqApply  a  where  a.RecruitNo='20190040';


--OnSite需求申请表  对于岗位表   （一对多）  其中V开头代表是视图
select   *  from  V_RecruitPositionReq   a; 
select   *  from  RecruitPositionReq   a ;


--OnSite需求申请周报表    （一对多）  
select   *  from  RecruitWeekReport    a;

--工作流记录  
select   *  from  WorkFlowRecord  a;

--PersonInfo  表    
--OnJobStatus=1  表示离职
--OnJonStatus=0  表示在职


--EBFD1271-2278-4292-992A-0AA08CDDE0E4
select  b.RecruitNo,*   from  RecruitWeekReport     a  
inner join   RecruitReqApply  b   on  a.RecruitReqApplyId=b.ReqcruitReqApplyId
where b.RecruitNo='20180205';


select  b.RecruitNo,*   from  RecruitWeekReport     a  
inner join   V_RecruitPositionReq  b   on  a.RecruitReqApplyId=b.ReqcruitReqApplyId
where b.RecruitNo='20180205';

select  *   from  RecruitWeekReport   a  where   a.RecruitWeekReportId='5B66035B-100E-43C6-B18E-189E1F38A7D2';


select  *  from  
(
select   *,Row_Number()  over(partition by  a.ReqcruitReqApplyId  order by  RecruitStatus ASC,RecruitNo DESC,b.CreateDate  desc  ) as RankNum  from  V_RecruitPositionReq  a   left  join   RecruitWeekReport  b  on  a.ReqcruitReqApplyId=b.RecruitReqApplyId
where  a.IsTrainee=0   
)  temp 
where  RankNum=1 and  temp.RecruitNo='20180205';

select *  from ( select  *,Row_Number()  over(partition by  a.ReqcruitReqApplyId order by b.CreateDate  desc) as RankNum  from  V_RecruitPositionReq  a   left  join   RecruitWeekReport  b  on  a.ReqcruitReqApplyId=b.RecruitReqApplyId        where  a.IsTrainee=0   ) temp   where  RankNum=1;

select * from ( select *  from ( select  *,Row_Number()  over(partition by  a.ReqcruitReqApplyId order by b.CreateDate  desc) as Num  from  V_RecruitPositionReq  a   
left  join   RecruitWeekReport  b  
on  a.ReqcruitReqApplyId=b.RecruitReqApplyId        
where  a.IsTrainee=0   and RecruitNo like '%20180205%' ) temp   
where  Num=1 ) t ;


select * from 
(
	select *,ROW_NUMBER() OVER(ORDER BY  RecruitStatus ASC,RecruitNo DESC 
)   Num from V_RecruitPositionReq where IsTrainee=0 ) t 
where t.Num>0 and t.num<=20;




