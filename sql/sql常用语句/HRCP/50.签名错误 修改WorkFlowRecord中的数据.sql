--修改的表  WorkFlowRecord   

--1、从页面上拿到数据主表的id   对应ProcessFlow中的ApprovalId,根据ApprovalId查出对应的InstanceId
select   *   from   ProcessFlow   a   where  a.ApprovalId='954c1577-3626-40bf-9535-13273f4529e8';

--2、在WorkFlowTask中  根据WorkFlowInStanceId来查询出对应的WorlFlowTaskId    InstanceId和TaskId是一对多关系  

select   *   from   WorkFlowTask  a    where   a.WorkFlowInstanceId='027BA48E-4AD0-4471-8EF6-F6292DD6BC68';

--3、找到对应流程的TaskId  作为唯一条件  来更新Record表中对应的字段 
select   *   from  WorkFlowRecord  a;