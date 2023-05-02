declare @startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@IsPDT nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4),@pageIndex int,@pageCount int;
select @startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',
@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',
@IsPDT=N'5,6,7,8,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',
@proTreeNode=N'',@deptTreeNode=N'',@RowID=N'',@pageIndex=1,@pageCount=15;

DECLARE @tempMonth  datetime;
DECLARE @Condition NVARCHAR(MAX);
DECLARE @SQL NVARCHAR(MAX);
--������ʱ�� ������ϸ��WorkHourDetail���л�������
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
--������ĿȨ����ʱ��
create table #tempProductInfo
(
	ProCode varchar(100)
);
---��������Ȩ����ʱ��
create table #tempDeptInfo
(
	Dept_Code varchar(100)
);
--������  ������ĿȨ�ޱ����ѡ����Ŀjoin֮�������
create table #tempCheckedProductInfo
(
	ProCode varchar(100)
);
--������ʱ���������û�ѡ�����Ŀ  
create table  #checkedProTable
(
	ProCode  varchar(100)
);


if(@SysRole = 0)
	--�ǹ���Ա    �жϾ����ɫ
	BEGIN
		--����Ŀ����
		if(@SysProjectManager=1)
			BEGIN
				--��ѯ��ĿȨ��
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
		--��POP
		else if(@SysPoP=1)
			BEGIN
				--��ѯ��ĿȨ��
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
		--�ǲ�������
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
		--�ǲ�������
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
	--����Ա�鿴ȫ������
	begin
		--����Ŀ��Ϣȫ��������ʱ��
		insert INTO #tempProductInfo
		SELECT ProCode  FROM ProductInfo  where DeleteFlag!=1; 
		--��������Ϣȫ��������ʱ��
		insert INTO #tempDeptInfo
		SELECT DeptCode  FROM Department   where   DeleteFlag=0; 
	end

DECLARE @Split_projectCode NVARCHAR(MAX);
set @Split_projectCode='';
--���û�ѡ��Ĳ�Ʒ�����ֶ���д�Ĳ��ű���ϲ�
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

--���û�ѡ��Ĳ�Ʒ�����ֶ���д����Ŀ���뱣���ڱ���
insert  into   #checkedProTable  
select tableColumn from F_SplitStrToTable(@Split_projectCode);


--�����û�ѡ�����Ŀ����ݹ������ӽڵ�
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
		--Ȼ����#tempCheckedProductInfo����ϸ�����join�õ����յ�����Դ
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM tempCheckedProduct  a  join #tempProductInfo  b  on  a.ProCode=b.ProCode ;
	end
else
	begin
		print '0000000000000000000';
		--Ȼ����#tempCheckedProductInfo����ϸ�����join�õ����յ�����Դ
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM #tempProductInfo  a
	end


--����ϸ�����ݲ�����ʱ��    ������Ҫ����startDate��endDate���ж�ȡ��ǰ��ѯ�ĸ��������
--@startDate,@endDate,@IsPDT,@UserId,@projectCode,@proTreeNode
set @tempMonth=DATEADD(MONTH,-2,GETDATE());
if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
	begin
		--ֻ��ѯ��ʷ��
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
		--��ѯ��ʷ��͵�ǰ��
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
		--��ѯ��ǰ��
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

--�����ܱ�����
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

--�����������
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

--����PDT�������ܱ�����
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

--����PDT�������������
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

--�ܱ��������������
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

--PDT�������ܱ��������������
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



/****************�������ϼ�start**************************/
--rowIDѡ�� Ӧ���ڵ�����ѡ
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
			--������λ�� --select a.*,b.Name as StationNameShow into #SelectAllPro from ('+@SQL+') a left join StationCategory b on a.Station=b.Code
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
	--������λ�� --select a.*,b.Name as StationNameShow into #SelectAllPro from ('+@SQL+') a left join StationCategory b on a.Station=b.Code
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