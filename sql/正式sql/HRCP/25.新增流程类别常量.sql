insert   into   AppConstant  
values(NEWID(),'WorkFlowType','项目流程类别',GETDATE(),'liuyujing kf6850','','',0);

insert  into   AppConstantValue
select   NEWID(),AppConstantId,'OnSiteRecruit','OnSite需求申请','OnSiteRecruit',1,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeRecruit','实习生需求申请','TraineeRecruit',2,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSitePersonEntry','OnSite人员入项','OnSitePersonEntry',3,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineePersonEntry','实习生人员入项','TraineePersonEntry',4,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSitePersonLeave','OnSite人员离项','OnSitePersonLeave',5,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineePersonLeave','实习生人员离项','TraineePersonLeave',6,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSitePersonEvaluate','OnSite人员考评','OnSitePersonEvaluate',7,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeEvaluate','实习生人员考评','TraineeEvaluate',8,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeThesis','实习生论文审批','TraineeThesis',9,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeBankInfo','实习生银行信息','TraineeBankInfo',10,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeCertificate','实习生证明办理','TraineeCertificate',11,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'CooProjectSetup','合作项目立项申请','CooProjectSetup',12,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'AskForLeave','请假申请','AskForLeave',13,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'AskForOverTime','加班申请','AskForOverTime',14,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'AskForAddPoint','加点申请','AskForAddPoint',15,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeApproval','实习生人员报批','TraineeApproval',16,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProjectSummary','项目总结报告','ProjectSummary',17,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProjectExceptionEnd','项目异常中止','ProjectExceptionEnd',18,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'WorkingAbnormal','工作日异常反馈','WorkingAbnormal',19,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonEntry','进入研发区申请','ProPersonEntry',20,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonLeave','项目人员离项','ProPersonLeave',21,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonEvaluate','项目人员考评','ProPersonEvaluate',22,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'PayConfirm','对外付款报告','PayConfirm',23,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSiteTraineePayReport','Onsite/实习生付款报告','OnSiteTraineePayReport',24,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ConfirmPersonLeaveArchive','人员离项归档确认','ConfirmPersonLeaveArchive',25,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'PersonLeaveArchive','人员离项归档','PersonLeaveArchive',26,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeEntryArchive','实习生入项归档','TraineeEntryArchive',27,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeLeaveArchive','实习生离项归档','TraineeLeaveArchive',28,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProjectSummary','项目验收报告','ProjectSummary',29,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonEntryArchive','项目人员入项归档','ProPersonEntryArchive',30,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ConfirmProPersonEntryArchive','项目人员入项归档确认','ConfirmProPersonEntryArchive',31,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonLeaveArchive','项目人员离项归档','ProPersonLeaveArchive',32,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ConfirmProPersonLeaveArchive','项目人员离项归档确认','ConfirmProPersonLeaveArchive',33,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSiteToFormal','优秀合作员工转正','OnSiteToFormal',34,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType';
