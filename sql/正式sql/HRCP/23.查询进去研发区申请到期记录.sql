create  view  V_ProjectPersonEntryWarning  as
select  *   from 
(
select  NEWID() as  PrimaryKey  ,d.ProjectName,d.ProjectMgr,d.CooMgr,
b.Name,c.ApplyStartDate,c.ApplyEndDate
,ROW_NUMBER()  over(partition  by   d.ProjectName,b.Name  order  by  c.ApplyEndDate  desc)   as   rankNum
from  ProjectEntry_Person_Relation   a 
inner   join  ProjectPersonInfo  b   on  a.ProjectPersonInfoId=b.ProjectPersonInfoId  and b.PersonStatus='ÔÚ¸Ú-ÄÚ³¡'
inner   join  ProjectPersonEntry c   on  a.ProjectPersonEntryId=c.ProjectPersonEntryId
left  join  ProjectControl  d  on  c.ProjectControlId=d.ProjectControlId
) temp
where  temp.rankNum=1    and    DATEDIFF(day,GETDATE(),temp.ApplyEndDate)<=14 and  DATEDIFF(day,GETDATE(),temp.ApplyEndDate)>=0;








