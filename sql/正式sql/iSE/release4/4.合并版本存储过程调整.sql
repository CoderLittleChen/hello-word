USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[P_MergeVersion]    Script Date: 2021/1/12 11:19:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:cys2689
-- Create date: 2020-12-06
-- Description:	�ϲ��汾
-- =============================================
ALTER procedure [dbo].[P_MergeVersion]
(
	--�����汾Code
	@tarVerCode  varchar(20),
	--ͬ���汾Code
	@srcVerCode  varchar(20)
)
as
begin
	IF OBJECT_ID('tempdb..#tarTable') IS NOT NULL DROP TABLE #tarTable;   
	create table #tarTable
	(
		 [dataSetID] int
		,[dataSrc] int
		,[srcID] nvarchar(50)
		,[srcPID] nvarchar(50)
		,[srcName] nvarchar(200)
		,[PDT_Code] nvarchar(50)
		,[ProductLine_Code] nvarchar(50)
		,[verType] int
		,[orderNo] int 
		,[IDLevel] int
		,[Status] int
		,[flag] int
		,[BLNumber] int
		,[show] int
		,[isSync] tinyint
		,[BaseVersionType] tinyint
		,[IsMerge] int
	)
	IF OBJECT_ID('tempdb..#srcTable') IS NOT NULL DROP TABLE #srcTable;   
	create table #srcTable
	(
		 [dataSetID] int
		,[dataSrc] int
		,[srcID] nvarchar(50)
		,[srcPID] nvarchar(50)
		,[srcName] nvarchar(200)
		,[PDT_Code] nvarchar(50)
		,[ProductLine_Code] nvarchar(50)
		,[verType] int
		,[orderNo] int 
		,[IDLevel] int
		,[Status] int
		,[flag] int
		,[BLNumber] int
		,[show] int
		,[isSync] tinyint
		,[BaseVersionType] tinyint
		,[IsMerge] int
	)
	IF OBJECT_ID('tempdb..#dataSetIdTable') IS NOT NULL DROP TABLE #dataSetIdTable;   
	create table #dataSetIdTable
	(
		 [dataSetID] int
		,[dataSrc] int
		,[srcID] nvarchar(50)
		,[srcPID] nvarchar(50)
		,[srcName] nvarchar(200)
		,[PDT_Code] nvarchar(50)
		,[ProductLine_Code] nvarchar(50)
		,[verType] int
		,[orderNo] int 
		,[IDLevel] int
		,[Status] int
		,[flag] int
		,[BLNumber] int
		,[show] int
		,[isSync] tinyint
		,[BaseVersionType] tinyint
		,[IsMerge] int
	)
	declare  @tempSrcVerCode  varchar(200);
	set @tempSrcVerCode='';
	declare  @tempTarVerCode  varchar(200);
	set @tempTarVerCode='';
	declare  @tempTarDataSetId  int;
	set @tempTarDataSetId=0;
	declare  @tempSrcDataSetId  int;
	set @tempSrcDataSetId=0;
	declare  @tempTarProductInfoId  uniqueidentifier;
	set @tempTarProductInfoId=NEWID();
	declare  @tempSrcProductInfoId  uniqueidentifier;
	set @tempSrcProductInfoId=NEWID();
	if(CHARINDEX('PR',@tarVerCode)>0)
		begin
			with temp1  as
			(
				select  *  from  specMS_SpecDataIDSet  where  srcID=@tarVerCode
				union  all
				select  a.*  from  specMS_SpecDataIDSet  a  inner join  temp1  b  on  a.srcPID=b.srcID
			)
			insert   into #tarTable 
			select  * from  temp1  a  where a.isSync=0  and ( IsMerge=0  or  IsMerge  is  null);

			with temp2  as
			(
				select  *  from  specMS_SpecDataIDSet  where  srcID=@srcVerCode
				union  all
				select  a.*  from  specMS_SpecDataIDSet  a  inner join  temp2  b  on  a.srcPID=b.srcID
			)
			insert   into #srcTable 
			select  * from  temp2  a  where a.isSync=1  and  (IsMerge=0  or  IsMerge is null);

		end
	else
		begin
			with temp3  as
			(
				select  *  from  specMS_SpecDataIDSet  where  srcID=(select  srcPid  from  specMS_SpecDataIDSet  where srcID=@tarVerCode)
				union  all
				select  a.*  from  specMS_SpecDataIDSet  a  inner join  temp3  b  on  a.srcPID=b.srcID
			)
			insert   into #tarTable 
			select  * from  temp3  a  where a.isSync=0  and   (IsMerge=0  or  IsMerge is null);

			with temp4  as
			(
				select  *  from  specMS_SpecDataIDSet  where  srcID=(select  srcPid  from  specMS_SpecDataIDSet  where srcID=@srcVerCode)
				union  all
				select  a.*  from  specMS_SpecDataIDSet  a  inner join  temp4  b  on  a.srcPID=b.srcID
			)
			insert   into #srcTable 
			select  * from  temp4  a  where a.isSync=1  and   (IsMerge=0  or  IsMerge is null);
		end
	declare   verCodeCursor   cursor  for  select  srcID  from #tarTable;
	declare @verCode  varchar(20);
	open verCodeCursor;
	fetch  next  from  verCodeCursor  into  @verCode;
	while @@FETCH_STATUS=0
		begin
			set @tempTarVerCode=@verCode;
			set @tempSrcVerCode=( select   srcId  from  #srcTable  where  srcName  in  (select  srcName  from  #tarTable  where  srcID=@verCode) );
			set @tempTarDataSetId=(select   dataSetID   from  specms_SpecDataIDSet   a   where  a.srcId=@tempTarVerCode);
			set @tempSrcDataSetId=(select   dataSetID   from  specms_SpecDataIDSet   a   where  a.srcId=@tempSrcVerCode);
			--set @tempTarProductInfoId=
			--ͬ��  ����  ����������ͬ���İ汾 ����ʾ
			--update  specms_SpecDataIDSet   set   isMerge=1  where srcId=@tempSrcVerCode;
			if @tempSrcVerCode<>@tempTarVerCode and @tempSrcVerCode<>'' and @tempTarVerCode<>''
				begin	
					--��ͬ���汾����Ϣ���µ������汾
					update  a  set  a.srcId=b.srcId,a.srcPID=b.srcPID,a.srcName=b.srcName,a.orderNo=b.orderNo,a.isSync=1,isMerge=1
					from  specms_SpecDataIDSet  a,specms_SpecDataIDSet b  where  a.srcId=@tempTarVerCode  and  b.srcId=@tempSrcVerCode;

					--����Sync_ProductInfo ������   ���������ȫһ��  ֱ��ͨ�������汾��codeɾ������
					--ֻ���ֶ�����R�汾  û���ֶ�����B�汾  ����R�汾����Ҫһ��  ����ϲ�
					--�����汾  ͬ���汾����R B�汾   ���Ұ汾����  �汾������ȫƥ��   ����ϲ�
					--1��
					if(CHARINDEX('PR',@tempTarVerCode)>0)
						if (not exists( select  1 from  specMS_SpecDataIDSet  where srcPID=@tempTarVerCode ))
							begin
								--����R�汾  ��B�汾
								set @tempTarProductInfoId=(select  ProductInfoID  from   Sync_ProductInfo  where  Release_Code=@tempTarVerCode);
								delete Sync_ProductInfo  where Release_Code=@tempTarVerCode;
							end
						else	
							begin
								
							end

					--delete Sync_ProductInfo  where Release_Code=@tempTarVerCode  or BVersionCode=@tempTarVerCode;			

					--����Ȩ��  ��ͬ���汾��Ӧ��dataSetId��Ϊ�����汾��dataSetId
					update  specMS_SpecPermission  set  dataSetID=@tempTarDataSetId    where   dataSetID=@tempSrcDataSetId;
					
					--���� dataSetId��ͬ���汾����ɾ������������һ��code��Ӧ�����汾
					delete  specms_SpecDataIDSet where   dataSetID=@tempSrcDataSetId;

					update  specMS_ChangeControl_Apply  set  releaseCode=@tempSrcVerCode  where  releaseCode=@tempTarVerCode;

					update  specMS_EntryDepend  set  sourverCode=@tempSrcVerCode  where  sourverCode=@tempTarVerCode;

					update  specMS_PredefineParam  set  verTreeCode=@tempSrcVerCode  where  verTreeCode=@tempTarVerCode;

					update  specMS_Read_Apply  set  releaseCode=@tempSrcVerCode  where  releaseCode=@tempTarVerCode;

					update  specMS_SpecEditor  set  verTreeCode=@tempSrcVerCode  where  verTreeCode=@tempTarVerCode;

					delete   specMs_SpecModuleBLRel   where  smid  in  (select  smId  from  specms_SpecModule   where verTreeCode=@tempSrcVerCode);
					delete   specMS_SpecModule  where   verTreeCode=@tempSrcVerCode;
					update  specMS_SpecModule  set  verTreeCode=@tempSrcVerCode  where  verTreeCode=@tempTarVerCode;

					delete   specMs_SpecBaseLine   where  blid  in  (select  blid  from  specMS_SpecList   where verTreeCode=@tempSrcVerCode);

					update  specMS_SpecList  set  verTreeCode=@tempSrcVerCode  where  verTreeCode=@tempTarVerCode;

					--��Ŀ������
					update  specMS_Deliverables  set  releaseCode=@tempSrcVerCode  where  releaseCode=@tempTarVerCode;
					--���������
					update  specMS_Character  set  releaseCode=@tempSrcVerCode  where  releaseCode=@tempTarVerCode;
				end
			

			fetch  next  from  verCodeCursor  into  @verCode;

		end
	close verCodeCursor;
	deallocate verCodeCursor;

	drop table #tarTable;
	drop table #srcTable;
	drop table #dataSetIdTable;
end
GO


