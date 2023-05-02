use hrcp;
select  *  from  Loginfo   a   order  by  a.LogTime desc;

select  *  from  ProjectPersonInfo   a  where  a.Name  like  '%≥¬√Ù≤‚ ‘2%';

select  *  from  ProjectPersonInfo_History   a  where  a.Name  like  '%≥¬√Ù≤‚ ‘2%';

exec  P_ArchiveProjectPersonInfo   '73a998ed-fa77-4f62-a826-1a9a2a3dcb7c','liuyujing kf6850','lkf6850'  

select   *   from   ProjectPersonInfo    a     where   a.ProjectPersonInfoId='73a998ed-fa77-4f62-a826-1a9a2a3dcb7c';

select   *   from   ProjectPersonInfo_History    a     where   a.ProjectPersonInfoId='73a998ed-fa77-4f62-a826-1a9a2a3dcb7c';

--drop   procedure   P_ArchiveProjectPersonInfo;

select   a.WorkNum,a.NotesId,a.Domains,*   from   PersonEntry   a  where a.EmployeeName='’≈∞Æ¡·';

--update   PersonEntry   set   WorkNum='59954' where  EmployeeName='’≈–°∑…';

--update   PersonEntry   set   PY_Xing='zhang',PY_Ming='xiaofei' where  EmployeeName='’≈–°∑…';

select   NotesId,*   from   PersonEntry   a  where  a.NotesId!=''  order  by  a.RecruitNo desc;

select  *   from   Department   a ;

select  a.LeaveAgreeRemark,LeaveConfirmOpinion,a.LeaveReason,a.CooOpinion,*   from   V_PersonInfo  a   where  a.DeleteFlag=0   and   a.IsTrainee=1  and  a.WorkNum='58945';

select  a.WorkNum,*  from  PersonEntry  a   order  by  a.WorkNum  desc;

select  *  from   AppConstantValue  a  order by  a.CreateDate desc;

select  *  from   AppConstant  a;

select  *  from   V_PersonEntry  a  where  a.Name='ª∆≤≥';

select  *  from   AppConstantValue  a 
where  a.Text like '%dinghaitao%'
order by  a.CreateDate desc;







