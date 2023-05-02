USE [PersonalInputTest]
GO

/****** Object:  StoredProcedure [dbo].[P_WorkHourSummaryView]    Script Date: 2019/12/23 10:38:13 ******/
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
@IsPDT varchar(50),--@IsPDT 5��PDT���� 6���ܱ�����  7���������	
@UserId varchar(50),--�û����  ��:liucaixuan 03806
@SysRole int, --�û���ɫ 0�������Ա  1�ǹ���Ա
@projectCode VARCHAR(MAX),
@station VARCHAR(50),
@proTreeNode VARCHAR(MAX),
@deptTreeNode VARCHAR(MAX),
@RowID varchar(max), --rowIDѡ�� Ӧ���ڵ�����ѡ

--��ת���Ӵ�����������
@IsLinkType varchar(100),
@ProductLineCode varchar(100),
@PDTCode varchar(100),
@FirstProCode varchar(100),
@SecondProCode varchar(100),
@ThirdProCode varchar(100),
@FourthProCode varchar(100),
@Mon_date varchar(100),
@SecondDeptName varchar(100)
AS
    BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	--set @RowID='';
--������ʱ�� ������ϸ���������

	create table #temp_table
(
				Row_ID int ,  --Row_ID ������
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

	  
	
	  insert into #temp_table (Row_ID,SecondDeptName,DName,UserName,UserCode,mon_date,ProductLineName,PDTName,PDTCode,FirstProCode,FirstProName,SecondProCode,SecondProName,Station,StationName,
			sumPer,sumMon,ispdt,DeptCode,SecondDeptCode,ProductLineCode,ThirdProName,ThirdProCode,FourthProName,FourthProCode,PCodeShare,FirstProCodeShare,SecondProCodeShare,ThirdProCodeShare,FourthProCodeShare,StationNameShow,SumAll,Counts) EXEC [dbo].[P_WorkHourDetailView] 0,0, @startDate,@endDate,@ProjectLevel,@IsPDT,@UserId,@SysRole,'','',@projectCode,@station,@proTreeNode,@deptTreeNode,'','false','','','','','','','','';



--����PDT����
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1and CHARINDEX('7', @IsPDT)<1 )
begin
set @SQL='select ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode,sumPer),0) rowID,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName,Convert(float,isnull(PDT.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,0) ZB,Convert(float,0) WB from (
select sum(sumPer/sumMon) as sumPer, ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
from #temp_table 
where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
) PDT
'
end

--�����ܱ�����
if(CHARINDEX('6', @IsPDT)>0 and CHARINDEX('5', @IsPDT)<1 and CHARINDEX('7', @IsPDT)<1)
begin
set @SQL='
select ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode,sumPer),0) rowID,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName,Convert(float,isnull(ZB.sumPer,0)) SAPAll,Convert(float,isnull(ZB.sumPer,0)) SAP,Convert(float,0) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,0) WB from (
select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
from #temp_table 
where ispdt=1 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
) ZB
'
End

--�����������
if(CHARINDEX('7', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1 and CHARINDEX('5', @IsPDT)<1)
begin
set @SQL='
select ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode,sumPer),0) rowID,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName,Convert(float,isnull(WB.sumPer,0)) SAPAll,Convert(float,0) SAP,Convert(float,0) PDT,Convert(float,0) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
from #temp_table 
where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
) WB
'
End

--����PDT�������ܱ�����
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)<1)
begin
if(@ProjectLevel='2')--����
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,0) WB from (
		select sum(sumPer/sumMon) sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode
		'
	end

else if(@ProjectLevel='3')--����
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,0) WB from (
		select sum(sumPer/sumMon) sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode and SAPALL.ThirdProCode=PDT.ThirdProCode 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode and SAPALL.ThirdProCode=ZB.ThirdProCode 
		'
	end

else if(@ProjectLevel='4')--�ļ�
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,0) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode and SAPALL.ThirdProCode=PDT.ThirdProCode and SAPALL.FourthProCode=PDT.FourthProCode 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode and SAPALL.ThirdProCode=ZB.ThirdProCode and SAPALL.FourthProCode=ZB.FourthProCode 
		'
	end

else if(@ProjectLevel='')--PDT��
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,0) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode 
		'
	end

