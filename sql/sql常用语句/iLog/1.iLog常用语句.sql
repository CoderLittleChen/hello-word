select   *   from  DateSetting   a;

select  *  from  HourInfo_New  a   where  a.Creator like '%liucaixuan%'  order by  a.Date  desc;

select  *  from  User_Role_Relation  a;

select  *  from  HourInfoMain   a  order by  a.id   desc;

select  *  from  V_HourInfo_New;

select  *  from  HourInfo_New;

select  *  from  HourInfoDetailHistory   a;

select  *  from  ConstantValue  a order by a.CreationDate desc;

select  *  from  ProductInfo  a where  a.ProID in('989BEC98-BA86-45F6-B42D-8F2B875CC943');

select  *  from  PDTRelation   a;

select  *  from  V_HourInfoDetailHistory  a;

select  *  from   ProductConfig a  ;

select  *  from   ProductConfigLogic a;

select *  from   ProductConfigDetail  a  with(nolock)  where DetailId=1;

select  *  from   ProductConfigImportData  a;

select  DetailId  from   ProductConfigDetail  a   where  a.ProName='dsa'   and  a.ProLevel=6;
--delete ProductConfigImportData;
--l12577  李玉双  25号 

select  *  from  F_GetUserDayPercentsHistory('liyushuang 12577','2020-02-26');

select  *  from  F_GetUserDayPercentsHistory('03806','2020-02-26')

select  *  from   ImportData   a;

DECLARE @tmpDate nvarchar(30)
DECLARE @firstDayOfMonth date
DECLARE @monday nvarchar(20)
--Declare @empNum nvarchar(20);
set @firstDayOfMonth= CONVERT(datetime,convert(nvarchar(7),DATEADD(month,-1,getdate()),120)+'-01',20);
set @monday=dbo.GetMondayByDate(@firstDayOfMonth);

select @firstDayOfMonth,@monday;

--{11da6335-4e57-4256-ad32-befeb9d37316}

--{ed474af6-b3eb-46c4-bf7f-834c34bdc28d}
select *  from  ImportData   a  order  by CreateTime  desc;

select *  from  ProductInfo   a  order  by CreateTime  desc;

--2216465	2216466
select  *  from  HourInfo_New   a  where  a.Date='2020-01-06'  and a.Creator='liucaixuan 03806';

select  *  from  HourInfoDetailHistory   a  where  a.Date='2020-01-06'  and a.Creator='liucaixuan 03806';

--delete  HourInfo_New  where ID='2216478'

select  COUNT(*)  from  V_HourInfo_New  a  where a.UserCode='03806' and a.Date='2020-03-03'  and a.ProID='131158f7-02c6-4b6d-8bb7-b6c9b5bd53da'	 

select  *  from  V_HourInfo_New  a  where a.UserCode='03806' and a.Date='2020-03-03';

select  *  from   UserInfo  a  where  a.ChnNamePY='sunxuguang';

select  *  from  WorkHourDetail  a;

select  ProCode  from   V_HourInfo_New  a   where  a.UserCode='03806' and  a.Date between '2020-03-01'  and '2020-03-31'
group by a.ProCode;

select  ProCode  from   V_HourInfo_New  a   where  a.UserCode='12577' and  a.Date between '2020-03-01'  and '2020-03-31'
group by a.ProCode;

select  *  from   V_HourInfo_New  a  where  a.UserCode='03806' and  a.Date between '2020-03-01'  and '2020-03-31';

select  *  from   V_HourInfo_New  a  where  a.UserCode='12577' and  a.Date between '2020-03-01'  and '2020-03-31';

--A13000T  A170071
select *  from  ProductInfo  a   where  a.ProCode='A000002';

select *  from  ProductInfo  a   where  a.ProLevel=6

--BETWEEN DATEADD(dd,-DAY(@date) + 1,@date) AND  DATEADD(MONTH, 1,DATEADD(dd,-DAY(@date) + 1,@date))
declare @date date;
set @date='2020-02-26';
select DATEADD(dd,-DAY(@date) + 1,@date),DATEADD(MONTH, 1,DATEADD(dd,-DAY(@date) + 1,@date))

select  COUNT(*)  from  V_HourInfo_New  a  where a.UserCode='03806' and a.Date='2020-03-03'  
and a.ProID='0AD4F06F-A77F-4088-8C35-023050CE7376'

--原因  有效期  当月1号至次月1号   实际上项目是2号失效

--delete ProductConfigDetail  where DetailId=92

select  *  from  ConstantValue  a order by a.CreationDate desc;
  
select  *  from  ConstantValue  a   where   a.Name='固定人员'  or  a.Code='1'

