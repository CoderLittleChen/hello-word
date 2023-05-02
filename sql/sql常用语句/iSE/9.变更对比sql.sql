 IF OBJECT_ID('tempdb.. #temp1') IS NOT NULL DROP TABLE  #temp1;
                                    SELECT * INTO  #temp1 FROM (
	                                    SELECT * FROM specMS_SpecBLEntryRel 
		                                    WHERE specMS_SpecBLEntryRel.blID=15584 AND specMS_SpecBLEntryRel.flag=0
	                                    UNION
	                                    SELECT * FROM specMS_SpecBLEntryRel 
		                                    WHERE specMS_SpecBLEntryRel.blId in (select blID from specMS_tabRefBaseLine where listblID=15584) AND specMS_SpecBLEntryRel.flag=0 
                                    ) a;
                                    IF OBJECT_ID('tempdb.. #temp') IS NOT NULL DROP TABLE  #temp;
                                    SELECT specMS_SpecEntry.entryItemID,specMS_SpecEntry.entryID,specMS_SpecEntryContent.isShare,
                                            specMS_SpecEntryContent.entryCName,specMS_SpecEntryContent.entryEName INTO  #temp
                                    from specMS_SpecEntry 
	                                     INNER JOIN specMS_SpecEntryContent on specMS_SpecEntryContent.entryID=specMS_SpecEntry.entryID
	                                     WHERE specMS_SpecEntry.entryID IN(
	                                     SELECT entryID FROM  #temp1
	                                     );
										 select DISTINCT en.entryItemID as entryParentItemID, #temp1.blEntryID, #temp1.entryPID,
                                         CASE when  #temp1.blID=15584 
                                         THEN 0
                                             WHEN (SELECT status FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584)=2 THEN  #temp1.refID
                                             ELSE (SELECT tabID FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584) end refID,
				 
				                         CASE when  #temp1.blID=15584 then 0 
					                        when(SELECT status FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584)=2 THEN 0
					                        else 1 end refStatus,
                                          #temp1.lvl,sp.*,
                                         CASE when (  #temp1.blID=15584 ) 
				                              THEN  
					                              CASE when ISNULL(module.smID,'')!='' then baseLine.lTitle else temp.pageName end   ----子线 可能是通用页面，或者模块
				                              WHEN (SELECT status FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584)=2 then tab.tabTitile 
				                              WHEN (SELECT dataSrc FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584)=2
				                              THEN 
					                              (select pageName from specMS_TemplateSpec where tempName = (
						                            SELECT tabTitile from specMS_SpecListTab where tabID = (SELECT tabID FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584))
					                              )
				                              ELSE (SELECT tabTitile from specMS_SpecListTab where tabID = (SELECT tabID FROM specMS_tabRefBaseLine WHERE blID=  #temp1.blID AND listblID=15584)) 
				                              END pageName
                                        ,(select  a.ConsCNName  from  specMS_AppConstantValue a  where a.AppConstantValueID= entryConExt.Importance ) as Importance
										,(select  a.ConsCNName  from  specMS_AppConstantValue a  where a.AppConstantValueID= entryConExt.Entrysource ) as Entrysource
										,(select  a.ConsCNName  from  specMS_AppConstantValue a  where a.AppConstantValueID= entryConExt.Verificationmode ) as Verificationmode
                                        ,temp.isProduct
                                    from  #temp1 
                                    left join  #temp sp 
                                    on sp.entryID= #temp1.entryID
                                    left join specMS_SpecEntry en on en.entryID =  #temp1.entryPID 
                                    left join specMS_SpecListTab tab on  #temp1.refID = tab.tabID
                                    left join specMS_SpecModuleBLRel module on  #temp1.blID = module.blID
                                    left join specMS_SpecBaseLine baseLine on  #temp1.blID = baseLine.blID
                                    left join specMS_TemplateSpecBLRel tempbl on tempbl.blID =  #temp1.blID
                                    left join specMS_EntryContentExt entryConExt  on   #temp1.entryID=entryConExt.EntryID
                                    left join dbo.specMS_TemplateSpec temp on tempbl.tempID = temp.tempID; 
									IF OBJECT_ID('tempdb.. #temp3') IS NOT NULL DROP TABLE  #temp3;
                                    SELECT * INTO  #temp3 FROM (
	                                    SELECT * FROM specMS_SpecBLEntryRel 
		                                    WHERE specMS_SpecBLEntryRel.blID=15592 AND specMS_SpecBLEntryRel.flag=0
	                                    UNION
	                                    SELECT * FROM specMS_SpecBLEntryRel 
		                                    WHERE specMS_SpecBLEntryRel.blId in (select blID from specMS_tabRefBaseLine where listblID=15592) AND specMS_SpecBLEntryRel.flag=0 
                                    ) a;
                                    IF OBJECT_ID('tempdb.. #temp2') IS NOT NULL DROP TABLE  #temp2;
                                    SELECT specMS_SpecEntry.entryItemID,specMS_SpecEntry.entryID,specMS_SpecEntryContent.isShare,
                                            specMS_SpecEntryContent.entryCName,specMS_SpecEntryContent.entryEName INTO  #temp2
                                    from specMS_SpecEntry 
	                                     INNER JOIN specMS_SpecEntryContent on specMS_SpecEntryContent.entryID=specMS_SpecEntry.entryID
	                                     WHERE specMS_SpecEntry.entryID IN(
	                                     SELECT entryID FROM  #temp3
	                                     );
										 select DISTINCT en.entryItemID as entryParentItemID, #temp3.blEntryID, #temp3.entryPID,
                                         CASE when  #temp3.blID=15592 
                                         THEN 0
                                             WHEN (SELECT status FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592)=2 THEN  #temp3.refID
                                             ELSE (SELECT tabID FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592) end refID,
				 
				                         CASE when  #temp3.blID=15592 then 0 
					                        when(SELECT status FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592)=2 THEN 0
					                        else 1 end refStatus,
                                          #temp3.lvl,sp.*,
                                         CASE when (  #temp3.blID=15592 ) 
				                              THEN  
					                              CASE when ISNULL(module.smID,'')!='' then baseLine.lTitle else temp.pageName end   ----子线 可能是通用页面，或者模块
				                              WHEN (SELECT status FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592)=2 then tab.tabTitile 
				                              WHEN (SELECT dataSrc FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592)=2
				                              THEN 
					                              (select pageName from specMS_TemplateSpec where tempName = (
						                            SELECT tabTitile from specMS_SpecListTab where tabID = (SELECT tabID FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592))
					                              )
				                              ELSE (SELECT tabTitile from specMS_SpecListTab where tabID = (SELECT tabID FROM specMS_tabRefBaseLine WHERE blID=  #temp3.blID AND listblID=15592)) 
				                              END pageName
                                        ,(select  a.ConsCNName  from  specMS_AppConstantValue a  where a.AppConstantValueID= entryConExt.Importance ) as Importance
										,(select  a.ConsCNName  from  specMS_AppConstantValue a  where a.AppConstantValueID= entryConExt.Entrysource ) as Entrysource
										,(select  a.ConsCNName  from  specMS_AppConstantValue a  where a.AppConstantValueID= entryConExt.Verificationmode ) as Verificationmode
                                        ,temp.isProduct
                                    from  #temp3 
                                    left join  #temp2 sp 
                                    on sp.entryID= #temp3.entryID
                                    left join specMS_SpecEntry en on en.entryID =  #temp3.entryPID 
                                    left join specMS_SpecListTab tab on  #temp3.refID = tab.tabID
                                    left join specMS_SpecModuleBLRel module on  #temp3.blID = module.blID
                                    left join specMS_SpecBaseLine baseLine on  #temp3.blID = baseLine.blID
                                    left join specMS_TemplateSpecBLRel tempbl on tempbl.blID =  #temp3.blID
                                    left join specMS_EntryContentExt entryConExt  on   #temp3.entryID=entryConExt.EntryID
                                    left join dbo.specMS_TemplateSpec temp on tempbl.tempID = temp.tempID; 
									select  a.blEntryID,a.ProCategory,a.ProCategoryValue,a.VerStatus,c.entryID,a.ProdColID,b.Name   from specMS_ProColContent  a   inner join  specMS_ProductColumn  b   on  a.ProdColID=b.ProdColID   inner join  specMS_SpecBLEntryRel  c   on  a.BlEntryId=c.BlEntryId    where   a.VerStatus>-2  and  c.BlId=15584  order by  a.blEntryID,a.ProdColID ; 
									select  a.blEntryID,a.ProCategory,a.ProCategoryValue,a.VerStatus,c.entryID,a.ProdColID,b.Name   from specMS_ProColContent  a   inner join  specMS_ProductColumn  b   on  a.ProdColID=b.ProdColID   inner join  specMS_SpecBLEntryRel  c   on  a.BlEntryId=c.BlEntryId    where   a.VerStatus>-2  and  c.BlId=15592  order by  a.blEntryID,a.ProdColID; 

DROP TABLE  #temp;
DROP TABLE  #temp1;
DROP TABLE  #temp2;
DROP TABLE  #temp3;