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



















