--插入更换基线后的新增数据
--insert into specMS_SpecListExtColData(blEntryID, tecID, supCase, implCase, mergVer, standard, 
--                                     explain, virtualSpec, xmlData, oldVersion, createTime, createBy, status, blID, srcTecID, srcblID, 
--                                     IsAutoMatchRVersion, param, extModifyBlId) 

                                     select c.entryCName,a.blEntryID, 24298, a.supCase, 2, '', a.standard, 
                                     '', 0, xmlData, oldVersion, GETDATE(), a.createBy, 0, 16761, tecID, 16880, 
                                     IsAutoMatchRVersion, param, 16761 from specMS_SpecListExtColData  a
									 inner join  specMS_SpecBLEntryRel  b on a.blEntryID=b.blEntryID
									 inner join  specMS_SpecEntryContent  c  on  b.entryID=c.entryID
                                     where a.blID = 16880 and 
									 a.blEntryID in 
									(
										--要替换的基线的所有共享规格
										select rel.blEntryID 
										from specMS_SpecBLEntryRel rel,specMS_SpecEntryContent content
										where rel.entryID = content.entryID and content.isShare=1 and rel.blID in (16881) 
									) and a.blEntryID not in 
                                    (
										--原基线  引用基线2的规格
										select new.blEntryID
										--,entryContent.entryCName 
										from specMS_SpecBLEntryRel old
										inner join  specMS_SpecBLEntryRel new  on  old.entryID = new.entryID
										inner join  specMS_SpecEntryContent  entryContent  on  old.entryID=entryContent.entryID
										where  old.blID in (16791,16792) and new.blID in (16881)  and entryContent.isShare=0
									) and 
									(
										a.blEntryID in 
											(
												select blEntryID from specMS_SpecBLEntryRel where  blID in 
												(
												--16800 中的 defaultTab页
												select blID from specMS_TabRefBaseLine where tabID=98099 and listblID=16880 and dataSrc<>2 and status=1 
												)
											)
												and tecID=24434 or
										a.blEntryID in 
											(
												select blEntryID from specMS_SpecBLEntryRel where  blID in 
												(
												select blID from specMS_TabRefBaseLine where listblID=16880 and status=2 
												) and refID=98099
											)
												and tecID=24434
									) 

