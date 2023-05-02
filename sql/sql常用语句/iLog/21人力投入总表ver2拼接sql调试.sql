declare  @startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(75),@IsPDT nvarchar(8),@UserId nvarchar(16),@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000),@pageIndex int,@pageCount int;
select @startDate='2020-01-01 00:00:00',@endDate='2020-01-31 00:00:00',@ProjectLevel=N'Normal',@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',@IsPDT=N'5,6,7,8,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=1,@sysDeptManager=1,@sysDeptSecretary=1,@projectCode=N'',@proTreeNode=N'',@deptTreeNode=N'',@rowID=N'',@pageIndex=1,@pageCount=15
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

	
--������ʱ�� ������ϸ��WorkHourDetail���л�������
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
--������ʱ���������û�ѡ�����Ŀ  
create table  #inputProTable
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


--�ж��Ƿ���ѡ���Ʒ��
if(@proTreeNode<>'')
		begin				
			--���û�ѡ��Ĳ�Ʒ�������ڱ���   �ֶ��������Ŀ����ֱ�Ӻ���ϸ������ж�
			insert  into   #checkedProTable  
			select tableColumn from F_SplitStrToTable(@proTreeNode);
		end
--�ж��Ƿ��ֶ���������Ŀ����  ���������� ��,Ϊ���
if(@projectCode<>'')
		begin
			insert  into   #inputProTable  
			select tableColumn from F_SplitStrToTable(@projectCode);
		end



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


--����ϸ�����ݲ�����ʱ��    ������Ҫ����startDate��endDate���ж�ȡ��ǰ��ѯ�ĸ��������
--@startDate,@endDate,@IsPDT,@UserId,@projectCode,@proTreeNode

--����ʱ��ȷ�����ĸ���
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

--�ж�PDT �ܱ�  ���
--PDT
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1and CHARINDEX('7', @IsPDT)<1 )
	begin
		SET @Condition = @Condition + ' where  IsPDT=1  and IsVendor=0 ';
	end
--�ܱ�
else if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)<1)
	begin
		SET @Condition = @Condition + ' where  IsPDT=0  and IsVendor=0 ';
	end
--���
else if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('7', @IsPDT)>0)
	begin
		SET @Condition = @Condition + ' where   IsVendor=1 ';
	end
--PDT �ܱ�
else if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)<1)
	begin
		SET @Condition = @Condition + ' where   IsVendor=0 ';
	end
--PDT ���
else if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('7', @IsPDT)>0)
	begin
		SET @Condition = @Condition + ' where  IsPDT=1  or IsVendor=1 ';
	end
--�ܱ�  ��� 
else if(CHARINDEX('5', @IsPDT)<1 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0)
	begin
		SET @Condition = @Condition + ' where  IsPDT=0  or IsVendor=1 ';
	end
--����ȫѡ ��ȫ��ѡ
else
	begin
		SET @Condition = @Condition + ' where  1=1 ';
	end

--��ͨ��ʱ��  PDT �ܱ�  ����  ɸѡ������ݲ���tempDetail����
EXEC sp_executesql @Condition; 

--select  *  from  #tempDetailTable

--set @Condition='';
----ֻ���ж��Ƿ���������Ŀ����
--if(@projectCode<>'')
--	begin
--		--���Կ�����Ʒ  ��������Ŀ����
--		set @Condition='  insert into #temp_table  
--									select  '+@rowName+' from  #tempDetailTable   a  
--									inner  join  #tempCheckedProductInfo  b  on  a.proCode=b.proCode  	
--									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code										   
--									where 1=1
--									And (ProductLineCode IN (SELECT * FROM #inputProTable) OR PDTCode IN (SELECT * FROM #inputProTable) OR BVersionCode IN (SELECT * FROM #inputProTable) OR SecondProCode IN(SELECT * FROM #inputProTable) OR ThirdProCode IN(SELECT * FROM #inputProTable) OR FourthProCode IN (SELECT * FROM #inputProTable)) 
--									and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')>='+@startDate+' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')<'+@endDate+'
--									union 
--									select  '+@rowName+' from  #tempDetailTable   a  
--									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code						   
--									where 1=1
--									And (ProductLineCode IN (SELECT * FROM #inputProTable) OR PDTCode IN (SELECT * FROM #inputProTable) OR BVersionCode IN (SELECT * FROM #inputProTable) OR SecondProCode IN(SELECT * FROM #inputProTable) OR ThirdProCode IN(SELECT * FROM #inputProTable) OR FourthProCode IN (SELECT * FROM #inputProTable)) 
--									and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')>='+@startDate+' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')<'+@endDate+''
--	end 
--else
--	begin
--	--���Կ�����Ʒ  δ������Ŀ����
--		set @Condition=' insert into #temp_table  (
--									select  '+@rowName+' from  #tempDetailTable   a  
--									inner  join  #tempCheckedProductInfo  b  on  a.proCode=b.proCode  	
--									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code										   
--									where 1=1
--									and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')>='+@startDate+' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')<'+@endDate+'
--									union 
--									select  '+@rowName+' from  #tempDetailTable   a  
--									inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code						   
--									where 1=1
--									and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')>='+@startDate+' and convert(datetime,CONVERT(varchar(20),a.YearMonth)+''01'')<'+@endDate+') dsa'
--	end

		insert into #temp_table  
		select [ID]
      ,a.[ProCode]
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
	  ,[VendorCount] from  #tempDetailTable   a  
		inner  join  #tempCheckedProductInfo  b  on  a.proCode=b.proCode  	
		inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code										   
		where 1=1
		and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),a.YearMonth)+'01')<@endDate
		union 
		select  [ID]
      ,a.[ProCode]
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
	  ,[VendorCount] from  #tempDetailTable   a  
		inner join  #tempDeptInfo  c  on  a.DeptCode=c.Dept_Code						   
		where 1=1
		and  	convert(datetime,CONVERT(varchar(20),a.YearMonth)+'01')>=@startDate and convert(datetime,CONVERT(varchar(20),a.YearMonth)+'01')<@endDate
	

 


--select @Condition;



--EXEC sp_executesql @Condition; 
select  * from #temp_table;

set @sql='select '+@GroupBySql+
	',SUM(a.PDTCount) as PDT
	,SUM(a.RoundCount) as ZB
	,SUM(a.VendorCount) as WB
	,Sum(a.PDTCount+a.RoundCount+a.VendorCount) as SAPALL
	,Sum(a.PDTCount+a.RoundCount) as SAP
from  #temp_table a 
Group  by '+@GroupBySql;


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
	--SELECT @SQL;
/****************�������ϼ�start**************************/
drop table #temp_table;
drop table #tempProductInfo;
drop table #tempDeptInfo;
drop table #tempCheckedProductInfo;
drop table #checkedProTable;
drop table #tempDetailTable;
drop table #inputProTable;