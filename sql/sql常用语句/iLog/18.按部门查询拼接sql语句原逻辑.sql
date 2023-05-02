
declare @startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@IsPDT nvarchar(5),@UserId nvarchar(16),@sysRole int,@projectCode nvarchar(4000),
@station nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@SelRowID nvarchar(4000),@IsLinkType nvarchar(5),@ProductLineCode nvarchar(4000),@PDTCode nvarchar(4000),@FirstProCode nvarchar(4000),@SecondProCode nvarchar(4000),@ThirdProCode nvarchar(4000),@FourthProCode nvarchar(4000),@Month nvarchar(4000),@SecondDeptName nvarchar(4000)
select @startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',@IsPDT=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=0,@projectCode=N'',@station=N'',@proTreeNode=N'',@deptTreeNode=N'',
@SelRowID=N'',@IsLinkType=N'false',@ProductLineCode=N'',@PDTCode=N'',@FirstProCode=N'',@SecondProCode=N'',@ThirdProCode=N'',@FourthProCode=N'',@Month=N'',@SecondDeptName=N''
declare @RowID varchar(max);
declare @SQL nvarchar(max);

set @RowID='';
	--新增临时表 接收明细表基础数据
create table #temp_table
(
				Row_ID int ,  --Row_ID 自增长
				SecondDeptName varchar(100),
				DName varchar(100),
				UserName varchar(100),
				UserCode varchar(100),
				mon_date varchar(100),
				ProductLineName varchar(100),
				PDTName varchar(100),
				PDTCode varchar(100),
				FirstProCode varchar(100), 
				FirstProName varchar(100), 
				SecondProCode varchar(100),
				SecondProName varchar(100),
				Station varchar(100),
				StationName varchar(100),
				sumPer float,
				sumMon float,
				ispdt int,
				DeptCode varchar(100),
				SecondDeptCode varchar(100),
				ProductLineCode varchar(100),
				ThirdProName varchar(100),
				ThirdProCode varchar(100),
				FourthProName varchar(100),
				FourthProCode varchar(100),
				PCodeShare varchar(100),
				FirstProCodeShare varchar(100),
				SecondProCodeShare varchar(100),
				ThirdProCodeShare varchar(100),
				FourthProCodeShare varchar(100),
				StationNameShow varchar(100),
				SumAll float,
				Counts int
)   


--							  declare @startDate DATETIME,--时间区间开始
--@endDate DATETIME,--时间区间结束
--@ProjectLevel VARCHAR(50),
--@IsPDT varchar(50),
--@UserId varchar(50),
--@SysRole int

--set @startDate='2018-11-01';
--set @endDate='2018-12-30';
--set @ProjectLevel='4';
--set @IsPDT='5,6,7';
--set @UserId='liucaixuan 03806';
--set @SysRole=0;

	insert into #temp_table (Row_ID,SecondDeptName,DName,UserName,UserCode,mon_date,ProductLineName,PDTName,PDTCode,FirstProCode,FirstProName,SecondProCode,SecondProName,Station,StationName,
	sumPer,sumMon,ispdt,DeptCode,SecondDeptCode,ProductLineCode,ThirdProName,ThirdProCode,FourthProName,FourthProCode,PCodeShare,FirstProCodeShare,SecondProCodeShare,ThirdProCodeShare,FourthProCodeShare,StationNameShow,SumAll,Counts) EXEC [dbo].[P_WorkHourDetailView] 0,0, @startDate,@endDate,@ProjectLevel,@IsPDT,@UserId,@SysRole,'','',@projectCode,@station,@proTreeNode,@deptTreeNode,@RowID,'false','','','','','','','',''


	

	/****************导出，合计start**************************/
	--rowID选中 应用于导出勾选

	declare @contion varchar(max);
	if(@SelRowID<>'')
	begin
		DECLARE @Split_RowID NVARCHAR(MAX);
		if(CHARINDEX(',',@SelRowID)>0)
			begin
			set @Split_RowID='select tableColumn from F_SplitStrToTable('''+@SelRowID+''')';
			end
		else
			begin
			set @Split_RowID=''''+isnull(@SelRowID,'')+'''';
			end
			set @contion='where RowID  in ('+@Split_RowID+')';
	end

	

	/****************导出，合计start**************************/
	set @SQL='
	select ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode),0) rowID,sum(sumPer/sumMon) sumPer,ProductLineCode,
	ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName,SecondDeptName,
	SecondDeptCode into #SelectAllPro from #temp_table
	where SecondDeptCode is not null and SecondDeptCode<>''''
    group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,
		ThirdProCode,ThirdProName,FourthProCode,FourthProName,SecondDeptName,SecondDeptCode;';
	
