declare @startDate DATETIME;--Mon_Dateʱ�����俪ʼ
declare @endDate DATETIME;--Mon_Dateʱ���������
declare @ProjectLevel VARCHAR(50); --��Ŀ�㼶  2�Ƕ�����Ŀ 3��������Ŀ  4���ļ���Ŀ ''��PDT����Ŀ  else Ϊ9���뿪ͷ�İ汾
declare @GroupBySql varchar(200);--�����sql���
declare @IsPDT varchar(50);--@IsPDT 5��PDT���� 6���ܱ�����  7���������	
declare @UserId varchar(50);--�û����  ��:liucaixuan 03806
declare @SysRole int; --�Ƿ�Ϊ����Ա 0�������Ա  1�ǹ���Ա
declare @SysProjectManager  int;--�Ƿ�Ϊ��Ŀ����  0�����  1������
declare @SysPoP int;--�Ƿ�ΪPOP  0�����  1������
declare @SysDeptManager  int;--�Ƿ�Ϊ��������  0����� 1������
declare @SysDeptSecretary  int;--�Ƿ�Ϊ��������  0�����  1������
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
	--����˼·  
	--�ǹ���Ա�Ȳ�ѯȨ�ޣ���ĿȨ�޺Ͳ���Ȩ�ޣ� ����ɸѡ
	--Ȼ���ڸ���ҳ��ѡ�������  join���ж���ɸѡ
	--����ɸѡ�����ʱ�����ϸ�� join  �����������ݱ�  
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

insert INTO #tempProductInfo
SELECT ProCode  FROM ProductInfo  where DeleteFlag!=1; 
--��������Ϣȫ��������ʱ��
insert INTO #tempDeptInfo
SELECT DeptCode  FROM Department  where DeleteFlag!=1; 

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

--���û�ѡ��Ĳ�Ʒ�����ֶ���д�Ĳ��ű��뱣���ڱ���
insert  into   #checkedProTable  
select tableColumn from F_SplitStrToTable(@Split_projectCode);
--�����û�ѡ��Ĳ��ű���ݹ������ӽڵ�
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

--��ѡ����Ŀ�ڵ�ݹ�  Ȼ���Ȩ��join֮�󱣴浽#tempCheckedProductInfo��ʱ��


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

