
select  *   from   ProjectPersonRecord   a;

select  *   from   ProjectPersonRecord_Temp;

select  *   from   ProjectPersonRecordBak;

--drop   table   ProjectPersonRecordBak;
--delete   ProjectPersonRecordBak;

--�������ݱ�(�������ɵı���̳�ԭ������� Լ����ϵ��)
--����д��ǰ���Ǳ���������   ��ֱ�Ӵ�������������     

--�����Ѿ�����   ��������д   
--insert  into  TargetTable  select   *  from     SourceTable;

--������  
--select  *   Into  ProjectPersonRecordBak   from   ProjectPersonRecord where 1=0;

select  *   from  ProjectPersonRecordBak  a;

select  *   from  ProjectPersonRecord   a;

select  *   from  ProjectPersonInfo  a;

select   COUNT(1)   from   ProjectPersonRecord  a    group  by  a.ProjectPersonInfoId   ;
  
--2D6BA8C0-F6C2-4808-B121-0028C1C75693,613442C9-E3AD-4469-B1B0-003657A34488

--����ָ������������
insert  into   ProjectPersonRecordBak  
select  *,NEWID(),'chenmin  123',GETDATE()   from  V_ProjectPersonRecord  a  where  a.ProjectPersonRecordId  in  ('2D6BA8C0-F6C2-4808-B121-0028C1C75693','613442C9-E3AD-4469-B1B0-003657A34488')


select  a.ApplyEntryArea   from   ProjectPersonRecord   a ;

select  a.ApplyEntryArea,*   from  V_ProjectPersonRecord   a ;

select  a.ApplyEntryArea   from  MaterialFile   a;

select  *   from   ProjectPersonInfo   a;   

select  *   from   PayReport  a;

select  *   from  BenefitProDivide  a   where   a.ProjectSetupId='';

select  *   from  Department  a   where  a.Name like '%�����ն��з���%';

select  *   from  AttendanceAbnormalDetail  a;

select  a.Name   from  V_ProjectPersonRecord  a   group  by  a.Name   having(COUNT(a.Name)>1);

select   *   from   WorkFlowRecord  a   where Remarks  like '%�����M1���ͺͰ�װ���%';
--8A7BF52D-F735-4333-B1DF-6D7C867E41AD

select   *   from   WorkFlowTransition   a  where  a.WorkFlowTransitionId='8A7BF52D-F735-4333-B1DF-6D7C867E41AD';

select   *   from   WorkFlowTask   a     where  a.WorkFlowTaskId='FB72E3EB-2FE9-464A-93E2-DC269C4D6497';

select   *   from   PayReport  a   where  a.ProjectId='RD20180806';

select   *   from   ProcessFlow  a  where  a.ApprovalId='954c1577-3626-40bf-9535-13273f4529e8';

--InStanceId��TaskId��һ�Զ��ϵ       WorkFlowTaskID��  InstancId  
select   *   from   WorkFlowTask  a   where a.WorkFlowInstanceId='027BA48E-4AD0-4471-8EF6-F6292DD6BC68';

select   *   from   WorkFlowRecord   a    where   a.WorkFlowTaskId='FB72E3EB-2FE9-464A-93E2-DC269C4D6497';  

select  a.IsPayStandingBook,*   from  PayReport   a   where  a.ProjectId='RD20171224'  and  a.Instalment=2;

select  *    from   PayStandingBook   a ;

--exec CreatePayStandingBook '954c1577-3626-40bf-9535-13273f4529e8','2019/8/21 0:00:00','cmmc'update PayStandingBook set ModificationDate=getdate(),Modifier='liuyujing kf6850' WHERE PayReportId IN ('954c1577-3626-40bf-9535-13273f4529e8')

select   *  from  PayStandingBook  a   where a.PayReportId='954c1577-3626-40bf-9535-13273f4529e8';

--delete     PayStandingBook   where  PayReportId='954c1577-3626-40bf-9535-13273f4529e8';

--update PayReport set IsPayStandingBook=0  where PayReportId='954c1577-3626-40bf-9535-13273f4529e8';
--exec CreatePayStandingBook '954c1577-3626-40bf-9535-13273f4529e8','2019/8/21 0:00:00','11111'update PayStandingBook set ModificationDate=getdate(),Modifier='liuyujing kf6850' WHERE PayReportId IN ('954c1577-3626-40bf-9535-13273f4529e8');

--exec CreatePayStandingBook '954c1577-3626-40bf-9535-13273f4529e8','2019/8/21 0:00:00','111'update PayStandingBook set ModificationDate=getdate(),Modifier='liuyujing kf6850' WHERE PayReportId IN ('954c1577-3626-40bf-9535-13273f4529e8')