--drop table ProductConfigLogic
--delete ProductConfig
--delete ProductConfigLogic
select  *  from   IPDProjectType  a;

select  *   from  IPDProjectTemp   a  
where  a.IPDProjectTypeID='39745539-fec0-48d4-b34c-0993c6f58008'

select  *   from  IPDProjectTemp   a  
where  a.IPDProjectTypeID='01248680-5e79-49aa-abed-116bf7bee56a';

select  MONTH(GETDATE());

select  *  from  Department a  where  a.DeleteFlag=0;

select *  from   ProductConfigDetail  a ;

--递归
with CTE
as
(
    select DetailId from ProductConfigDetail where DetailId=1
    union all
    select  proConfig.DetailId from CTE inner join ProductConfigDetail as proConfig
    on CTE.DetailId=proConfig.ParentId
)
select * from CTE order by DetailId;

with CTE
as
(
    select * from ProductConfigDetail where DetailId=87
    union all
    select G.* from CTE inner join ProductConfigDetail as G
    on CTE.DetailId=G.ParentId
)
delete  ProductConfigDetail  where DetailId in(select  DetailId from CTE)

--标量函数  exec  funcName   内联标  FuncNam
--内联表值函数 select   *   from  funcName 
select  *   from    dbo.F_GetUserDayPercents('dsa','2019-01-01')

select  GETDATE()-DATEADD(MONTH,1,GETDATE())

select  DATEADD(MONTH,1,GETDATE())

--2019-10-15
--2019-12-05

select  DATEDIFF(month,'2019-10-15',GETDATE());

--update   HourInfoDetailHistory   set   Remark='1、IPMT相关：云数IPMT会议安排，会议材料预审；2则云平台项目PDCP合同审核及问题沟通；卫娜拟文及合同审核关注
--2、专利优化相关：整理上次会议结论，专利技术专家任命文件定稿提交总裁办会签发布；评审评估流程和专利管理办法正式发布通知拟制；
--3、iLog相关：挂起版本状态判定原则沟通。
--'  where  Creator  like  '%liucaixuan%'  and  Date='2019-10-08'

select  *   from   HourInfoDetailHistory  a  where  a.Creator  like  '%liucaixuan%'  order by  a.CreateTime desc;

--1、IPMT相关：云数IPMT会议安排，会议材料预审；2则云平台项目PDCP合同审核及问题沟通；卫娜拟文及合同审核关注
--2、专利优化相关：整理上次会议结论，专利技术专家任命文件定稿提交总裁办会签发布；评审评估流程和专利管理办法正式发布通知拟制；
--3、iLog相关：挂起版本状态判定原则沟通。


select   *   from  V_HourInfo_New   a;
select   *   from  HourInfoMain  a  where   a.id=544550;
select   *   from  V_HourInfoMain  a;

select    DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,GETDATE())), 0)
select    DATEADD(dd, -1,GETDATE())
select    DATEDIFF(wk, 0, DATEADD(dd, -1,GETDATE()))
select    DATEDIFF(WK,GETDATE(),0)
 --user  liucaixuan 03806

 SELECT * FROM dbo.V_HourInfoMain c 
 WHERE c.Creator=@Creator 	AND c.DeleteFlag=0  AND ( DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,CreateTime)), 0) BETWEEN  @Begintime AND @EndTime OR  DATEADD(wk,  DATEDIFF(wk, 0,DATEADD(dd, -1,CreateTime)), 6) BETWEEN  @Begintime AND @EndTime)


 SELECT * FROM dbo.V_HourInfoMain c 
 WHERE 
	c.Creator='liucaixuan 03806' 	AND 
	c.DeleteFlag=0  AND 
	( DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,CreateTime)), 0) BETWEEN  '2019-12-01' AND  '2019-12-31'       OR  
	DATEADD(wk,  DATEDIFF(wk, 0,DATEADD(dd, -1,CreateTime)), 6) BETWEEN  '2019-12-01' AND '2019-12-31')

select  *   from   V_HourInfoMain   a   where  a.UserCode='03806'  order  by  a.CreateTime  desc;
select  *   from   V_HourInfoDetailHistory  a;

--GetListFromHourInfoNewAndHistory
--您只能选择9编码及其子节点

select    DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,GETDATE())), 6);

 SELECT * FROM dbo.V_HourInfoMain c 
 WHERE c.Creator=@Creator 	AND c.DeleteFlag=0  
 AND ( DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,CreateTime)), 0) BETWEEN  @Begintime AND @EndTime 
 OR  DATEADD(wk,  DATEDIFF(wk, 0,DATEADD(dd, -1,CreateTime)), 6) BETWEEN  @Begintime AND @EndTime)
 union all  SELECT * FROM dbo.V_HourInfoMainHistory a WHERE a.Creator=@Creator 	AND a.DeleteFlag=0 and Year(a.CreateTime)=Year(@Begintime)   and Month(a.CreateTime)=Month(@Begintime)


