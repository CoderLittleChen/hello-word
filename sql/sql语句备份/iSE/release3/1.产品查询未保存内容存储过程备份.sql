USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[SP_GetEntryChangeList]    Script Date: 2020/8/21 10:49:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[SP_GetEntryChangeList]    Script Date: 2017/7/14 9:22:51 ******/
-- =============================================
-- Author:		Baorenyun
-- Create date: 20140107
-- Description:	��ȡĳ�����´���ʽ�ݸ��޸ĳɿɳ����ݸ�󣬱��޸ĵĹ����Ŀ��Ϣ
-- =============================================
Alter PROCEDURE [dbo].[SP_GetEntryChangeList](
	 @currBlId int              -- ��ǰ����id�����߻����ߣ�
)AS
DECLARE @count int
DECLARE @entryBlId int --��Ŀֱ�����ҵĻ���
DECLARE @T table(entryID int,currBlid int,tabId int) 

BEGIN
	SET NOCOUNT ON;
	create table #temp(
	     Entryid int,
	     Entrypid int,
	     EntrycName nvarchar(200),
	     EntryeName nvarchar(200),
	     ModifyFlag int, --1��ʾ���� 2��ʾɾ�� 3��Ŀ�޸� 4��չ���޸� 5��Ŀ��չ�ж��޸� 6��ҳ����� 7ת�ݸ�
         Operate nvarchar(50),  
	     OldEntryid int,
	     OldEntrypid int,
	     EntryBlid int,
	     CurrBlid int,
	     Tabid int,
	     Remark nvarchar(200)
	);

	insert into @T
	select main.entryID,main.currBlid,main.tabId from 
	(
		--select rel.entryID,rel.refID tabId,
		--case when (select count(*) from specMS_TabRefBaseLine where blID = rel.blID and status=2 AND listblID=@currBlId )>0
		--then ( select top 1 ref.listblID from specMS_TabRefBaseLine ref 
		--where ref.status = 2 and ref.blID = rel.blID)
		--else rel.blID end currBlid
		--from specMS_SpecBLEntryRel rel

		select rel.entryID,rel.refID tabId,rel.blID currBlid
		from specMS_SpecBLEntryRel rel WHERE rel.blID =@currBlId
		UNION
		select  rel.entryID,rel.refID tabId,ref.listblID currBlid from specMS_TabRefBaseLine ref
		INNER JOIN specMS_SpecBLEntryRel rel ON ref.blID = rel.blID 
		WHERE ref.status=2 AND ref.listblID=@currBlId
		UNION
		select rel.entryID,tabRef.tabID,
		tabRef.listblID currBlid from 
		specMS_SpecBLEntryRel rel,
		specMS_TabRefBaseLine tabRef,
		specMS_SpecEntryContent content
		WHERE tabRef.listblID=@currBlId AND rel.flag = 0 and rel.blID = tabRef.blID and tabRef.status = 1 
		      and content.entryID = rel.entryID and content.isShare = 1
	) main
	where main.currBlid = @currBlId

	select @count=COUNT(*) from dbo.specMS_SpecList where blID = @currBlId;
	
	if @count>0
	begin
	  select @entryBlId = blID from dbo.specMS_TabRefBaseLine where listblID = @currBlId and status = 2;
	end
	else
	begin
	  select @entryBlId = @currBlId;
	end

    --ɾ��
    insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,Tabid) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,2,'ɾ��',rel.entryID,rel.blID,@currBlId,t.tabId
    from specMS_SpecEntryContent content,specMS_SpecEntry entry,specMS_SpecBLEntryRel rel,@T t
	where  content.entryID = rel.entryID and rel.flag = -1
	and rel.blID=@entryBlId and t.entryID=rel.entryID
	and rel.entryID=entry.entryID and entry.verStatus!=-1;

    --��Ŀ�޸�
    insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,OldEntrypid,Tabid,Remark) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,3,'�޸�',change.oldEntryID,rel.blID,@currBlId,change.newPID,t.tabId,
    case when change.oldTabId>0 then
    '��ҳ�����:'+ (select top 1 tabTitile from specMS_SpecListTab where tabID = change.oldTabId ) + '-->' +
	(select top 1 tabTitile from specMS_SpecListTab where tabID = t.tabId )
	else ''
	end Remark
    from specMS_SpecEntryContent content,specMS_SpecBLEntryRel rel,specMS_SpecEntryChangeRel change,@T t
    where content.entryID=rel.entryID and rel.entryID = change.entryID 
    and (change.entryID = change.oldEntryID and change.newPID != 0 
    and (select COUNT(*) from specMS_SpecEntryChangeRel where change.newPID=oldEntryID and blID = @entryBlId
    and change.secID > secID) = 0 and rel.lvl != change.oldLvl
    or change.entryID = change.oldEntryID and rel.lvl != change.oldLvl
    or change.entryID != change.oldEntryID)
    and change.blID=rel.blID and change.blID = @entryBlId
    and rel.entryID = t.entryID 

    --��ҳ�����
    insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,OldEntrypid,Tabid,Remark) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,6,'��ҳ�����',change.oldEntryID,rel.blID,@currBlId,change.newPID,t.tabId,
	(select top 1 tabTitile from specMS_SpecListTab where tabID = change.oldTabId) + '-->' +
	(select top 1 tabTitile from specMS_SpecListTab where tabID = t.tabId) Remark
    from specMS_SpecEntryContent content,specMS_SpecBLEntryRel rel,specMS_SpecEntryChangeRel change,@T t
    where content.entryID=rel.entryID and rel.entryID = change.entryID 
    and change.entryID = change.oldEntryID and change.oldLvl =1 and change.oldTabId>0
    and change.blID=rel.blID and change.blID = @entryBlId
    and rel.entryID = t.entryID
    and change.entryID not in (select Entryid from #temp);

    --��չ���޸�
    insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,Tabid) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,4,'�޸�',rel.entryID,rel.blID,@currBlId,t.tabId
    from specMS_SpecEntryContent content,specMS_SpecBLEntryRel rel,@T t
    where content.entryID = rel.entryID and rel.flag = 0
	and rel.blID in (select blID from specMS_TabRefBaseLine where listblID= @currBlId  union select @currBlId)
	and rel.entryID in (
		select entryID from dbo.specMS_StandardSupport where blID = @currBlId
		and flag = 1 and status = -2 
		union
		select entryID from specMS_EntryParam where blID = @currBlId and type = 1 and status=-2 
		union 
		select rel.entryID from dbo.specMS_SpecListExtColData ext,dbo.specMS_SpecBLEntryRel rel
		where  ext.blID = @currBlId and ext.status = -2 and ext.blEntryID=rel.blEntryID 
		
	)
	and rel.entryID not in (select Entryid from #temp where ModifyFlag = 3)
	and rel.entryID = t.entryID

	--��Ʒ���޸�
	insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,Tabid) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,8,'�޸�',rel.entryID,rel.blID,@currBlId,t.tabId
    from specMS_SpecEntryContent content,specMS_SpecBLEntryRel rel,@T t
    where content.entryID = rel.entryID and rel.flag = 0
	and rel.blID in (select blID from specMS_TabRefBaseLine where listblID= @currBlId  union select @currBlId)
	and rel.entryID in (
		select entryID from specMS_EntryParam where blID = @currBlId and type = 2 and status=-2 
		union 
		select rel.entryID from dbo.specMS_ProColContent ext,dbo.specMS_ProductColumn procol
		where ext.verStatus = -2 and procol.blID = @currBlId AND procol.prodColID =  ext.ProdColID AND ext.blentryID=rel.blentryID
	)
	and rel.entryID not in (select Entryid from #temp where ModifyFlag = 8)
	and rel.entryID = t.entryID

    --��Ŀ����չ�ж����޸�
    update #temp set ModifyFlag = 5 where entryID in (
		select entryID from dbo.specMS_StandardSupport where blID = @currBlId
		and flag = 1 and status = -2
		union 
		select entryID from specMS_EntryParam where blID = @currBlId and type = 1 and status=-2
		union
		select rel.entryID from dbo.specMS_SpecListExtColData ext,dbo.specMS_SpecBLEntryRel rel
		where ext.blEntryID=rel.blEntryID and ext.status = -2 
		and ext.blID = @currBlId
	);

	--����
	insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,Tabid) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,1,'����',rel.entryID,rel.blID,@currBlId,t.tabId
    from dbo.specMS_SpecEntry entry,specMS_SpecEntryContent content,specMS_SpecBLEntryRel rel,@T t
	where entry.entryID = content.entryID and entry.entryID = rel.entryID and entry.optType = 1 
	and entry.verStatus = -1 and rel.blID = @entryBlId and rel.flag=0 
	and entry.entryID = t.entryID
    and entry.entryID not in (
    select Entryid from #temp   );


    --�ݹ�������ڵ�
	with cte_child
	as
	(
		--��ʼ����
		select a.Entryid,a.Entrypid,a.EntryBlid,a.ModifyFlag
		from #temp a
		union all
		--�ݹ�����
		select a.entryID Entryid,a.entryPID Entrypid,a.blID EntryBlid,0 ModifyFlag 
		from specMS_SpecBLEntryRel a 
		inner join 
		cte_child b
		on ( a.entryID=b.Entrypid and a.blID = b.EntryBlid) 
	)

    insert into #temp(Entryid,Entrypid,EntrycName,EntryeName,ModifyFlag,Operate,OldEntryid,EntryBlid,CurrBlid,Tabid) 
	select rel.entryID,rel.entryPID,content.entryCName,content.entryEName,0,'',rel.entryID,rel.blID,@currBlId,t.tabId
	from specMS_SpecEntryContent content,specMS_SpecBLEntryRel rel,cte_child cte,@T t
	where content.entryID = rel.entryID and rel.entryID= cte.Entryid and cte.ModifyFlag = 0
	and rel.blID = cte.EntryBlid and content.entryID = t.entryID ;

	select * from #temp where ModifyFlag>0 
	union
	select * from #temp where ModifyFlag = 0 and 
	Entryid not in (select Entryid from #temp where ModifyFlag>0 )
	--ת�ݸ�
	union
	select change.entryID,change.newPID,content.entryCName,content.entryEName,7,'ת�ݸ�',change.oldEntryID,0,@currBlId,change.newPID,0,
    'ת������:'+
    case when
	(select module.type from  specMS_SpecModule module, specMS_SpecModuleBLRel rel where
	rel.smID = module.smID and
	rel.blId=change.oldBLID)=0 then
	(select module.smName from  specMS_SpecModule module, specMS_SpecModuleBLRel rel where
	rel.smID = module.smID and
	rel.blId=change.oldBLID) +'--'
	else ''
	end  +
    (select lTitle from specMS_SpecBaseLine where 
    blID= isnull((select top 1 listblID from dbo.specMS_TabRefBaseLine where blID=change.oldBLID and status=2),change.oldBLID)) Remark
    from specMS_SpecEntryContent content,specMS_SpecEntryChangeRel change
    where content.entryID=change.entryID and change.oldBLID>0
    and change.blID = @entryBlId;

    IF OBJECT_ID(N'tempdb.dbo.#temp', N'U') IS NOT NULL  
    BEGIN  
      DROP TABLE #temp;
    END  	
	SET NOCOUNT OFF;	
END;


GO


