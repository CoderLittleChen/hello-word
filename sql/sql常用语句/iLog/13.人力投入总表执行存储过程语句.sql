exec sp_executesql N'EXEC [dbo].[P_WorkHourSummaryView1]  @startDate,@endDate,@ProjectLevel,@GroupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary, @projectCode, @proTreeNode, @deptTreeNode,@rowID',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(84),@conditionFlag nvarchar(8),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000)',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7,8,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=0,@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@rowID=N''

exec sp_executesql N'EXEC [dbo].[P_WorkHourSummaryView1]  @startDate,@endDate,@ProjectLevel,@GroupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary, @projectCode, @proTreeNode, @deptTreeNode,@rowID',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(75),@conditionFlag nvarchar(8),@UserId nvarchar(13),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(8),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000)',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7,8,',@UserId=N'chengxi 18102',@sysRole=0,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=0,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'PL000005',@deptTreeNode=N'',@rowID=N''

exec sp_executesql N'EXEC [dbo].[P_WorkHourSummaryView_New]  @startDate,@endDate,@ProjectLevel,@GroupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary, @projectCode, @proTreeNode, @deptTreeNode,@rowID',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(75),@conditionFlag nvarchar(8),@UserId nvarchar(13),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000),@pageIndex int,@pageCount int',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7,8,',@UserId=N'chengxi 18102',@sysRole=0,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=0,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@rowID=N'',@pageIndex=1,@pageCount=15

exec sp_executesql N'EXEC [dbo].[P_WorkHourSummaryView_New]  @startDate,@endDate,@ProjectLevel,@GroupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary, @projectCode, @proTreeNode, @deptTreeNode,@rowID,@pageIndex,@pageCount',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(75),@conditionFlag nvarchar(8),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000),@pageIndex int,@pageCount int',@startDate='2020-01-01 00:00:00',@endDate='2020-01-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7,8,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@rowID=N'',@pageIndex=1,@pageCount=15

--导出数据
exec sp_executesql N'EXEC [dbo].[P_WorkHourSummaryView_New]  @startDate,@endDate,@ProjectLevel,@GroupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary, @projectCode, @proTreeNode, @deptTreeNode,@RowID',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(75),@conditionFlag nvarchar(19),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(2),@pageIndex int,@pageCount int',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7,8,5,6,7,8,on,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@pageIndex=1,@pageCount=15

--按部门查询  原
exec sp_executesql N'EXEC [dbo].[P_WorkHourDeptView]  @startDate,@endDate,@ProjectLevel,@conditionFlag,@UserId,@sysRole,@projectCode,@station,@proTreeNode,@deptTreeNode,@RowID,@IsLinkType, @ProductLineCode, @PDTCode, @FirstProCode, @SecondProCode, @ThirdProCode, @FourthProCode,@Month,@SecondDeptName',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@conditionFlag nvarchar(5),@UserId nvarchar(16),@sysRole int,@projectCode nvarchar(4000),@station nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4000),@IsLinkType nvarchar(5),@ProductLineCode nvarchar(4000),@PDTCode nvarchar(4000),@FirstProCode nvarchar(4000),@SecondProCode nvarchar(4000),@ThirdProCode nvarchar(4000),@FourthProCode nvarchar(4000),@Month nvarchar(4000),@SecondDeptName nvarchar(4000)',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@conditionFlag=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=0,@projectCode=N'',@station=N'',@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@IsLinkType=N'false',@ProductLineCode=N'',@PDTCode=N'',@FirstProCode=N'',@SecondProCode=N'',@ThirdProCode=N'',@FourthProCode=N'',@Month=N'',@SecondDeptName=N''
--按部门查询  新
--chenxi
exec sp_executesql N'EXEC [dbo].[P_WorkHourDeptView_New]  @startDate,@endDate,@ProjectLevel,@groupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary,@projectCode,@proTreeNode,@deptTreeNode,@RowID',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@conditionFlag nvarchar(5),@UserId nvarchar(13),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4000)',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7',@UserId=N'chengxi 18102',@sysRole=0,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=0,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@PageIndex=1,@pageCount=15

--liucaixuan  按部门查询  导出数据
exec sp_executesql N'EXEC [dbo].[P_WorkHourDeptView]  @startDate,@endDate,@ProjectLevel,@groupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary,@projectCode,@proTreeNode,@deptTreeNode,@RowID',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@conditionFlag nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4)',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@PageIndex=1,@pageCount=15

exec sp_executesql N'EXEC [dbo].[P_WorkHourDeptView_New]  @startDate,@endDate,@ProjectLevel,@groupBySql,@whereSql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary,@projectCode,@proTreeNode,@deptTreeNode,@RowID,@pageIndex,@pageCount',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@whereSql nvarchar(99),@conditionFlag nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4000),@pageIndex int,@pageCount int',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@whereSql=N' where  ProductLineCode=sp.ProductLineCode and PDTCode=sp.PDTCode and BVersionCode=sp.BVersionCode ',@conditionFlag=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'50041371,50041372,50041373,50041374,50041375,50043439,',@RowID=N'',@pageIndex=1,@pageCount=15

