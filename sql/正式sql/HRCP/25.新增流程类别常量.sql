insert   into   AppConstant  
values(NEWID(),'WorkFlowType','��Ŀ�������',GETDATE(),'liuyujing kf6850','','',0);

insert  into   AppConstantValue
select   NEWID(),AppConstantId,'OnSiteRecruit','OnSite��������','OnSiteRecruit',1,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeRecruit','ʵϰ����������','TraineeRecruit',2,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSitePersonEntry','OnSite��Ա����','OnSitePersonEntry',3,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineePersonEntry','ʵϰ����Ա����','TraineePersonEntry',4,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSitePersonLeave','OnSite��Ա����','OnSitePersonLeave',5,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineePersonLeave','ʵϰ����Ա����','TraineePersonLeave',6,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSitePersonEvaluate','OnSite��Ա����','OnSitePersonEvaluate',7,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeEvaluate','ʵϰ����Ա����','TraineeEvaluate',8,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeThesis','ʵϰ����������','TraineeThesis',9,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeBankInfo','ʵϰ��������Ϣ','TraineeBankInfo',10,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeCertificate','ʵϰ��֤������','TraineeCertificate',11,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'CooProjectSetup','������Ŀ��������','CooProjectSetup',12,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'AskForLeave','�������','AskForLeave',13,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'AskForOverTime','�Ӱ�����','AskForOverTime',14,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'AskForAddPoint','�ӵ�����','AskForAddPoint',15,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeApproval','ʵϰ����Ա����','TraineeApproval',16,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProjectSummary','��Ŀ�ܽᱨ��','ProjectSummary',17,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProjectExceptionEnd','��Ŀ�쳣��ֹ','ProjectExceptionEnd',18,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'WorkingAbnormal','�������쳣����','WorkingAbnormal',19,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonEntry','�����з�������','ProPersonEntry',20,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonLeave','��Ŀ��Ա����','ProPersonLeave',21,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonEvaluate','��Ŀ��Ա����','ProPersonEvaluate',22,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'PayConfirm','���⸶���','PayConfirm',23,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSiteTraineePayReport','Onsite/ʵϰ�������','OnSiteTraineePayReport',24,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ConfirmPersonLeaveArchive','��Ա����鵵ȷ��','ConfirmPersonLeaveArchive',25,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'PersonLeaveArchive','��Ա����鵵','PersonLeaveArchive',26,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeEntryArchive','ʵϰ������鵵','TraineeEntryArchive',27,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'TraineeLeaveArchive','ʵϰ������鵵','TraineeLeaveArchive',28,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProjectSummary','��Ŀ���ձ���','ProjectSummary',29,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonEntryArchive','��Ŀ��Ա����鵵','ProPersonEntryArchive',30,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ConfirmProPersonEntryArchive','��Ŀ��Ա����鵵ȷ��','ConfirmProPersonEntryArchive',31,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ProPersonLeaveArchive','��Ŀ��Ա����鵵','ProPersonLeaveArchive',32,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'ConfirmProPersonLeaveArchive','��Ŀ��Ա����鵵ȷ��','ConfirmProPersonLeaveArchive',33,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType'
union all
select   NEWID(),AppConstantId,'OnSiteToFormal','�������Ա��ת��','OnSiteToFormal',34,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='WorkFlowType';
