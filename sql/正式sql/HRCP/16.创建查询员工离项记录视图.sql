--查询员工的离项/释放记录
create view   V_ProjectPersonLeaveRecord_History  as
select       NEWID() as  PrimaryKey , a.FirstPersonInfoId,a.ReleaseType,a.LeaveFieldDate,a.ProMgrReleaseDate,
b.ProMgrSureReleaseDateSign,b.ProMgrSureReleaseDateSignTime,a.ModificationDate,a.Modifier
from   ProjectPersonInfo_History   a    left  join   ProjectPersonRecord_History  b   on  a.FirstPersonInfoId=b.ProjectPersonInfoId  and  a.ProjectPersonRecordId=b.ProjectPersonRecordId;







