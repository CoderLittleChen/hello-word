-------ProjectPersonRecord_History表
--NoMaterial  无人员材料
--ByMonthAccount  是否按人月结算
--CooMgrUploadEntryDataUrl    合作经理上传入项材料url
--CooMgrUploadEntryOpinion
--CooMgrUploadEntryDataSign
--CooMgrUploadEntryDataSignTime

-------MaterialFile_History表
--PersonalAgreeFile   个人保密承诺书
--InterviewFile			外包项目人员测评表
--WrittenFile				笔试答题纸
--PhysicalCopyFile     体检报告复印件
--IdCardCopyFile       身份证复印件
--CvCopyFile             简历/实习生报名表
--GraduateCopyFile   毕业证学位证复印件  

go
create view   V_ProjectCooMgrUploadEntryFileRecord_History  as
select   NEWID() as  PrimaryKey,a.ModificationDate,a.Modifier,
a.NoMaterial,a.ByMonthAccount,a.ProjectPersonInfoId,
b.AttachUrl,a.CooMgrUploadEntryOpinion,
a.CooMgrUploadEntryDataSign,a.CooMgrUploadEntryDataSignTime,
b.PersonalAgreeFile,b.InterviewFile,b.WrittenFile,b.PhysicalCopyFile,b.IdCardCopyFile,
b.CvCopyFile,b.GraduateCopyFile,b.MaterialFileNo
from   ProjectPersonRecord_History   a 
inner  join   MaterialFile_History    b   on  a.ProjectPersonRecordId=b.ProjectPersonRecordId;



