select  DATEADD(dd, -1,GETDATE())
--6258 
select  datediff(wk,0,'2019-12-08 14:16:38.610');

select  DATEADD(WK,6258,0);


select  *   from   Department  a     where  a.DeptCode='50041012'




select  *   from   HourInfo_New  a  where  a.Creator  like '%liucaixuan%'  and  a.Date='2019-12-02';
--BD0C67FD-5C63-4AA7-A0E2-F4781CD539CE

--update   HourInfo_New   set   ProID='BD0C67FD-5C63-4AA7-A0E2-F4781CD539CE' 
--where  Creator  like '%liucaixuan%'  and  Date='2019-12-02';

select  a.ActualSuspendTime,*   from  ProductInfo   a  where  a.ProID='4B78BCEA-A323-40D3-A407-852668970622';
select  *   from  ProductInfo   a  where  a.ProID='BD0C67FD-5C63-4AA7-A0E2-F4781CD539CE';

select  *   from  ProductInfo   a  where  a.ProCode='PL000033'
select  *   from  ProductInfo   a  where  a.ProLevel=3;
select  *   from  ProductInfo_Display  a  ;

--update  HourInfoDetailHistory   set   Remark='备份表读取测试'   where  Creator  like '%liucaixuan%'  and  Date='2019-10-30';

select   a.Remark,*    from  HourInfoDetailHistory  a where    Creator  like '%liucaixuan%'  and  Date='2019-10-28';
select   a.Remark,*    from  HourInfo_New  a where    Creator  like '%liucaixuan%'  and  Date='2019-10-25';

--delete  HourInfoDetailHistory;

--insert   into   HourInfoDetailHistory  
--select  *   from  HourInfo_New  a  where  a.Date<='2019-10-30';

--update  HourInfoDetailHistory   set   Remark='备份表读取测试10-25'   where  Creator  like '%liucaixuan%'  and  Date='2019-10-25';

--update  HourInfoDetailHistory   set   Remark='备份表读取测试10-28'   where  Creator  like '%liucaixuan%'  and  Date='2019-10-28';

--update  HourInfoDetailHistory   set   Remark='备份表读取测试10-30'   where  Creator  like '%liucaixuan%'  and  Date='2019-10-30';

--update  HourInfo_New   set   Remark='正式表读取测试10-30'   where  Creator  like '%liucaixuan%'  and  Date='2019-10-30';

--这个表是干什么的？ 
select  *  from  ProductInfo_Display  a;

select  *  from  HourInfoDetailHistory   a where  Creator  like '%liucaixuan%'  and  Date='2019-10-30';

select  *  from  HourInfoDetailHistory   a where  Creator  like '%liucaixuan%'  and  Date='2019-10-29';

select  *  from  HourInfo_New   a 
where  Creator  like '%liucaixuan%'  --and  Date='2019-10-29'
order by a.Date desc;

select  *  from  HourInfoDetailHistory   a 
where  Creator  like '%liucaixuan%'  --and  Date='2019-10-29'
order by  a.Date desc ;


select  *  from  HourInfoMainHistory   a 
where  Creator  like '%liucaixuan%';

select  *  from  HourInfoMain   a where  Creator  like '%liucaixuan%';

select  *  from  DateSetting  a  order  by  a.Date desc;
--delete  HourInfoDetailHistory  where  Date>='2019-10-28';

--P_PersonalMonthView   params
--code   03806
--month  2019-10
--checkFlag   4
--conditionFlag   2,3,4,
--date  2019-11-18
--projectCode  ''
--proTreeCode  ''

select   CONVERT(datetime,'2019-10'+'-01',20)
select   CONVERT(datetime,GETDATE(),20)

select  DATEDIFF(MONTH,'2019-10-31 00:00:00.000','2019-12-07 09:43:05.327')

select  *   from  BackRecord   a  order  by  a.Back_ID  desc ;

select  MIN(Back_Date) as firstDayOfWeek,MAX(Back_Date) as endDayOfWeek   from  BackRecord  a  where  a.Back_ID='544550';

select  *   from  BackRecordHistory   a;

select  *   from  HourInfoMain  a;


--insert  into   BackRecordHistory
--select   *   from  BackRecord  

select  *   from   BackRecordHistory   a   where   a.Creator  like  '%liucaixuan%'  order by  a.Back_Date desc ;

select  *   from   BackRecord   a   where   a.Creator  like  '%liucaixuan%'  order by  a.Back_Date desc ;

select  *   from   BackRecord   a   where    a.IsBack>1

