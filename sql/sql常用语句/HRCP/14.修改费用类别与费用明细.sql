select  a.CostType,a.ParticularCostType,*  from  PayReport   a   where  a.ProjectId='FRD201904-01'  and  a.DeleteFlag=0;

select  a.ParticularCostType  from   PayReport   a   where  a.CostType='������'  group  by    a.ParticularCostType;

--1���޸����ձ���
--update ProjectCheckReport    set  NextAuditors='zhangsan 12345'
--where  ProjectCheckReportId='A747221E-19F2-484D-9358-A6E9877BBD23';

--update  WorkFlowRecord  set   Approvaler='zhangsan 12345'
--where  WorkFlowRecordId='C6D4AFF3-6D19-4621-9678-127CDC85913C'  
--or  WorkFlowRecordId='E59002AB-0E97-4D25-ABAD-DCB5E8EA1710' ;

--2���޸ķ������ͺͷ�����ϸ
--update  PayReport   set  ParticularCostType='��ҵί���������'   where  ProjectId='FRD201906-01'  and  a.DeleteFlag=0;
--update PayReport   set  CostType='������Է�',ParticularCostType='����'   where  ProjectId='RD20181107'  and  DeleteFlag=0;
--update PayReport  set  ParticularCostType='NRE-ODM��Ŀ'  where  ProjectId='FRD201904-01'  and  DeleteFlag=0;

--3���޸���Ա����ڽ�ֹ����
--update   PersonInfo   set   AttendEndDate='2019-02-23'   where WorkNum='40218';


select   *   from   PayReport  a;
--��672       =1  560    =2  22   =3 14    =4  4   =5  2
select  a.ProjectId  from PayReport  a  group  by   a.ProjectId  having  count(a.ProjectId)>6;
select   a.AttendEndDate   from  PersonInfo    a   where   a.WorkNum='40218';

--�Ժ�ע�⸶���Ǹ���ͬ������һ�ڶ�Ӧ��   
--����һ����Ŀ  ��Ӧһ����ͬ��   
--һ����ͬ�Ŷ�Ӧ�����ͬ����     
--һ����ͬ���ڶ�Ӧһ��ȷ�ϸ���棨��Ŀ���ձ��桢�׶��Ա��桢�ɹ�ת���嵥���ܽᱨ�桢��������Ҳ�����ƣ�   
select  *  from  PayReport   a;
