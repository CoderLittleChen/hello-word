declare @startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@IsPDT nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4),@pageIndex int,@pageCount int;
select @startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',
@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',
@IsPDT=N'5,6,7,8,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',
@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@pageIndex=1,@pageCount=15;

DECLARE @tempMonth  datetime;
DECLARE @Condition NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);
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


if(@SysRole = 0)
	--非管理员    判断具体角色
	BEGIN
		--是项目主管
		if(@SysProjectManager=1)
			BEGIN
				--查询项目权限
				WITH    pro  AS 
				( 
					SELECT ProCode,ProLevel,ParentCode
					FROM     ProductInfo
					WHERE    Manager=@UserId  and DeleteFlag!=1
					UNION ALL
					SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag=0
				)
				insert INTO #tempProductInfo
				SELECT ProCode  FROM pro; 
				insert into #tempProductInfo
				SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId=@UserId;
			END
		--是POP
		else if(@SysPoP=1)
			BEGIN
				--查询项目权限
				WITH    pro  AS 
				( 
					SELECT ProCode,ProLevel,ParentCode
					FROM     ProductInfo
					WHERE    CC=@UserId  and DeleteFlag!=1
					UNION ALL
					SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag=0
				)
				insert INTO #tempProductInfo
				SELECT ProCode  FROM pro; 
				insert into #tempProductInfo
				SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId=@UserId;
			END
		--是部门主管
		if(@SysDeptManager=1)
			BEGIN
				WITH    dept  AS 
				( 
					SELECT DeptCode,DeptLevel,ParentDeptCode
					FROM     Department
					WHERE    DeptManager=@UserId  and DeleteFlag=0
					UNION ALL
					SELECT a.DeptCode,a.DeptLevel,a.ParentDeptCode  FROM Department a INNER JOIN dept b ON  a.ParentDeptCode=b.DeptCode where a.DeleteFlag=0
				)
				insert INTO #tempDeptInfo
				SELECT DeptCode  FROM dept; 
				insert into #tempDeptInfo
				SELECT DeptCode FROM GiveRight_Dept WHERE DeleteFlag=0 AND UserId=@UserId;
			END
		--是部门秘书
		else if(@SysDeptSecretary=1)
			BEGIN
				WITH    dept  AS 
				( 
					SELECT DeptCode,DeptLevel,ParentDeptCode
					FROM     Department
					WHERE    DeptSecretary=@UserId  and DeleteFlag=0
					UNION ALL
					SELECT a.DeptCode,a.DeptLevel,a.ParentDeptCode  FROM Department a INNER JOIN dept b ON  a.ParentDeptCode=b.DeptCode where a.DeleteFlag=0
				)
				insert INTO #tempDeptInfo
				SELECT DeptCode  FROM dept; 
				insert into #tempDeptInfo
				SELECT DeptCode FROM GiveRight_Dept WHERE DeleteFlag=0 AND UserId=@UserId;
			END

END
else
	--管理员查看全部数据
	begin
		--将项目信息全部插入临时表
		insert INTO #tempProductInfo
		SELECT ProCode  FROM ProductInfo  where DeleteFlag!=1; 
		--将部门信息全部插入临时表
		insert INTO #tempDeptInfo
		SELECT DeptCode  FROM Department   where   DeleteFlag=0; 
	end

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

--将用户选择的产品树和手动填写的项目编码保存在表中
insert  into   #checkedProTable  
select tableColumn from F_SplitStrToTable(@Split_projectCode);