--1�����ݱ�ı�ṹ  �Ƿ�Ӧ�ú�V_ProjectPersonRecord  ��ͼ�Ľṹһ����  �޷�ʵ��  
--2��02 03���ڵ��ֶ�  ����PerosnInfo���04-07���ڵ��ֶ�����PersonRecord ����� 
--1��ȷ�����ر�����ݵĲ�ѯ������ʲô     Ӧ������ProjectPersonInfoId
--2���������״̬��ť��  �����ݲ��뱸�ݱ�    
--3��ԭ��Ӧ��������Ψһ�ģ�һ����ֻ��Ӧһ��״̬   ��ʷ��¼���ڱ��ݱ���鿴     
--select  *   from   ProjectPersonRecord  a  where   a.   

select    a.ProjectPersonInfoId     from   ProjectPersonRecord  a  group  by  a.ProjectPersonInfoId;  

select    *     from   V_ProjectPersonRecord  a;

select    a.PersonStatus,a.IsInField     from  ProjectPersonInfo  a;

--LeaveDate  �볡ʱ��   ProMgrReleaseDate   ����ʱ��   
select    a.ApplyEntryArea,a.LeaveDate,a.ProMgrReleaseDate,a.LeaveType,*     from  ProjectPersonInfo  a  where  a.Name='����';

select    *     from    ProjectPersonRecordBak  a;

--select    *     from   ProjectPersonInfo  a   where  a.Name  like  '%����%';

select    a.Modifier,a.ModificationDate,*     from   ProjectPersonRecord   a  where a.ProjectPersonRecordId='f412d0d6-2fdd-43e2-9b12-dd3c181d6d17'

select   a.States,a.CurrentNode,a.EmployeeName,*  from  V_PersonEvaluate  a   order  by   a.States;

select  a.IsFinishFile,a.EntryFile      from    V_ProjectPersonRecord   a
where  a.IdCard='321023199302172416';

select  a.RecruitReqApplyAttach   from   RecruitReqApply   a  where   a.RecruitNo='20190026';

select  *    from  V_ProjectCheckReport   a;

select  a.DeleteFlag,a.ContractStageId,*    from  ProjectCheckReport   a  ;

select  *    from  ProjectStageReport  a;

select  *    from  ProjectResultList   a;

select  *    from  ProjectSummary  a;

select  *    from  ProjectEvaluateReport  a;

select  *    from  ContractStage  a  where   a.ContractStageId='34B0F101-5CC1-496B-BA96-A61A78208046'

select  *    from  ProjectControl  a  where  a.ProjectControlId='9A407EFB-8E5E-4ACF-8410-2AE24F9CAA90';

select  a.IsFinishFile,a.EntryFile,*   from    V_ProjectPersonRecord  a  where   a.EntryFile='' or a.EntryFile is null;

select *  from  V_ProjectPersonRecord   a  where  a.IdCard  in
(
select  a.IdCard  from  V_ProjectPersonRecord  a  group   by  a.IdCard having  count(a.Name)>1
)
order  by   a.IdCard  ;
	
select  *   from    WorkFlowNode   a   where  a.WorkFlowId='D477D130-7482-4D60-9B17-1C8FD0DA0059'  order  by  convert(int,a.Code);

select  a.RecruitReqApplyAttach,*   from    RecruitReqApply  a   where a.RecruitNo='20190028';

select  *   from  V_PeronsInfo_ForDataMP    a;

select  a.NotesId,a.WorkNum,*   from  PersonInfo  a   where   a.NotesId='kf7882';

select  a.ProjectStatus,*   from  ProjectControl   a;

select  a.PersonStatus,a.Name,*   from  ProjectPersonInfo   a ;

--���ΰ  ������   
select  *   from   ProjectPersonInfo   a   where  a.Name='����'  and  IdCard='130824199411062336';

--������ϱ��Ϊʲô���ظ���
select   a.MaterialLeaveFileNo,a. , *   from   V_ProjectPersonRecord  a  order  by  a.MaterialLeaveFileNo  desc;

select     [dbo].[F_GetSerialProjectLeaveFileCode]();

select  a.DeleteFlag,*   from   ProjectPersonInfo  a    where   a.Name='��˶��';

SELECT TOP 1 mf.MaterialLeaveFileNo FROM MaterialFile mf 
inner join ProjectPersonInfo pf ON mf.PersonInfoId=pf.ProjectPersonInfoId WHERE  pf.DeleteFlag=0  order by mf.MaterialLeaveFileNo desc

select  convert(varchar(4),Getdate(),112);

select  a.PersonalSecrecyAgreement,*   from    ProjectPersonInfo_History   a   where   a.Name   like  '���ΰ';

