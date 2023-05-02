--验收报告审批记录视图  V_FlowRecord
select   *  from   WorkFlowRecord   a   
where  a.Approvaler  like  '%caiyouhua%'    and   a.ApprovalTime='2018-12-17 14:10:09';

select   *   from   WorkFlowRecord  a   where   a.WorkFlowRecordId='C6D4AFF3-6D19-4621-9678-127CDC85913C';
--C6D4AFF3-6D19-4621-9678-127CDC85913C    E59002AB-0E97-4D25-ABAD-DCB5E8EA1710

--update   WorkFlowRecord   set   Approvaler='chenmin YS2689'
--where  WorkFlowRecordId='C6D4AFF3-6D19-4621-9678-127CDC85913C'  or  WorkFlowRecordId='E59002AB-0E97-4D25-ABAD-DCB5E8EA1710';

--查询审批记录  WorkFlowRecord  
--其中包含几个外键id   WorkFlowTaskId   WorkFlowTransitionId     
select   *   from   WorkFlowTask  a;


--ProjectControlId   0FFEA351-61F2-4A86-BC6E-5EC763957684
select   *   from   ProjectCheckReport  a;
select   *   from   ProjectControl  a  where  a.AgreementNum='2018-INT-OTR-088';
select   *   from   ContractStage  a;
select   *   from   ProcessFlow  a;
select   *   from   WorkFlowInstance  a;
select  *    from  ProjectCheckReport  a;
select  *    from  WorkFlowRecord  a;