--最新
--版本
exec sp_executesql N'EXEC [dbo].[P_WorkHourDeptView_New]  @startDate,@endDate,@ProjectLevel,@groupBySql,@whereSql,@groupByProductNoDeptSql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary,@projectCode,@proTreeNode,@deptTreeNode,@RowID,@pageIndex,@pageCount',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@whereSql nvarchar(99),@groupByProductNoDeptSql nvarchar(73),@conditionFlag nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(54),@RowID nvarchar(4000),@pageIndex int,@pageCount int',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@whereSql=N' where  ProductLineCode=sp.ProductLineCode and PDTCode=sp.PDTCode and BVersionCode=sp.BVersionCode ',@groupByProductNoDeptSql=N'ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'50041371,50041372,50041373,50041374,50041375,50043439,',@RowID=N'',@pageIndex=1,@pageCount=15

--四级项目
exec sp_executesql N'EXEC [dbo].[P_WorkHourDeptView_New]  @startDate,@endDate,@ProjectLevel,@groupBySql,@whereSql,@groupByProductNoDeptSql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary,@projectCode,@proTreeNode,@deptTreeNode,@RowID,@pageIndex,@pageCount',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(1),@GroupBySql nvarchar(187),@whereSql nvarchar(2040),@groupByProductNoDeptSql nvarchar(155),@conditionFlag nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4000),@pageIndex int,@pageCount int',@startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'4',@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName',@whereSql=N' where  ProductLineCode=sp.ProductLineCode and PDTCode=sp.PDTCode and BVersionCode=sp.BVersionCode and  SecondProCode=sp.SecondProCode and  ThirdProCode=sp.ThirdProCode and  FourthProCode=sp.FourthProCode',@groupByProductNoDeptSql=N'ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName',@conditionFlag=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@pageIndex=1,@pageCount=15

--drop  procedure  P_WorkHourSummaryView1_New

exec sp_executesql N'EXEC [dbo].[P_WorkHourMonthView_New]  
@startDate,@endDate,@ProjectLevel,@conditionFlag,@UserId,@sysRole,@projectCode,@proTreeNode,@RowID,
@integratedSql,@checkVersion,@orderTypeSort,@orderNameSort,@rows,@page',N'@startDate datetime,
@endDate datetime,@ProjectLevel nvarchar(5),@conditionFlag nvarchar(6),@UserId nvarchar(16),
@sysRole int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@RowID nvarchar(4000),
@integratedSql nvarchar(4000),@checkVersion nvarchar(1),@orderTypeSort nvarchar(4),
@orderNameSort nvarchar(4000),@rows int,@page int',
@startDate='2019-01-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Nomal',
@conditionFlag=N'5,6,7,',@UserId=N'liucaixuan 03806',@sysRole=0,@projectCode=N'',@proTreeNode=N'',
@RowID=N'',@integratedSql=N'',@checkVersion=N'8',@orderTypeSort=N'desc',@orderNameSort=N'',
@rows=15,@page=1


select  COUNT(1)  from  ProductInfo a;

--select  1 as code  into   #temp   from  ProductInfo
--select  *  from  #temp;
--drop  table #temp;

--50040000   
--update  Department   set  ParentDeptCode=null   where  DeptLevel=1;


WITH    dept  AS 
		( 
			SELECT DeptCode,DeptLevel,ParentDeptCode
			FROM     Department
			WHERE    DeptSecretary='chengxi 18102'  and DeleteFlag=0
			UNION ALL
			SELECT a.DeptCode,a.DeptLevel,a.ParentDeptCode  FROM Department a INNER JOIN dept b ON  a.ParentDeptCode=b.DeptCode where a.DeleteFlag=0
		)

SELECT DeptCode  FROM dept
union 
SELECT DeptCode FROM GiveRight_Dept WHERE DeleteFlag=0 AND UserId='chengxi 18102';

WITH    pro  AS 
	( 
		SELECT ProCode,ProLevel,ParentCode
		FROM     ProductInfo
		WHERE    Manager='chengxi 18102'  and DeleteFlag!=1
		UNION ALL
		SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag=0
	)
	SELECT ProCode  FROM pro
	union
	SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId='chengxi 18102';


--50041414
--50041415
--50041416
--50042596
--50042597

--9000009   proCode

select  *   from  ProductInfo  a  where  a.ProCode='9000009'

select * from  Department   a  where a.DeptName='2029战略研究院';

select * from  Department   a  where a.DeptLevel>0 order by  a.DeptLevel  ;

select * from  Department   a  where a.DeptCode in ('50041414','50041415','50041416','50042596','50042597')  ;

WITH    pro  AS 
	( 
		SELECT ProCode,ProLevel,ParentCode
		FROM     ProductInfo
		WHERE    Manager='chengxi 18102'  and DeleteFlag!=1
		UNION ALL
		SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag=0
	)

	
select  SUM(PDTCount+RoundCount+VendorCount) over(partition by SecondDeptCode)   from  WorkHourDetail  a  where a.DeptCode in ('50041414','50041415','50041416','50042596','50042597')
union
select  SUM(PDTCount+RoundCount+VendorCount) over(partition by SecondDeptCode)   from  WorkHourDetail  a  where a.ProCode in (
SELECT ProCode  FROM pro
union
SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId='chengxi 18102');

select tableColumn from F_SplitStrToTable('0,');

select  SUM(a.RoundCount) over(partition by  BVersionCode) ,*   from  WorkHourDetail  a  where  a.BVersionName='CloudUIS V600R001B08'  and  a.YearMonth='201912';

select  *  from  ProductInfo  a  where  a.ProCode='A17006L';