if(@contion<>'')
	begin
	set @sql=@sql+'select '+@GroupBySql+' into #pro from #SelectAllPro;
	select SecondDeptName,SecondDeptCode,Sum(sp.sumPer) over(partition by sp.RowID)as SumAll into #SelectAllPer 
	from #SelectAllPro sp 
	where exists 
	(
		select * from #pro '+@whereSql+'
	) group by SecondDeptName,SecondDeptCode;

	select sp.*,b.SumAll  from #SelectAllPro sp inner join #SelectAllPer b on sp.SecondDeptCode=b.SecondDeptCode  
	where exists 
		(
			select * from #pro '+@whereSql+'
		) and  rowId  between  ' + CAST(( ( @pageIndex - 1 ) * @pageCount + 1) AS VARCHAR(20))
                            + ' and ' + CAST(@pageIndex * @pageCount AS VARCHAR(20)) +isnull(@contion,'') ;

	end      
else
	begin
	SET @sql = @sql+ ' select Count(1) as totalCount into #totalCountTable from #SelectAllPro;';
	set @SQL=@SQL+'select *,SUM(sumPer) over(partition by '+@GroupBySql+')as SumAll
		from  #SelectAllPro  inner  join  #totalCountTable  tct on 1=1  '+'where  rowId  between  ' + CAST(( ( @pageIndex - 1 ) * @pageCount + 1) AS VARCHAR(20))
		+ ' and ' + CAST(@pageIndex * @pageCount AS VARCHAR(20));
end

	
	----select SecondDeptCode,sum(sumPer) as SumAll into #SelectAllPer from #SelectAllPro '+isnull(@contion,'') +'group by SecondDeptCode;
	
	-----select a.*,b.SumAll from #SelectAllPro a inner join #SelectAllPer b on a.SecondDeptCode=b.SecondDeptCode '+isnull(@contion,'');  

	--set  @SQL='select   FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,
	--	ThirdProCode,ThirdProName,FourthProCode,FourthProName  from   ('+@SQL+') group by   FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,
	--	ThirdProCode,ThirdProName,FourthProCode,FourthProName ';

	--select  @SQL;

	select ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode),0) rowID,sum(sumPer/sumMon) sumPer,ProductLineCode,
	ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName,SecondDeptName,
	SecondDeptCode into #SelectAllPro from #temp_table
	where SecondDeptCode is not null and SecondDeptCode<>''
    group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,
		ThirdProCode,ThirdProName,FourthProCode,FourthProName,SecondDeptName,SecondDeptCode;select SecondDeptName,sum(sumPer) as SumAll into #SelectAllPer from #SelectAllPro  group by SecondDeptName;
	select  COUNT(*) from 
	(
		select a.*,b.SumAll from #SelectAllPro a inner join #SelectAllPer b on a.SecondDeptName=b.SecondDeptName 
	) a  group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,
		ThirdProCode,ThirdProName,FourthProCode,FourthProName

	--Exec Sp_ExecuteSql @SQL;

drop table #temp_table;
--drop table #tempProductInfo;
--drop table #tempDeptInfo;
--drop table #checkedProTable;
--drop table #checkedDeptTable;
--drop table #tempCheckedProductInfo;
--drop table #tempCheckedDeptInfo;
drop table #SelectAllPro;
drop table #SelectAllPer;