else 
	 begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,0) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode 
		'
	end
end

--����PDT�������������
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0 and CHARINDEX('6', @IsPDT)<1)
begin
if(@ProjectLevel='2')--����
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(WB.sumPer,0)) WB,Convert(float,0) ZB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode
		'
	end

else if(@ProjectLevel='3')--����
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(WB.sumPer,0)) WB,Convert(float,0) ZB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode  and SAPALL.SecondProCode=PDT.SecondProCode  and SAPALL.ThirdProCode=PDT.ThirdProCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode and SAPALL.ThirdProCode=WB.ThirdProCode 
		'
	end

else if(@ProjectLevel='4')--�ļ�
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(WB.sumPer,0)) WB,Convert(float,0) ZB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode and SAPALL.ThirdProCode=PDT.ThirdProCode and SAPALL.FourthProCode=PDT.FourthProCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode and SAPALL.ThirdProCode=WB.ThirdProCode and SAPALL.FourthProCode=WB.FourthProCode 
		'
	end

else if(@ProjectLevel='')--PDT��
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(WB.sumPer,0)) WB,Convert(float,0) ZB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=ZB.ProductLineCode  and SAPALL.PDTCode=WB.PDTCode 
		'
	end

else
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(PDT.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(WB.sumPer,0)) WB,Convert(float,0) ZB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table where ispdt=0 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode  and SAPALL.FirstProCode=WB.FirstProCode 
		'
	end
end


--�ܱ��������������
if(CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0 and CHARINDEX('5', @IsPDT)<1)
begin
	if(@ProjectLevel='2')--����
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(WB.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,0+isnull(ZB.sumPer,0)) SAP,Convert(float,0) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode
		'
	end

else if(@ProjectLevel='3')--����
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(WB.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,0+isnull(ZB.sumPer,0)) SAP,Convert(float,0) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode and SAPALL.ThirdProCode=ZB.ThirdProCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode and SAPALL.ThirdProCode=WB.ThirdProCode 
		'
	end

else if(@ProjectLevel='4')--�ļ�
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(WB.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,0+isnull(ZB.sumPer,0)) SAP,Convert(float,0) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode and SAPALL.ThirdProCode=ZB.ThirdProCode and SAPALL.FourthProCode=ZB.FourthProCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode and SAPALL.ThirdProCode=WB.ThirdProCode and SAPALL.FourthProCode=WB.FourthProCode 
		'
	end

else if(@ProjectLevel='')--PDT��
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(WB.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,0+isnull(ZB.sumPer,0)) SAP,Convert(float,0) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode
		 left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode 
		'
	end
