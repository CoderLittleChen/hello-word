use hrcp;
--logInfo   ��־��¼��  
select   *  from  loginfo  order   by  LogTime desc;

--WorkFlow�����HRCPϵͳ�ļ�����Ҫ�Ĺ�����
select   *  from  WorkFlow   a   where  a.WorkFlowId='0D8B81F4-7596-40E3-B999-A4FBC611DBDA';

select   *  from  WorkFlowInstance  a;

select   *  from  WorkFlowNode   a   where  a.WorkFlowId='0D8B81F4-7596-40E3-B999-A4FBC611DBDA'
order by   a.Code;


select  *  from  PersonInfo  a where  EmployeeName='ceshi1';

select  *  from  VEmployee a  where  a.RegionAccount  like '%14514%';

select  *  from  PersonEvaluate   a;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
select  a.CurrentNode,a.CurrentPerson  from  V_PayReportDetail   a  where  a.ProjectId='FRD201906-01';

select  *  from  V_PayList  a;

select  *  from  V_OnsitePayReport   a;

select  *  from  WorkFlowRecord  a;

--��ѯ�����е�������¼
select  *  from  V_FlowRecord  a;









