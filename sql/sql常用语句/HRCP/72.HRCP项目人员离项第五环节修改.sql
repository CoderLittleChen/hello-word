--项目人员离项更新数据
update [ProjectPersonInfo] set MaterialReturnCurrent =(select OnSiteMaterialReturn from AreaConfig where WorkPlace=Area and DeleteFlag=0) where ProjectPersonInfoId in (
select pinfo.ProjectPersonInfoId--, MaterialReturnCurrent,PcCurrent,Area
from [ProjectPersonInfo] pinfo inner join ProcessFlow pf on pinfo.ProjectPersonInfoId=pf.ApprovalId inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
left join ProjectPersonRecord pr on pr.ProjectPersonInfoId=pinfo.ProjectPersonInfoId  
LEFT JOIN Department D2 ON D2.Code=pinfo.DeptCode2
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptCode1
LEFT JOIN Department d3 ON d3.Code=pinfo.DeptCode3
 where States='5' and MaterialReturnCurrent is NULL);

update [ProjectPersonInfo] set PcCurrent =(select RdAsset from AreaConfig where WorkPlace=Area and DeleteFlag=0) where ProjectPersonInfoId in (
select pinfo.ProjectPersonInfoId--, MaterialReturnCurrent,PcCurrent,Area
from [ProjectPersonInfo] pinfo inner join ProcessFlow pf on pinfo.ProjectPersonInfoId=pf.ApprovalId inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
left join ProjectPersonRecord pr on pr.ProjectPersonInfoId=pinfo.ProjectPersonInfoId  
LEFT JOIN Department D2 ON D2.Code=pinfo.DeptCode2
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptCode1
LEFT JOIN Department d3 ON d3.Code=pinfo.DeptCode3
 where States='5' and PcCurrent is NULL);


--补充签名时间
Use  hrcp
go

update [ProjectPersonInfo] set MaterialReturnSign=PermissionCancleSign,MaterialReturnSignDate=PermissionCancleSignDate,MaterialReturnRemark='物料清退情况原属第六环节',MaterialReturnApproval=1
where ProjectPersonInfoId in 
( select pinfo.ProjectPersonInfoId--,MaterialReturnRemark,MaterialReturnApproval,MaterialReturnSign,MaterialReturnSignDate
from [ProjectPersonInfo] pinfo inner join ProcessFlow pf on pinfo.ProjectPersonInfoId=pf.ApprovalId inner join WorkFlowInstance wfi on wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
left join ProjectPersonRecord pr on pr.ProjectPersonInfoId=pinfo.ProjectPersonInfoId  
LEFT JOIN Department D2 ON D2.Code=pinfo.DeptCode2
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptCode1
LEFT JOIN Department d3 ON d3.Code=pinfo.DeptCode3
 where States>'5' and PermissionCancleSign<>'');