--update  BackRecordHistory  set  Operation='添加测试'  where  Back_Date='2019-10-30'  and Creator like '%liucaixuan%'

select xtype from sysobjects where id=object_id('dbo.[F_GetDayLog]');

--drop  function F_GetWeekLog;   
select  *   from  F_GetWeekLog('544550');

select  *   from  dbo.F_GetUserDayPercentsHistory('liucaixuan 03806','2019-10-30')

--获取上个月的1号
select CONVERT(varchar(7), dateadd(MM,-1,'2019-01-01') , 120) + '-01';

select CONVERT(datetime,convert(nvarchar(7),DATEADD(month,-1,getdate()),120)+'-01',20)

select   DATEPART(DW,GETDATE());

select  DATEPART(WEEKDAY,'2019-11-03');

select  DATEADD(DAY,-5,'2019-11-01');

select  dbo.GetMondayByDate('2019-12-01')

select   *   from   dbo.F_GetDayLog('liucaixuan 03806','2019-10-30')

select   *   from   V_HourInfoMain  a  where a.Creator  like  '%liucaixuan%'  order   by  a.CreateTime desc ;


select   *   from   HourInfoMainHistory   a;

--insert   into   HourInfoMainHistory  
--select  *   from  HourInfoMain  a  where  a.CreateTime<='2019-10-21';

 SELECT * FROM dbo.V_HourInfoMain c 
 WHERE 
 c.Creator=@Creator 	
 AND c.DeleteFlag=0  
 AND ( DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,CreateTime)), 0) BETWEEN  @Begintime AND @EndTime 
 OR  DATEADD(wk,  DATEDIFF(wk, 0,DATEADD(dd, -1,CreateTime)), 6) BETWEEN  @Begintime AND @EndTime)
 union all  SELECT * FROM dbo.V_HourInfoMainHistory a WHERE a.Creator=@Creator 	AND a.DeleteFlag=0 and Year(a.CreateTime)=Year(@Begintime)   and Month(a.CreateTime)=Month(@Begintime)

   
select   *   from  ProductInfo  a  where  a.ProCode='A161018';
--A12FA453-CB74-46F7-B594-33731223962A
--94C45859-E86C-445B-9352-816F1AB3E710
select   *   from  ProductInfo  a  where  a.ProID='A12FA453-CB74-46F7-B594-33731223962A';

select  *   from   HourInfo_New  a  where   a.Creator  like '%liucaixuan%'   and   a.Date='2019-12-05';

--update    HourInfo_New   set   ProID='94C45859-E86C-445B-9352-816F1AB3E710'  
--where   Creator  like '%liucaixuan%'  and  Date='2019-12-05'

select  *   from   V_Department_Test   a;

select  *   from   Department   a  where  a.DeleteFlag=0;

select  *   from   UserInfo   a;

select  *   from   RoleInfo   a;


select   a.SecondDeptCode,a.SecondDeptName*   from   Department  a;

select  *  from  BackRecord   a  where  a.Creator  like  '%liucaixuan%'  and a.IsBack=2   order  by  a.Back_Date  desc;

select  *  from  BackRecordHistory   a   where  a.Creator  like  '%liucaixuan%'  and a.IsBack=2 order  by  a.Back_Date  desc;

select  *  from  HourInfoMain  a   where  a.id='476725'
--453712   10.07
--476725   10.28

--delete  BackRecordHistory  

--insert  into  BackRecordHistory
--select  *  from  BackRecord

--update  BackRecord  set  Operation='正式表添加10.25' where  Back_Date='2019-10-25' and Creator  like  '%liucaixuan%';

--update  BackRecord  set  Operation='正式表添加10.28' where  Back_Date='2019-10-28' and Creator  like  '%liucaixuan%';

--update  BackRecord  set  Opinion='正式表添加10.07' where  Back_ID='453712' and IsBack=2 and Creator  like  '%liucaixuan%';

--update  BackRecord  set  Opinion='正式表添加10.28' where  Back_ID='476725' and IsBack=2 and Creator  like  '%liucaixuan%';

--update  BackRecordHistory  set  Opinion='备份表添加10.07' where  Back_ID='453712' and IsBack=2  and Creator  like  '%liucaixuan%';

--update  BackRecordHistory  set  Opinion='备份表添加10.28' where  Back_ID='476725' and IsBack=2  and Creator  like  '%liucaixuan%';

--update  BackRecordHistory  set  Operation='备份表添加10.25' where  Back_Date='2019-10-25' and Creator  like  '%liucaixuan%';

--update  BackRecordHistory  set  Operation='备份表添加10.28' where  Back_Date='2019-10-28' and Creator  like  '%liucaixuan%';

