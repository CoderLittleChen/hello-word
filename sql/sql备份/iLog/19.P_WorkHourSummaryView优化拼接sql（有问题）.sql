USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_WorkHourSummaryView_New]    Script Date: 2020/1/3 19:21:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



	


-- =============================================
-- Author:		工时投入人力总表  by lys0670 
-- =============================================
ALTER PROCEDURE [dbo].[P_WorkHourSummaryView_New]

@startDate DATETIME,--Mon_Date时间区间开始
@endDate DATETIME,--Mon_Date时间区间结束
@ProjectLevel VARCHAR(50), --项目层级  2是二级项目 3是三级项目  4是四级项目 ''是PDT级项目  else 为9编码开头的版本
@GroupBySql varchar(200),--分组的sql语句
@IsPDT varchar(50),--@IsPDT 5是PDT人力 6是周边人力  7是外包人力	
@UserId varchar(50),--用户标记  如:liucaixuan 03806
@SysRole int, --是否为管理员 0代表管理员  1非管理员
@SysProjectManager  int,--是否为项目主管  0代表否  1代表是
@SysPoP int,--是否为POP  0代表否  1代表是
@SysDeptManager  int,--是否为部门主管  0代表否 1代表是
@SysDeptSecretary  int,--是否为部门秘书  0代表否  1代表是
@projectCode VARCHAR(MAX),
@proTreeNode VARCHAR(MAX),
@deptTreeNode VARCHAR(MAX),
@RowID varchar(max), --rowID选中 应用于导出勾选
@pageIndex int,
@pageCount int
AS
	--总体思路  
	--非管理员先查询权限（项目权限和部门权限） 初步筛选
	--然后在根据页面选择的条件  join进行二次筛选
	--二次筛选后的临时表和明细表 join  生成最终数据表  
    BEGIN
	DECLARE @tempMonth  datetime;
	set @tempMonth=DATEADD(MONTH,-2,GETDATE());
	declare @rowName varchar(1000);
	set @rowName = ' [ID]
      ,[ProCode]
      ,[ProName]
      ,[ProductLineCode]
      ,[ProductLineName]
      ,[PDTCode]
      ,[PDTName]
      ,[BVersionCode]
      ,[BVersionName]
      ,[SecondProCode]
      ,[SecondProName]
      ,[ThirdProCode]
      ,[ThirdProName]
      ,[FourthProCode]
      ,[FourthProName]
      ,[UserCode]
      ,[UserName]
      ,[YearMonth]
      ,[Percents]
      ,[WorkingDay]
      ,[DeptCode]
      ,[DeptName]
      ,[SecondDeptCode]
      ,[SecondDeptName]
      ,[StationCategoryCode]
      ,[StationCategoryName]
      ,[IsPDT]
      ,[IsVendor]
	  ,[PDTCount]
	  ,[RoundCount]
	  ,[VendorCount] ';

	DECLARE @Condition NVARCHAR(MAX);
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @Split_proTreeCode NVARCHAR(MAX);
	set @Split_proTreeCode='';
	DECLARE @Split_projectCode NVARCHAR(MAX);
	set @Split_projectCode='';
	--set @RowID='';
	
--新增临时表 接收明细表WorkHourDetail表中基础数据
create table #tempDetailTable
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
		WorkingDay tinyint,
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
		WorkingDay tinyint,
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
	Pro_Code varchar(100)
);
--创建临时表来保存用户选择的项目  
create table  #checkedProTable
(
	Pro_Code  varchar(100)
);
--创建临时表来保存用户选择的项目  
create table  #inputProTable
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


--判断是否有选择产品树
if(@proTreeNode<>'')
		begin				
			--将用户选择的产品树保存在表中   手动输入的项目编码直接和明细表关联判断
			insert  into   #checkedProTable  
			select tableColumn from F_SplitStrToTable(@proTreeNode);
		end
--判断是否手动输入了项目编码  可能输入多个 已,为间隔
if(@projectCode<>'')
		begin
			insert  into   #inputProTable  
			select tableColumn from F_SplitStrToTable(@projectCode);
		end



