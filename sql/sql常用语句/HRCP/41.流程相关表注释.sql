--WorkFlow�������  ��������������Լ���id
select   *   from  WorkFlow  a;

--�������WorkFlow������ ÿ���������������Ľڵ�����ƺ�id
select   *   from  WorkFlowNode  a;

--����������  ���̵�ִ�м�¼��
--�������ĸ���  ��̫����

--��¼���� ÿ������ģ���Ӧ����������  �빦��ģ�飨�Ӳ˵���һһ��Ӧ
select    *   from   WorkFlow;

--��¼����  ÿ�������ж�Ӧ�Ľڵ��Լ��ýڵ��Ӧ��Code  
select   *   from   WorkFlowNode;

--��¼����  �����ڵ�֮�����ת��ϵ
select   *   from   WorkFlowTransition   a;

--��¼���ǵ�ǰʵ��Instance  ĳһ�����ݵĵ�ǰ�������Լ������Ľڵ�
select   *   from   WorkFlowTask   a;

--��¼����  ��ǰʵ���ĵ�ǰ״̬  
select   *   from   WorkFlowInstance  a;

--����������̵�ÿһ���ύ�������ļ�¼  
select   *   from   WorkFlowRecord  a;

--�������ÿһ������ �����ĵ�ǰ״̬�͵�ǰ�ڵ��Լ����ڵ�Status
select   *   from   ProcessFlow   a;

select   *   from OfficeConfig where OfficeArea='����·԰��' and DeleteFlag=0;

select   *   from  WorkFlowInstance   a;

select   *   from   Loginfo  a  order  by  a.LogTime desc;
--ViewData��Controller������ 

SELECT * FROM WorkFlow WHERE WorkFlowId='8E5D8253-E386-4242-9B58-2FA1902FE4AB'   --recruitReqApply

SELECT * FROM WorkFlowNode WHERE WorkFlowId='D477D130-7482-4D60-9B17-1C8FD0DA0059' order by Code

SELECT * FROM WorkFlowTransition WHERE FlowType='ProjectSetup' order by FromCode,ToCode


SELECT * FROM RecruitReqApply WHERE ReqcruitReqApplyId='4ca7cee2-efac-4fb3-af65-cead01adcb7c'

SELECT *  FROM ProcessFlow WHERE ApprovalId='82371bca-7e2d-437e-8d38-c96145d28334'

SELECT * FROM WorkFlowInstance  WHERE WorkFlowInstanceId='BD106074-9C08-4E74-94E1-CE8B00B08838'

SELECT * FROM WorkFlowTask WHERE WorkFlowInstanceId='BD106074-9C08-4E74-94E1-CE8B00B08838' ORDER BY CreateDate

SELECT WorkFlowRecord.* FROM WorkFlowRecord WHERE WorkFlowTaskId IN (
SELECT WorkFlowTaskId FROM WorkFlowTask WHERE WorkFlowInstanceId='BD106074-9C08-4E74-94E1-CE8B00B08838' );


--��ѯ��� 
SELECT WorkFlowRecord.* FROM WorkFlowRecord WHERE WorkFlowTaskId IN 
(
SELECT WorkFlowTaskId FROM WorkFlowTask   a
inner join  ProcessFlow  b   on  a.WorkFlowInstanceId=b.WorkFlowInstanceId
WHERE b.ApprovalId='82371bca-7e2d-437e-8d38-c96145d28334' 
);

select   *  from  WorkFlowRecord  a;

select   *  from   WorkFlowTransition  a;

select   *  from   ProcessFlow  a;