select    *   from   HourInfo_New   a   where  a.Creator='liucaixuan 03806'  and  a.Date='2019-10-25';
select    *   from   HourInfoDetailHistory   a   where  a.Creator='liucaixuan 03806'  and  a.Date='2019-10-12';

select    *   from   HourInfo_New   a   where  a.Creator='liucaixuan 03806'  and  a.Date='2019-10-30';
select    *   from   HourInfoDetailHistory   a   where  a.Creator='liucaixuan 03806'  and  a.Date='2019-10-30';

--delete  from   HourInfo_New   where  Creator='liucaixuan 03806'  and  Date='2019-10-28';
--delete  from   HourInfoDetailHistory   where  Creator='liucaixuan 03806'  and  Date='2019-10-28';

select  *   from  F_GetWeekLog('476725','2019-10-28');
select  *   from  DateSetting   a;


select  DATEDIFF(MONTH,'2019-12-21','2020-01-21');
select  CONVERT(datetime,'2019-10',20);

select   *   from   HourInfo_New   a  where  a.Creator  like '%liucaixuan%'   order  by   a.Date  desc;

--返回指定字符在字符串中的位置  以1开始  出现多次取第一次
select  CHARINDEX('d','dsad');

select   *   from   WorkHourDetail  a  ;

select   *   from   WorkHourDetailHistory  a;

select   *   from   WorkHourDetailView  a  where  a.ProCode=a.BVersionCode;

--where   convert(datetime,whdh.YearMonth+'01')>=@startDate and convert(datetime,whdh.YearMonth+'01')<@endDate
select  *   from   WorkHourDetailHistory  a
where   convert(datetime,CONVERT(varchar(20),a.YearMonth)+'01')>='2019-06-01' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+'01')<'2019-10-30'
order by a.YearMonth desc;

select *  from  HourInfo_New   a  where  a.Creator  like '%14912%' and a.ProID='33EBFADF-7158-46F3-84F1-F6EA5C0AFD32' order by  a.Date desc;
select *  from  ProductInfo   a where  a.ProCode='C0500TQ'

select   convert(datetime,CONVERT(varchar(20),201902)+'01',20)

select  CONVERT(varchar(20),201902);

select  *  from   ProductInfo   a  where  a.ProName='预研公共';

SELECT g.DeptCode FROM dbo.GiveRight_Dept g INNER JOIN Department d on g.DeptCode=d.DeptCode WHERE g.UserId='liucaixuan 03806' and g.DeleteFlag =0   and d.DeleteFlag=0
UNION  
SELECT DeptCode FROM dbo.ProductInfo WHERE  DeptManager=@DeptManager  and DeleteFlag =0 


SELECT * FROM dbo.ProductInfo WHERE  DeleteFlag =0 ;

select   *   from ProductInfo   a;

select  *  from  GiveRight_Pro  a;

create table #procuctManager
(
	ProCode varchar(100)
);
WITH    pro  AS 
( 
	SELECT ProCode,ProLevel,ParentCode
    FROM     ProductInfo
    WHERE    (Manager=@ManagerUser or CC=@ManagerUser) and DeleteFlag=0
	UNION ALL
	SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag=0
  )
insert INTO #procuctManager
SELECT ProCode  FROM pro; 
insert into #procuctManager
SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId=@ManagerUser;
  
select  DATEADD(MM,-2,GETDATE());

SELECT   ProCode  FROM     ProductInfo  a   where  a.DeleteFlag=0  and  a.ParentCode='9020222' ;

select  *   from  HourInfo_New  a  where  a.Creator  like  '%liucaixuan%';

select  *   from  GiveRight_Pro  a;

select  *   from  Department  a where a.DeptCode='50041372';

select  *   from  WorkHourDetail  a   where a.ProName='预研公共';

select  *   from  ProductInfo  a  where  a.ProCode='A13002X'

--59.14    51.52
select  SUM(RoundCount)   from  WorkHourDetail  a   where  a.SecondDeptName='运作与质量管理部'  and a.YearMonth='201912'
group  by  a.SecondDeptCode;

select  *   from   WorkHourDetail  a  where  a.SecondDeptName='测试中心'  and  a.YearMonth='201912'  and  BVersionName='预研公共';

select  *   from   WorkHourDetail  a  where  a.ProCode='PL000005';

--Group  by与Over能否公用
--select  *   from   WorkHourDetailHistory  a  where  a.YearMonth='201911';

select  SUM(Percents)   from  WorkHourDetail  a  group by SecondDeptName,SecondProCode

select  a.SecondDeptName   from Department  a  where a.DeleteFlag=0 and SecondDeptName!=''  and  SecondDeptName is not null  group  by a.SecondDeptName 

