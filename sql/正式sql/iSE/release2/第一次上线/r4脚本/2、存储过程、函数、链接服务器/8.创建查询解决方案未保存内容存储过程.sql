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
-- Description:	��ȡ�����������δ����ĸ���
-- =============================================
CREATE PROCEDURE [dbo].[SP_SolGetEntryChangeList](
	 @BlID  INT,  --��ǰ����id
	 @TabID INT   --��ǰtabҳid
)
AS
BEGIN
	CREATE TABLE #Entry(
	     Entryid INT,
	     _parentId INT,
		 Level INT,
	     EntrycName NVARCHAR(200),
	     ModifyFlag INT, -- Ŀǰֻȡ0(�ޱ䶯)��1(�б䶯)  ----1��ʾ���� 2��ʾɾ�� 3��Ŀ�޸� 4��չ���޸� 5��Ŀ��չ�ж��޸� 6��ҳ����� 7ת�ݸ�
         Operate NVARCHAR(50),  
	   --  Remark NVARCHAR(200),
		 EntryTreeOrder NVARCHAR(MAX),
		 IsLeaf INT
	);

	--ɾ��
    INSERT INTO #Entry(Entryid,_parentId,Level,EntrycName,ModifyFlag,Operate,EntryTreeOrder,IsLeaf) 
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'ɾ��',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Entry ent 
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND ent.DeleteFlag=1

	--����
    INSERT INTO #Entry(Entryid,_parentId,Level,EntrycName,ModifyFlag,Operate,EntryTreeOrder,IsLeaf) 
	--��ĿSol_Entry
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'����',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Entry ent 
	INNER JOIN Sol_EntryRelation rel ON ent.Entryid=rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND rel.BackEntryID=0 AND ent.DeleteFlag<>-1 AND ent.Status IN(-1)

	--�޸�
    INSERT INTO #Entry(Entryid,_parentId,Level,EntrycName,ModifyFlag,Operate,EntryTreeOrder,IsLeaf) 
	--Sol_Entry��Ŀ
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'�޸�',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Entry ent 
	INNER JOIN Sol_EntryRelation rel ON ent.Entryid=rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND rel.BackEntryID<>0 AND ent.DeleteFlag<>-1 AND ent.Status IN(-1)
	UNION
	--������Ʒ
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'�޸�',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_PartProductAttribute part
	INNER JOIN Sol_EntryRelation rel ON part.RelID=rel.RelID
	INNER JOIN Sol_Entry ent ON ent.Entryid =rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND ent.DeleteFlag<>-1 AND ent.Status NOT IN(-1,-2) AND part.Status=-1
	UNION
	--ÿ������
	SELECT ent.Entryid,ent.entryPID,ent.Lvl,ent.EntrycName,1,'�޸�',ent.EntryTreeOrder,ent.IsLeaf
    FROM Sol_Features feature
	INNER JOIN Sol_EntryRelation rel ON feature.RelID=rel.RelID
	INNER JOIN Sol_Entry ent ON ent.Entryid =rel.Entryid
	WHERE ent.BlID=@BlID AND ent.TabID=@TabID AND ent.DeleteFlag<>-1 AND ent.Status NOT IN(-1,-2) AND feature.Status=-1

	 --�ݹ�������ڵ�(������#Entry�еĽڵ�)
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
	--���������ݷŵ������
	SELECT * INTO #Result FROM(
	SELECT * FROM #Entry
	UNION
	SELECT * FROM #Parent
	)T
	--���Ӽ�������޸ģ��������޸�չʾ����ʱ�����������Ӽ�չʾ
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


