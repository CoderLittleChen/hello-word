--将搜索条件改为多选  问题点
--1、搜索条件中的数据是从数据库中查出来的  需要在页面上的常量配置中进行配置
--2、其次将 代码修改为多选的代码  原来为 select   option 类型的
--3、常量配置完毕，代码也修改了  但是还是点击没有弹出常量选择页面，是因为没有引用ControlCommon.js  

--sql语句的执行顺序

--from  
--join   
--on    
--where   
--group  by 
--avg sum
--having
--select   
--distinct
--order by
--top


--AppConstant				常量类别   常量的类别
--AppConstantValue		常量值
select  *   from   AppConstantValue  a    where  a.Text='ICT委托开发';

select  *   from   AppConstant  a    where  a.Name   like  '%项目人员管理%';

--9B50E82D-566E-4D7A-AA81-68173C4EC32F
select  *   from   AppConstantValue  a    where  a.AppConstantId='9B50E82D-566E-4D7A-AA81-68173C4EC32F';

--项目人员记录  人员状态中的几种类型       
--在岗-外场   
--在岗-内场
--离场办理中
--离项办理中
--离项    
--释放
  


select   *      from   ProjectPersonInfo   a;
select   a.*   from   V_ProjectPersonRecord   a    where  a.PersonStatus  like  '%转%';

select   a.Name,a.MaterialFileNo,a.CreateDate      from   V_ProjectPersonRecord   a   order  by   a.CreateDate  desc;

--该函数用来生成材料归档新编号  MaterialFileNo
select  dbo.F_GetSerialProjectFileCode();

select  dbo.F_GetSerialProjectLeaveFileCode();

select   convert(varchar(4),Getdate(),112);

select   a.MaterialFileNo,MaterialLeaveFileNo,a.MaterialFileId,a.*   from  MaterialFile  a   order  by   a.CreateDate desc;

select   *   from  ProjectPersonInfo   a  where  ProjectPersonInfoId='0EAAEFBA-D445-4C90-AF19-F6C72162D0E3';

--update  MaterialFile   set   MaterialLeaveFileNo='20190001'  where  MaterialFileId='91430E55-93F7-45EF-B1CA-8AD6049691DC';

select   *   from    MaterialFile  a  inner   join   ProjectPersonInfo   b   on  a.PersonInfoId=b.ProjectPersonInfoId 
where  (b.Name  like  '&陈敏测试&');
  
--考勤异常   

--找不到项目人员的   离项操作是在哪里？
select   *    from   ProjectPersonInfo   a;

--考勤记录表
select   *    from   AttendanceRecord  a;

--考勤异常表
--表中  AbnormalRecordId  是怎么来的？什么意思？
--通过AttendanceRecordId 来进行关联 
select   *    from   AttendanceAbnormalDetail   a;         
         

--项目人员离项  查询的是  V_ProjectPersonInfo                                                                                                                                                                                                                                                                                                                                                                                                             