select  STUFF((select  ','+a.SecondDeptName+',' +convert(varchar(10),SUM(Percents))+';'   from WorkHourDetail  a  where  SecondDeptName!=''  and  SecondDeptName is not null  group  by a.SecondDeptName    FOR XML PATH('')),1, 1, '');

select  DATEDIFF(MONTH,DATEADD(MONTH,-2,GETDATE()),'2020-01-31');

select *  from ProductInfo  a where  a.DeleteFlag=0   and  a.ProName='AI研究院'

select  *  from  HourInfo_New  a   where  a.HMain_ID='507997';

select  *  from  HourInfo_New  a   where  a.Creator  like '%liucaixuan%'

select  *  from BackRecord  a  where  a.Creator  like '%15504%'  and a.CreateTime>'2019-10-01'  order  by  a.CreateTime;

select  *  from BackRecordHistory  a  where  a.Creator  like '%15504%'  and a.CreateTime>'2019-10-01'  order  by  a.CreateTime

select  *  from  HourInfoDetailHistory   a  where   a.Creator  like '%liucaixuan%'  order by  a.Date desc;

select  *  from  V_HourInfoDetailHistory   a   where   a.Modifier  like '%liucaixuan%';

select  *  from  V_HourInfoDetailHistory   a   where   a.Creator is not null;

select  *  from  HourInfo_New   a where a.Creator  like '%liucaixuan%'  order by  a.Date desc;

select  *  from  HourInfoMain   a  where  a.Creator  like '%liucaixuan%'  ;

select   *  from   F_GetUserDayPercentsHistory('liucaixuan 03806','2019-11-06');

select   CONVERT(datetime,convert(nvarchar(7),DATEADD(month,-1,getdate()),120)+'-01',20);

select dbo.GetMondayByDate('2019-12-01');

select  *   from HourInfo_New  ;
select  *   from HourInfoMain   ;

select   CHARINDEX(' ','zhangwei 16180');
select   CHARINDEX(' ','zhangwei ys6180');

select  REPLACE(SUBSTRING('zhangwei 16180',CHARINDEX(' ','zhangwei 16180'),10),' ','')

select LTRIM(SUBSTRING('zhangwei 16180',CHARINDEX(' ','zhangwei 16180'),10))

select REPLACE(SUBSTRING('zhangwei 16180',CHARINDEX(' ','zhangwei 16180'),10),' ','')

select LTRIM(SUBSTRING('zhangwei  ys6180',CHARINDEX(' ','zhangwei  ys6180'),10))

select SUBSTRING('zhangwei  ys6180',CHARINDEX(' ','zhangwei  ys6180'),10)

 select name from sysobjects as s
inner  join syscomments as o
on s.id=o.id 
where text like N'%V_HourInfo_New%'

--V_HourInfo_New
--V_HourInfoDetailHistory

select *  from  BackRecordHistory   a  where  a.Creator like '%liucaixuan%'  order by  a.Back_Date desc

--502097  501665  507746
select *  from  BackRecord  a  where  a.Creator like '%liucaixuan%'  order by  a.Back_Date desc;

select *  from  BackRecordHistory  a  where  a.Creator like '%liucaixuan%'  order by  a.Back_Date desc;

select * from  dbo.F_GetDayLog('03806','2019-11-05')

select  *   from  HourInfoDetailHistory  a  where  a.Creator  like '%liucaixuan%'  order by  a.Date desc;

select  *   from  HourInfoMain  a  where  a.Creator  like '%liucaixuan%'  order by  a.CreateTime desc;

select  *   from  HourInfoMain  a  where  a.Creator like '%liucaixuan%'  and  a.id='501665';

select  *   from  HourInfoMainHistory  a  where  a.Creator like '%liucaixuan%'  and  a.id='183576' order by a.CreateTime desc;

select  *   from  HourInfo_New  a  where  a.HMain_ID='555412';

select  *   from  HourInfo_New  a  where  a.Creator  like '%liucaixuan%'  order by  a.CreateTime desc;

 select  *   from  HourInfoMain  a   where  a.CreateTime='2019-12-30' and a.id  not  in(select  a.HMain_ID from  HourInfo_New  a   where  a.Date>'2019-11-25')  
 and  a.UserCode='03086';

 select   *  from dbo.F_GetDayLog('03806','2019-12-03');

 select  CONVERT(VARCHAR(6),'2019-12-01', 112);

 select  *  from WorkHourDetail  a where  a.SecondProCode='A18001M';

 select  *  from WorkHourDetail  a where  a.SecondProCode in (A18001M);

 select  *  from WorkHourDetail  a where  a.UserCode='ys3082'  and a.YearMonth='201912';

