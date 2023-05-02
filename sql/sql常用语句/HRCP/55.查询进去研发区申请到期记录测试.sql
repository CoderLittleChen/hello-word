use  hrcp;
--这里存在一个项目多次申请   需要最大申请结束日期和当前日期进行比较  14天之内  发邮件提醒   

select   a.ProjectNum   from  V_ProjectPersonEntry  a  group   by   a.ProjectNum,a.ProjectName;


--go
--create    view   V_ProjectPersonEntryWarning  as
--select  *   from  
--(
--	select   *   from   
--		(
--		select   NEWID() as PrimaryKey,a.ProjectName,a.ProjectMgr,a.CooMgr,a.ApplyStartDate,a.ApplyEndDate,b.Name,
--		ROW_NUMBER()  over(partition by  b.Name  order  by  a.ApplyEndDate  desc) as  rankNum    
--		from    V_ProjectPersonEntry    a
--		left join   ProjectPersonInfo  b  on  a.ProjectNum=b.ProjectCode  and  a.ProjectName=b.ProjectName  
--		where  b.PersonStatus='在岗-内场'
--		)    temp1
--		where  temp1.rankNum=1
--)  temp2
--where  DATEDIFF(day,GETDATE(),temp2.ApplyEndDate)<=14  and  temp2.ApplyEndDate>GETDATE();   




select   *   from   ProjectPersonInfo;    
 


--select   *    from   ProjectPersonEntry   a   where  a.n

--
--drop  view   V_ProjectPersonEntryWarning	

--项目中对应的人员信息  从哪里来？ 表示如何关联？ 这里应该要的申请的开始和结束时间
select  b.Name,*   from   V_ProjectPersonEntry   a 
inner join   ProjectPersonInfo  b  on  a.ProjectNum=b.ProjectCode  and  a.ProjectName=b.ProjectName
--where  a.CooMgr='lixia 06533' order by  b.ApplySignDate  desc ; 
where  b.Name='李美丽';

select  a.EntryDate,a.ExpiryDate,*   from   ProjectPersonInfo   a   where  a.PersonStatus='在岗-内场'  order  by  a.CreateDate  desc;  

select   DATEDIFF(day,GETDATE(),null);

--内场人员项目到期提醒
--人员状态要限制成在岗-内场
--同一条项目可以创建多次申请
--每次创建申请可以添加多条人员记录  

--每个内场人员对应一个项目   然后查出申请的最大时间   与当前时间做比较   

select   *   from  V_ProjectPersonEntry   a   where  a.ProjectName='项目测试';

select  b.ProjectName,b.CooMgr,b.ProjectMgr,c.Name  from   ProjectPersonEntry  a  
inner  join   ProjectControl   b  on  a.ProjectControlId=b.ProjectControlId
inner  join   ProjectPersonInfo   c  on   b.ProjectNum=c.ProjectCode  and  b.ProjectName=c.ProjectName
where  b.ProjectName='项目测试';    



select   *   from   
(
select   NEWID() as PrimaryKey,a.ProjectName,a.ProjectMgr,a.CooMgr,a.ApplyStartDate,a.ApplyEndDate,c.Name,c.ProjectPersonInfoId,a.ProjectControlId,
ROW_NUMBER()  over(partition by  c.ProjectPersonInfoId,a.ProjectControlId  order  by  a.ApplyEndDate  desc) as  rankNum    
from    V_ProjectPersonEntry    a
inner join   ProjectControl_Person_Relation  b  on  a.ProjectControlId=b.ProjectControlId 
inner join   ProjectPersonInfo  c  on  b.ProPersonId=c.ProjectPersonInfoId
where  c.PersonStatus='在岗-内场'
)    temp
where  temp.rankNum=1  and  DATEDIFF(day,GETDATE(),temp.ApplyEndDate)<=14  and  temp.ApplyEndDate>GETDATE();    


--现在的问题  是用Controlld来进行数据关联  会导致数据重复
select   a.ApplyStartDate,a.ApplyEndDate,*    from   V_ProjectPersonEntry  a  
left  join  ProjectControl_Person_Relation   b   on  a.ProjectControlId=b.ProjectControlId
left  join   ProjectPersonInfo  c  on  b.ProPersonId=c.ProjectPersonInfoId
order by   a.CooMgrSignDate desc;


select   *   from   ProjectControl_Person_Relation   a;
select   *   from   ProjectPersonInfo  a;

