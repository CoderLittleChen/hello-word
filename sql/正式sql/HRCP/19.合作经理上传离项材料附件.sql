
--合作经理上传离项材料   
create  view   V_ProjectCooMgrUploadLeaveFileRecord_History   as   
select    NEWID() as  PrimaryKey,a.ModificationDate,a.Modifier,a.ProjectPersonInfoId,
b.AttachLeaveUrl,b.MaterialLeaveFileNo,b.LeaveAgreeFile,a.CooMgrUploadReleaseDataSign,a.CooMgrUploadReleaseDataSignTime,
a.CooMgrUploadReleaseOpinion
from   ProjectPersonRecord_History  a
inner  join    MaterialFile_History   b   on   a.ProjectPersonRecordId=b.ProjectPersonRecordId;










