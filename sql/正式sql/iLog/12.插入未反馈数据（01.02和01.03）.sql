--插入01.02数据
insert  into   UnFeedBackHourInfo 
select  NEWID(),'','',
'00000000-0000-0000-0000-000000000000','','',
'00000000-0000-0000-0000-000000000000','','',
'00000000-0000-0000-0000-000000000000','','',
'00000000-0000-0000-0000-000000000000','','',
'2020-01-02',
Name,Code,'0.000000',null,'',SecondDeptName,a.DeptName,SecondDeptCode,a.DeptCode,c.BillNo,c.id,0,'D'
from UserInfo a 
left  join  Department  b   on   a.DeptCode=b.DeptCode
left  join  HourInfoMain   c  on  a.Code=c.UserCode  and  c.CreateTime='2019-12-30'
where a.DeleteFlag=0  and c.id  is not  null  
and not exists(select 1 from HourInfo_New b where b.Date='2020-01-02' and FillState=0 and exists(select 1 from HourInfoMain c where c.UserCode=a.Code and c.id=b.HMain_ID))


--插入01.03数据
insert  into   UnFeedBackHourInfo 
select  NEWID(),'','',
'00000000-0000-0000-0000-000000000000','','',
'00000000-0000-0000-0000-000000000000','','',
'00000000-0000-0000-0000-000000000000','','',
'00000000-0000-0000-0000-000000000000','','',
'2020-01-03',
Name,Code,'0.000000',null,'',SecondDeptName,a.DeptName,SecondDeptCode,a.DeptCode,c.BillNo,c.id,0,'D'
from UserInfo a 
left  join  Department  b   on   a.DeptCode=b.DeptCode
left  join  HourInfoMain   c  on  a.Code=c.UserCode  and  c.CreateTime='2019-12-30'
where a.DeleteFlag=0  and c.id  is not  null
and not exists(select 1 from HourInfo_New b where b.Date='2020-01-03' and FillState=0 and exists(select 1 from HourInfoMain c where c.UserCode=a.Code and c.id=b.HMain_ID))