--��Ա����ְ  OnSite/ʵϰ��

--OnSite/ʵϰ����ְ
select   *   from   PersonEntry  a;
--OnSite/ʵϰ����Ϣ    ����OnJobStatus=0��ʾ��ְ  1��ʾ��ְ  
select   *   from   PersonInfo  a;
--OnSite/ʵϰ��������   ������  3���¿���һ��
select   *   from   PersonEvaluate  a;


--��Ŀ����ģ��
--�����
select   *   from  ProjectSetup  a;
--��ر�    ��Ŀ����֮��  ��Ҫͨ����Ŀ������ܴ�����Ŀ���  
select   *   from  ProjectControl  a;
--��Ŀ��ر��еĺ�ͬ���ڱ�  
--��ͬ����   ÿһ�ڶ����ܻ��漰����Ŀ���ձ���  �׶��Ա���� 
--��Ŀ���ڱ���   �м����ֶ�   
--ֵ=1  �漰
--ֵ=0  ���漰
--CheckReport							���ձ���
--StageReport							�׶��Ա���
--ResultList								�ɹ��ƽ��嵥
--SummaryReport						��Ŀ�ܽᱨ��  
--EvaluateReport						��Ŀ���۱���
--WithOutNecessaryAttach			���ǰ�漸�Ϊ0 ���ֵΪ1������Ϊ1 ���ֵΪ0  
select   *   from  ContractStage  a;
--��Ŀ��Ա��¼   ʹ�ý���
select   *   from  ProjectPersonInfo  a;
--��Ŀ���ձ���
select   *   from  ProjectCheckReport  a;
--�׶��Ա���
select   *   from  ProjectStageReport  a;
--�ɹ��ƽ��嵥
select   *   from  ProjectResultList   a;
--��Ŀ�ܽᱨ��
select   *   from  ProjectSummary  a;
--��Ŀ���۱���
select   *   from  ProjectEvaluateReport  a;


--�������
--��Ŀ��������
select  *  from   PayReport  a;
--������������(OnSite/ʵϰ��)
select  *  from   ExpenseSettlementDetail  a;

--�����̯��
select  *  from   BenefitProDivide  a; 

--�ҵĹ���̨
select  *  from   V_MyToDo  a;

--OnSite���������
select   *  from  V_RecruitReqApplyList  a;
select   *  from  RecruitReqApply  a  where  a.RecruitNo='20180050';

--OnSite���������չ��
select   *  from  RecruitReqApply  a  where  a.RecruitNo='20190040';


--OnSite���������  ���ڸ�λ��   ��һ�Զࣩ  ����V��ͷ��������ͼ
select   *  from  V_RecruitPositionReq   a; 
select   *  from  RecruitPositionReq   a ;


--OnSite���������ܱ���    ��һ�Զࣩ  
select   *  from  RecruitWeekReport    a;

--��������¼  
select   *  from  WorkFlowRecord  a;

--PersonInfo  ��    
--OnJobStatus=1  ��ʾ��ְ
--OnJonStatus=0  ��ʾ��ְ


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




