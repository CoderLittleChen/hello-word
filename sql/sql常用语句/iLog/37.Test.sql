select  *  from   UserInfo  a  where  a.ChnNamePY like '%jichengzhi%';
--j08604
exec sp_executesql N'EXEC [dbo].[P_WorkHourSummaryView]  @startDate,@endDate,@ProjectLevel,@GroupBySql,@conditionFlag,@UserId,@sysRole,@sysProjectManager,@sysPoP,@sysDeptManager,@sysDeptSecretary, @projectCode, @proTreeNode, @deptTreeNode,@rowID,@pageIndex,@pageCount',N'@startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(75),@conditionFlag nvarchar(8),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000),@pageIndex int,@pageCount int',@startDate='2020-02-01 00:00:00',@endDate='2020-02-29 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@conditionFlag=N'5,6,7,8,',@UserId=N'jichengzhi 08604',@sysRole=0,@sysProjectManager=1,@sysPoP=0,@sysDeptManager=0,@sysDeptSecretary=0,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@rowID=N'',@pageIndex=1,@pageCount=15

select  SUM(a.Percents)  from    WorkHourDetail  a  where a.BVersionName='园区核心维护开发项目B01'
and  a.YearMonth=202002  and DeptName='资料开发部网络&IT产品资料部（杭州）';

select  SUM(RoundCount)  from    WorkHourDetail  a  where a.BVersionName='园区核心维护开发项目B01'
and  a.YearMonth=202002  and DeptName='资料开发部网络&IT产品资料部（杭州）';

select  SUM(RoundCount)  from    WorkHourDetail  a  where a.BVersionName='园区核心维护开发项目B01'
and  a.YearMonth=202002  and DeptName='资料开发部网络&IT产品资料部（杭州）';

select  SUM(a.Percents)   from    WorkHourDetail  a  where a.BVersionName='园区核心维护开发项目B01'
and  a.YearMonth=202002  and DeptName='资料开发部网络&IT产品资料部（杭州）' 
and a.UserName='袁士伟';

select  *   from    WorkHourDetail  a  where a.BVersionName='园区核心维护开发项目B01'
and  a.YearMonth=202002  and DeptName='资料开发部网络&IT产品资料部（杭州）';


WITH    pro  AS 
( 
	SELECT ProCode,ProLevel,ParentCode
	FROM     ProductInfo
	WHERE    Manager='jichengzhi 08604'  and DeleteFlag!=1
	UNION all
	SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag=0
)
--insert INTO #tempProductInfo
SELECT   ProCode  FROM pro; 
--insert into #tempProductInfo
--SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId='jichengzhi 08604';
;