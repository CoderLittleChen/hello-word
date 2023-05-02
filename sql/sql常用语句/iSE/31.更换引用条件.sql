--非所选自定义页面的共享规格  支持情况默认不涉及   

--更换时候  选中页面包含自定义页面规格  执行sql

--insert into specMS_SpecListExtColData(blEntryID, tecID, supCase, implCase, mergVer, standard, 
--                                     explain, virtualSpec, xmlData, oldVersion, createTime, createBy, status, blID, srcTecID, srcblID, 
--                                     IsAutoMatchRVersion, param, extModifyBlId) 
--                                     select blEntryID, 24298, -1, 2, '', standard, 
--                                     '', 0, xmlData, oldVersion, GETDATE(), createBy, 0, 16761, tecID, 17066, 
--                                     IsAutoMatchRVersion, param, 16761 from specMS_SpecListExtColData
--                                     where blID = 17066 and blEntryID in (select rel.blEntryID 
--                                     from specMS_SpecBLEntryRel rel,specMS_SpecEntryContent content
--                                     where rel.entryID = content.entryID and content.isShare=1 and rel.blID in (17067,17002) ) and blEntryID not in 
--                                     (
--                                        select new.blEntryID
--										from specMS_SpecBLEntryRel old
--										inner join  specMS_SpecBLEntryRel new  on  old.entryID = new.entryID
--										inner join  specMS_SpecEntryContent  entryContent  on  old.entryID=entryContent.entryID
--										where  old.blID in (16880,16881) and new.blID in (17067,17002)  and entryContent.isShare=0
--                                     ) and (
--                                            blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
--                                            select blID from specMS_TabRefBaseLine where listblID=17066 and status=2 ) and refID!=100966)
--                                            and tecID=24604  
--                                        ) 


--更换时候  选中页面不包含自定义页面规格  执行sql