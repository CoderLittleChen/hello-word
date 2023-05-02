--更新前后都有的规格
with oldExtData as (
                                    select * from specMS_SpecListExtColData where blID=16761   and blEntryID in 
                                    (select old.blEntryID from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                    where old.entryID = new.entryID and old.blID in (16880,16881) and new.blID in (17067,17002)  )
                                    ),
                                    BlEntryIds as (
                                    (select new.blEntryID newBlEntryId,old.blEntryID oldBlEntryId
                                    from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                    where  old.entryID = new.entryID and old.blID in (16880,16881) and new.blID in (17067,17002) )
                                    ),
                                    newExtData as(
                                    select ext.implCase,ext.supCase,ext.tecId,ext.Explain,ext.MergVer,BlEntryIds.newBlEntryId,BlEntryIds.oldBlEntryId
                                    from (select * from specMS_SpecListExtColData where blID=17066 and (blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where tabID=100966 and listblID=17066 and dataSrc<>2 and status=1 ))
                                            and tecID=24604 or
                                            blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where listblID=17066 and status=2 ) and refID=100966)
                                            and tecID=24604)   and blEntryId in 
                                    (select rel.blEntryID from specMS_SpecEntryContent content,
                                    specMS_SpecBLEntryRel rel where content.entryID=rel.entryID
                                    and rel.blID in (17067,17002) and content.isShare = 1  )) ext,BlEntryIds where ext.blID=17066 and 
                                    ext.blEntryID = BlEntryIds.newBlEntryId
                                    )
                                    update specMS_SpecListExtColData set 
                                    srcTecID=(select tecId from newExtData where oldBlEntryId=specMS_SpecListExtColData.blEntryID) ,
                                    Srcblid=17066,Status=0,BlEntryid=isnull((
                                    select top 1 new.blEntryID from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                    where old.entryID = new.entryID and old.blID in (16880,16881) and new.blID in (17067,17002) 
                                    and old.blEntryID = oldExtData.blEntryID),specMS_SpecListExtColData.blEntryID),
                                    Explain=(select top 1 Explain from newExtData where oldBlEntryId=specMS_SpecListExtColData.blEntryID),
                                    MergVer=(select top 1 MergVer from newExtData where oldBlEntryId=specMS_SpecListExtColData.blEntryID),
                                    ImplCase=(select top 1 ImplCase from newExtData where oldBlEntryId=specMS_SpecListExtColData.blEntryID),
                                    SupCase=(select top 1 SupCase from newExtData where oldBlEntryId=specMS_SpecListExtColData.blEntryID),
                                    ExtModifyBlId = (case when oldExtData.implCase <> '2' and 
                                    (select top 1 implCase from newExtData where
                                    oldBlEntryId=specMS_SpecListExtColData.blEntryID) ='2' or
                                    oldExtData.SupCase > (select top 1 SupCase from newExtData where
                                    oldBlEntryId=specMS_SpecListExtColData.blEntryID)
                                    then 16761 else oldExtData.extModifyBlId end)                                                                       
                                    from oldExtData
                                    inner join specMS_SpecListExtColData on specMS_SpecListExtColData.extDataID = oldExtData.extDataID
                                    INNER JOIN newExtData ON newExtData.oldBlEntryId=specMS_SpecListExtColData.blEntryID
                                    where   oldExtData.tecID=24299 ;