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
   @PageIndex INT,				--�ڼ�ҳ
   @PageSize INT,				--ÿҳ��ʾ��������
   @BlID INT,					--����id
   @EntryPID INT,				--����Ŀ ��û�и�����Ϊ0
   @TabID INT,					--TabҳID
   @Condition NVARCHAR(MAX),    --ɸѡ����
   @IsSupport NVARCHAR(1),		--�Ƿ�֧�� Y/N ����Ϊȫѡ
   @IsAgree NVARCHAR(1),		--�Ƿ�ͬ�� Y/N ����Ϊȫѡ
   @IsFeedBack NVARCHAR(1),		--�Ƿ��� Y/N ����Ϊȫѡ
   @EntryIDs NVARCHAR(MAX),	    --��ѡ��EntryID���ϣ����ŷָ�(������)
   @IsNeedChild INT,			--�Ƿ���Ҫ�Ӽ�0 ����Ҫ 1��Ҫ(������)
   @IsExport INT				--1�ǵ�����ѯ 0 ������ѯ
AS
BEGIN
	DECLARE @colList NVARCHAR(MAX)=''			--��ת�е��м���
	DECLARE @partCol NVARCHAR(MAX)=''			--������ת�е����ַ�������
	DECLARE @featCol NVARCHAR(MAX)=''			--������ת�е����ַ�������
	DECLARE @colPartSelect NVARCHAR(MAX)=''		--��ת��ѡ��Ĳ�����Ʒ�ֶ�
	DECLARE @colFeatureSelect NVARCHAR(MAX)=''	--��ת��ѡ���ÿ�ڰ汾�ֶ�
	DECLARE @existsPart INT					--�Ƿ���ڲ�����Ʒ
	DECLARE @existsIssue INT				--�Ƿ����ÿ�ڰ汾����

	DECLARE @sql NVARCHAR(MAX)=''			--ƴ�ӵ�sql

	--�ϲ����м�����ڽ����ݽ�����ת��
	CREATE TABLE #MergeTable
	( 
	  EntryID INT,	--��ĿID
	  EntryPID INT, --��Ŀ��ID
	  RelID INT,	--��ϵ��ID
	  Lvl INT,		--��Ŀ����
	  EntryCName NVARCHAR(400),	--��Ŀ������
	  Remark NVARCHAR(MAX),	--��ע
	  Description NVARCHAR(MAX),--˵��
	  DictValueCh NVARCHAR(50),--���ȼ�
	  NetName NVARCHAR(200),--����ͼ����
	  Type INT,--1:������Ʒ 2:ÿ������
	  ColID INT,--��ID
	  IsLeaf INT,--�Ƿ�ΪҶ�ӽڵ�
	  EntryOrder FLOAT,--��Ŀ�����ֶ�
	  EntryTreeOrder NVARCHAR(MAX), --���ṹ�����ֶ�
	  ConVertCol NVARCHAR(500),--��̬����
	  ContentValue NVARCHAR(MAX) --��̬������
	)

	CREATE TABLE #Entry
	(
	  EntryID INT,	--��ĿID
	  EntryPID INT, --��Ŀ��ID
	  RelID INT,	--��ϵ��ID
	  Lvl INT,		--��Ŀ����
	  EntryCName NVARCHAR(400),	--��Ŀ������
	  Remark NVARCHAR(MAX),	--��ע
	  Description NVARCHAR(MAX),--˵��
	  IsLeaf INT,--Ҷ�ӽڵ�
	  dictValueCh NVARCHAR(50),--���ȼ�
	  NetName NVARCHAR(200), --����ͼ����
	  ColID INT,--��չ��ID
	  Name NVARCHAR(200),--��չ����
	  Type INT, --��չ������
	  IsSupport CHAR(1),--������Ʒ ֧��
	  IsAgree CHAR(1),--������Ʒ ͬ��
	  DefectFeedBack NVARCHAR(MAX),--������Ʒȱ�ݷ���
	  OtherFeedBack NVARCHAR(MAX),--������Ʒ��������
	  FeatureSupport CHAR(1),--ÿ������֧��
	  EntryOrder FLOAT,--��Ŀ�����ֶ�
	  EntryTreeOrder NVARCHAR(MAX) --���ṹ�����ֶ�
	)

	--����@IsSupport,@IsAgree,@IsFeedBack������ֵʱ�������ʱ���������
	CREATE TABLE #EntryID
	(
	EntryID INT
	)

	IF @IsExport=0
		BEGIN
			IF @Condition<>'' OR @IsSupport<>'' OR @IsAgree <>'' OR @IsFeedBack <>''  --�����в�ѯ�����Ĳ���@EntryPID����
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

	SELECT @existsPart=COUNT(*) --������Ʒ
	FROM Sol_EntryColName col 
	WHERE col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID	AND col.Type=1	

	SELECT @existsIssue=COUNT(*) --ÿ�ڰ汾
	FROM Sol_EntryColName col
	WHERE col.Status IN(-1,0,1) AND col.BlID=@BlID AND col.TabID=@TabID	AND col.Type=2 	

	IF @existsPart>0 AND (SELECT COUNT(*) FROM #Entry)>0
		BEGIN
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_1_IsSupport') AS [ConVertCol],IsSupport AS[ContentValue] FROM #Entry WHERE Type=1--  --������Ʒ֧�����
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_2_IsAgree') AS [ConVertCol],IsAgree AS[ContentValue] FROM #Entry WHERE Type=1--  --������Ʒ�Ƿ�ͬ��
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_3_DefectFeedBack') AS [ConVertCol],DefectFeedBack AS[ContentValue] FROM #Entry WHERE Type=1--  --������Ʒȱ�ݷ���
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('1_solPart_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_4_OtherFeedBack') AS [ConVertCol],OtherFeedBack AS[ContentValue] FROM #Entry WHERE Type=1--  --��������

			IF (@IsSupport<>'' AND @IsAgree <>'' AND @IsFeedBack <>'') OR(@IsSupport<>'' AND @IsAgree <>'' AND @IsFeedBack ='') -- 
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=1 AND IsSupport=@IsSupport AND IsAgree=@IsAgree 
					AND NOT EXISTS(SELECT 1 FROM #EntryID id WHERE id.EntryID=#Entry.EntryID)
				END
			ELSE IF @IsSupport<>'' AND @IsAgree ='' AND @IsFeedBack <>''
				BEGIN
					IF @IsFeedBack ='Y' --����
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
					IF @IsFeedBack ='Y' --����
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
	ELSE --û����Ŀ���ݣ������ڲ�����Ʒ����
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

	IF @existsIssue>0 AND (SELECT COUNT(*) FROM #Entry)>0 --ÿ������
		BEGIN
			INSERT INTO #MergeTable
			SELECT   EntryID,EntryPID,RelID,Lvl,EntryCName,Remark,Description,dictValueCh,NetName,Type,ColID,IsLeaf,EntryOrder,EntryTreeOrder,('2_solIssue_'+CONVERT(NVARCHAR(50),ColID)+'_'+Name+'_IsSupport') AS [ConVertCol],FeatureSupport AS [ContentValue] FROM #Entry  WHERE Type=2--  --ÿ�ڰ汾
		
			IF @IsSupport<>'' AND @IsAgree='' AND @IsFeedBack='' -- �Ƿ�֧�ֲ�����Ϊ��
				BEGIN
					INSERT INTO #EntryID
					SELECT EntryID FROM #Entry WHERE Type=2 AND FeatureSupport=@IsSupport
				END
		END
	ELSE --û����Ŀ����,������ÿ����������
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
  
	IF (@existsPart>0 OR @existsIssue>0) --������ת�е����ݲ�������Ŀ����
		BEGIN
			IF(SELECT COUNT(*) FROM #Entry)>0
				BEGIN
					SELECT DISTINCT [ConVertCol],ColID INTO #PartTable FROM #MergeTable WHERE Type=1 ORDER BY ColID
					SELECT DISTINCT [ConVertCol],ColID INTO #FeatureTable FROM #MergeTable WHERE Type=2 ORDER BY ColID
					SELECT [ConVertCol] INTO #OrderPartTable FROM #PartTable  --���������ı�����Ʒ
					SELECT [ConVertCol] INTO #OrderFeatureTable FROM #FeatureTable --����������ÿ�ڰ汾
					SELECT @colList=@colList+',['+[ConVertCol]+']' FROM (SELECT DISTINCT [ConVertCol] FROM #MergeTable) T 
					SELECT @colPartSelect=@colPartSelect+',MAX(['+[ConVertCol]+']) AS '+'['+[ConVertCol]+']'  FROM (SELECT [ConVertCol] FROM #OrderPartTable) T  
					SELECT @colFeatureSelect=@colFeatureSelect+',MAX(['+[ConVertCol]+']) AS '+'['+[ConVertCol]+']'  FROM (SELECT [ConVertCol] FROM #OrderFeatureTable) T 

					SELECT @colList=RIGHT(@colList,LEN(@colList)-1) 
					DROP TABLE #PartTable;DROP TABLE #FeatureTable;DROP TABLE #OrderPartTable;DROP TABLE #OrderFeatureTable;
				END
			ELSE --û����Ŀ����
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
    ELSE --��������ת������
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

	IF @IsExport=0 --��ѯ
		BEGIN
			IF @Condition<>'' OR @IsSupport<>'' OR @IsAgree<>'' OR @IsFeedBack<>''
				--�������������ݹ鵽һ����� ��¼����T1��Ȼ���һ������ҳȡ������Ҫ���Ƿ�ҳ���⣩���÷�ҳ��һ�����ݹ�ȡ�����Ӽ�T2,T1��T2ȡ�����γ���������
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
								--�����������ݹ鵽һ������������
								SELECT * INTO #ConditionResult FROM #Result result WHERE Exists(SELECT EntryID from #BottomToTop t where t.EntryID=result.EntryID) 

								DECLARE @count INT 
								--����һ�����ݸ���
								SELECT @count=COUNT(*) FROM #ConditionResult WHERE _parentId=0 
								--����ҳȡ����Ӧ�����һ����ID
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
				--û����������
				BEGIN
					IF @EntryPID=0 --��ѯһ����Ŀ��Ҫ��ҳ
						BEGIN
							SET @sql=@sql +'
								SELECT *,(SELECT COUNT(*) FROM #Result) AS TotalCount FROM #Result 
								ORDER BY EntryOrder OFFSET '
							+ CAST(( ( @PageIndex * @PageSize ) - @PageSize ) AS VARCHAR(10))
							+ ' ROWS FETCH NEXT ' + CAST(@PageSize AS VARCHAR(10))
							+ ' ROWS ONLY';
						END
					ELSE
						BEGIN --��ѯ����ʱ ��ʾ��������
							SET @sql=@sql +'
								SELECT *,(SELECT COUNT(*) FROM #Result) AS TotalCount FROM #Result ORDER BY EntryOrder'
						END
				END
		END
	ELSE IF @IsExport=1 --����(չʾΪ���νṹ Ҫ���ǵݹ���������)
		BEGIN
			IF @EntryIDs='' AND @Condition='' AND @IsSupport='' AND @IsAgree='' AND @IsFeedBack='' --���м�¼
				BEGIN
					SET @sql=@sql +'
								 SELECT r.*,(SELECT COUNT(*) FROM #Result) AS TotalCount FROM #Result r ORDER BY r.EntryTreeOrder
								 '
				END
			ELSE IF @EntryIDs='' AND (@Condition<>''  OR @IsSupport<>'' OR @IsAgree<>'' OR @IsFeedBack<>'') --ɸѡ�ؼ���
				BEGIN
					SET @sql=@sql --�ݹ鵽һ����Ŀ
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
			ELSE IF @EntryIDs<>'' --AND (@Condition='' OR @Condition<>'') --ֻҪ�й�ѡ �Ͳ��ӹؼ���������
				BEGIN
					IF @IsNeedChild=1 --��Ҫ�Ӽ� �ݹ��ȡ�����Ӽ�
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
					ELSE --����Ҫ�Ӽ� �ݹ鵽һ�����
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