--根据用户选择的项目编码递归求其子节点
if((select top 1 *  from #checkedProTable)!='')
	begin
		print '1111111111111';
		WITH    tempCheckedProduct  AS 
		( 
			(
			SELECT c.ProCode,ProLevel,ParentCode
			FROM     ProductInfo  c
			inner join   #checkedProTable  d  on c.ProCode=d.ProCode
			where DeleteFlag!=1
			union 
			SELECT c.ProCode,ProLevel,ParentCode
			FROM     ProductInfo  c
			inner join   #checkedProTable  d  on c.ProCode=d.ProCode
			where DeleteFlag=1 
			)
			UNION ALL
			SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a 
			INNER JOIN tempCheckedProduct b ON  a.ParentCode=b.ProCode 
			where a.DeleteFlag!=1
		)
		--然后用#tempCheckedProductInfo和明细表进行join得到最终的数据源
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM tempCheckedProduct  a  join #tempProductInfo  b  on  a.ProCode=b.ProCode ;
	end
else
	begin
		print '0000000000000000000';
		--然后用#tempCheckedProductInfo和明细表进行join得到最终的数据源
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM #tempProductInfo  a
	end


--将明细表数据插入临时表    这里需要根据startDate和endDate来判断取当前查询哪个表的数据
--@startDate,@endDate,@IsPDT,@UserId,@projectCode,@proTreeNode
set @tempMonth=DATEADD(MONTH,-2,GETDATE());
if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
	begin
		--只查询历史表
		insert into #temp_table 
		select   
			ID,
			whdh.ProCode,
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
		from  WorkHourDetailHistory  whdh
		inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
		where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
		union
		select   
			ID,
			whdh.ProCode,
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
		from  WorkHourDetailHistory  whdh
		inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
		inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
		where	convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')<@endDate
	end
else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
	begin
		--查询历史表和当前表
		insert into #temp_table 
		select   
			ID,
			whdh.ProCode,
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
		from  WorkHourDetailHistory  whdh
		inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
		where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
		union
		select   
			ID,
			whdh.ProCode,
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
		from  WorkHourDetailHistory  whdh
		inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
		inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.ProCode
		where  convert(datetime,CONVERT(varchar(20),whdh.YearMonth)+'01')>=@startDate 
		union 
		select   
			ID,
			whd.ProCode,
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
			IsVendor
		from  WorkHourDetail  whd
		inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
		where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
		union
		select   
			ID,
			whd.ProCode,
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
			IsVendor
		from  WorkHourDetail  whd
		inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
		inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
		where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
	end
else
	begin
		--查询当前表
		insert into #temp_table 
		select   
			ID,
			whd.ProCode,
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
		where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
		union
		select   
			ID,
			whd.ProCode,
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
		inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
		inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
		where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
	end


if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1and CHARINDEX('7', @IsPDT)<1 )
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table a  where  IsPDT=1  and IsVendor=0
Group  by '+@GroupBySql
end

--存在周边人力
if(CHARINDEX('6', @IsPDT)>0 and CHARINDEX('5', @IsPDT)<1 and CHARINDEX('7', @IsPDT)<1)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table a  where  IsPDT=0  and IsVendor=0
Group  by '+@GroupBySql
End

--存在外包人力
if(CHARINDEX('7', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('5', @IsPDT)<1)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table a  where  IsVendor=1
Group  by '+@GroupBySql
End

--存在PDT人力、周边人力
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)<1)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table  a  where  IsVendor=0
Group  by '+@GroupBySql
end

--存在PDT人力、外包人力
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from
(
	select  '+@GroupBySql+',PDTCount,RoundCount,VendorCount
	from  #temp_table   where  IsPDT=1 
	union all
	select  '+@GroupBySql+',PDTCount,RoundCount,VendorCount
	from  #temp_table   where  IsVendor=1
)  a
Group  by '+@GroupBySql
end

--周边人力、外包人力
if(CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0 and CHARINDEX('5', @IsPDT)<1)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from
(
	select  '+@GroupBySql+',PDTCount,RoundCount,VendorCount
	from  #temp_table   where  IsPDT=0
	union all
	select  '+@GroupBySql+',PDTCount,RoundCount,VendorCount
	from  #temp_table   where  IsVendor=1
)  a
Group  by '+@GroupBySql

end

