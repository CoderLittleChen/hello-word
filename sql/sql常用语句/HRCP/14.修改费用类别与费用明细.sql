select  a.CostType,a.ParticularCostType,*  from  PayReport   a   where  a.ProjectId='FRD201904-01'  and  a.DeleteFlag=0;

select  a.ParticularCostType  from   PayReport   a   where  a.CostType='合作费'  group  by    a.ParticularCostType;

--1、修改验收报告
--update ProjectCheckReport    set  NextAuditors='zhangsan 12345'
--where  ProjectCheckReportId='A747221E-19F2-484D-9358-A6E9877BBD23';

--update  WorkFlowRecord  set   Approvaler='zhangsan 12345'
--where  WorkFlowRecordId='C6D4AFF3-6D19-4621-9678-127CDC85913C'  
--or  WorkFlowRecordId='E59002AB-0E97-4D25-ABAD-DCB5E8EA1710' ;

--2、修改费用类型和费用明细
--update  PayReport   set  ParticularCostType='工业委托造型设计'   where  ProjectId='FRD201906-01'  and  a.DeleteFlag=0;
--update PayReport   set  CostType='试验测试费',ParticularCostType='其他'   where  ProjectId='RD20181107'  and  DeleteFlag=0;
--update PayReport  set  ParticularCostType='NRE-ODM项目'  where  ProjectId='FRD201904-01'  and  DeleteFlag=0;

--3、修改人员离项考勤截止日期
--update   PersonInfo   set   AttendEndDate='2019-02-23'   where WorkNum='40218';


select   *   from   PayReport  a;
--总672       =1  560    =2  22   =3 14    =4  4   =5  2
select  a.ProjectId  from PayReport  a  group  by   a.ProjectId  having  count(a.ProjectId)>6;
select   a.AttendEndDate   from  PersonInfo    a   where   a.WorkNum='40218';

--以后注意付款是跟合同分期是一期对应的   
--可能一个项目  对应一个合同号   
--一个合同号对应多个合同分期     
--一个合同分期对应一个确认付款报告（项目验收报告、阶段性报告、成果转移清单、总结报告、评估报告也是类似）   
select  *  from  PayReport   a;
