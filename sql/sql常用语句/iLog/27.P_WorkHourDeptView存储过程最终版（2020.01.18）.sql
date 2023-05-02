USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_WorkHourDeptView]    Script Date: 2020/1/18 13:52:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









-- =============================================
-- Author:	cm
-- =============================================
ALTER  PROCEDURE [dbo].[P_WorkHourDeptView]
@startDate DATETIME,--Mon_Dateʱ�����俪ʼ
@endDate DATETIME,--Mon_Dateʱ���������
@ProjectLevel VARCHAR(50), --��Ŀ�㼶  2�Ƕ�����Ŀ 3��������Ŀ  4���ļ���Ŀ ''��PDT����Ŀ  else Ϊ9���뿪ͷ�İ汾
@GroupBySql varchar(200),--�����sql���
@whereSql varchar(500),  --ɸѡ����  �����ڵ�����ʱ��  ɸѡ����
@GroupByProductNoDeptSql varchar(200),--��ҳ�� ֻ���ݲ�Ʒ����
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
@SelRowID varchar(max),--rowIDѡ�� Ӧ���ڵ�����ѡ
@pageIndex int,  --��ǰҳ��
@pageCount  int  --��ҳ����
AS
    BEGIN
	declare @SQL nvarchar(max);
	DECLARE @tempMonth  datetime;
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
--������ʱ���������û�ѡ��Ĳ���
create table  #inputProjectTable
(
	inputProCode  varchar(100)
);
--������  ������ĿȨ�ޱ����ѡ����Ŀjoin֮�������
create table #tempCheckedProductInfo
(
	Pro_Code varchar(100)
);
--������  ���沿��Ȩ�ޱ����ѡ����join֮�������
create table #tempCheckedDeptInfo
(
	Dept_Code varchar(100)
);
--����������
create table #totalCount
(	
	TotalCount  int
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
DECLARE @Split_proTreeCode NVARCHAR(MAX);
set @Split_proTreeCode='';
DECLARE @Split_deptCode NVARCHAR(MAX);
set @Split_deptCode='';
--���û�ѡ��Ĳ�Ʒ�����ֶ���д�Ĳ��ű���ϲ�
if(@proTreeNode<>'')
	begin
		insert  into   #checkedProTable  
		select tableColumn from F_SplitStrToTable(@proTreeNode);
	end

if(@deptTreeNode<>'')
	begin
		insert  into   #checkedDeptTable  
		select tableColumn from F_SplitStrToTable(@deptTreeNode);
	end
if(@projectCode<>'')
	begin
		insert  into   #inputProjectTable
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

--�ж��û��Ƿ��Ѿ�ѡ���˶�������
if((select top 1 *  from #checkedDeptTable)!='')
	begin
		--�û�ѡ��Ĳ��ź����еĲ���Ȩ�� join
		insert INTO #tempCheckedDeptInfo
		SELECT a.DeptCode  FROM #checkedDeptTable  a  join #tempDeptInfo  b  on  a.DeptCode=b.Dept_Code ;
	end
else
	begin
		--ֱ�ӽ�����Ȩ�޲�����ʱ��
		insert INTO #tempCheckedDeptInfo
		SELECT a.Dept_Code  FROM #tempDeptInfo  a
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
				if((select top 1 *  from #tempCheckedDeptInfo)!='')
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
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
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
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								set @insertTempSql=@insertTempSql+' union ';

								--��ѯ��ʽ��
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  >=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
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
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';

								--ͨ������Ȩ��ɸѡ��ƷȨ��
								set @insertTempSql=@insertTempSql+' union ';
								--ProductLineCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
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
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
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
				if((select top 1 *  from #tempCheckedDeptInfo)!='')
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
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
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
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' and whdh.FourthProCode in(select * from #inputProjectTable)  ';

								set @insertTempSql=@insertTempSql+' union ';

								--��ѯ��ʽ��
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
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
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ProductLineCode in(select * from #inputProjectTable) ';
								set @insertTempSql=@insertTempSql+' union ';
								--PDTCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.PDTCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--BVersionCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd     ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.BVersionCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--SecondProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.SecondProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--ThirdProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.ThirdProCode in(select * from #inputProjectTable)  ';
								set @insertTempSql=@insertTempSql+' union ';
								--FourthProCode
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' and whd.FourthProCode in(select * from #inputProjectTable)  ';
							end
					end
			end
	end
else
	begin
		if((select top 1 *  from #tempCheckedProductInfo)!='')
			begin
				if((select top  1 *  from  #tempCheckedDeptInfo)!='')
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   inner join  #tempCheckedProductInfo  a   on  whdh.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >=  '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 

							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.Pro_Code ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
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
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd   inner join  #tempCheckedProductInfo  a   on  whd.ProCode=a.ProCode ';
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
				if((select top  1 *  from  #tempCheckedDeptInfo)!='')
					begin
						if(DATEDIFF(MONTH,@tempMonth,@endDate)<=0)
							begin
								--ֻ��ѯ��ʷ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh   ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
						else if(DATEDIFF(MONTH,@tempMonth,@endDate)>0  and  DATEDIFF(MONTH,@tempMonth,@startDate)<=0)
							begin
								--��ѯ��ʷ��͵�ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetailHistory  whdh    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whdh.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whdh.YearMonth  >= '+ CONVERT(VARCHAR(6), @startDate, 112) 
								set @insertTempSql=@insertTempSql+' union';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  <=  '+ CONVERT(VARCHAR(6), @endDate, 112) 
							end
						else
							begin
								--��ѯ��ǰ��
								set @insertTempSql=' insert into #temp_table ';
								set @insertTempSql=@insertTempSql+' select     '+@rowName;
								set @insertTempSql=@insertTempSql+' from  WorkHourDetail  whd    ';
								set @insertTempSql=@insertTempSql+' inner join  #tempCheckedDeptInfo  b  on  whd.DeptCode=b.Dept_Code  ';
								set @insertTempSql=@insertTempSql+' where  whd.YearMonth  between  '+ CONVERT(VARCHAR(6), @startDate, 112) + ' and '+ CONVERT(VARCHAR(6), @endDate, 112);
							end
					end
			end
	end


exec  sp_executesql  @insertTempSql;



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
		set @contion='where RowID  in ('+@Split_RowID+')';
end

	

/****************�������ϼ�start**************************/
set @SQL='
	select ISNULL( ROW_NUMBER() OVER(ORDER BY '+@GroupByProductNoDeptSql+'),0) rowID,sum(Percents)as sumPer, '
	+@GroupBySql+' into #SelectAllPro from #temp_table
	where SecondDeptCode is not null and SecondDeptCode<>''''  
	group by '+@GroupBySql+' ; ';



set @SQL=@SQL+'select ISNULL( ROW_NUMBER() OVER(ORDER BY '+@GroupByProductNoDeptSql+'),0) rowID,'+@GroupByProductNoDeptSql+
				'  into   #GroupByProductNoDept  from  #SelectAllPro   '+
				'  group by '+@GroupByProductNoDeptSql+' ; ';

set @SQL=@SQL+' select  *  into   #GroupByProductNoDeptOfPaging  from #GroupByProductNoDept  '+
				'where  rowId  between  ' + CAST(( ( @pageIndex - 1 ) * @pageCount + 1) AS VARCHAR(20))+ 
				' and ' + CAST(@pageIndex * @pageCount AS VARCHAR(20));

set @SQL=@SQL+' ;select Count(1) as totalCount  into #totalCount  from  #GroupByProductNoDept;';





set @SQL=@SQL+' select SecondDeptName,SecondDeptCode,SUM(Percents) as SumAll  into #GroupBySecondDept  from #temp_Table    group  by  SecondDeptName,SecondDeptCode; ';

if(@contion<>'')
	begin
	set @sql=@sql+'select '+@GroupBySql+' into #pro from #SelectAllPro '+isnull(@contion,'')+';
	select SecondDeptName,SecondDeptCode,SUM(sumPer) as SumAll into #SelectAllPer 
	from #SelectAllPro sp 
	where exists 
	(
		select * from #pro '+@whereSql+'
	) group by SecondDeptName,SecondDeptCode;'

	set @SQL=@SQL+' declare @allSecondDeptInfo varchar(1000);
						select @allSecondDeptInfo='''';
						select  @allSecondDeptInfo=STUFF((select  '',''+sp.SecondDeptName+''-'' +convert(varchar(10),SUM(sumPer))   from #SelectAllPro  sp  
						where exists 
						(
							select * from #pro  '+@whereSql+'
						)	and  SecondDeptName!=''''  and  SecondDeptName is not null  group  by sp.SecondDeptName    FOR XML PATH('''')),1, 1, ''''); ';		

	set @sql=@sql+'select sp.*,a.SumAll,@allSecondDeptInfo  as AllSecondDeptInfo  from #SelectAllPro sp inner join #SelectAllPer b on sp.SecondDeptCode=b.SecondDeptCode  
	inner join  #GroupBySecondDept a on  sp.SecondDeptCode=a.SecondDeptCode
	where exists 
		( 
			select * from #pro '+@whereSql+
		');'
	end      
else
	begin
	--set @SQL=@SQL+'select *,SUM(sumPer) over(partition by SecondDeptCode)as SumAll  from  #SelectAllPro ';

	set @SQL=@SQL+' declare @allSecondDeptInfo varchar(1000);
						select @allSecondDeptInfo='''';
						select  @allSecondDeptInfo=STUFF((select  '',''+sp.SecondDeptName+''-'' +convert(varchar(10),SUM(sumPer))   from #SelectAllPro  sp  where  SecondDeptName!=''''  and  SecondDeptName is not null  group  by sp.SecondDeptName    FOR XML PATH('''')),1, 1, ''''); ';		

	set @SQL=@SQL+'select sp.*,a.SumAll,c.TotalCount,@allSecondDeptInfo  as AllSecondDeptInfo from  #SelectAllPro  sp '+
					 ' inner join   #totalCount  c on  1=1 '+
					 ' inner join  #GroupBySecondDept a on  sp.SecondDeptCode=a.SecondDeptCode '+
					 ' where exists   (select  *   from  	#GroupByProductNoDeptOfPaging  '+@whereSql+');'
end





Exec Sp_ExecuteSql @SQL
--select @SQL;


drop table #temp_table;
drop table #tempProductInfo;
drop table #tempDeptInfo;
drop table #checkedProTable;
drop table #checkedDeptTable;
drop table #tempCheckedProductInfo;
drop table #tempCheckedDeptInfo;
--drop table #GroupBySecondDept;
--drop table #totalCount 
--drop table #SelectAllPro;
--drop table #GroupByProductNoDept;
--drop table #GroupByProductNoDeptOfPaging;
END









GO


