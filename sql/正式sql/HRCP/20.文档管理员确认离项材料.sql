
create  view   V_ProjectDocAdminConfirmLeaveFileRecord_History   as   
select    NEWID() as  PrimaryKey,a.ModificationDate,a.Modifier,a.ProjectPersonInfoId,
b.AttachLeaveUrl,a.DocAdminSureReleaseDataSign,a.DocAdminSureReleaseDataSignTime,a.DocAdminSureReleaseOpinion
from   ProjectPersonRecord_History  a
inner  join    MaterialFile_History   b   on   a.ProjectPersonRecordId=b.ProjectPersonRecordId;