-- drop FUNCTION [dbo].[F_GetDayLog]
--drop FUNCTION [dbo].[F_GetWeekLog]

--where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate

select  CONVERT(VARCHAR(6), '2019-12', 112);
select  *  from  WorkHourDetail  a  where a.ProductLineCode  in ('')

select  CONVERT(varchar(20),'2019-12')+'01'

select  convert(datetime,CONVERT(varchar(20),'201912')+'01',23)
select convert(datetime,CONVERT(varchar(20),201912)+'01')

select  convert(datetime,CONVERT(varchar(120),20191201),23)


declare @sql  nvarchar(100); 
set @sql='select convert(datetime,CONVERT(varchar(20),201912)+''01'') ';
select  convert(datetime,CONVERT(varchar(20),201912)+'01',120)


declare @startDate1  datetime;
set @startDate1 ='2019-12-14 00:00:00';
declare @Condition nvarchar(max);
--set @Condition='select '+' CONVERT(varchar(10), convert(datetime,CONVERT(varchar(20),''20191201'),23),126);
set @Condition='select * from ProductInfo   where '' '+ convert(varchar(20),CONVERT(varchar(20),201912)+'01',120)+ ' ''>='''+CONVERT(varchar(20),@startDate1,120) +''

--set @Condition='select * from ProductInfo   where  '+ '2019-12-01'+ ' >='+'2019-12-12'
--set @Condition='select  top  1 from  productInfo where convert(varchar(20),convert(datetime,CONVERT(varchar(20),201912)+''01''))>= ' +@startDate

--set @Condition='dsa';

select convert(datetime,CONVERT(varchar(20),201912)+'01',120);
select CONVERT(datetime,'2019-12-14 00:00:00',120) 
select @Condition;
--exec(convert(datetime,CONVERT(varchar(20),201912)+'01',120));
--exec sp_executesql @Condition;

