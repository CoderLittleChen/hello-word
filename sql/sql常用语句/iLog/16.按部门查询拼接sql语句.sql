declare @startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(105),@conditionFlag nvarchar(5),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@RowID nvarchar(4),@whereSql varchar(200),@pageIndex int,@pageCount int,@GroupByProductNoDeptSql varchar(200);
select @startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',
@GroupBySql=N'  SecondDeptName,SecondDeptCode,ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName ',
@GroupByProductNoDeptSql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName ',
@conditionFlag=N'5,6,7',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',
--@conditionFlag=N'5,6,7',@UserId=N'chengxi 18102',@sysRole=0,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=0,@sysDeptSecretary=1,@projectCode=N'',
@proTreeNode=N'',@deptTreeNode=N'50041371,50041372,50041373,50041374,50041375,50043439,',@RowID=N'',
--@proTreeNode=N'PL000005,PT000076,PT000077,PT000183,PT000225,PT000268,PT000271,PT000280,PT000286,PT000288,PT000291,PT000292,PT000293,PT000294,PT000295,',@deptTreeNode=N'',@RowID=N'',
@whereSql='where  ProductLineCode=sp.ProductLineCode and PDTCode=sp.PDTCode and BVersionCode=sp.BVersionCode',
@pageIndex=1,@pageCount=15;


declare @SelRowID varchar(max);
declare @SQL nvarchar(max);
DECLARE @tempMonth  datetime;
set @SelRowID=@RowID;


--������ʱ�� ������ϸ���������  
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
--������ʱ���������û�ѡ�����Ŀ  
create table  #checkedProTable
(
	ProCode  varchar(100)
);
--������ʱ���������û�ѡ��Ĳ���
create table  #checkedDeptTable
(
	DeptCode  varchar(100)
);
--������  ������ĿȨ�ޱ����ѡ����Ŀjoin֮�������
create table #tempCheckedProductInfo
(
	ProCode varchar(100)
);
--������  ���沿��Ȩ�ޱ����ѡ����join֮�������
create table #tempCheckedDeptInfo
(
	Dept_Code varchar(100)
);

--����������
--create table #totalCount
--(	
--	totalCount  int
--)
create table #GroupBySecondDept
(
	SecondDeptName varchar(100),
	SecondDeptCode varchar(20),
	SumAll float
)

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
DECLARE @Split_deptCode NVARCHAR(MAX);
set @Split_deptCode='';
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

if(@deptTreeNode<>'')
	begin
		set @Split_deptCode=@Split_deptCode+@deptTreeNode;
	end


--���û�ѡ��Ĳ�Ʒ�����ֶ���д����Ŀ���뱣���ڱ���
insert  into   #checkedProTable  
select tableColumn from F_SplitStrToTable(@Split_projectCode);

insert  into   #checkedDeptTable  
select tableColumn from F_SplitStrToTable(@Split_deptCode);
--�����û�ѡ�����Ŀ����ݹ������ӽڵ�
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
		--Ȼ����#tempCheckedProductInfo����ϸ�����join�õ����յ�����Դ
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM tempCheckedProduct  a  join #tempProductInfo  b  on  a.ProCode=b.ProCode ;
	end
else
	begin
		--Ȼ����#tempCheckedProductInfo����ϸ�����join�õ����յ�����Դ
		insert INTO #tempCheckedProductInfo
		SELECT a.ProCode  FROM #tempProductInfo  a
	end

