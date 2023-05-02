declare @startDate DATETIME;--Mon_Date时间区间开始
declare @endDate DATETIME;--Mon_Date时间区间结束
declare @ProjectLevel VARCHAR(50); --项目层级  2是二级项目 3是三级项目  4是四级项目 ''是PDT级项目  else 为9编码开头的版本
declare @GroupBySql varchar(200);--分组的sql语句
declare @IsPDT varchar(50);--@IsPDT 5是PDT人力 6是周边人力  7是外包人力	
declare @UserId varchar(50);--用户标记  如:liucaixuan 03806
declare @SysRole int; --是否为管理员 0代表管理员  1非管理员
declare @SysProjectManager  int;--是否为项目主管  0代表否  1代表是
declare @SysPoP int;--是否为POP  0代表否  1代表是
declare @SysDeptManager  int;--是否为部门主管  0代表否 1代表是
declare @SysDeptSecretary  int;--是否为部门秘书  0代表否  1代表是
declare @projectCode VARCHAR(MAX);
declare @proTreeNode VARCHAR(MAX);


set @startDate='2019-12-01';
set @endDate='2019-12-31';
set @ProjectLevel='Normal';
set @GroupBySql='Group  by  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName';
set @IsPDT='5,6,7,8,';
set @UserId='liucaixuan 03806';
set @SysRole='1';
set @SysProjectManager='1';
set @SysPoP='0';
set @SysDeptManager='1';
set @SysDeptSecretary='0';
set @projectCode='';
set @proTreeNode='';
--PT000183


--AS
	--总体思路  
	--非管理员先查询权限（项目权限和部门权限） 初步筛选
	--然后在根据页面选择的条件  join进行二次筛选
	--二次筛选后的临时表和明细表 join  生成最终数据表  
    --BEGIN
--drop  table #temp_table
--drop  table #tempProductInfo
--drop  table #tempDeptInfo
--drop  table #tempCheckedProductInfo
--drop  table #checkedProTable
	DECLARE @tempMonth  datetime;
	DECLARE @Condition NVARCHAR(MAX);
	DECLARE @SQL NVARCHAR(MAX);
	--set @RowID='';
--新增临时表 接收明细表WorkHourDetail表中基础数据
create table #temp_table
(
		ID int,
		ProCode varchar(20),
		ProName nvarchar(100),
		ProductLineCode varchar(20),
		ProductLineName nvarchar(100),
		PDTCode varchar(20),
		PDTName nvarchar(100),
		BVersionCode varchar(20),
		BVersionName nvarchar(100),
		SecondProCode varchar(20),
		SecondProName nvarchar(100),
		ThirdProCode  varchar(20),
		ThirdProName nvarchar(100),
		FourthProCode varchar(20),
		FourthProName nvarchar(100),
		UserCode varchar(20),
		UserName nvarchar(50),
		YearMonth int,
		Percents float,
		WorkingCopy tinyint,
		DeptCode varchar(10),
		DeptName nvarchar(100),
		SecondDeptCode varchar(10),
		SecondDeptName  nvarchar(100),
		StationCategoryCode varchar(10),
		StationCategoryName nvarchar(50),
		IsPDT bit,
		IsVendor bit,
		PDTCount  float,
		RoundCount float,
		VendorCount float
) 
--创建项目权限临时表
create table #tempProductInfo
(
	ProCode varchar(100)
);
---创建部门权限临时表
create table #tempDeptInfo
(
	Dept_Code varchar(100)
);
--创建表  保存项目权限表和已选择项目join之后的数据
create table #tempCheckedProductInfo
(
	ProCode varchar(100)
);
--创建临时表来保存用户选择的项目  
create table  #checkedProTable
(
	ProCode  varchar(100)
);

insert INTO #tempProductInfo
SELECT ProCode  FROM ProductInfo  where DeleteFlag!=1; 
--将部门信息全部插入临时表
insert INTO #tempDeptInfo
SELECT DeptCode  FROM Department  where DeleteFlag!=1; 

DECLARE @Split_projectCode NVARCHAR(MAX);
set @Split_projectCode='';
--将用户选择的产品树和手动填写的部门编码合并
if(@projectCode<>'')
		begin
			set @Split_projectCode=@Split_projectCode+@projectCode;
			if(@proTreeNode<>'')
				begin
					set @Split_projectCode=@Split_projectCode+','+@proTreeNode;
				end
		end
else 
	if(@proTreeNode<>'')
				begin
					set @Split_projectCode=@Split_projectCode+@proTreeNode;
				end

--将用户选择的产品树和手动填写的部门编码保存在表中
insert  into   #checkedProTable  
select tableColumn from F_SplitStrToTable(@Split_projectCode);
--根据用户选择的部门编码递归求其子节点
if((select top 1 *  from #checkedProTable)!='')
	begin
		WITH    tempCheckedProduct  AS 
		( 
			SELECT c.ProCode,ProLevel,ParentCode
			FROM     ProductInfo  c
			inner join   #checkedProTable  d  on c.ProCode=d.ProCode
			where DeleteFlag!=1
			UNION ALL
			SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a 
			INNER JOIN tempCheckedProduct b ON  a.ParentCode=b.ProCode 
			where a.DeleteFlag!=1  
		)
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM tempCheckedProduct  a  join #tempProductInfo  b  on  a.ProCode=b.ProCode;
	end
else
	begin
		--WITH    tempCheckedProduct  AS 
		--( 
		--	SELECT c.ProCode,ProLevel,ParentCode
		--	FROM     ProductInfo  c
		--	where DeleteFlag=0
		--	UNION ALL
		--	SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a 
		--	INNER JOIN tempCheckedProduct b ON  a.ParentCode=b.ProCode 
		
		--	where a.DeleteFlag=0  
		--)
		--select  1;
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM #tempProductInfo  a;
	end

--所选的项目节点递归  然后和权限join之后保存到#tempCheckedProductInfo临时表


--insert INTO #tempCheckedProductInfo
--SELECT a.ProCode  FROM tempCheckedProduct  a 

--select  *   from  #checkedProTable;
--select  *   from  #tempProductInfo;
--select  *   from  #tempCheckedProductInfo  --where  ProCode='PT000183';

--select   *   from  tempCheckedProduct  a;

insert into #temp_table 
		select   
			ID,
			a.ProCode,
			ProName,
			ProductLineCode,
			ProductLineName,
			PDTCode,
			PDTName,
			BVersionCode,
			BVersionName,
			SecondProCode,
			SecondProName,
			ThirdProCode,
			ThirdProName,
			FourthProCode,
			FourthProName,
			UserCode,
			UserName,
			YearMonth,
			Percents,
			WorkingDay,
			DeptCode,
			DeptName,
			SecondDeptCode,
			SecondDeptName,
			StationCategoryCode,
			StationCategoryName,
			IsPDT,
			IsVendor,
			PDTCount,
			RoundCount,
			VendorCount 
		from  WorkHourDetail  whd
		inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
		inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
		where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate



select 
ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName
,SUM(a.PDTCount) as PDT
,SUM(a.RoundCount) as ZB,SUM(a.VendorCount) as WB
,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table a   where  a.BVersionCode='9000009'
Group  by  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName

