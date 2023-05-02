--修改切换前后都有的条目（且条目本身发生修改）的扩展列
with EntryChange as (
                                        select old.blEntryID OldBlEntryId,new.blEntryID NewBlEntryId from 
                                        (select rel.blEntryID,entry.entryItemID,rel.entryID
                                        from specMS_SpecBLEntryRel rel,specMS_SpecEntry entry,specMS_SpecEntryContent content
                                        where rel.blID in (16791,16792) and rel.entryID=entry.entryID
                                        and rel.entryID = content.entryID and content.isShare=1 ) old,
                                        (select rel.blEntryID,entry.entryItemID,rel.entryID
                                        from specMS_SpecBLEntryRel rel,specMS_SpecEntry entry,specMS_SpecEntryContent content
                                        where rel.blID in (16881) and rel.entryID=entry.entryID
                                        and rel.entryID = content.entryID and content.isShare=1 ) new
                                        where old.entryItemID = new.entryItemID and old.entryID<>new.entryID
                                    ),
                                    refExtColData as (
                                        select * from specMS_SpecListExtColData where blId=16880 and (blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where tabID=98099 and listblID=16880 and dataSrc<>2 and status=1 ))
                                            and tecID=24434 or
                                            blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where listblID=16880 and status=2 ) and refID=98099)
                                            and tecID=24434) 
                                        and blEntryId in (
                                        select rel.blEntryID from specMS_SpecEntryContent content,
                                        specMS_SpecBLEntryRel rel where content.entryID=rel.entryID
                                        and rel.blID in (16881) and content.isShare = 1 )
                                    )
                                    update Specms_SpecListExtColData
                                    set ImplCase = (case when ext.implCase <> refExtColData.implCase and refExtColData.implCase='2' then refExtColData.implCase ELSE ext.implCase end),
                                    SupCase=(case when ext.supCase > refExtColData.supCase THEN refExtColData.supCase ELSE ext.supCase end),
                                    mergVer = ext.mergVer,explain= ext.explain,status=0,Srcblid=16880
                                    from EntryChange
                                    INNER JOIN specMS_SpecListExtColData ON Specms_SpecListExtColData.blEntryID = EntryChange.NewBlEntryId
	                                INNER JOIN specMS_SpecListExtColData ext ON ext.blEntryID = EntryChange.OldBlEntryId AND ext.tecID = Specms_SpecListExtColData.tecID
	                                INNER JOIN refExtColData ON refExtColData.blEntryID = EntryChange.NewBlEntryId AND refExtColData.tecID = Specms_SpecListExtColData.tecID
	                                where Specms_SpecListExtColData.blID=16761  and 
									Specms_SpecListExtColData.status>-2 AND ext.blId=16761 and ext.status>-2 ;