--�ж��û��Ƿ��Ѿ�ѡ���˶�������
if((select top 1 *  from #checkedDeptTable)!='')
	begin
		--�û�ѡ��Ĳ��ź����еĲ���Ȩ�� join
		print '------------------';
		insert INTO #tempCheckedDeptInfo
		SELECT a.DeptCode  FROM #checkedDeptTable  a  join #tempDeptInfo  b  on  a.DeptCode=b.Dept_Code ;
	end
else
	begin
		print '6666666666666666666666';
		--ֱ�ӽ�����Ȩ�޲�����ʱ��
		insert INTO #tempCheckedDeptInfo
		SELECT a.Dept_Code  FROM #tempDeptInfo  a
	end



--����ϸ�����ݲ�����ʱ��    ������Ҫ����startDate��endDate���ж�ȡ��ǰ��ѯ�ĸ��������
--@startDate,@endDate,@IsPDT,@UserId,@projectCode,@proTreeNode
set @tempMonth=DATEADD(MONTH,-2,GETDATE());

if((select top 1 *  from #checkedDeptTable)!='')
	begin
		--ѡ���˲���
		if((select top 1 *  from #checkedProTable)!='')
			--ѡ���˲�Ʒ
			begin
				print '111111111111111111';
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
						inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
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
						inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
						from  WorkHourDetail  whd
						inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
						inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
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
						inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
						where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
					end
			end
		else
			begin
				--�в���  û��Ʒ
				
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
						inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
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
						inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
						from  WorkHourDetail  whd
						inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode
						inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
						from  WorkHourDetail  whd
						inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
						where   convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
					end
				else
					begin
						print '2222222222222';
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
						inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
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
						inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
						where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
					end
			end
	end
else 
	begin
		if((select top 1 *  from #checkedProTable)!='')
			begin
				print '33333333333333';
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
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
			end
		else
			--���źͲ�Ʒ������û��		
			begin
				print '444444444444444444';
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
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
							IsVendor,
							PDTCount,
							RoundCount,
							VendorCount 
						from  WorkHourDetail  whd
						inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code
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
						where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate
					end
			end
	end
	


declare @contion varchar(max);
set @contion='';

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
		set @contion=' where  RowID  in ('+@Split_RowID+')';
end


/****************�������ϼ�start**************************/
set @SQL='
	select ISNULL( ROW_NUMBER() OVER(ORDER BY ProductLineCode,PDTCode,BVersionCode),0) rowID,sum(Percents)as sumPer, '
	+@GroupBySql+' into #SelectAllPro from #temp_table
	where SecondDeptCode is not null and SecondDeptCode<>''''  
	group by '+@GroupBySql+' ; ';


--Exec Sp_ExecuteSql  @SQL;
--select  @SQL;
--select *  from  #SelectAllPro;

set @SQL=@SQL+'select ISNULL( ROW_NUMBER() OVER(ORDER BY '+@GroupByProductNoDeptSql+'),0) rowID,'+@GroupByProductNoDeptSql+
				'  into   #GroupByProductNoDept  from  #SelectAllPro   '+
				'  group by '+@GroupByProductNoDeptSql+' ; ';

set @SQL=@SQL+' select  *  into   #GroupByProductNoDeptOfPaging  from #GroupByProductNoDept  '+
				'where  rowId  between  ' + CAST(( ( @pageIndex - 1 ) * @pageCount + 1) AS VARCHAR(20))+ 
				' and ' + CAST(@pageIndex * @pageCount AS VARCHAR(20));

set @SQL=@SQL+' ;select Count(1) as totalCount  into #totalCount  from  #GroupByProductNoDept;    ';




set @SQL=@SQL+' declare @allSecondDeptInfo varchar(1000);
						select @allSecondDeptInfo='''';
						select  @allSecondDeptInfo=STUFF((select  '',''+a.SecondDeptName+''-'' +convert(varchar(10),SUM(sumPer))   from #SelectAllPro  a  where  SecondDeptName!=''''  and  SecondDeptName is not null  group  by a.SecondDeptName    FOR XML PATH('''')),1, 1, ''''); ';

set @SQL=@SQL+' select SecondDeptName,SecondDeptCode,SUM(Percents) as SumAll  into #GroupBySecondDept  from #temp_Table    group  by  SecondDeptName,SecondDeptCode; ';

--Exec Sp_ExecuteSql @SQL;
--select  @allSecondDeptInfo;
-----select @SQL;
--select  *  from  #GroupBySecondDept ;

if(@contion<>'')
	begin
	print 'dsadsadasd'
	set @sql=@sql+'select '+@GroupBySql+' into #pro from #SelectAllPro '+isnull(@contion,'')+';
	select SecondDeptName,SecondDeptCode,SUM(sumPer) as SumAll into #SelectAllPer 
	from #SelectAllPro sp 
	where exists 
	(
		select * from #pro '+@whereSql+'
	) group by SecondDeptName,SecondDeptCode;

	select sp.*,a.SumAll,@allSecondDeptInfo  as ff from #SelectAllPro sp inner join #SelectAllPer b on sp.SecondDeptCode=b.SecondDeptCode  
	inner join  #GroupBySecondDept a on  sp.SecondDeptCode=a.SecondDeptCode
	where exists 
		(
			select * from #pro '+@whereSql+'
		);'
	end      
else
	begin
	--set @SQL=@SQL+'select *,SUM(sumPer) over(partition by SecondDeptCode)as SumAll  from  #SelectAllPro ';
	set @SQL=@SQL+'select sp.*,a.SumAll,c.TotalCount,@allSecondDeptInfo  as ff from  #SelectAllPro  sp '+
					 ' inner join   #totalCount  c on  1=1 '+
					 ' inner join  #GroupBySecondDept  a on  sp.SecondDeptCode=a.SecondDeptCode '+
					 ' where exists   
					 (
						 select  *   from  	#GroupByProductNoDeptOfPaging  '+@whereSql+
					 ');'
end


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
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
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
								inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code
								where  convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),whd.YearMonth)+'01')<@endDate



--Exec Sp_ExecuteSql @SQL



drop table #temp_table;
drop table #tempProductInfo;
drop table #tempDeptInfo;
drop table #checkedProTable;
drop table #checkedDeptTable;
drop table #tempCheckedProductInfo;
drop table #tempCheckedDeptInfo;
drop table #GroupBySecondDept;
--drop table #totalCount 
--drop table #SelectAllPro;
--drop table #GroupByProductNoDept;
--drop table #GroupByProductNoDeptOfPaging;


