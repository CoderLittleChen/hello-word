--�ĵ�����Աȷ��������ϼ�¼
go
create view   V_ProjectDocAdminConfirmEntryFileRecord_History  as
select   NEWID() as  PrimaryKey,a.ModificationDate,a.Modifier,a.ProjectPersonInfoId,
b.AttachUrl,a.DocAdminSureEntryOpinion,a.DocAdminSureEntryDataSign,a.DocAdminSureEntryDataSignTime
from   ProjectPersonRecord_History   a 
inner  join   MaterialFile_History    b   on  a.ProjectPersonRecordId=b.ProjectPersonRecordId;