select  *   from    ProjectPersonRecord_History  a   where   a.ProjectPersonInfoId='87085C38-A3B9-4442-928E-5F9F0307A0F5';

--0F2E2AC2-ADEE-41FF-9EC8-13D0E40D3B6F   2017  
--2A4D0C0D-DE23-4B4E-A753-34E5C09A8F3F  2018  
--87085C38-A3B9-4442-928E-5F9F0307A0F5  null
select  *   from    ProjectPersonInfo   a  where   a.Name   like  '���ΰ';


select pc.* from V_ProjectControl pc 
inner join ProjectControl_Person_Relation relation 
on pc.ProjectControlId =relation.ProjectControlId where relation.ProPersonId='{0}' AND relation.IsCurrent=0;

--û����������  ��Ϣ��ȫ����   �����  
select   a.ApplyEntryArea,a.IsInField,a.EntryDate,a.ExpiryDate,a.ApplyType,a.PersonalSecrecyAgreement,a.AttendanceClass,a.IsApplyId,a.ID   from    ProjectPersonInfo_History  a  where  a.FirstPersonInfoId='87085C38-A3B9-4442-928E-5F9F0307A0F5';
--drop  view  V_ProjectPersonInfo_History;

select   *    from   V_ProjectPersonInfoDetail   a;

select   a.LeaveDate,a.LeaveType,a.LeaveFieldDate,a.ReleaseTime,a.ReleaseType   from   ProjectPersonInfo_History  a   where  a.Name='���ΰ';

--select   *    from   V_ProjectPersonRecord_History  a;

--�������� ע��������ݵ�ʱ��    ��Ҫ��������  ������id��ѯ����������ظ�
select  a.NoMaterial,a.ByMonthAccount,a.*    from     ProjectPersonRecord_History    a
left  join    MaterialFile_History  b  on  a.ProjectPersonRecordId=b.ProjectPersonRecordId;

select  a.PersonalAgreeFile,*   from  MaterialFile_History   a ;

select  a.CooMgrUploadEntryDataUrl,a.CooMgrUploadEntryDataSign,a.CooMgrUploadEntryDataSignTime,a.CooMgrUploadEntryOpinion,*   from  ProjectPersonRecord_History   a ;

----------���������ϴ�������ϼ�¼
-------ProjectPersonRecord_History��
--NoMaterial  ����Ա����
--ByMonthAccount  �Ƿ����½���
--CooMgrUploadEntryDataUrl    ���������ϴ��������url
--CooMgrUploadEntryOpinion
--CooMgrUploadEntryDataSign
--CooMgrUploadEntryDataSignTime

-------MaterialFile_History��
--PersonalAgreeFile   ���˱��ܳ�ŵ��
--InterviewFile			�����Ŀ��Ա������
--WrittenFile				���Դ���ֽ
--PhysicalCopyFile     ��챨�渴ӡ��
--IdCardCopyFile       ���֤��ӡ��
--CvCopyFile             ����/ʵϰ��������
--GraduateCopyFile   ��ҵ֤ѧλ֤��ӡ��  

----------�ͷż�¼
--ReleaseType			��������
--LeaveFieldDate		�볡ʱ��
--ProMgrReleaseDate	��������

select  a.PersonalAgreeFile,a.*   from   MaterialFile_History  a;

select   a.DocAdminSureEntryDataSign,a.*    from   ProjectPersonRecord_History  a;

select  a.LeaveDate,a.LeaveFieldDate,a.LeaveType,a.ReleaseTime,a.ReleaseType,*   from   ProjectPersonInfo  a   where  a.Name='����';

select   a.PersonInfoId,*   from   MaterialFile   a  where  a.MaterialFileNo='20180042';

select  a.MaterialFileId  from  MaterialFile  a   group   by   a.MaterialFileId;

select  *   from   ProjectPersonInfo  a   
inner join   MaterialFile  b  on   a.ProjectPersonInfoId=b.PersonInfoId
where  b.MaterialFileNo='20180042';


--�ͷŵ���ʷ��¼   PersonInfo���PersonRecord������  
--a.ReleaseType,a.LeaveFieldDate,a.ProMgrReleaseDate,a.ProMgrSureReleaseDateSign,a.ProMgrSureReleaseDateSignTime

select   *   from   ProjectPersonRecord_History    a;


--4CAA35AA-04EC-4E1E-82A3-C93B2C574BC1	
select   *   from  MaterialFile   a  where  a.PersonInfoId='4CAA35AA-04EC-4E1E-82A3-C93B2C574BC1';

select  a.PingYing,a.OfficePlace,a.WorkPlace,a.OfficeLocation,*   from   V_PeronsInfo_ForDataMP  a;