if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('7', @IsPDT)<1)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table   a
Group  by '+@GroupBySql
end

--PDT人力、周边人力、外包人力
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0)
begin
set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table   a  
Group  by '+@GroupBySql

--set @SQL=' select  *  from  #temp_table  '
end



/****************导出，合计start**************************/
--rowID选中 应用于导出勾选
	if(@RowID<>'')
	begin
	DECLARE @Split_RowID NVARCHAR(MAX);
		if(CHARINDEX(',',@RowID)>0)
			begin
			set @Split_RowID='select tableColumn from F_SplitStrToTable('''+@RowID+''')';
			end
		else
			begin  
			set @Split_RowID=''''+isnull(@RowID,'')+'''';
			end
	--set @SQL='select * from ('+@SQL+') a where RowID  in ('+@Split_RowID+')';
	--set @SQL='select * from ('+@SQL+') a  ';
			--关联岗位表 --select a.*,b.Name as StationNameShow into #SelectAllPro from ('+@SQL+') a left join StationCategory b on a.Station=b.Code
	set @SQL='DECLARE @SAPAll float;DECLARE @SAP float;DECLARE @PDT float;DECLARE @ZB float;DECLARE @WB float;
	select ISNULL( ROW_NUMBER() OVER(ORDER BY '+@GroupBySql+'),0) rowID,a.* into #SelectAllPro from ('+@SQL+') a;
	SELECT @SAPAll=sum(SAPAll) FROM #SelectAllPro;
	SELECT @SAP=sum(SAP) FROM #SelectAllPro;
	SELECT @PDT=sum(PDT) FROM #SelectAllPro;
	SELECT @ZB=sum(ZB) FROM #SelectAllPro;
	SELECT @WB=sum(WB) FROM #SelectAllPro;
	select Count(1) as totalCount into #totalCountTable from #SelectAllPro;
	select *,@SAPAll SAPAllNew,@SAP SAPNew,@PDT PDTNew,@ZB ZBNew,@WB WBNew,tct.TotalCount from #SelectAllPro ' +
	'inner  join  #totalCountTable  tct on 1=1 '+'where RowID  in ('+@Split_RowID+')';
	end
else	
begin
	--关联岗位表 --select a.*,b.Name as StationNameShow into #SelectAllPro from ('+@SQL+') a left join StationCategory b on a.Station=b.Code
	set @SQL='DECLARE @SAPAll float;DECLARE @SAP float;DECLARE @PDT float;DECLARE @ZB float;DECLARE @WB float;
	select ISNULL( ROW_NUMBER() OVER(ORDER BY '+@GroupBySql+'),0) rowID,a.* into #SelectAllPro from ('+@SQL+') a;
	SELECT @SAPAll=sum(SAPAll) FROM #SelectAllPro;
	SELECT @SAP=sum(SAP) FROM #SelectAllPro;
	SELECT @PDT=sum(PDT) FROM #SelectAllPro;
	SELECT @ZB=sum(ZB) FROM #SelectAllPro;
	SELECT @WB=sum(WB) FROM #SelectAllPro;
	select Count(1) as totalCount into #totalCountTable from #SelectAllPro;
	select *,@SAPAll SAPAllNew,@SAP SAPNew,@PDT PDTNew,@ZB ZBNew,@WB WBNew,tct.TotalCount from #SelectAllPro ' +
	'inner  join  #totalCountTable  tct on 1=1 '+
	'where  rowId  between  ' + CAST(( ( @pageIndex - 1 ) * @pageCount + 1) AS VARCHAR(20))+ 
				' and ' + CAST(@pageIndex * @pageCount AS VARCHAR(20));
end

	

	
	


    Exec Sp_ExecuteSql @sql;
	--select @SQL;
drop table #temp_table;
drop table #tempProductInfo;
drop table #tempDeptInfo;
drop table #tempCheckedProductInfo;
drop table #checkedProTable;