else
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.PDTCode,SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.ProductLineCode,SAPALL.ProductLineName,SAPALL.PDTCode,SAPALL.PDTName,SAPALL.FirstProCode,SAPALL.FirstProName,SAPALL.SecondProCode,SAPALL.SecondProName,SAPALL.ThirdProCode,SAPALL.ThirdProName,SAPALL.FourthProCode,SAPALL.FourthProName,Convert(float,isnull(WB.sumPer,0)+isnull(ZB.sumPer,0)) SAPAll,Convert(float,0+isnull(ZB.sumPer,0)) SAP,Convert(float,0) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 or  (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.PDTCode=ZB.PDTCode
		 left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.PDTCode=WB.PDTCode 
		'

	end

end

--PDT�������ܱ��������������
if(CHARINDEX('5', @IsPDT)>0 and CHARINDEX('6', @IsPDT)>0 and CHARINDEX('7', @IsPDT)>0)
begin
	if(@ProjectLevel='2')
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.*,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName


		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode  and SAPALL.SecondProCode=ZB.SecondProCode
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode  and SAPALL.SecondProCode=WB.SecondProCode
		'
	end
else if(@ProjectLevel='3')
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.*,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode and SAPALL.ThirdProCode=PDT.ThirdProCode 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode and SAPALL.ThirdProCode=ZB.ThirdProCode
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode and SAPALL.ThirdProCode=WB.ThirdProCode
		'
	end
else if(@ProjectLevel='4')
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.*,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table  where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode and SAPALL.SecondProCode=PDT.SecondProCode and SAPALL.ThirdProCode=PDT.ThirdProCode and SAPALL.FourthProCode=PDT.FourthProCode 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode and SAPALL.SecondProCode=ZB.SecondProCode and SAPALL.ThirdProCode=ZB.ThirdProCode and SAPALL.FourthProCode=ZB.FourthProCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode and SAPALL.SecondProCode=WB.SecondProCode and SAPALL.ThirdProCode=WB.ThirdProCode and SAPALL.FourthProCode=WB.FourthProCode 
		'
	end
else if(@ProjectLevel='')
	begin 
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.*,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table  where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode 
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table  where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode 
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName from #temp_table where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode 
		'
	end
else 
	begin
		set @SQL='
		select ISNULL( ROW_NUMBER() OVER(ORDER BY SAPALL.FirstProCode,SAPALL.SecondProCode,SAPALL.ThirdProCode,SAPALL.FourthProCode,SAPALL.sumPer),0) rowID,SAPALL.*,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)+isnull(WB.sumPer,0)) SAPAll,Convert(float,isnull(PDT.sumPer,0)+isnull(ZB.sumPer,0)) SAP,Convert(float,isnull(PDT.sumPer,0)) PDT,Convert(float,isnull(ZB.sumPer,0)) ZB,Convert(float,isnull(WB.sumPer,0)) WB from (
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName
		) SAPALL left join (
		--PDT����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table  where ispdt=0 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) PDT on SAPALL.ProductLineCode=PDT.ProductLineCode and SAPALL.PDTCode=PDT.PDTCode and SAPALL.FirstProCode=PDT.FirstProCode
		left join (
		--�ܱ�����
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table where ispdt=1 and  (CHARINDEX(''KF'',UserCode)=0 and CHARINDEX(''YS'',UserCode)=0 and CHARINDEX(''WX'',UserCode)=0 and CHARINDEX(''FW'',UserCode)=0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) ZB on SAPALL.ProductLineCode=ZB.ProductLineCode and SAPALL.PDTCode=ZB.PDTCode and SAPALL.FirstProCode=ZB.FirstProCode
		left join (
		--�������
		select sum(sumPer/sumMon) as sumPer,ProductLineCode,ProductLineName,PDTCode,PDTName,FirstProCode,FirstProName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName 
		from #temp_table  where (CHARINDEX(''KF'',UserCode)>0 or CHARINDEX(''YS'',UserCode)>0 or CHARINDEX(''WX'',UserCode)>0 or CHARINDEX(''FW'',UserCode)>0)
		group by FirstProCode,FirstProName,PDTCode,PDTName,ProductLineCode,ProductLineName,SecondProCode,SecondProName,ThirdProCode,ThirdProName,FourthProCode,FourthProName

		) WB on SAPALL.ProductLineCode=WB.ProductLineCode and SAPALL.PDTCode=WB.PDTCode and SAPALL.FirstProCode=WB.FirstProCode
		'
	end
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
	set @SQL='select * from ('+@SQL+') a where RowID  in ('+@Split_RowID+')';
 --   set @SQL='select * from ('+@SQL+') a  ';
	end

	--������λ�� --select a.*,b.Name as StationNameShow into #SelectAllPro from ('+@SQL+') a left join StationCategory b on a.Station=b.Code
	set @SQL='DECLARE @SAPAll float;DECLARE @SAP float;DECLARE @PDT float;DECLARE @ZB float;DECLARE @WB float;
	select a.* into #SelectAllPro from ('+@SQL+') a 
	SELECT @SAPAll=sum(SAPAll) FROM #SelectAllPro;
	SELECT @SAP=sum(SAP) FROM #SelectAllPro;
	SELECT @PDT=sum(PDT) FROM #SelectAllPro;
	SELECT @ZB=sum(ZB) FROM #SelectAllPro;
	SELECT @WB=sum(WB) FROM #SelectAllPro;
	select *,@SAPAll SAPAllNew,@SAP SAPNew,@PDT PDTNew,@ZB ZBNew,@WB WBNew from #SelectAllPro --order by mon_date,SecondDeptCode,DeptCode';

    Exec Sp_ExecuteSql @SQL
	--SELECT @SQL;
/****************�������ϼ�start**************************/
drop table #temp_table;

	END


GO


