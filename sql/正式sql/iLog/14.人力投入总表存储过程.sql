USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_WorkHourSummaryView]    Script Date: 2020/4/13 15:20:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















	


-- =============================================
-- Author:		��ʱͶ�������ܱ�  by lys0670 
-- =============================================
ALTER PROCEDURE [dbo].[P_WorkHourSummaryView]

@startDate DATETIME,--Mon_Dateʱ�����俪ʼ
@endDate DATETIME,--Mon_Dateʱ���������
@ProjectLevel VARCHAR(50), --��Ŀ�㼶  2�Ƕ�����Ŀ 3��������Ŀ  4���ļ���Ŀ ''��PDT����Ŀ  else Ϊ9���뿪ͷ�İ汾
@GroupBySql varchar(200),--�����sql���
@IsPDT varchar(50),--@IsPDT 5��PDT���� 6���ܱ�����  7���������	
@UserId varchar(50),--�û����  ��:liucaixuan 03806
@SysRole int, --�Ƿ�Ϊ����Ա 0�������Ա  1�ǹ���Ա
@SysProjectManager  int,--�Ƿ�Ϊ��Ŀ����  0�����  1������
@SysPoP int,--�Ƿ�ΪPOP  0�����  1������
@SysDeptManager  int,--�Ƿ�Ϊ��������  0����� 1������
@SysDeptSecretary  int,--�Ƿ�Ϊ��������  0�����  1������
@projectCode VARCHAR(MAX),
@proTreeNode VARCHAR(MAX),
@deptTreeNode VARCHAR(MAX),
@RowID varchar(max), --rowIDѡ�� Ӧ���ڵ�����ѡ
@pageIndex int,
@pageCount int
AS
	--����˼·  
	--�ǹ���Ա�Ȳ�ѯȨ�ޣ���ĿȨ�޺Ͳ���Ȩ�ޣ� ����ɸѡ
	--Ȼ���ڸ���ҳ��ѡ�������  join���ж���ɸѡ
	--����ɸѡ�����ʱ�����ϸ�� join  �����������ݱ�  
    BEGIN
	DECLARE @tempMonth  datetime;
	DECLARE @Condition NVARCHAR(MAX);
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @rowName varchar(1000);
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
	Pro_Code varchar(100)
);
--������ʱ���������û�ѡ�����Ŀ  
create table  #checkedProTable
(
	ProCode  varchar(100)
);

create table  #inputProjectTable
(
	inputProCode  varchar(100)
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
				SELECT ProCode  FROM pro
				union
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
				SELECT ProCode  FROM pro
				union
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
				SELECT DeptCode  FROM dept
				union
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
				SELECT DeptCode  FROM dept
				union
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
DECLARE @Split_proTreeCode NVARCHAR(MAX);
set @Split_proTreeCode='';
--���û�ѡ��Ĳ�Ʒ�����ֶ���д�Ĳ��ű���ϲ�
if(@projectCode<>'')
		begin
			insert  into   #inputProjectTable  
			select tableColumn from F_SplitStrToTable(@projectCode);
		end
if(@proTreeNode<>'')
		begin
			insert  into   #checkedProTable  
			select tableColumn from F_SplitStrToTable(@proTreeNode);
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
set @tempMonth=DATEADD(MONTH,-2,GETDATE());
DECLARE   @insertTempSql  nvarchar(max);
set @insertTempSql='';

if(@projectCode<>'')
	begin	
		if((select top 1 *  from #tempCheckedProductInfo)!='')
			begin
				if((select top 1 *  from #tempDeptInfo)!='')
					begin
						--�в�ƷȨ�� �в���Ȩ��
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								set @insertTempSql=@insertTempSql+' union ';

								--��ѯ��ʽ��
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';
							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';

							end
					end
				else
					begin
						--�в�ƷȨ��  û�в���Ȩ��
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								set @insertTempSql=@insertTempSql+' union ';

								--��ѯ��ʽ��
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';
							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';

							end
					end
			end
		else 
			begin
				if((select top 1 *  from #tempDeptInfo)!='')
					begin
						--û��ƷȨ�� �в���Ȩ��
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								set @insertTempSql=@insertTempSql+' union ';

								--��ѯ��ʽ��
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';
							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table '
								--����#tempCheckedProductInfo
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd     ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';
							end
					end
			end
	end
else if(@proTreeNode<>'')
		begin
			if((select top 1 *  from #tempCheckedProductInfo)!='')
				begin
					if((select top  1 *  from  #tempDeptInfo)!='')
						begin
							if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
								begin
									--ֻ��ѯ��ʷ��
									print('History');
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								end
							else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
								begin
									--��ѯ��ʷ��͵�ǰ��
									print('Union');
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 

								end
							else
								begin
									--��ѯ��ǰ��
									print('Current');
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								end
						end
					else 
						begin
							if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
								begin
									--ֻ��ѯ��ʷ��
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								end
							else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
								begin
									--��ѯ��ʷ��͵�ǰ��
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) ;
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112); 

								end
							else
								begin
									--��ѯ��ǰ��
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								end
						end
				end
			else 
				begin
					if((select top  1 *  from  #tempDeptInfo)!='')
						begin
							if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
								begin
									--ֻ��ѯ��ʷ��
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								end
							else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
								begin
									--��ѯ��ʷ��͵�ǰ��
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >= '+ CONVERT(VARCHAR(6), @startDate, 112) 
									set @insertTempSql=@insertTempSql+' union';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								end
							else
								begin
									--��ѯ��ǰ��
									set @insertTempSql=' insert into #temp_table ';
									set @insertTempSql=@insertTempSql+' select     '+@rowName;
									set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
									set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
									set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								end
						end
				end
	end
else 
	begin
		if((select top 1 *  from #tempCheckedProductInfo)!='')
			begin
				if((select top  1 *  from  #tempDeptInfo)!='')
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								print('History');
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								--set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								print('Union');
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								--set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								--set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 

							end
						else
							begin
								--��ѯ��ǰ��
								print('Current');
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								--set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
					end
				else 
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) ;
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112); 

							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
					end
			end
		else 
			begin
				if((select top  1 *  from  #tempDeptInfo)!='')
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >= '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
					end
			end
	end

--print @insertTempSql;
exec  sp_executesql  @insertTempSql;


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
	union 
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
	union 
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
	SELECT @SAPAll=sum(SAPAll) FROM #SelectAllPro'+' where RowID  in ('+@Split_RowID+');'+'
	SELECT @SAP=sum(SAP) FROM #SelectAllPro'+' where RowID  in ('+@Split_RowID+');'+'
	SELECT @PDT=sum(PDT) FROM #SelectAllPro'+' where RowID  in ('+@Split_RowID+');'+'
	SELECT @ZB=sum(ZB) FROM #SelectAllPro'+' where RowID  in ('+@Split_RowID+');'+'
	SELECT @WB=sum(WB) FROM #SelectAllPro'+' where RowID  in ('+@Split_RowID+');'+'
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

--select  *  from  #tempCheckedProductInfo;
--select  *  from  #temp_table;
Exec Sp_ExecuteSql @sql;
--SELECT @SQL;

/****************�������ϼ�start**************************/
drop table #temp_table;
drop table #tempProductInfo;
drop table #tempDeptInfo;
drop table #tempCheckedProductInfo;
drop table #checkedProTable;
	END

















GO


