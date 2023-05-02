USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[P_InsertBaseLineData]    Script Date: 2020-10-28 14:33:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Alter PROC [dbo].[P_InsertBaseLineData]
(
@Basename NVARCHAR(200),
@CreateBy NVARCHAR(200),
@Explain NVARCHAR(200),
@Fileaway INT,
@ListType INT ,
@Parentid INT,
@Status INT,
@PreVer NVARCHAR(200),
@VerRCode NVARCHAR(200)
)
AS
DECLARE @ResBaseID INT
DECLARE @ResBasename NVARCHAR(200)=@Basename
DECLARE @ResExplain NVARCHAR(200)=@Explain
DECLARE @ResCreateTime DATETIME
DECLARE @ResCreateBy NVARCHAR(200)=@CreateBy
DECLARE @ResFileaway INT=@Fileaway

DECLARE @newBlId INT
DECLARE @NowTime DATETIME=GETDATE()
DECLARE @SpectModelListID INT
DECLARE @SpecListModelListId INT 
DECLARE @DefaultCol INT=0

BEGIN TRY
	--BEGIN TRANSACTION TRANS
		IF @Parentid!=0 AND @Status=0 AND EXISTS(SELECT 1 FROM Specms_SpecBaseLine WHERE PreBlId=@Parentid AND Status!=1)
		BEGIN
			SELECT 
				@ResBaseID=BLID, 
				@ResBasename=LTITLE,
				@ResExplain=[DESCRIPTION],
				@ResCreateTime=CREATETIME,
				@ResCreateBy=createBy,
				@ResFileaway=-1
			FROM Specms_SpecBaseLine 
			WHERE PreBlId=@Parentid AND Status!=1
		END
		ELSE IF @Parentid=0 AND EXISTS(SELECT 1 FROM SPECMS_SPECLIST AS S WITH (NOLOCK) 
				INNER JOIN SPECMS_SPECBASELINE AS B WITH (NOLOCK) ON S.BLID = B.BLID 
				LEFT JOIN SYNC_EMPLOYEE E WITH (NOLOCK) ON B.CREATEBY = E.CODE
			WHERE  S.VERTREECODE=@VerRCode  and B.DeleteFlag=0)
		BEGIN
			SELECT 
				@ResBaseID=B.BLID, 
				@ResBasename=B.LTITLE,
				@ResExplain=B.DESCRIPTION,
				@ResCreateTime=B.CREATETIME,
				@ResCreateBy=E.NAME + ' ' + E.CODE,
				@ResFileaway=S.fileaway
			FROM SPECMS_SPECLIST AS S WITH (NOLOCK) 
				INNER JOIN SPECMS_SPECBASELINE AS B WITH (NOLOCK) ON S.BLID = B.BLID 
				LEFT JOIN SYNC_EMPLOYEE E WITH (NOLOCK) ON B.CREATEBY = E.CODE
			WHERE  S.VERTREECODE=@VerRCode  and B.DeleteFlag=0
		END
		ELSE
		BEGIN		
			DECLARE @COUNT INT,@COUNT2 INT; 
			SELECT @COUNT=COUNT(*) FROM SPECMS_SPECBASELINE WHERE PREBLID=@Parentid AND (STATUS=0 OR STATUS=-1) and DeleteFlag=0
					AND BLID IN (SELECT BLID FROM SPECMS_SPECLIST WHERE VERTREECODE=@VerRCode);
			SELECT @COUNT2=COUNT(*) FROM SPECMS_SPECBASELINE WHERE BLID=@Parentid AND (STATUS=0 OR STATUS=-1) and DeleteFlag=0
					AND BLID IN (SELECT BLID FROM SPECMS_SPECLIST WHERE VERTREECODE=@VerRCode ) ;
			IF  @COUNT=0 AND @COUNT2=0
			BEGIN
				INSERT INTO SPECMS_SPECBASELINE(LTITLE, CURVER, PREBLID, PREVER, BLEVEL, DATASRC, STATUS,DESCRIPTION, EDITSTATUS, LASTEDITOR, CREATEBY, CREATETIME,ip,ApplyID)
				VALUES (@Basename, @Basename, @Parentid, @PreVer, 0, (CASE WHEN @ListType=1 THEN 1 ELSE 3 END), @Status, @Explain, 0, '', @CreateBy,@NowTime,'',CAST(CAST(0 AS binary) AS uniqueidentifier));
				SET @newBlId=SCOPE_IDENTITY();
			END;
			IF NOT EXISTS(SELECT * FROM SPECMS_SPECBASELINE WHERE BLID=@newBlId)
			BEGIN
				RAISERROR(N'写入基线表数据时发生异常',16,1);
			END
			
			SET @ResBaseID= @newBlId
			SET @ResCreateTime= @NowTime
			
			--主线表
			INSERT INTO Specms_SpecList(blID,createBy,createTime,explain,fileaway,listType,verTreeCode)
			VALUES(@newBlId,@CreateBy,@NowTime,'',@Fileaway,@ListType,@VerRCode)
			SET @SpectModelListID=SCOPE_IDENTITY();
			SELECT @SpecListModelListId=Listid FROM specMS_SpecList WHERE blID=@Parentid
			
			--扩展列表
			IF(@Parentid>0)
			BEGIN
				INSERT INTO Specms_SpecListExtCol(listID,colEName,colName,xmlData,ifHide,orderNo,description,OldExtColid )
				SELECT 	@SpectModelListID,colEName,colName,xmlData,ifHide,orderNo,description,extColID 
				FROM Specms_SpecListExtCol WHERE listID=@SpecListModelListId
			END
			ELSE IF(@ListType=1)
			BEGIN
				INSERT INTO Specms_SpecListExtCol(listID,colEName,colName,xmlData,ifHide,orderNo,description )
				VALUES(@SpectModelListID,'Default','Default','1',0,0,'默认扩展列')
				SET @DefaultCol=SCOPE_IDENTITY();
			END
			
			-- tab表
			IF(@Parentid>0)
			BEGIN				
				INSERT INTO Specms_SpecListTab( listID,tabTitile,orderNo,tabCode,description,explain,tabStatus,isRef,flag,createBy,manager,OldtabID)
				SELECT @SpectModelListID,TABTITILE,ORDERNO,TABCODE,DESCRIPTION,EXPLAIN,TABSTATUS,ISREF,FLAG,@CreateBy,MANAGER,TABID FROM SPECMS_SPECLISTTAB A WHERE A.LISTID = @SpecListModelListId AND ISREF IN(1,2)
				UNION ALL
				SELECT @SpectModelListID,TABTITILE,ORDERNO,TABCODE,DESCRIPTION,A.EXPLAIN,TABSTATUS,ISREF,FLAG,@CreateBy,MANAGER,TABID FROM SPECMS_SPECLISTTAB A LEFT JOIN SPECMS_TEMPLATESPEC B ON A.TABTITILE = B.TEMPNAME
				WHERE A.ISREF = 0 AND B.STATUS =1 AND A.LISTID = @SpecListModelListId			
			END
			ELSE
			BEGIN
				INSERT INTO Specms_SpecListTab( listID,tabTitile,orderNo,tabCode,description,explain,tabStatus,isRef,flag,createBy,manager)
				VALUES(@SpectModelListID,'Default',1,'','Default','',1,1,1,@CreateBy,'')
				IF(@ListType=1)
				BEGIN
					INSERT INTO Specms_SpecListTabExtCol(tabID,extColID,status)
					VALUES(SCOPE_IDENTITY(),@DefaultCol,0)
				END
			END
			IF(@Parentid>0)
			BEGIN			
			
				--分组表
				INSERT INTO Sepcms_SpecListExtColGroup(ecgPID,gCode,gCName,gEName,gLvl,tabID,orderNo,blId,OldEcgid,status)
                SELECT ecgPID,gCode,gCName,gEName,gLvl,0,orderNo,@newBlId,ecgID,0 FROM Sepcms_SpecListExtColGroup  WHERE BlId=@Parentid
				INSERT INTO Sepcms_SpecListTabGroup(tabId,groupID,blId,createTime,lastModifyTime,status)
                SELECT T.tabId,C.Ecgid,@newBlId,@NowTime,@NowTime,0
                FROM Sepcms_SpecListTabGroup G INNER JOIN Specms_SpecListTab T ON G.TabId=T.OldTabid  AND ISNULL(T.OldTabid,0)!=0
	                INNER JOIN Sepcms_SpecListExtColGroup C ON G.Groupid=C.OldEcgid AND ISNULL(C.OldEcgid,0)!=0
                WHERE G.blId=@Parentid AND C.blId=@newBlId
				
				--页组扩展列关系表
				INSERT INTO Specms_SpecListTabExtCol(Groupid,ExtColid,Tabid,newGroupId,newOrderNo,status)
				SELECT G.ecgID,ISNULL(C.ExtColid,0),ISNULL(Tab.tabID,0),0,0,0 
				FROM (select a.* from specMS_SpecListTabExtCol a where  tabID in 
						(
							select tabID from specMS_SpecListTab a
								left join specMS_TemplateSpec b	on a.tabTitile =b.tempName
								where listID = @SpecListModelListId and b.status =1 and a.isRef =0
						)or (status=0 or status =-1) and tabID in(select tabID from specMS_SpecListTab where listID =@SpecListModelListId and isRef in(1,2))
				) T
				LEFT JOIN Sepcms_SpecListExtColGroup G ON T.groupID=G.OldEcgid AND G.blId=@newBlId  AND ISNULL(G.OldEcgid,0)!=0
				LEFT JOIN Specms_SpecListExtCol C ON T.ExtColid=C.OldExtColid AND C.listID=@SpectModelListID  AND ISNULL(C.OldExtColid,0)!=0
				LEFT JOIN Specms_SpecListTab Tab ON T.Tabid=Tab.OldTabid AND C.listID=@SpectModelListID  AND ISNULL(Tab.OldTabid,0)!=0
				
				--附件表
                INSERT INTO SPECMS_SPECLISTATTACHMENT(LISTID,POSNUM,FILENAME,FILEURL,FILETYPE,EXPLAIN,CREATETIME,CREATEBY,FILESIZE,ISDEL)
				SELECT @SpectModelListID,MAIN.LISTID,MAIN.FILENAME,MAIN.FILEURL,MAIN.FILETYPE,MAIN.EXPLAIN,
				  MAIN.CREATETIME,EMPLOYEE.CODE CREATEBY,MAIN.FILESIZE,MAIN.ISDEL
				  FROM 
				  (
					  SELECT A.SLAID,A.LISTID,A.FILENAME,A.FILEURL,A.FILETYPE,A.EXPLAIN,
						A.CREATETIME,A.CREATEBY,A.FILESIZE,A.ISDEL,D.SRCNAME +' - '+C.SMNAME AS POSNUM  
					  FROM        SPECMS_SPECLISTATTACHMENT A
					  LEFT JOIN SPECMS_SPECMODULEBLREL B ON A.LISTID=B.BLID
					  LEFT JOIN SPECMS_SPECMODULE C ON B.SMID = C.SMID
					  LEFT JOIN SPECMS_SPECDATAIDSET D ON C.VERTREECODE = D.SRCID
					  INNER JOIN SPECMS_TABREFBASELINE REF ON REF.BLID= A.LISTID
					  WHERE A.FILETYPE=1 AND REF.LISTID=@SPECLISTMODELLISTID AND REF.STATUS=1
					  UNION
					  SELECT A.SLAID,A.LISTID,A.FILENAME,A.FILEURL,A.FILETYPE,A.EXPLAIN,
						  A.CREATETIME,A.CREATEBY,A.FILESIZE,A.ISDEL,C.SRCNAME AS POSNUM   
					  FROM    SPECMS_SPECLISTATTACHMENT A
					  LEFT JOIN SPECMS_SPECLIST B ON A.LISTID = B.LISTID
					  LEFT JOIN SPECMS_SPECDATAIDSET C ON B.VERTREECODE = C.SRCID		  
					  WHERE A.FILETYPE=0 AND A.LISTID=@SPECLISTMODELLISTID 		
					UNION
					SELECT A.SLAID,A.LISTID,A.FILENAME,A.FILEURL,A.FILETYPE,A.EXPLAIN,
						  A.CREATETIME,A.CREATEBY,A.FILESIZE,A.ISDEL,C.SRCNAME AS POSNUM   
					  FROM    SPECMS_SPECLISTATTACHMENT A
					  LEFT JOIN SPECMS_SPECLIST B ON A.LISTID = B.LISTID
					  LEFT JOIN SPECMS_SPECDATAIDSET C ON B.VERTREECODE = C.SRCID	
					  INNER JOIN SPECMS_SPECLIST SLIST ON A.LISTID=SLIST.LISTID
					 INNER JOIN SPECMS_TABREFBASELINE REF ON REF.REFVER=SLIST.BLID
					   WHERE A.FILETYPE=0 AND REF.LISTID=@SPECLISTMODELLISTID AND REFVER!=0 
				  )
				  MAIN LEFT JOIN SYNC_EMPLOYEE EMPLOYEE ON MAIN.CREATEBY = EMPLOYEE.CODE
				  
				--基线标准协议
				INSERT INTO specMS_StandardSupport(blEntryID,entryID,extColID,stdID,supCase,flag,blID,status,modifyFlag,Comment)
                SELECT 0,ENTRYID,EXTCOLID,A.STDID,SUPCASE,FLAG,@newBlId,STATUS,MODIFYFLAG,COMMENT 
                FROM SPECMS_STANDARD A  WITH(NOLOCK),SPECMS_STANDARDSUPPORT B  WITH(NOLOCK) 
                WHERE A.STDID = B.STDID AND B.STATUS<>-2  AND B.BLID =@Parentid AND  FLAG=2
				
				--复制引用的产品列关系
				INSERT INTO SpecMS_BaselineProductRel(ListBlid,TempId,Blid,ProdColID,CreateTime,CreateBy)
				SELECT @newBlId,TempId,Blid,ProdColID,GETDATE(),@CreateBy FROM SpecMS_BaselineProductRel WHERE ListBlid=@Parentid
				
				--获取前主基线下所有的子基线				
				--复制主基线与子基线的关系				
				DECLARE @PreBLID INT,  @NewSubBLID INT,@preName NVARCHAR(200)
				--DECLARE @DataSrc INT=3;
				--IF(@newBlId>0)
				--BEGIN
				--	SELECT @DATASRC=DATASRC FROM SPECMS_SPECBASELINE WHERE BLID=@newBlId
				--END
				--INSERT INTO SPECMS_SPECBASELINE(DATASRC,LTITLE,PREBLID,CREATEBY,CREATETIME,STATUS,DESCRIPTION)
				--SELECT @DATASRC,LTITLE+'.DRAFT',BLID,CREATEBY,GETDATE(),0,'草稿节点' FROM SPECMS_SPECBASELINE WHERE BLID IN (SELECT BLID FROM #TABLEREF WHERE STATUS=2)

				SELECT TOP(1) @PreBLID=blID FROM SPECMS_TABREFBASELINE A WHERE DATASRC!=2 AND LISTID = @SpecListModelListId AND A.status=2
				select TOP(1) @preName=LTitle  from specMS_SpecBaseLine where blID=@PreBLID
				 
				EXEC P_InsertPlatChildBaseLine @preBLID,@preName,2,@CreateBy,1,1,@Parentid,@newBlId,@NowTime,@NewSubBLID OUT
				IF (@NewSubBLID IS NULL OR @NewSubBLID=0)
				BEGIN
					RAISERROR(N'数据异常',16,1);
				END

				IF EXISTS(SELECT * FROM TEMPDB..SYSOBJECTS WHERE ID=OBJECT_ID('TEMPDB..#TABLEREF')) 
				BEGIN
					DROP TABLE #TABLEREF
				END
				SELECT * INTO #TABLEREF FROM (
					SELECT A.* FROM SPECMS_TABREFBASELINE A WHERE DATASRC!=2 AND LISTID = @SpecListModelListId 
					UNION ALL 
					SELECT A.* FROM SPECMS_TABREFBASELINE A ,SPECMS_TEMPLATESPECBLREL B ,
					SPECMS_TEMPLATESPEC C WHERE A.BLID =B.BLID  AND C.TEMPID = B.TEMPID
					AND  A.STATUS = 1 AND A.LISTID = @SpecListModelListId AND A.DATASRC =2 AND C.STATUS =1
				)T 				
				
				INSERT INTO SPECMS_TABREFBASELINE(BLID,LISTID,STATUS,DATASRC,TABID,LISTBLID,SPECLBLID,CREATETIME,CREATEBY,PARENTBLID)
				SELECT @NewSubBLID,@SpectModelListID,2,T.DATASRC,0,@newBlId,T.SPECLBLID,@NowTime,@CreateBy,0 
				--FROM SPECMS_SPECBASELINE BL INNER JOIN (SELECT * FROM #TABLEREF WHERE STATUS=2) T ON  PREBLID = T.BLID
				FROM  #TABLEREF T  WHERE STATUS=2 

				
				INSERT INTO Specms_TabRefBaseLine(Blid,Listid,Status,DataSrc,Tabid,RefVer,Refid,HasChange,ListblID,SpecLblid,Oldblid,OldSpecLblid,ParentBlid,CreateTime,CreateBy)
				SELECT Blid,@SpectModelListID,1,DataSrc,TAB.tabID,RefVer,Refid,HasChange,@newBlId,SpecLblid,Oldblid,OldSpecLblid,ParentBlid,@NowTime,@CreateBy 
				FROM #TableRef LEFT JOIN Specms_SpecListTab TAB ON #TableRef.tabID=TAB.OldTabid AND ISNULL(TAB.OldTabid,0)!=0 WHERE status=1
				
				--复制引用的扩展列数据
				INSERT INTO specMS_SpecListExtColData(blEntryID,tecID,supCase,implCase,mergVer,standard,explain,virtualSpec,xmlData,oldVersion,createTime,createBy,status,blID,srcTecID,srcblID,
				ISAUTOMATCHRVERSION,PARAM,EXTMODIFYBLID)
				SELECT COLDATA.BLENTRYID,ISNULL(EXTCOL.EXTCOLID,0),COLDATA.SUPCASE,COLDATA.IMPLCASE,COLDATA.MERGVER,COLDATA.STANDARD,COLDATA.EXPLAIN,COLDATA.VIRTUALSPEC,COLDATA.XMLDATA,COLDATA.OLDVERSION,
					COLDATA.CREATETIME,COLDATA.CREATEBY,0,@newBlId,COLDATA.SRCTECID,COLDATA.SRCBLID,0,PARAM,EXTMODIFYBLID 
				FROM SPECMS_SPECLISTEXTCOLDATA COLDATA WITH(NOLOCK) INNER JOIN  SPECMS_SPECBLENTRYREL REL WITH(NOLOCK)ON COLDATA.BLENTRYID = REL.BLENTRYID 
					LEFT JOIN SPECMS_SPECENTRYCONTENT CONTENT WITH(NOLOCK)ON REL.ENTRYID = CONTENT.ENTRYID 
					INNER JOIN #TABLEREF ON #TABLEREF.BLID=REL.BLID
					LEFT JOIN SPECMS_SPECLISTEXTCOL EXTCOL ON EXTCOL.OLDEXTCOLID=TECID AND ISNULL(EXTCOL.OLDEXTCOLID,0)!=0
				WHERE REL.FLAG=0 AND COLDATA.BLID=@Parentid AND CONTENT.ISSHARE=1
				
				--复制引用条目变更信息
				INSERT INTO SPECMS_MODIFYREFENTRY(BLID, ENTRYID, ENTRYCNAME, ENTRYENAME, FUNCDESC, REMARK, CREATETIME, CREATEBY)
				SELECT @NEWBLID, ENTRYID, ENTRYCNAME, ENTRYENAME, FUNCDESC, REMARK, CREATETIME, CREATEBY
				FROM SPECMS_MODIFYREFENTRY WHERE BLID=@PARENTID
			END
		END
		
		IF EXISTS(SELECT * FROM TEMPDB..SYSOBJECTS WHERE ID=OBJECT_ID('TEMPDB..#TABLEREF')) 
		BEGIN
			DROP TABLE #TABLEREF
		END
		SELECT @ResBaseID AS BaseID,@ResBasename AS Basename,@ResFileaway AS Fileaway,@ResExplain AS Explain,@ResCreateTime AS CreateTime,@ResCreateBy AS CreateBy
	--COMMIT TRANSACTION TRANS
END TRY
BEGIN CATCH
	--ROLLBACK TRANSACTION TRANS
	--PRINT('ROLLBACK')	
	IF EXISTS(SELECT * FROM TEMPDB..SYSOBJECTS WHERE ID=OBJECT_ID('TEMPDB..#TABLEREF')) 
	BEGIN
		DROP TABLE #TABLEREF
	END
	DECLARE   @ErrorMessage   NVARCHAR ( 4000 );
	DECLARE   @ErrorSeverity   INT ;
	DECLARE   @ErrorState   INT ;
	SELECT  
		@ErrorMessage   =  ERROR_MESSAGE(),
		@ErrorSeverity   =  ERROR_SEVERITY(),
		@ErrorState   =  ERROR_STATE();
	RAISERROR  ( @ErrorMessage ,   --  Message text.
			@ErrorSeverity ,  --  Severity.
			@ErrorState       --  State.
			);
END CATCH
GO


