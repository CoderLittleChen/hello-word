--refExt
entryId in ( select entryId from specMS_SpecBLEntryRel where   blID in (
select blID from specMS_TabRefBaseLine where tabID=82215 and listblID=15609 and dataSrc<>2 and status=1))
and extColID=22882 or
entryId in (select entryId from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82215)

and extColID=22882 or entryId in ( select entryId from specMS_SpecBLEntryRel where   blID in (
select blID from specMS_TabRefBaseLine where tabID=82209 and listblID=15609 and dataSrc<>2 and status=1))
and extColID=22882 or
entryId in (select entryId from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82209)

and extColID=22882 or entryId in ( select entryId from specMS_SpecBLEntryRel where   blID in (
select blID from specMS_TabRefBaseLine where tabID=82218 and listblID=15609 and dataSrc<>2 and status=1))
and extColID=22882 or
entryId in (select entryId from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82218)

and extColID=22882 or entryId in ( select entryId from specMS_SpecBLEntryRel where   blID in (
select blID from specMS_TabRefBaseLine where tabID=82212 and listblID=15609 and dataSrc<>2 and status=1))
and extColID=22882 or
entryId in (select entryId from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82212)

and extColID=22882 or entryId in ( select entryId from specMS_SpecBLEntryRel where   blID in (
select blID from specMS_TabRefBaseLine where tabID=82210 and listblID=15609 and dataSrc<>2 and status=1))
and extColID=22882 or
entryId in (select entryId from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82210)

and extColID=22882 or entryId in ( select entryId from specMS_SpecBLEntryRel where   blID in (
select blID from specMS_TabRefBaseLine where tabID=82198 and listblID=15609 and dataSrc<>2 and status=1))
and extColID=22882 or
entryId in (select entryId from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82198)
and extColID=22882

--blEntryID
blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where tabID=82215 and listblID=15609 and dataSrc<>2 and status=1 ))
and tecID=22882 or
blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82215)

and tecID=22882 or blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where tabID=82209 and listblID=15609 and dataSrc<>2 and status=1 ))
and tecID=22882 or
blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82209)

and tecID=22882 or blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where tabID=82218 and listblID=15609 and dataSrc<>2 and status=1 ))
and tecID=22882 or
blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82218)

and tecID=22882 or blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where tabID=82212 and listblID=15609 and dataSrc<>2 and status=1 ))
and tecID=22882 or
blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82212)

and tecID=22882 or blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where tabID=82210 and listblID=15609 and dataSrc<>2 and status=1 ))
and tecID=22882 or
blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82210)

and tecID=22882 or blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where tabID=82198 and listblID=15609 and dataSrc<>2 and status=1 ))
and tecID=22882 or
blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
select blID from specMS_TabRefBaseLine where listblID=15609 and status=2 ) and refID=82198)
and tecID=22882


insert into specMS_SpecListExtColData(blEntryID, tecID, supCase, implCase, mergVer, standard, 
explain, virtualSpec, xmlData, oldVersion, createTime, createBy, status, blID, srcTecID, srcblID, 
IsAutoMatchRVersion, param, extModifyBlId) 
select blEntryID, {0}, {1}, {2}, '', standard, 
'', 0, xmlData, oldVersion, GETDATE(), createBy, 0, {3}, tecID, {4}, 
IsAutoMatchRVersion, param, {3} 
from specMS_SpecListExtColData
where blID = {4} and blEntryID in 
(
	select rel.blEntryID 
	from specMS_SpecBLEntryRel rel,specMS_SpecEntryContent content
	where rel.entryID = content.entryID and content.isShare=1 and rel.blID in ({5})  
) and blEntryID not in 
(
	select new.blEntryID from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
	where old.entryID = new.entryID and old.blID in ({6}) and new.blID in ({5}) )