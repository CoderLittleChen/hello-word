USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[SP_SolGetEntryChangeList]    Script Date: 2020/12/25 10:47:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		ys2338
-- Create date: 20200723
-- Description:	获取解决方案基线未保存的更改
-- =============================================
CREATE PROCEDURE [dbo].[SP_SolGetEntryChangeList](
	 @BlID  INT,  --当前基线id
	 @TabID INT   --当前tab页id
)
AS
BEGIN
	CREATE TABLE #Entry(
	     Entryid INT,
	     _parentId INT,
		 Level INT,
	     EntrycName NVARCHAR(200),
	     ModifyFlag INT, -- 目前只取0(无变动)，1(有变动)  ----1表示新增 2表示删除 3条目修改 4扩展列修改 5条目扩展列都修改 6跨页面剪切 7转草稿
         Operate NVARCHAR(50),  
	   --  Remark NVARCHAR(200),
		 EntryTreeOrder NVARCHAR(MAX),
		 IsLeaf INT
	);

	--删除
    INSERT INTO #Entry(Entryid,_parentId,Level,EntrycName,ModifyFlag,Operate,EntryTreeOrder,IsLeaf) 
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'删除',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Entry ent 
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND ent.DeleteFlag=1

	--新增
    INSERT INTO #Entry(Entryid,_parentId,Level,EntrycName,ModifyFlag,Operate,EntryTreeOrder,IsLeaf) 
	--条目Sol_Entry
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'新增',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Entry ent 
	INNER JOIN Sol_EntryRelation rel ON ent.Entryid=rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND rel.BackEntryID=0 AND ent.DeleteFlag<>-1 AND ent.Status IN(-1)

	--修改
    INSERT INTO #Entry(Entryid,_parentId,Level,EntrycName,ModifyFlag,Operate,EntryTreeOrder,IsLeaf) 
	--Sol_Entry条目
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'修改',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Entry ent 
	INNER JOIN Sol_EntryRelation rel ON ent.Entryid=rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND rel.BackEntryID<>0 AND ent.DeleteFlag<>-1 AND ent.Status IN(-1)
	UNION
	--部件产品
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'修改',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_PartProductAttribute part
	INNER JOIN Sol_EntryRelation rel ON part.RelID=rel.RelID
	INNER JOIN Sol_Entry ent ON ent.Entryid =rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND ent.DeleteFlag<>-1 AND ent.Status NOT IN(-1,-2) AND part.Status=-1
	UNION
	--每期特性
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'修改',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Features feature
	INNER JOIN Sol_EntryRelation rel ON feature.RelID=rel.RelID
	INNER JOIN Sol_Entry ent ON ent.Entryid =rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND ent.DeleteFlag<>-1 AND ent.Status NOT IN(-1,-2) AND feature.Status=-1

	 --递归出父级节点(不包含#Entry中的节点)
	;WITH ent
	AS
	(
		SELECT a.Entryid,a._parentId
		FROM #Entry a
		UNION ALL
		SELECT b.Entryid ,b.EntryPID AS _parentId
		FROM Sol_Entry b
		INNER JOIN ent a ON a._parentId=b.Entryid  
	)
	SELECT s.Entryid,s.EntryPID,s.Lvl AS Level, s.EntrycName,0 AS ModifyFlag,'' AS Operate,s.EntryTreeOrder ,IsLeaf
	INTO #Parent 
	FROM Sol_Entry s 
	WHERE EXISTS(
		SELECT n.Entryid FROM ent n WHERE n.Entryid=s.Entryid AND NOT EXISTS(SELECT 1 FROM #Entry o WHERE o.Entryid=n.Entryid)
	)
	--将所有数据放到结果表
	SELECT * INTO #Result FROM(
	SELECT * FROM #Entry
	UNION
	SELECT * FROM #Parent
	)T
	--有子集项本身有修改，子项无修改展示数据时，不能以有子集展示
	UPDATE #Result
	SET IsLeaf=1
	WHERE NOT EXISTS(SELECT 1 FROM #Result r WHERE r._parentId=#Result.Entryid)

	SELECT *,CASE WHEN IsLeaf=1 THEN 'open' ELSE 'closed' END state FROM #Result ORDER BY EntryTreeOrder
	--SELECT *,CASE WHEN T.IsLeaf=1 THEN 'open' ELSE 'closed' END state  FROM(
	--SELECT * FROM #Entry
	--UNION
	--SELECT * FROM #Parent
	--)T
	--ORDER BY T.EntryTreeOrder

	DROP TABLE #Entry;DROP TABLE #Parent;
END
GO


