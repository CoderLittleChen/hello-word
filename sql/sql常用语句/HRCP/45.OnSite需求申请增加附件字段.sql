use  hrcp;

select  *   from   RecruitReqApply  a ;

select  a.SetupMaterial,a.SetupMaterialAttach,a.ProjectNum,a.*   from   ProjectSetup   a   where  a.ProjectNum='RD20181101'

select  *   from   RecruitReqApply   a   where  a.RecruitNo='20190011';

select  *   from   FileArchive   a;  
 
--alter table  RecruitReqApply  add      RecruitReqApplyAttach    nvarchar(max)  null;

select  *    from   RecruitReqApply   a  where  a.RecruitNo='20190017';

select  *    from   RecruitPositionReq  a;  

select  *    from   PersonInfo  a   where  a.DeleteFlag=0   and  IsTrainee=0 ;

select  *   from  V_PersonInfo   a   where a.DeleteFlag=0  and  IsTrainee=0;

select  *   from  V_MyToDo  a  where  a.CurrentPerson  like '%liuyujing%' ;

select  *   from  PersonInfo  a;