select  a.CreateBy,a.CreateDate,*   from   ProjectControl  a;

--应该是先找出人员信息   项目信息   申请开始时间   申请结束时间      申请开始事
 
select  *   from 
(
select  NEWID() as  PrimaryKey  ,d.ProjectName,d.ProjectMgr,d.CooMgr,
b.Name,c.ApplyStartDate,c.ApplyEndDate
,ROW_NUMBER()  over(partition  by   d.ProjectName,b.Name  order  by  c.ApplyEndDate  desc)   as   rankNum
from  ProjectEntry_Person_Relation   a 
inner   join  ProjectPersonInfo  b   on  a.ProjectPersonInfoId=b.ProjectPersonInfoId
inner   join  ProjectPersonEntry c   on  a.ProjectPersonEntryId=c.ProjectPersonEntryId
left  join  ProjectControl  d  on  c.ProjectControlId=d.ProjectControlId
) temp
where  temp.rankNum=1 and    DATEDIFF(day,GETDATE(),temp.ApplyEndDate)<=14 and  DATEDIFF(day,GETDATE(),temp.ApplyEndDate)>=0;


--temp.rankNum=1 and
--and  temp.Name='cm1'

select   *   from  ProjectControl_Person_Relation  a  where  a.ProjectControlId='3B1DB991-6A89-4502-A924-2C787252BDD5';
select   *   from  ProjectControl  a  where  a.ProjectName='项目测试';

--ProjectControlId   3B1DB991-6A89-4502-A924-2C787252BDD5

--这个表中  一个人员 同一个项目多次申请  是怎么记录的？  只记录id的关联    
select  *   from  ProjectControl_Person_Relation  a  
where  a.ProjectControlId='3B1DB991-6A8-4502-A924-2C787252BDD5'  and   ControlPersonRelationId='B6DAA1BF-2452-4706-B6BE-C3EF93FA30F9';

select   *  from  ProjectPersonInfo   a  where  a.ProjectPersonInfoId='F8A8D3C3-8DE7-436B-B0EC-DE1512529970';

select   *  from  V_ProjectPersonEntry  a where   a.ProjectName='项目测试';

select   *  from  ProjectPersonEntry  a  where  a.ProjectControlId='3B1DB991-6A89-4502-A924-2C787252BDD5';

--ProjectControlId  3B1DB991-6A89-4502-A924-2C787252BDD5
--ProcessFlowId  10AA67F4-FBEE-4D64-9595-2C1F968C208E
--WorkFlowInstanceId  C8F10624-36CF-4B00-919C-06D7BA6712EB

select  *  from  ProcessFlow  a  where  ProcessFlowId='10AA67F4-FBEE-4D64-9595-2C1F968C208E';
select  *  from  WorkFlowInstance  a  where  WorkFlowInstanceId='C8F10624-36CF-4B00-919C-06D7BA6712EB';

select  *  from  V_ProjectPersonInfo_All  a;

select  *  from  ProjectEntry_Person_Relation   a;


select  *  from   ProjectPersonEntry  a   
inner  join  ProjectEntry_Person_Relation   b  on  a.ProjectPersonEntryId=b.ProjectPersonEntryId
inner  join  ProjectPersonInfo   c  on  b.ProjectPersonInfoId=c.ProjectPersonInfoId;

select  *  from  V_PeronsInfo_ForDataMP  a;

select  a.PersonStatus,*  from  ProjectPersonInfo  a   where    a.Name='cm3';  

select   a.PositionName,*   from    V_PersonEvaluate  a;


SELECT *, ROW_NUMBER()OVER(ORDER BY  CreateDate DESC,CurrentNode DESC )Num  FROM V_PersonEvaluate WHERE DeleteFlag=0 and IsTrainee=0;

select  *   from   V_PersonEvaluate;

select  a.PositionLevel,*   from  PersonInfo   a  where  a.EmployeeName='金云露';

select   *    from  PrjectPersonRDODC   a;

select   a.CurrentLevel,A.PositionLevel,*    from  PersonInfo   a  where  a.PositionLevel!=CurrentLevel  and  a.DeleteFlag=0  and  a.OnJobStatus=0;

select   a.PersonStatus,*   from  ProjectPersonInfo  a  where  a.Name='cm3';

--hrcp_rd_rdregularemployee     研发正式员工角色编码
--hrcp_rd_commonemployee	 普通员工角色编码










