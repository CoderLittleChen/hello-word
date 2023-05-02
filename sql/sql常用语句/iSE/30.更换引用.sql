-- 修改切换前后都有的条目(且条目本身没有修改)的扩展列
with oldExtData as (
									--当前引用基线下的规格
                                    select * from specMS_SpecListExtColData where blID=16761   and blEntryID in 
                                    (select old.blEntryID from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                    where old.entryID = new.entryID and old.blID in (16791,16792) and new.blID in (16881) )
									--and (blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
         --                                   select blID from specMS_TabRefBaseLine where tabID=98099 and listblID=16880 and dataSrc<>2 and status=1 ))
         --                                   and tecID=24434 or
         --                                   blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
         --                                   select blID from specMS_TabRefBaseLine where listblID=16880 and status=2 ) and refID=98099)
         --                                   and tecID=24434) 
                                    ),
                                    BlEntryIds as (
									--当前基线规格的blEntryId和新基线规格的blEntryId 对应关系
                                    (select new.blEntryID newBlEntryId,old.blEntryID oldBlEntryId
                                    from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                    where  old.entryID = new.entryID and old.blID in (16791,16792) and new.blID in (16881) )
                                    ),
                                    newExtData as(

                                    select ext.implCase,ext.supCase,ext.tecId,BlEntryIds.newBlEntryId,BlEntryIds.oldBlEntryId
                                    from (select * from specMS_SpecListExtColData where blID=16880   and (blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where tabID=98099 and listblID=16880 and dataSrc<>2 and status=1 ))
                                            and tecID=24434 or
                                            blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where listblID=16880 and status=2 ) and refID=98099)
                                            and tecID=24434) 
									and blEntryId in 
                                    (select rel.blEntryID from specMS_SpecEntryContent content,
                                    specMS_SpecBLEntryRel rel where content.entryID=rel.entryID
                                    and rel.blID in (16881) and content.isShare = 1 ) ) ext,BlEntryIds where ext.blID=16880 and 
                                    ext.blEntryID = BlEntryIds.newBlEntryId

									)

									--select  *  from  newExtData  a;

                                    --UPDATE specMS_SpecListExtColData SET
									select *,
                                    srcTecID=(select tecId from newExtData where oldBlEntryId=specMS_SpecListExtColData.blEntryID) ,
                                    Srcblid=16880,Status=0,
	                                BlEntryid=isnull((
                                    select new.blEntryID from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                    where old.entryID = new.entryID and old.blID in (16791,16792) and new.blID in (16881) 
                                    and old.blEntryID = oldExtData.blEntryID),specMS_SpecListExtColData.blEntryID),

                                    ImplCase= (case when oldExtData.implCase <> '2' and newExtData.implCase ='2' then '2' else specMS_SpecListExtColData.implCase end),

                                    SupCase = (case when oldExtData.SupCase > newExtData.SupCase then newExtData.SupCase else specMS_SpecListExtColData.SupCase end),

                                    ExtModifyBlId = (case when oldExtData.implCase <> '2' and newExtData.implCase  ='2' OR oldExtData.SupCase > newExtData.SupCase
                                    then 16761 else oldExtData.extModifyBlId end)                                                                       
                                    from oldExtData 
	                                INNER JOIN specMS_SpecListExtColData on specMS_SpecListExtColData.extDataID = oldExtData.extDataID  --and specMS_SpecListExtColData.tecID=24299
	                                INNER JOIN newExtData ON newExtData.oldBlEntryId=specMS_SpecListExtColData.blEntryID
                                