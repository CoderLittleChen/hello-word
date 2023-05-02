USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[BatchSpecListExtColData_Edit]    Script Date: 2020-11-25 19:51:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



Alter PROCEDURE [dbo].[BatchSpecListExtColData_Edit]
    @StrBlEntryIDs VARCHAR(max) ,
    @ImplCase INT ,
    @supCase INT ,
    @virtualSpec INT ,
    @version VARCHAR(2000) ,
    @explian VARCHAR(2000) ,
    @explianType INT ,
    @blId INT ,
    @cBlId INT ,
    @extColId INT 
AS

BEGIN
	IF OBJECT_ID('tempdb..#extData') IS NOT NULL DROP TABLE #extData;    
	CREATE TABLE #extData( extDataID INT,blEntryID INT,srcblID INT,srcTecID INT,flag INT);

	set @StrBlEntryIDs = replace(@StrBlEntryIDs,'''','');

	DECLARE @insertsql varchar(max)
	
	SET @insertsql = 'INSERT INTO #extData(extDataID,blEntryID,srcblID,srcTecID,flag) SELECT extDataID,extColData.blEntryID,srcblID,srcTecID,0 FROM specMS_SpecListExtColData  extColData
	left join specMS_SpecBLEntryRel  rel on  rel.blEntryId=extColData.blEntryId
	WHERE  rel.isLeaf=0  and extColData.blEntryID in('+@StrBlEntryIDs+') and extColData.blID='+CAST(@blId AS VARCHAR(100))+' and tecID='+CAST(@extColId AS VARCHAR(100))+' and [status]>-2';

	SET @insertsql = 'INSERT INTO #extData(extDataID,blEntryID,srcblID,srcTecID,flag) SELECT extDataID,extColData.blEntryID,srcblID,srcTecID,0 FROM specMS_SpecListExtColData  extColData
	WHERE   extColData.blEntryID in('+@StrBlEntryIDs+') and extColData.blID='+CAST(@blId AS VARCHAR(100))+' and tecID='+CAST(@extColId AS VARCHAR(100))+' and [status]>-2';

	select  * from  #extData;
	return;

	EXEC(@insertsql);

	--DECLARE extDataBlEntryID_cursor CURSOR FOR SELECT blEntryID FROM #extData
	--OPEN extDataBlEntryID_cursor
	--	FETCH NEXT FROM extDataBlEntryID_cursor INTO @blentryID;
	--	WHILE @@fetch_status=0           --判断是否成功获取数据
	--	BEGIN

	--		SELECT @Count1=count(*) FROM specMS_SpecBLEntryRel WHERE blEntryID = @blentryID
	--		IF (@Count1 = 0)
	--			BEGIN
	--				FETCH NEXT FROM extDataBlEntryID_cursor INTO @blentryID;
	--				CONTINUE;
	--			END

	--		SELECT @Count2=count(*) FROM specMS_SpecListExtColData WHERE 
 --                   blEntryID=@blentryID and blID=@blId and tecID=@extColId and [status]>-2
	--		IF (@Count2 = 0)
	--			BEGIN
	--				FETCH NEXT FROM extDataBlEntryID_cursor INTO @blentryID;
	--				CONTINUE;
	--			END

	--		SELECT @relModelBlid=blID FROM specMS_SpecBLEntryRel WHERE blEntryID = @blentryID
	--		IF (@relModelBlid = @cBlId)
 --               UPDATE #extData SET flag=1 WHERE blEntryID = @blentryID
	--		ELSE
	--			BEGIN
	--				SELECT @Srcblid=srcblID,@SrcTecid=srcTecID,@SupCase1=supCase,@ImplCase1=implCase FROM specMS_SpecListExtColData WHERE 
	--				blEntryID=@blentryID and blID=@blId and tecID=@extColId and [status]>-2

	--				SELECT @COUNT3 = COUNT(*) FROM specMS_SpecListExtColData WHERE 
	--				blEntryID=@blentryID and blID=@blId and tecID=@extColId and [status]>-2

	--				IF(@COUNT3 >0)
	--					BEGIN
	--						IF(@SupCase1 <0)
	--							SET @lastSupCase=1;
	--						ELSE
	--							SET @lastSupCase = @SupCase1;
	--						IF(@supCase <= @lastSupCase AND @ImplCase >= @ImplCase1)
	--							UPDATE #extData SET flag=1 WHERE blEntryID = @blentryID
	--						ELSE
	--							UPDATE #extData SET flag=0 WHERE blEntryID = @blentryID
	--					END
	--			END
	--		FETCH NEXT FROM extDataBlEntryID_cursor INTO @blentryID;
	--	END
	
	DECLARE @UpdateSql1 nvarchar(max)
	DECLARE @UpdateSql2 nvarchar(max)
	DECLARE @UpdateSql3 nvarchar(max)
	DECLARE @UpdateSql4 nvarchar(max)
	DECLARE @UpdateSql5 nvarchar(max)

	SET @UpdateSql1 = 'UPDATE #extData SET flag=1 WHERE blEntryID IN(SELECT blEntryID FROM specMS_SpecBLEntryRel WHERE blEntryID IN ('+@StrBlEntryIDs+')  and isLeaf=0 AND blID = '+CAST(@cBlId AS VARCHAR(100))+')';
	
	SET @UpdateSql2 = 'UPDATE #extData SET flag=1 WHERE blEntryID IN( 
		SELECT blEntryID FROM specMS_SpecListExtColData WHERE 
			blEntryID IN (select blEntryID from #extData) and 
			blID in(select srcblID from #extData) and 
			tecID in(select srcTecID from #extData) and 
			[status]>-2 AND  
			supCase<0 AND '+CAST(@supCase AS VARCHAR(100))+' <= 1 AND '+CAST(@ImplCase AS VARCHAR(100))+' >= ImplCase)';

	SET @UpdateSql3 = 'UPDATE #extData SET flag=1 WHERE blEntryID IN( 
		SELECT blEntryID FROM specMS_SpecListExtColData WHERE 
			blEntryID IN (select blEntryID from #extData) and 
			blID in(select srcblID from #extData) and 
			tecID in(select srcTecID from #extData) and 
			[status]>-2 AND 
			supCase>=0 AND '+CAST(@supCase AS VARCHAR(100))+' <= supCase AND '+CAST(@ImplCase AS VARCHAR(100))+' >= ImplCase)';

	EXEC(@UpdateSql1)
	EXEC(@UpdateSql2)
	EXEC(@UpdateSql3)
	EXEC(@UpdateSql4)
	EXEC(@UpdateSql5)

	select * from #extData

--当flag为1
	--status = -1
		IF (@virtualSpec != -1)
			UPDATE specMS_SpecListExtColData SET virtualSpec = @virtualSpec WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1;
		IF(@supCase>-999)
			BEGIN
				UPDATE specMS_SpecListExtColData SET SupCase = @supCase WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1
				IF (@ImplCase > -999)
					UPDATE specMS_SpecListExtColData SET implCase = @ImplCase WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1
			END
		ELSE
			BEGIN
				IF (@ImplCase > -999)
					UPDATE specMS_SpecListExtColData SET implCase = @ImplCase WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) AND Status = -1 AND SupCase > 1
			END
	
		IF(CHARINDEX(@version,'noaction')<=0)
			BEGIN
				IF(@supCase>-999)
					UPDATE specMS_SpecListExtColData SET MergVer = @version WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) AND Status = -1
				ELSE
					UPDATE specMS_SpecListExtColData SET MergVer = @version WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) AND Status = -1 AND SupCase > 1
			END

		IF (@explianType = 1) UPDATE specMS_SpecListExtColData SET Explain = Explain+@explian WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1;
		IF (@explianType = 2) UPDATE specMS_SpecListExtColData SET Explain = @explian WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1;
		IF (@explianType = 3) UPDATE specMS_SpecListExtColData SET Explain = '' WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1;
		UPDATE specMS_SpecListExtColData SET IsAutoMatchRVersion = 0 WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and Status = -1;
	
	--status !=-1
		IF OBJECT_ID('tempdb..#specMS_SpecListExtColDatCasual') IS NOT NULL DROP TABLE #specMS_SpecListExtColDatCasual;                          
		SELECT * INTO #specMS_SpecListExtColDatCasual 
		FROM specMS_SpecListExtColData WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and [Status] != -1 and [Status] > -2; 
		
		UPDATE specMS_SpecListExtColData SET [status] = -2 WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 1) and [Status] != -1 and [Status] > -2; 

		UPDATE #specMS_SpecListExtColDatCasual SET [status] = -1 ;

		IF (@virtualSpec != -1)
			UPDATE #specMS_SpecListExtColDatCasual SET virtualSpec=@virtualSpec;
		IF(@supCase>-999)
			BEGIN
				UPDATE #specMS_SpecListExtColDatCasual SET supCase=@supCase;
				IF (@ImplCase > -999)
					UPDATE #specMS_SpecListExtColDatCasual SET ImplCase=@ImplCase;
			END
		ELSE
			BEGIN
				IF (@ImplCase > -999)
					UPDATE #specMS_SpecListExtColDatCasual SET ImplCase=@ImplCase WHERE supCase>1;
			END

		IF(CHARINDEX(@version,'noaction')<=0)
			BEGIN
				IF(@supCase>-999)
					UPDATE #specMS_SpecListExtColDatCasual SET MergVer = @version 
				ELSE
					UPDATE #specMS_SpecListExtColDatCasual SET MergVer = @version WHERE supCase>1
			END
		
		IF (@explianType = 1) UPDATE #specMS_SpecListExtColDatCasual SET Explain = Explain+@explian 
		IF (@explianType = 2) UPDATE #specMS_SpecListExtColDatCasual SET Explain = @explian 
		IF (@explianType = 3) UPDATE #specMS_SpecListExtColDatCasual SET Explain = '' 

		INSERT INTO specMS_SpecListExtColData(blEntryID,tecID,supCase,implCase,mergVer,[standard],explain,virtualSpec,xmlData,oldVersion,createTime,createBy,[status],blID,srcTecID,srcblID,IsAutoMatchRVersion,[param],extModifyBlId)
		SELECT blEntryID,tecID,supCase,implCase,mergVer,[standard],explain,virtualSpec,xmlData,oldVersion,createTime,createBy,[status],blID,srcTecID,srcblID,IsAutoMatchRVersion,[param],extModifyBlId FROM #specMS_SpecListExtColDatCasual


--当flag不为1
	IF (@explianType = 1) UPDATE specMS_SpecListExtColData SET Explain = Explain+@explian WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 0) ;
    IF (@explianType = 2) UPDATE specMS_SpecListExtColData SET Explain = @explian WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 0) ;
    IF (@explianType = 3) UPDATE specMS_SpecListExtColData SET Explain = '' WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 0) ;
    UPDATE specMS_SpecListExtColData SET IsAutoMatchRVersion = 0 WHERE extDataID IN(SELECT extDataID FROM #extData WHERE flag = 0) ;

END



GO