select 'select * from ST_PPTN_R where TM Between '''+CONVERT(nvarchar(100), DATEADD(D,-1,GETDATE()),120)+''' and ''' + CONVERT(nvarchar(100), GETDATE() ,120 )+ ''''


--EXEC sp_executesql @Condition; 

--exec (@Condition)


declare @sql  datetime;
set @sql='select  * from  WorkHourInfoDetail  a  where '' '+201912+' '' '+'='+201912
select @sql;



select  * from  WorkHourDetail  a where  a.ProCode='A18001M' and  a.YearMonth=201912;



--人力投入总表
--1、select产品树  递归子节点之后   和明细表各级procode依次对应
--2、input 项目编码   不用递归  直接明细表各级procode依次对应  不能先和产品权限  join

--先根据时间筛选  明细表   确定查询正式表还是历史表   放到临时表里

--有产品树   有项目编码
--

--判断是否手动输入项目编码   


--按部门查询 
--1、select产品树  递归子节点之后   和明细表各级procode依次对应
--2、input 项目编码   不用递归  直接明细表各级procode依次对应  不能先和产品全线  join

--这里的逻辑要统一调整  最后通过时间 产品权限  输入的产品 筛选  生成一个取数据的临时表  供后面使用
--

declare  @tempDate  datetime;
set @tempDate='2019-12-01'
select   CONVERT(varchar(6),@tempDate,112)

--and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')>='+@startDate+' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')<'+@endDate+'

--and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')>='+@startDate+' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')<'+@endDate+'

--convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')

select  * from HourInfoMain   a   where   a.Creator='liucaixuan 03806';

select  *  from  ProductInfo  a  where  a.ProCode='A18001M';

select  *  from  ProductShare    a   where  a.ProCode='A18001M';

--568004  568105
select  * from HourInfoMain   a   where   a.Creator='liucaixuan 03806';

select  * from HourInfo_New  a  where  a.HMain_ID='530952';

select  *  from  BackRecord   a   where  a.Creator  like '%liucaixuan%'  order  by  a.Back_Date  desc;

select  *  from  BackRecord   a   where  a.Creator  like '%liucaixuan%'  and  a.IsBack<>1  order  by  a.Back_Date  desc;

select  *  from  HourInfo_New  a   where  a.Creator  like  '%liucaixuan%';

select  SUM(ROUND(VendorCount,2) )  from  WorkHourDetail   a   where  a.YearMonth='202001';

select  *  from  WorkHourDetail  a  where  a.SecondDeptName='基础部件开发部'  and  a.YearMonth>'201911'  and a.YearMonth<'202001'
and  a.BVersionName='预研公共';

select *  from  WorkHourDetailHistory  a  where  a.YearMonth   between CONVERT(VARCHAR(6), '2019-12-01', 112)  and  CONVERT(VARCHAR(6), '2019-12-31', 112);

select   *   from   ProductInfo_Display  a ;

select  *  from  WorkHourDetail  a  ;

--修改 按部门  增加IsPDT条件筛选  

select   DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,'2019-12-01')), 0)
select   DATEADD(dd, -1,'2019-12-02')
select   DATEDIFF(WK,0,'2019-12-02')
select   DATEADD(WK,6257,6)

--查询当前数据库中存在的所有索引        
select  *  from  sys.indexes;      

--执行拼接的sql语句    
exec  sp_executesql  @sql;

declare  @temp varchar(20);
set @temp=@temp+'dsa';
select  @temp;

--FillState  null  未提交
--FillState  0   已提交
--FillState  1   返回修改
select   *  from  HourInfo_New  a  where  a.Creator   like  '%liucaixuan%'  order by  a.Date desc;

select   *  from  HourInfo_New  a  where  a.Creator   like  '%liliang%'  order by  a.Date desc;

select   *  from  ProductInfo   a  where   a.ProName='ADNET产品线';

select   *  from  ProductInfo   a  where  a.ProCode='B300002';

select   *  from  UserInfo  a ;

--0d86917e-eb14-4fd8-9a71-acf5c393d447  业务讨论
--0ad4f06f-a77f-4088-8c35-023050ce7377  团队建设
--131158f7-02c6-4b6d-8bb7-b6c9b5bd53da 业务结果评审
--3a5a3e64-f678-470e-a56f-17dea6b179d0
--3a5a3e64-f678-470e-a56f-17dea6b179d0

--9a75b42d-2b21-442e-97bd-2af837839e2d
select   *  from  ProductInfo   a  where  a.ProID='9a75b42d-2b21-442e-97bd-2af837839e2d';

select   *  from  ProductInfo   a  where  a.ProCode='PL000038'

--月统计   项目批量替换   
--1、

select  *  from  HourInfo_New  a  where  a.Creator  like '%chenmin ys2689%';

select  *  from  BackRecordHistory  a  where  a.Creator  like '%liucaixuan%';

select  *  from  ProductInfo  a  where  a.ProName='I2R-课题申报';

select  *  from  ProductInfo  a  where  a.ProName='I²R-课题申报';

select   *  from   HourInfo_New  a   where  a.Creator  like '%liucaixuan%'  order  by  a.Date desc  ;  

select  *   from  WorkHourDetailHistory  a  where  a.ProName='预研公共'  or a.BVersionName='预研公共'  and  a.YearMonth=201911;

select  *   from  WorkHourDetail  a  where  a.ProName='预研公共'  or a.BVersionName='预研公共'  and  a.YearMonth=202001;

select  SUM(Percents)   from  WorkHourDetailHistory  a  where  a.ProName='预研公共'  or a.BVersionName='预研公共'  and  a.YearMonth=201911;

select  *   from  WorkHourDetail  a  where  a.UserCode='20992'  and  a.YearMonth=201912;

--9010109
--PT000076


select  *  from  ProductInfo  a  where  a.ProCode='9010109'  or a.ProCode='PT000076';
select  *  from  ProductInfo  a  where  a.ProName='资料平台';
--园区核心维护开发项目B01	

select  *  from  ProductInfo  a  where  a.='资料平台';

select  *  from  ProductInfo_Display   a;

select  *  from  Product_User_Relation  a;

--个人月统计  Home  系统资源   按部门

select  *  from  DateSetting    order by  Date desc;

select  *  from  HourInfo_New  a  where  a.Creator like '%liucaixuan%'  order  by  Date desc;

select  *  from  HourInfo_New  a  where  a.Creator like '%18102%'  order  by  Date desc;

select  *  from  Dairy a;

select  *  from  HourInfo_New   a  where  Date  between '2020-01-01'  and '2020-01-31' 
and FillState is null  --and a.Creator like '%xuewei%'
order by a.Date ;


select  *  from  HourInfo_New   a  where  a.Creator like '%bianxuewei%'
order by a.Date ;

select  *  from  V_HourInfoFeedBack   a  where  a.Creator like '%bianxuewei%';
 
select   DATEADD(wk,DATEDIFF(wk, 0, DATEADD(dd, -1,'2020-01-03')),6)  ;

select  *  from  ProductInfo_Display  a;

select  *  from  ProductInfo  a
--where a.ProName='降额审查'
order  by  a.CreateTime desc;

select * from ProductInfo where ProCode like 'C%' and ParentCode like 'A%';

select * from ProductInfo where ProCode like 'A%' and ParentCode like 'A%'; 

select  *  from LogInfo  a  order by  a.OptTime desc;
--9200031

select  *   from  ImportData  a  order by  a.CreateTime desc;

AE526742-15F9-4987-9355-8063B7B4CCD3
