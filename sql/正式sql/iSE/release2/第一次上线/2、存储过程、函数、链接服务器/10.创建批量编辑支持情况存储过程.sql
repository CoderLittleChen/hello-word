USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[BatchSolExtColData_Edit]    Script Date: 2020-12-25 11:18:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--批量编辑支持情况
CREATE PROCEDURE [dbo].[BatchSolExtColData_Edit]
    @blId INT ,--基线ID
    @tabId INT ,--页面ID
    @ColIDS NVARCHAR(2000) ,--要编辑的扩展列
    @RelIDS NVARCHAR(4000) ,--选中的规格
    @type INT ,-- 1、部件产品 2、每期版本号
    @supCase NVARCHAR(50) ,--支持情况
	@Agree NVARCHAR(50),--是否同意
	@DefectFeedBack NVARCHAR(2000), --缺陷反馈
	@OtherFeedBack NVARCHAR(2000),--其他意见
    @subSpecms INT --是否处理子规格
AS

BEGIN
	IF OBJECT_ID('tempdb..#RelIDTemp') IS NOT NULL DROP TABLE #RelIDTemp;   
	CREATE TABLE #RelIDTemp(RelID int);
	IF OBJECT_ID('tempdb..#ColIDTemp') IS NOT NULL DROP TABLE #ColIDTemp;   
	CREATE TABLE #ColIDTemp( ColID int);

	INSERT INTO #ColIDTemp( ColID )
	SELECT a FROM [dbo].[f_SplitToTable](@ColIDS,',')


	IF (@subSpecms=1)
		BEGIN
			  WITH cte_child as (
				  SELECT * FROM dbo.Sol_Entry WHERE EntryID IN(
				  SELECT EntryID FROM Sol_EntryRelation WHERE RelID in (SELECT a FROM [dbo].[f_SplitToTable](@RelIDS,',')))
				  UNION all 
				  SELECT a.* from Sol_Entry a
				  INNER  JOIN cte_child b on a.EntryPID=b.EntryID
             ) 
			 INSERT INTO #RelIDTemp( RelID )
			 SELECT c.RelID FROM Sol_EntryRelation c 
			 INNER JOIN cte_child d ON c.EntryID= d.EntryID
		END
	ELSE 
		BEGIN
			 INSERT INTO #RelIDTemp( RelID )
			 SELECT a FROM [dbo].[f_SplitToTable](@RelIDS,',')
		END

	IF(@type =1)
		BEGIN
			IF(@Agree <> '')
			BEGIN
				
				DELETE FROM Sol_PartProductAttribute WHERE BlID=@blId AND TabID=@tabId AND Status=-2
				AND EXISTS(SELECT 0 FROM #RelIDTemp cc WHERE Sol_PartProductAttribute.RelID = cc.RelID);
				
				DELETE FROM Sol_Entry WHERE Status=-2
				AND EXISTS(SELECT 0 FROM Sol_EntryRelation aa WHERE EXISTS(SELECT 0 FROM #RelIDTemp cc WHERE cc.RelID=aa.RelID)
				AND aa.BackEntryID !=0 AND aa.BackEntryID = Sol_Entry.EntryID);

				UPDATE Sol_Entry SET Status = 0 WHERE Status=-1 AND 
				EXISTS(SELECT 0 FROM Sol_EntryRelation aa WHERE EXISTS(SELECT 0 FROM #RelIDTemp cc WHERE cc.RelID=aa.RelID)
				AND aa.BackEntryID !=0 AND aa.EntryID = Sol_Entry.EntryID);
				
				UPDATE Sol_EntryRelation SET BackEntryID=0 WHERE EXISTS(SELECT 0 FROM #RelIDTemp cc WHERE cc.RelID=Sol_EntryRelation.RelID);

				UPDATE Sol_PartProductAttribute SET Status=0
				WHERE BlID=@blId AND TabID=@tabId AND Status NOT IN (-2,1)
				AND EXISTS(SELECT 0 FROM #RelIDTemp b where Sol_PartProductAttribute.RelID=b.RelID);


				UPDATE Sol_PartProductAttribute SET IsAgree=@Agree,DefectFeedBack=@DefectFeedBack,OtherFeedBack=@OtherFeedBack,Status=0
				WHERE BlID=@blId AND TabID=@tabId AND Status NOT IN (-2,1)
				AND EXISTS(SELECT 0 FROM #RelIDTemp b where Sol_PartProductAttribute.RelID=b.RelID)
				AND EXISTS(SELECT 0 FROM #ColIDTemp c where Sol_PartProductAttribute.ColID = c.ColID)
            END
            ELSE
            BEGIN
				IF OBJECT_ID('tempdb..#BackAttributeTemp') IS NOT NULL DROP TABLE #BackAttributeTemp; 
				SELECT a.* INTO #BackAttributeTemp FROM dbo.Sol_PartProductAttribute a
				INNER JOIN #RelIDTemp b ON a.RelID=b.RelID
				INNER JOIN #ColIDTemp c ON a.ColID = c.ColID
				WHERE a.BlID=@blId AND a.TabID=@tabId AND a.Status NOT IN (-2,1);

				UPDATE Sol_PartProductAttribute SET IsSupport= @supCase,IsAgree='',DefectFeedBack='',OtherFeedBack='',Status=-1
				WHERE EXISTS(SELECT 0 FROM #BackAttributeTemp WHERE Sol_PartProductAttribute.AttrID=#BackAttributeTemp.AttrID);

				INSERT INTO dbo.Sol_PartProductAttribute
						( ColID , BlID ,TabID ,RelID ,IsSupport ,IsAgree ,DefectFeedBack ,OtherFeedBack ,Status,CreateTime ,CreateBy,Modifier,ModifyTime)
				SELECT ColID , BlID ,TabID ,RelID ,IsSupport ,IsAgree ,DefectFeedBack ,OtherFeedBack ,-2,CreateTime ,CreateBy,Modifier,ModifyTime FROM  #BackAttributeTemp
				WHERE Status != -1;

				UPDATE dbo.Sol_BaseLine SET Status=-1 WHERE BlID=@blId;
			END
		END
    ELSE
		BEGIN
			IF OBJECT_ID('tempdb..#BackFeaturesTemp') IS NOT NULL DROP TABLE #BackFeaturesTemp; 
			SELECT a.* INTO #BackFeaturesTemp FROM dbo.Sol_Features a
			INNER JOIN #RelIDTemp b ON a.RelID=b.RelID
			INNER JOIN #ColIDTemp c ON a.ColID = c.ColID
			WHERE a.BlID=@blId AND a.TabID=@tabId AND a.Status NOT IN (-2,1);

			UPDATE Sol_Features SET IsSupport= @supCase,Status=-1
			WHERE EXISTS(SELECT 0 FROM #BackFeaturesTemp WHERE Sol_Features.FeaID=#BackFeaturesTemp.FeaID);

			INSERT INTO dbo.Sol_Features
			        ( ColID,BlID,TabID,RelID,IsSupport,Status,CreateTime,CreateBy,Modifier,ModifyTime)
			SELECT ColID,BlID,TabID,RelID,IsSupport,-2,CreateTime,CreateBy,Modifier,ModifyTime FROM  #BackFeaturesTemp
			WHERE Status != -1;

			UPDATE dbo.Sol_BaseLine SET Status=-1 WHERE BlID=@blId;
		END
	IF OBJECT_ID('tempdb..#RelIDTemp') IS NOT NULL DROP TABLE #RelIDTemp;
	IF OBJECT_ID('tempdb..#ColIDTemp') IS NOT NULL DROP TABLE #ColIDTemp;
	IF OBJECT_ID('tempdb..#BackAttributeTemp') IS NOT NULL DROP TABLE #BackAttributeTemp;
	IF OBJECT_ID('tempdb..#BackFeaturesTemp') IS NOT NULL DROP TABLE #BackFeaturesTemp;
END




GO