--根据用户选择的项目编码递归求其子节点
if((select top 1 *  from #checkedProTable)!='')
	begin
		WITH    tempCheckedProduct  AS 
		( 
			SELECT c.ProCode,ProLevel,ParentCode
			FROM     ProductInfo  c
			inner join   #checkedProTable  d  on c.ProCode=d.Pro_Code
			where DeleteFlag!=1
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
		--然后用#tempCheckedProductInfo和明细表进行join得到最终的数据源
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM #tempProductInfo  a
	end


--将明细表数据插入临时表    这里需要根据startDate和endDate来判断取当前查询哪个表的数据
--@startDate,@endDate,@IsPDT,@UserId,@projectCode,@proTreeNode

--根据时间确定查哪个表
if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
	begin	
		SET @Condition = 'insert into  #tempDetailTable select '+ @rowName + ' from WorkHourDetailHistory ';
	end
else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
	begin
		SET @Condition = 'insert into  #tempDetailTable  
									 select * from 
										( 
											SELECT ' + @rowName + ' FROM dbo.WorkHourDetailHistory
											UNION all
											SELECT  ' + @rowName+ ' FROM dbo.WorkHourDetail
										) tempDetail ';
	end
else 
	begin
		SET @Condition = 'insert into  #tempDetailTable select '+ @rowName+ '  from WorkHourDetail ';
	end

--判断PDT 周边  外包
--PDT
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1and CHARINDEX('7', @IsPDT)<1 )
	begin
		SET @Condition = @Condition + ' where  IsPDT=1  and IsVendor=0 ';
	end
--周边
else if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)<1)
	begin
		SET @Condition = @Condition + ' where  IsPDT=0  and IsVendor=0 ';
	end
--外包
else if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('7', @IsPDT)>0)
	begin
		SET @Condition = @Condition + ' where   IsVendor=1 ';
	end
--PDT 周边
else if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)<1)
	begin
		SET @Condition = @Condition + ' where   IsVendor=0 ';
	end
--PDT 外包
else if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('7', @IsPDT)>0)
	begin
		SET @Condition = @Condition + ' where  IsPDT=1  or IsVendor=1 ';
	end
--周边  外包 
else if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0)
	begin
		SET @Condition = @Condition + ' where  IsPDT=0  or IsVendor=1 ';
	end
--三者全选 或全不选
else
	begin
		SET @Condition = @Condition + ' where  1=1 ';
	end

SET @Condition = @Condition + ' and YearMonth between '
        + CONVERT(VARCHAR(6), @startDate, 112) + ' and '
        + CONVERT(VARCHAR(6), @endDate, 112);

--将通过时间  PDT 周边  人力  筛选后的数据插入tempDetail表中
EXEC sp_executesql @Condition; 


set @Condition='';
--判断产品权限表是否为空   
--判断部门权限表是否为空
--判断手动输入的项目编码是否为空

--只需判断是否输入了项目编码
if(@projectCode<>'')
	begin
		--有产品权限  输入了项目编码
		set @Condition='  insert into #temp_table  
									select  '+@rowName+' from  #tempDetailTable   a  
									inner  join  #tempCheckedProductInfo  b  on  a.proCode=b.pro_Code  	
									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code										   
									where
								    (ProductLineCode IN (SELECT * FROM #inputProTable) OR PDTCode IN (SELECT * FROM #inputProTable) OR BVersionCode IN (SELECT * FROM #inputProTable) OR SecondProCode IN(SELECT * FROM #inputProTable) OR ThirdProCode IN(SELECT * FROM #inputProTable) OR FourthProCode IN (SELECT * FROM #inputProTable)) 
									union 
									select  '+@rowName+' from  #tempDetailTable   a  
									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code						   
									where 
								    (ProductLineCode IN (SELECT * FROM #inputProTable) OR PDTCode IN (SELECT * FROM #inputProTable) OR BVersionCode IN (SELECT * FROM #inputProTable) OR SecondProCode IN(SELECT * FROM #inputProTable) OR ThirdProCode IN(SELECT * FROM #inputProTable) OR FourthProCode IN (SELECT * FROM #inputProTable)) 
									'
	end 
else
	begin
	--有产品权限  未输入项目编码
		set @Condition='  insert into #temp_table  
									select  '+@rowName+' from  #tempDetailTable   a  
									inner  join  #tempCheckedProductInfo  b  on  a.proCode=b.pro_Code  	
									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code										   
									union 
									select  '+@rowName+' from  #tempDetailTable   a  
									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code						   
								  '
	end

	select  @Condition;

--EXEC sp_executesql @Condition; 

set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table a  
Group  by '+@GroupBySql;


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

    --Exec Sp_ExecuteSql @sql;
	--SELECT @SQL;
/****************导出，合计start**************************/
drop table #temp_table;
drop table #tempProductInfo;
drop table #tempDeptInfo;
drop table #tempCheckedProductInfo;
drop table #checkedProTable;
	END





GO


