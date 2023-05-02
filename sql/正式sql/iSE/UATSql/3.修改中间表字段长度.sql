USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[SP_SolGetEntryList]    Script Date: 2020-12-24 10:18:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:	ys2338
-- Create date: 20200702
-- Description:	
-- =============================================

ALTER PROCEDURE [dbo].[SP_SolGetEntryList]
   @PageIndex INT,				--第几页
   @PageSize INT,				--每页显示数据条数
   @BlID INT,					--基线id
   @EntryPID INT,				--父条目 若没有父级则为0
   @TabID INT,					--Tab页ID
   @Condition NVARCHAR(MAX),    --筛选条件
   @IsSupport NVARCHAR(1),		--是否支持 Y/N 空则为全选
   @IsAgree NVARCHAR(1),		--是否同意 Y/N 空则为全选
   @IsFeedBack NVARCHAR(1),		--是否反馈 Y/N 空则为全选
   @EntryIDs NVARCHAR(MAX),	    --勾选的EntryID集合，逗号分隔(导出用)
   @IsNeedChild INT,			--是否需要子集0 不需要 1需要(导出用)
   @IsExport INT				--1是导出查询 0 正常查询
AS
BEGIN
	DECLARE @colList NVARCHAR(MAX)=''			--行转列的列集合
	DECLARE @partCol NVARCHAR(MAX)=''			--部件行转列的列字符串集合
	DECLARE @featCol NVARCHAR(MAX)=''			--特性行转列的列字符串集合
	DECLARE @colPartSelect NVARCHAR(MAX)=''		--行转列选择的部件产品字段
	DECLARE @colFeatureSelect NVARCHAR(MAX)=''	--行转列选择的每期版本字段
	DECLARE @existsPart INT					--是否存在部件产品
	DECLARE @existsIssue INT				--是否存在每期版本特性

	DECLARE @sql NVARCHAR(MAX)=''			--拼接的sql

	--合并的中间表，用于将数据进行行转列
	CREATE TABLE #MergeTable
	( 
	  EntryID INT,	--条目ID
	  EntryPID INT, --条目父ID
	  RelID INT,	--关系表ID
	  Lvl INT,		--条目级别
	  EntryCName NVARCHAR(400),	--条目中文名
	  Remark NVARCHAR(MAX),	--备注
	  Description NVARCHAR(MAX),--说明
	  DictValueCh NVARCHAR(50),--优先级
	  NetName NVARCHAR(200),--组网图名称
	  Type INT,--1:部件产品 2:每期特性
	  ColID INT,--列ID
	  IsLeaf INT,--是否为叶子节点
	  EntryOrder FLOAT,--条目排序字段
	  EntryTreeOrder NVARCHAR(MAX), --树结构排序字段
	  ConVertCol NVARCHAR(500),--动态列名
	  ContentValue NVARCHAR(MAX) --动态列内容
	)

	CREATE TABLE #Entry
	(
	  EntryID INT,	--条目ID
	  EntryPID INT, --条目父ID
	  RelID INT,	--关系表ID
	  Lvl INT,		--条目级别
	  EntryCName NVARCHAR(400),	--条目中文名
	  Remark NVARCHAR(MAX),	--备注
	  Description NVARCHAR(MAX),--说明
	  IsLeaf INT,--叶子节点
	  dictValueCh NVARCHAR(50),--优先级
	  NetName NVARCHAR(200), --组网图名称
	  ColID INT,--扩展列ID
	  Name NVARCHAR(200),--扩展列名
	  Type INT, --扩展列类型
	  IsSupport CHAR(1),--部件产品 支持
	  IsAgree CHAR(1),--部件产品 同意
	  DefectFeedBack NVARCHAR(MAX),--部件产品缺陷反馈
	  OtherFeedBack NVARCHAR(MAX),--部件产品其他反馈
	  FeatureSupport CHAR(1),--每期特性支持
	  EntryOrder FLOAT,--条目排序字段
	  EntryTreeOrder NVARCHAR(MAX) --树结构排序字段
	)

	--对于@IsSupport,@IsAgree,@IsFeedBack条件有值时，向该临时表添加数据
	CREATE TABLE #EntryID
	(
	EntryID INT
	)

	IF @IsExport=0
		BEGIN
			IF @Condition<>'' OR @IsSupport<>'' OR @IsAgree <>'' OR @IsFeedBack <>''  --对于有查询条件的不加@EntryPID条件
				BEGIN
					INSERT INTO #Entry
					SELECT ent.EntryID,ent.EntryPID,rel.RelID, ent.Lvl,ent.EntryCName,ent.Remark,ent.Description,ent.IsLeaf, dic.dictValueCh,net.NetOrderNo,col.ColID,col.Name,col.Type,att.IsSupport,att.IsAgree,att.DefectFeedBack,att.OtherFeedBack,fea.IsSupport AS FeatureSupport,ent.EntryOrder,ent.EntryTreeOrder
					FROM Sol_Entry ent
					INNER JOIN Sol_EntryRelation rel ON ent.EntryID=rel.EntryID
					LEFT JOIN specMS_Dict dic ON ent.PriorityLevel=dic.dictId
					LEFT JOIN Sol_NetWorking net ON ent.NetID=net.NetID
					LEFT JOIN Sol_EntryColName col ON ent.BlID=col.BlID AND col.Status IN(-1,0,1) AND col.TabID=@TabID
					LEFT JOIN Sol_PartProductAttribute att ON col.ColID=att.ColID AND att.RelID=rel.RelID AND att.Status IN(-1,0,1)
					LEFT JOIN Sol_Features fea ON col.ColID=fea.ColID AND fea.RelID=rel.RelID AND fea.Status IN(-1,0,1)
					WHERE ent.DeleteFlag=0 AND ent.Status IN(-1,0,1) AND ent.BlID=@Blid AND ent.TabID=@TabID
				END
			ELSE
				BEGIN
					INSERT INTO #Entry
					SELECT ent.EntryID,ent.EntryPID,rel.RelID, ent.Lvl,ent.EntryCName,ent.Remark,ent.Description,ent.IsLeaf, dic.dictValueCh,net.NetOrderNo,col.ColID,col.Name,col.Type,att.IsSupport,att.IsAgree,att.DefectFeedBack,att.OtherFeedBack,fea.IsSupport AS FeatureSupport,ent.EntryOrder,ent.EntryTreeOrder
					FROM Sol_Entry ent
					INNER JOIN Sol_EntryRelation rel ON ent.EntryID=rel.EntryID
					LEFT JOIN specMS_Dict dic ON ent.PriorityLevel=dic.dictId
					LEFT JOIN Sol_NetWorking net ON ent.NetID=net.NetID
					LEFT JOIN Sol_EntryColName col ON ent.BlID=col.BlID AND col.Status IN(-1,0,1) AND col.TabID=@TabID
					LEFT JOIN Sol_PartProductAttribute att ON col.ColID=att.ColID AND att.RelID=rel.RelID AND att.Status IN(-1,0,1)
					LEFT JOIN Sol_Features fea ON col.ColID=fea.ColID AND fea.RelID=rel.RelID AND fea.Status IN(-1,0,1)
					WHERE ent.DeleteFlag=0 AND ent.Status IN(-1,0,1) AND ent.BlID=@Blid AND ent.TabID=@TabID AND ent.EntryPID=@EntryPID
				END
		END
	ELSE IF @IsExport=1
		BEGIN
			INSERT INTO #Entry
			SELECT ent.EntryID,ent.EntryPID,rel.RelID, ent.Lvl,ent.EntryCName,ent.Remark,ent.Description,ent.IsLeaf, dic.dictValueCh,net.NetOrderNo,col.ColID,col.Name,col.Type,att.IsSupport,att.IsAgree,att.DefectFeedBack,att.OtherFeedBack,fea.IsSupport AS FeatureSupport,ent.EntryOrder,ent.EntryTreeOrder
			FROM Sol_Entry ent
			INNER JOIN Sol_EntryRelation rel ON ent.EntryID=rel.EntryID
			LEFT JOIN specMS_Dict dic ON ent.PriorityLevel=dic.dictId
			LEFT JOIN Sol_NetWorking net ON ent.NetID=net.NetID
			LEFT JOIN Sol_EntryColName col ON ent.BlID=col.BlID AND col.Status IN(-1,0,1) AND col.TabID=@TabID
			LEFT JOIN Sol_PartProductAttribute att ON col.ColID=att.ColID AND att.RelID=rel.RelID AND att.Status IN(-1,0,1)
			LEFT JOIN Sol_Features fea ON col.ColID=fea.ColID AND fea.RelID=rel.RelID AND fea.Status IN(-1,0,1)
			WHERE ent.DeleteFlag=0 AND ent.Status IN(-1,0,1) AND ent.BlID=@Blid AND ent.TabID=@TabID --AND ent.EntryID IN(@EntryIDs)
		END

	SELECT @existsPart=COUNT(*) --部件产品
	FROM Sol_EntryColName col 
	WHERE col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID	AND col.Type=1	

	SELECT @existsIssue=COUNT(*) --每期版本
	FROM Sol_EntryColName col
	WHERE col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID	AND col.Type=2 	

	IF @existsPart>0 AND (SELECT COUNT(*) FROM #Entry)>0
		BEGIN
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_1_IsSupport') AS [ConVertCol],IsSupport AS[ContentValue] FROM #Entry WHERE Type=1--  --部件产品支持情况
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_2_IsAgree') AS [ConVertCol],IsAgree AS[ContentValue] FROM #Entry WHERE Type=1--  --部件产品是否同意
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_3_DefectFeedBack') AS [ConVertCol],DefectFeedBack AS[ContentValue] FROM #Entry WHERE Type=1--  --部件产品缺陷反馈
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_4_OtherFeedBack') AS [ConVertCol],OtherFeedBack AS[ContentValue] FROM #Entry WHERE Type=1--  --其他反馈

			IF (@IsSupport<>'' AND @IsAgree <>'' AND @IsFeedBack <>'') OR(@IsSupport<>'' AND @IsAgree <>'' AND @IsFeedBack ='') -- 
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=1 AND IsSupport=@IsSupport AND IsAgree=@IsAgree 
					AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
				END
			ELSE IF @IsSupport<>'' AND @IsAgree ='' AND @IsFeedBack <>''
				BEGIN
					IF @IsFeedBack ='Y' --反馈
						BEGIN
							INSERT INTO #EntryID
							SELECT EntryID FROM #Entry WHERE Type=1 AND IsSupport=@IsSupport AND IsAgree<>'' 
							AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
						END
					ELSE
						BEGIN
							INSERT INTO #EntryID
							SELECT EntryID FROM #Entry WHERE Type=1 AND IsSupport=@IsSupport AND IsAgree='' 
							AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
						END
				END
			ELSE IF @IsSupport='' AND @IsAgree <>'' AND @IsFeedBack <>''
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=1 AND IsAgree=@IsAgree
					AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
				END
			ELSE IF @IsSupport ='' AND @IsAgree ='' AND @IsFeedBack <>''
				BEGIN
					IF @IsFeedBack ='Y' --反馈
						BEGIN
							INSERT INTO #EntryID
							SELECT EntryID FROM #Entry WHERE Type=1 AND IsAgree<>'' 
							AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
						END
					ELSE
						BEGIN
							INSERT INTO #EntryID
							SELECT EntryID FROM #Entry WHERE Type=1 AND IsAgree='' 
							AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
						END
				END
			ELSE IF @IsSupport ='' AND @IsAgree <>'' AND @IsFeedBack =''
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=1 AND IsAgree=@IsAgree
					AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
				END
			ELSE IF @IsSupport <>'' AND @IsAgree ='' AND @IsFeedBack =''
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=1 AND IsSupport=@IsSupport
					AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
				END
		END
	ELSE --没有条目数据，但存在部件产品数据
		BEGIN
			SELECT @partCol  =  STUFF ((SELECT  ','+ part.[ContentValue] 
							FROM(
								SELECT DISTINCT ('[1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_1_IsSupport]'
								+',[1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_2_IsAgree]'
								+',[1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_3_DefectFeedBack]'
								+',[1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_4_OtherFeedBack]') AS [ContentValue]
								FROM Sol_EntryColName col    
								WHERE  col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID AND col.Type=1
							)part
							FOR XML PATH('')),1,1,'')

			SELECT @colPartSelect  = ','+ STUFF ((SELECT  ','+ part.[ContentValue] 
							FROM(
								SELECT DISTINCT ('MAX([1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_1_IsSupport]) AS [1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_1_IsSupport]'
								+',MAX([1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_2_IsAgree]) AS [1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_2_IsAgree]'
								+',MAX([1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_3_DefectFeedBack]) AS [1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_3_DefectFeedBack]'
								+',MAX([1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_4_OtherFeedBack]) AS [1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_4_OtherFeedBack]') AS [ContentValue]
								FROM Sol_EntryColName col    
								WHERE  col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID AND col.Type=1
							)part
							FOR XML PATH('')),1,1,'')

		END

	IF @existsIssue>0 AND (SELECT COUNT(*) FROM #Entry)>0 --每期特性
		BEGIN
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('2_solIssue_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_IsSupport') AS [ConVertCol],FeatureSupport AS [ContentValue] FROM #Entry  WHERE Type=2--  --每期版本
		
			IF @IsSupport<>'' AND @IsAgree='' AND @IsFeedBack='' -- 是否支持参数不为空
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=2 AND FeatureSupport=@IsSupport
				END
		END
	ELSE --没有条目数据,但存在每期特性数据
		BEGIN
			SELECT @featCol  =  STUFF ((SELECT  ','+ feature.[ContentValue] 
							FROM(
								SELECT DISTINCT ('[2_solIssue_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_IsSupport]') AS [ContentValue]
								FROM Sol_EntryColName col    
								WHERE  col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID AND col.Type=2
							)feature
							FOR XML PATH('')),1,1,'')

			SELECT @colFeatureSelect  = ','+ STUFF ((SELECT  ','+ feature.[ContentValue] 
							FROM(
								SELECT DISTINCT ('MAX([2_solIssue_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_IsSupport]) AS [2_solIssue_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_IsSupport]') AS [ContentValue]
								FROM Sol_EntryColName col    
								WHERE  col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID AND col.Type=2
							)feature
							FOR XML PATH('')),1,1,'')
		END
  
	IF (@existsPart>0 OR @existsIssue>0) --存在行转列的数据并且有条目数据
		BEGIN
			IF(SELECT COUNT(*) FROM #Entry)>0
				BEGIN
					SELECT DISTINCT [ConVertCol],ColID INTO #PartTable FROM #MergeTable WHERE Type=1 ORDER BY ColID
					SELECT DISTINCT [ConVertCol],ColID INTO #FeatureTable FROM #MergeTable WHERE Type=2 ORDER BY ColID
					SELECT [ConVertCol] INTO #OrderPartTable FROM #PartTable  --返回排序后的表部件产品
					SELECT [ConVertCol] INTO #OrderFeatureTable FROM #FeatureTable --返回排序后的每期版本
					SELECT @colList=@colList+',['+[ConVertCol]+']' FROM (SELECT DISTINCT [ConVertCol] FROM #MergeTable) T 
					SELECT @colPartSelect=@colPartSelect+',MAX(['+[ConVertCol]+']) AS '+'['+[ConVertCol]+']'  FROM (SELECT [ConVertCol] FROM #OrderPartTable) T  
					SELECT @colFeatureSelect=@colFeatureSelect+',MAX(['+[ConVertCol]+']) AS '+'['+[ConVertCol]+']'  FROM (SELECT [ConVertCol] FROM #OrderFeatureTable) T 

					SELECT @colList=RIGHT(@colList,LEN(@colList)-1) 
					DROP TABLE #PartTable;DROP TABLE #FeatureTable;DROP TABLE #OrderPartTable;DROP TABLE #OrderFeatureTable;
				END
			ELSE --没有条目数据
				BEGIN 
					IF LEN(ISNULL(@partCol,''))>0 AND LEN(ISNULL(@featCol,''))>0
						BEGIN
							SET @colList=@partCol+','+@featCol
						END
					ELSE IF LEN(ISNULL(@partCol,''))>0 AND LEN(ISNULL(@featCol,''))=0
						BEGIN
							SET @colList=@partCol
						END
					ELSE IF LEN(ISNULL(@partCol,''))=0 AND LEN(ISNULL(@featCol,''))>0
						BEGIN
							SET @colList=@featCol
						END
				END
			IF @IsExport=0
				BEGIN
						SET @sql='SELECT EntryID,EntryPID as _parentId,RelID,Lvl,EntryCName,Remark '+ISNULL(@colPartSelect,'')+',NetName,dictValueCh '+ISNULL(@colFeatureSelect,'')+',Description,EntryOrder,EntryTreeOrder,CASE WHEN IsLeaf=0 THEN ''closed'' ELSE ''open'' END state FROM( SELECT EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,dictValueCh,NetName,Description,IsLeaf,EntryOrder,EntryTreeOrder,'+@colList +' FROM #MergeTable a  
						PIVOT (MAX(ContentValue) FOR ConVertCol IN('+@colList+') 
						) AS pv ) b WHERE 1=1 GROUP BY EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,dictValueCh,NetName,Description,IsLeaf,EntryOrder,EntryTreeOrder '
				END
			ELSE IF @IsExport=1
				BEGIN
						SET @sql='SELECT EntryID,EntryPID as _parentId,RelID,Lvl,EntryCName,Remark '+ISNULL(@colPartSelect,'')+',NetName,dictValueCh '+ISNULL(@colFeatureSelect,'')+',Description,EntryOrder,EntryTreeOrder,CASE WHEN IsLeaf=0 THEN ''closed'' ELSE ''open'' END state FROM( SELECT EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,dictValueCh,NetName,Description,IsLeaf,EntryOrder,EntryTreeOrder,'+@colList +' FROM #MergeTable a  
						PIVOT (MAX(ContentValue) FOR ConVertCol IN('+@colList+') 
						) AS pv ) b WHERE 1=1 GROUP BY EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,dictValueCh,NetName,Description,IsLeaf,EntryOrder,EntryTreeOrder '
				END
		END
    ELSE --不存在行转列数据
		BEGIN
			IF @IsExport=0
				BEGIN
					SET @sql='	SELECT ent.EntryID,ent.EntryPID as _parentId,RelID, ent.Lvl,ent.EntryCName,ent.Remark,net.NetName,dic.dictValueCh,Description,EntryOrder,EntryTreeOrder,CASE WHEN IsLeaf=0 THEN ''closed'' ELSE ''open'' END state
								FROM Sol_Entry ent
								INNER JOIN Sol_EntryRelation rel ON ent.EntryID=rel.EntryID
								LEFT JOIN specMS_Dict dic ON ent.PriorityLevel=dic.dictId
								LEFT JOIN Sol_NetWorking net ON ent.NetID=net.NetID
								WHERE ent.DeleteFlag=0 AND ent.Status IN(-1,0,1) AND ent.BlID='+CONVERT(NVARCHAR(50),@Blid)+' AND ent.TabID='+CONVERT(NVARCHAR(50),@TabID) +' AND ent.EntryPID=' +CONVERT(NVARCHAR(50),@EntryPID)
				END
			ELSE IF @IsExport=1
				BEGIN
					SET @sql='	SELECT ent.EntryID,ent.EntryPID as _parentId,RelID, ent.Lvl,ent.EntryCName,ent.Remark,net.NetName,dic.dictValueCh,Description,EntryOrder,EntryTreeOrder,CASE WHEN IsLeaf=0 THEN ''closed'' ELSE ''open'' END state
									FROM Sol_Entry ent
									INNER JOIN Sol_EntryRelation rel ON ent.EntryID=rel.EntryID
									LEFT JOIN specMS_Dict dic ON ent.PriorityLevel=dic.dictId
									LEFT JOIN Sol_NetWorking net ON ent.NetID=net.NetID
									WHERE ent.DeleteFlag=0 AND ent.Status IN(-1,0,1) AND ent.BlID='+CONVERT(NVARCHAR(50),@Blid)+' AND ent.TabID='+CONVERT(NVARCHAR(50),@TabID) 
				END
		END

	SET @sql=' SELECT * INTO #Result FROM('+@sql+')T'

	IF @IsExport=0 --查询
		BEGIN
			IF @Condition<>'' OR @IsSupport<>'' OR @IsAgree<>'' OR @IsFeedBack<>''
				--根据搜索条件递归到一级规格 记录数据T1，然后对一级规格分页取数（主要考虑分页问题），用分页后一级规格递归取所有子集T2,T1和T2取交集形成最终数据
				BEGIN
					SET @sql=@sql 
							 +';WITH    ent
								  AS ( SELECT   EntryID,_parentId
									   FROM     (SELECT * FROM #Result res WHERE 1=1 '
									   IF @Condition<>''
										   BEGIN
											  SET @sql=@sql + @Condition
										   END
									   IF @IsSupport<>'' OR @IsAgree<>'' OR @IsFeedBack<>''
										   BEGIN
											  SET @sql=@sql + ' AND EXISTS(SELECT 1 FROM #EntryID WHERE res.EntryID=EntryID )'
										   END
					SET @sql=@sql    +')T
									   UNION ALL
									   SELECT   a.EntryID,a._parentId
									   FROM     #Result a
												INNER JOIN ent b ON a.EntryID = b._parentId
									 )
								SELECT DISTINCT EntryID INTO #BottomToTop FROM ent  
								--按搜索条件递归到一级的所有数据
								SELECT * INTO #ConditionResult FROM #Result result WHERE Exists(SELECT EntryID from #BottomToTop t where t.EntryID=result.EntryID) 

								DECLARE @count INT 
								--所有一级数据个数
								SELECT @count=COUNT(*) FROM #ConditionResult WHERE _parentId=0 
								--按分页取出对应区间的一级项ID
								SELECT EntryID INTO #LeveLOne FROM #ConditionResult WHERE _parentId=0
								ORDER BY EntryOrder OFFSET
							   '+ CAST(( ( @PageIndex * @PageSize ) - @PageSize ) AS VARCHAR(10))
								+ ' ROWS FETCH NEXT ' + CAST(@PageSize AS VARCHAR(10))
								+ ' ROWS ONLY

								;WITH    ent
								  AS ( SELECT   EntryID,0 AS _parentId
									   FROM     #LeveLOne
									   UNION ALL
									   SELECT   a.EntryID,a._parentId
									   FROM     #Result a
												INNER JOIN ent b ON a._parentId = b.EntryID
									 )
									 SELECT DISTINCT EntryID INTO #TopToBottom FROM ent 
						
								SELECT *,@count AS TotalCount FROM #Result WHERE EntryID IN(
									SELECT b.EntryID FROM #BottomToTop b INNER JOIN #TopToBottom t ON b.EntryID=t.EntryID
								)
								DROP TABLE #BottomToTop;DROP TABLE #TopToBottom;DROP TABLE #ConditionResult;DROP TABLE #LeveLOne
								'
				END
			ELSE
				--没有搜索条件
				BEGIN
					IF @EntryPID=0 --查询一级项目需要分页
						BEGIN
							SET @sql=@sql +'
								SELECT *,(SELECT COUNT(*) FROM #Result) AS TotalCount FROM #Result 
								ORDER BY EntryOrder OFFSET '
							+ CAST(( ( @PageIndex * @PageSize ) - @PageSize ) AS VARCHAR(10))
							+ ' ROWS FETCH NEXT ' + CAST(@PageSize AS VARCHAR(10))
							+ ' ROWS ONLY';
						END
					ELSE
						BEGIN --查询子项时 显示所有子项
							SET @sql=@sql +'
								SELECT *,(SELECT COUNT(*) FROM #Result) AS TotalCount FROM #Result ORDER BY EntryOrder'
						END
				END
		END
	ELSE IF @IsExport=1 --导出(展示为树形结构 要考虑递归排序问题)
		BEGIN
			IF @EntryIDs='' AND @Condition='' AND @IsSupport='' AND @IsAgree='' AND @IsFeedBack='' --所有记录
				BEGIN
					SET @sql=@sql +'
								 SELECT r.*,(SELECT COUNT(*) FROM #Result) AS TotalCount FROM #Result r ORDER BY r.EntryTreeOrder
								 '
				END
			ELSE IF @EntryIDs='' AND (@Condition<>''  OR @IsSupport<>'' OR @IsAgree<>'' OR @IsFeedBack<>'') --筛选关键字
				BEGIN
					SET @sql=@sql --递归到一级条目
							 +';WITH    ent
								  AS ( SELECT   EntryID,_parentId
									   FROM     (SELECT * FROM #Result res WHERE 1=1'
									   IF @Condition<>''
										   BEGIN
											  SET @sql=@sql + @Condition
										   END
									   IF @IsSupport<>'' OR @IsAgree<>'' OR @IsFeedBack<>''
										   BEGIN
											  SET @sql=@sql + ' AND EXISTS(SELECT 1 FROM #EntryID WHERE res.EntryID=EntryID )'
										   END
					SET @sql=@sql +')T
									   UNION ALL
									   SELECT   a.EntryID,a._parentId
									   FROM     #Result a
												INNER JOIN ent b ON a.EntryID = b._parentId
									 )
								SELECT DISTINCT EntryID INTO #BottomToTop FROM ent  

								SELECT * INTO #ConditionResult FROM #Result result WHERE Exists(SELECT EntryID from #BottomToTop t where t.EntryID=result.EntryID) 

								SELECT c.*,(SELECT COUNT(*) FROM #ConditionResult) AS TotalCount FROM #ConditionResult c ORDER BY c.EntryTreeOrder

								DROP TABLE #BottomToTop;DROP TABLE #ConditionResult;
								'
				END
			ELSE IF @EntryIDs<>'' --AND (@Condition='' OR @Condition<>'') --只要有勾选 就不加关键字条件了
				BEGIN
					IF @IsNeedChild=1 --需要子集 递归获取所有子集
						BEGIN
							SET @sql=@sql 
							 +';WITH    ent
								  AS ( SELECT   EntryID,_parentId
									   FROM     (SELECT * FROM #Result WHERE EntryID IN('+@EntryIDs+'))T
									   UNION ALL
									   SELECT   a.EntryID,a._parentId
									   FROM     #Result a
												INNER JOIN ent b ON a.EntryID = b._parentId
									 )
								SELECT DISTINCT EntryID INTO #BottomToTop FROM ent  

								;WITH    ent
								  AS ( SELECT   EntryID,_parentId
									   FROM     (SELECT * FROM #Result WHERE EntryID IN('+@EntryIDs+'))T
									   UNION ALL
									   SELECT   a.EntryID,a._parentId
									   FROM     #Result a
												INNER JOIN ent b ON b.EntryID = a._parentId
									 )
								SELECT DISTINCT EntryID INTO #TopToBottom FROM ent  

								SELECT * INTO #ConditionResult FROM(
									SELECT b.EntryID FROM #BottomToTop b 
									UNION
									SELECT t.EntryID FROM #TopToBottom t 
								)T

								SELECT c.*,(SELECT COUNT(*) FROM #ConditionResult) AS TotalCount FROM #ConditionResult c ORDER BY c.EntryTreeOrder

								DROP TABLE #BottomToTop;DROP TABLE #TopToBottom;DROP TABLE #ConditionResult;
								'
						END
					ELSE --不需要子集 递归到一级项即可
						BEGIN
							SET @sql=@sql 
							 +';WITH    ent
								  AS ( SELECT   EntryID,_parentId
									   FROM     (SELECT * FROM #Result WHERE EntryID IN('+@EntryIDs+'))T
									   UNION ALL
									   SELECT   a.EntryID,a._parentId
									   FROM     #Result a
												INNER JOIN ent b ON a.EntryID = b._parentId
									 )
								SELECT DISTINCT EntryID INTO #BottomToTop FROM ent  
							
								SELECT * INTO #ConditionResult FROM #Result result WHERE Exists(SELECT EntryID from #BottomToTop t where t.EntryID=result.EntryID) 

								SELECT *,(SELECT COUNT(*) FROM #ConditionResult) AS TotalCount FROM #ConditionResult c ORDER BY c.EntryTreeOrder

								DROP TABLE #BottomToTop;DROP TABLE #ConditionResult;
								'
						END
				END
		END

	SET @sql=@sql +' DROP TABLE #Result;DROP TABLE #MergeTable;DROP TABLE #Entry;DROP TABLE #EntryID '

	exec(@sql)
	--select @sql
END


GO