select   a.Person,*   from  MaterialFile  a;

select    a.AttachUrl,a.AttachLeaveUrl,*   from  V_ProjectPersonRecord   a;

select   a.CooMgrUploadEntryDataUrl,*   from  ProjectPersonRecord  a;


select   *   from  MaterialFile_History  a;

select   *   from  ProjectPersonInfo_History  a;

select   *   from  ProjectPersonRecord_History  a;

--exec  P_ArchiveProjectPersonInfo   '7e876e7a-d88c-452f-8201-1dbd6df2e014','chenmin ys2689','lkf6850'  

select   *   from  ProjectPersonInfo   a  where  a.Name='��������1';

select   *   from  V_ProjectPersonRecord   a  where  a.Name='��������1';



select   a.CooMgr,*  from  ProjectPersonInfo   a   where  a.ProjectPersonInfoId='67E30355-2972-4D20-8A49-EE7644813455';

--update   ProjectPersonInfo    set   CooMgr='lixia 06533'   where  ProjectPersonInfoId='67E30355-2972-4D20-8A49-EE7644813455';

select  *   from  ProjectPersonRecord    a   where  a.ProjectPersonInfoId=''

select   NEWID() as  PrimaryKey,a.FirstPersonInfoId,a.ReleaseType,a.LeaveFieldDate,a.ProMgrReleaseDate,
b.ProMgrSureReleaseDateSign,b.ProMgrSureReleaseDateSignTime,a.ModificationDate,a.Modifier
from   ProjectPersonInfo_History   a    left  join   ProjectPersonRecord_History  b   on  a.FirstPersonInfoId=b.ProjectPersonInfoId  and  a.ModificationDate=b.ModificationDate
where  a.FirstPersonInfoId='67E30355-2972-4D20-8A49-EE7644813455';

--92399C50-03D3-4069-8B8D-092C389081B6
select  *   from  ProjectPersonInfo a where  a.Name='С��';
select   a.AttachUrl,*   from  MaterialFile   a   where  a.PersonInfoId='92399C50-03D3-4069-8B8D-092C389081B6';

select   NEWID() as  PrimaryKey,a.ModificationDate,a.Modifier,
a.NoMaterial,a.ByMonthAccount,a.ProjectPersonInfoId,
b.AttachUrl,a.CooMgrUploadEntryOpinion,
a.CooMgrUploadEntryDataSign,a.CooMgrUploadEntryDataSignTime,
b.PersonalAgreeFile,b.InterviewFile,b.WrittenFile,b.PhysicalCopyFile,b.IdCardCopyFile,
b.CvCopyFile,b.GraduateCopyFile,b.MaterialFileNo
from   ProjectPersonRecord_History   a 
left  join   MaterialFile_History    b   on  a.ProjectPersonRecordId=b.ProjectPersonRecordId
where  a.ProjectPersonInfoId='7F032537-D5B5-47FA-9369-BED726A83A4F';

select   *   from   ProjectPersonInfo   a   where   a.Name='С��';

select   *   from   ProjectPersonRecord   a  where  a.ProjectPersonInfoId='7F032537-D5B5-47FA-9369-BED726A83A4F';

select   a.AttachUrl,a.AttachLeaveUrl,*   from   MaterialFile  a  where  a.PersonInfoId='7F032537-D5B5-47FA-9369-BED726A83A4F';

--RecordId   E4DFF8A6-17D0-4241-9BFA-18875953503D
select   *   from  ProjectPersonRecord_History   a     where   a.ProjectPersonInfoId='7F032537-D5B5-47FA-9369-BED726A83A4F';\

select   *   from  ProjectPersonRecord_History   a     where   a.ProjectPersonRecordId='20BA4794-2FEB-4FF1-87E9-EF854BFA0ABF';

select   *   from  MaterialFile_History  a   order   by   a.ModificationDate desc;

select   a.PersonalAgreeFile,a.InterviewFile,WrittenFile,PhysicalCopyFile,IdCardCopyFile,CvCopyFile,GraduateCopyFile,*   from  MaterialFile_History   a    where   a.ProjectPersonRecordId='E4DFF8A6-17D0-4241-9BFA-18875953503D';

select   a.DeleteFlag,a.OnJobStatus,*   from  PersonInfo  a  where   len(a.Telephone)!=11;

select   *   from    ProjectPersonEntry  a;

select   *   from    ProjectControl_Person_Relation   a;


--Personid  2e977496-050f-43aa-ad8e-566bf7a17685

select * from V_ProjectControl_Person_Relation where ProjectPersonInfoId='2e977496-050f-43aa-ad8e-566bf7a17685' order by CreateDate Desc