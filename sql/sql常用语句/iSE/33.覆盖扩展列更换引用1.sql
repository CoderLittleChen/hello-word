----新增加的插入数据逻辑  
insert into specMS_SpecListExtColData(blEntryID, tecID, supCase, implCase, mergVer, standard, 
                                     explain, virtualSpec, xmlData, oldVersion, createTime, '1', status, blID, srcTecID, srcblID, 
                                     IsAutoMatchRVersion, param, extModifyBlId) 
                                     select blEntryID, 24299, supCase, 2, '', standard, 
                                     '', 0, xmlData, oldVersion, GETDATE(), createBy, 0, 16761, tecID, 17066, 
                                     IsAutoMatchRVersion, param, 16761 from specMS_SpecListExtColData
                                     where blID = 17066 and blEntryID in (select rel.blEntryID 
                                     from specMS_SpecBLEntryRel rel,specMS_SpecEntryContent content
                                     where rel.entryID = content.entryID and content.isShare=1 and rel.blID in (17067,17002) ) and blEntryID not in 
                                     (select new.blEntryID from specMS_SpecBLEntryRel old,specMS_SpecBLEntryRel new 
                                     where old.entryID = new.entryID and old.blID in (16880,16881) and new.blID in (17067,17002) ) and (blEntryID in ( select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where tabID=100966 and listblID=17066 and dataSrc<>2 and status=1 ))
                                            and tecID=24604 or
                                            blEntryID in (select blEntryID from specMS_SpecBLEntryRel where  blID in (
                                            select blID from specMS_TabRefBaseLine where listblID=17066 and status=2 ) and refID=100966)
                                            and tecID=24604) 