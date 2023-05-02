--WorkFlow保存的是  定义的流程名称以及其id
select   *   from  WorkFlow  a;

--保存的是WorkFlow流程中 每个流程中所包含的节点的名称和id
select   *   from  WorkFlowNode  a;

--这个表保存的是  流程的执行记录吗？
--下面这四个表  不太懂？

--记录的是 每个功能模块对应的流程名称  与功能模块（子菜单）一一对应
select    *   from   WorkFlow;

--记录的是  每个流程中对应的节点以及该节点对应的Code  
select   *   from   WorkFlowNode;

--记录的是  各个节点之间的跳转关系
select   *   from   WorkFlowTransition   a;

--记录的是当前实例Instance  某一条数据的当前处理人以及所处的节点
select   *   from   WorkFlowTask   a;

--记录的是  当前实例的当前状态  
select   *   from   WorkFlowInstance  a;

--保存的是流程的每一次提交、审批的记录  
select   *   from   WorkFlowRecord  a;

--保存的是每一条数据 所处的当前状态和当前节点以及对于的Status
select   *   from   ProcessFlow   a;

select   *   from OfficeConfig where OfficeArea='北清路园区' and DeleteFlag=0;

select   *   from  WorkFlowInstance   a;

select   *   from   Loginfo  a  order  by  a.LogTime desc;
--ViewData是Controller的属性 

SELECT * FROM WorkFlow WHERE WorkFlowId='8E5D8253-E386-4242-9B58-2FA1902FE4AB'   --recruitReqApply

SELECT * FROM WorkFlowNode WHERE WorkFlowId='D477D130-7482-4D60-9B17-1C8FD0DA0059' order by Code

SELECT * FROM WorkFlowTransition WHERE FlowType='ProjectSetup' order by FromCode,ToCode


SELECT * FROM RecruitReqApply WHERE ReqcruitReqApplyId='4ca7cee2-efac-4fb3-af65-cead01adcb7c'

SELECT *  FROM ProcessFlow WHERE ApprovalId='82371bca-7e2d-437e-8d38-c96145d28334'

SELECT * FROM WorkFlowInstance  WHERE WorkFlowInstanceId='BD106074-9C08-4E74-94E1-CE8B00B08838'

SELECT * FROM WorkFlowTask WHERE WorkFlowInstanceId='BD106074-9C08-4E74-94E1-CE8B00B08838' ORDER BY CreateDate

SELECT WorkFlowRecord.* FROM WorkFlowRecord WHERE WorkFlowTaskId IN (
SELECT WorkFlowTaskId FROM WorkFlowTask WHERE WorkFlowInstanceId='BD106074-9C08-4E74-94E1-CE8B00B08838' );


--查询语句 
SELECT WorkFlowRecord.* FROM WorkFlowRecord WHERE WorkFlowTaskId IN 
(
SELECT WorkFlowTaskId FROM WorkFlowTask   a
inner join  ProcessFlow  b   on  a.WorkFlowInstanceId=b.WorkFlowInstanceId
WHERE b.ApprovalId='82371bca-7e2d-437e-8d38-c96145d28334' 
);

select   *  from  WorkFlowRecord  a;

select   *  from   WorkFlowTransition  a;

select   *  from   ProcessFlow  a;
