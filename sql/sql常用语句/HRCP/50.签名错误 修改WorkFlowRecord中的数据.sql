--�޸ĵı�  WorkFlowRecord   

--1����ҳ�����õ����������id   ��ӦProcessFlow�е�ApprovalId,����ApprovalId�����Ӧ��InstanceId
select   *   from   ProcessFlow   a   where  a.ApprovalId='954c1577-3626-40bf-9535-13273f4529e8';

--2����WorkFlowTask��  ����WorkFlowInStanceId����ѯ����Ӧ��WorlFlowTaskId    InstanceId��TaskId��һ�Զ��ϵ  

select   *   from   WorkFlowTask  a    where   a.WorkFlowInstanceId='027BA48E-4AD0-4471-8EF6-F6292DD6BC68';

--3���ҵ���Ӧ���̵�TaskId  ��ΪΨһ����  ������Record���ж�Ӧ���ֶ� 
select   *   from  WorkFlowRecord  a;