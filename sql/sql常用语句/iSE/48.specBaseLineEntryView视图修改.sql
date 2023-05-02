USE [iSEDB]
GO

/****** Object:  View [dbo].[SpecBaseLineEntryView_11]    Script Date: 2020-11-30 18:29:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[SpecBaseLineEntryView] AS
WITH specEntry AS (SELECT   dbo.specMS_SpecEntry.nodes, dbo.specMS_SpecEntry.entryID, dbo.specMS_SpecEntry.entryPID, 
                                                 dbo.specMS_SpecEntry.entryItemID, dbo.specMS_SpecEntry.entryVer, dbo.specMS_SpecEntry.lvl, 
                                                 dbo.specMS_SpecEntry.isLeaf, dbo.specMS_SpecEntry.preVer, dbo.specMS_SpecEntry.createTime, 
                                                 dbo.specMS_SpecEntry.createBy, dbo.specMS_SpecEntry.verStatus, 
                                                 dbo.specMS_SpecEntry.entrySrc, dbo.specMS_SpecEntry.optType, dbo.specMS_SpecEntry.flag, 
                                                 dbo.specMS_EntryItemID.IDCode
                                 FROM      dbo.specMS_SpecEntry WITH (NOLOCK) LEFT OUTER JOIN
                                                 dbo.specMS_EntryItemID WITH (NOLOCK) ON 
                                                 dbo.specMS_SpecEntry.entryItemID = dbo.specMS_EntryItemID.entryItemID), 
specEntryContent AS
    (SELECT   entryContent.entryCID, entryContent.entryID, entryContent.entryCode, entryContent.entryCName, 
                     entryContent.entryEName, entryContent.funcDesc, entryContent.remark, entryContent.virtualSpec, 
                     entryContent.standard, entryContent.isShare, entryContent.isPerform, entryContent.RefCount, entryContent.ImpCount, 
                     entryContent.supCase, entryContent.implCase, entryContent.mergVer, entryContent.explain, entryContent.createTime, 
                     entryContent.createBy, entryContent.entryParam, dict.dictValueCh AS ImplCaseCh, dict.dictValueEn AS ImplCaseEn, 
                     entryContent.levelOrder
     FROM      dbo.specMS_SpecEntryContent AS entryContent WITH (NOLOCK) LEFT OUTER JOIN
                     dbo.specMS_Dict AS dict WITH (NOLOCK) ON entryContent.implCase = dict.dictKey AND dict.dictParentId = 102000), 
Module AS
    (SELECT distinct   dbo.specMS_SpecModuleBLRel.blID, A.smID, A.smPID, A.smName, A.smLvl, A.mCode, A.explain, A.fspecNum, 
                     A.type, A.verTreeCode, A.mmanagerID, A.mmanager, A.orderNo, A.createBy, A.createTime, A.Release_Name
     FROM      dbo.specMS_SpecModuleBLRel WITH (NOLOCK) LEFT OUTER JOIN
                         (SELECT   dbo.specMS_SpecModule.smID, dbo.specMS_SpecModule.smPID, dbo.specMS_SpecModule.smName, 
                                          dbo.specMS_SpecModule.smLvl, dbo.specMS_SpecModule.mCode, dbo.specMS_SpecModule.explain, 
                                          dbo.specMS_SpecModule.fspecNum, dbo.specMS_SpecModule.type, 
                                          dbo.specMS_SpecModule.verTreeCode, dbo.specMS_SpecModule.mmanagerID, 
                                          dbo.specMS_SpecModule.mmanager, dbo.specMS_SpecModule.orderNo, 
                                          dbo.specMS_SpecModule.createBy, dbo.specMS_SpecModule.createTime, 
                                          dbo.Sync_ProductInfo.Release_Name
                          FROM      dbo.specMS_SpecModule WITH (NOLOCK) inner  JOIN
                                          dbo.Sync_ProductInfo WITH (NOLOCK) ON 
                                          dbo.specMS_SpecModule.verTreeCode = dbo.Sync_ProductInfo.Release_Code
						union
							SELECT   dbo.specMS_SpecModule.smID, dbo.specMS_SpecModule.smPID, dbo.specMS_SpecModule.smName, 
                                          dbo.specMS_SpecModule.smLvl, dbo.specMS_SpecModule.mCode, dbo.specMS_SpecModule.explain, 
                                          dbo.specMS_SpecModule.fspecNum, dbo.specMS_SpecModule.type, 
                                          dbo.specMS_SpecModule.verTreeCode, dbo.specMS_SpecModule.mmanagerID, 
                                          dbo.specMS_SpecModule.mmanager, dbo.specMS_SpecModule.orderNo, 
                                          dbo.specMS_SpecModule.createBy, dbo.specMS_SpecModule.createTime, 
                                          dbo.Sync_ProductInfo.BVersionName Release_Name
                          FROM      dbo.specMS_SpecModule WITH (NOLOCK) inner JOIN
                                          dbo.Sync_ProductInfo WITH (NOLOCK) ON 
                                          dbo.specMS_SpecModule.verTreeCode = dbo.Sync_ProductInfo.BVersionCode
										  ) AS A ON 
                     dbo.specMS_SpecModuleBLRel.smID = A.smID
 
), EntryModifyVer AS
    (SELECT   main.blID, main.EntryModifyVer + ' -- ' + bl.lTitle AS EntryModifyVer
     FROM      (SELECT   list.blID, idset.srcName AS EntryModifyVer
                      FROM      dbo.specMS_SpecList AS list INNER JOIN
                                      dbo.specMS_SpecDataIDSet AS idset ON list.verTreeCode = idset.srcID
                      WHERE   (list.blID <> 0)
                      UNION
                      SELECT   rel.blID, idset.srcName + ' -- ' + module.smName AS EntryModifyVer
            FROM      dbo.specMS_SpecModule AS module INNER JOIN
                                      dbo.specMS_SpecModuleBLRel AS rel ON module.smID = rel.smID INNER JOIN
                                      dbo.specMS_SpecDataIDSet AS idset ON module.verTreeCode = idset.srcID
                      WHERE   (module.type = 0)
                      UNION
                      SELECT   rel.blID, temp.tempName
                      FROM      dbo.specMS_TemplateSpec AS temp INNER JOIN
                                      dbo.specMS_TemplateSpecBLRel AS rel ON temp.tempID = rel.tempID) AS main LEFT OUTER JOIN
                     dbo.specMS_SpecBaseLine AS bl ON main.blID = bl.blID), Template AS
    (SELECT   temp.tempID, temp.tempName, rel.blID
     FROM      dbo.specMS_TemplateSpec AS temp INNER JOIN
                     dbo.specMS_TemplateSpecBLRel AS rel ON temp.tempID = rel.tempID)
    SELECT   specEntry_1.nodes, dbo.specMS_SpecBLEntryRel.blEntryID, dbo.specMS_SpecBLEntryRel.refID, 
                    dbo.specMS_SpecBLEntryRel.refBLID, dbo.specMS_SpecBLEntryRel.entryID, dbo.specMS_SpecBLEntryRel.blID, 
                    dbo.specMS_SpecBLEntryRel.specType, dbo.specMS_SpecBLEntryRel.orderNo, 
                    dbo.specMS_SpecBLEntryRel.createBy, dbo.specMS_SpecBLEntryRel.createTime, 
                    dbo.specMS_SpecBLEntryRel.flag, dbo.specMS_SpecBLEntryRel.entryPID, dbo.specMS_SpecBLEntryRel.isLeaf, 
                    dbo.specMS_SpecBLEntryRel.lvl, dbo.specMS_SpecBLEntryRel.vOrderNo, specEntry_1.entryID AS EditEntryid, 
                    specEntry_1.entryItemID, specEntry_1.entryVer, specEntry_1.preVer, specEntry_1.createTime AS EntryCreateTime, 
                    specEntry_1.createBy AS EntryCreateBy, specEntry_1.verStatus, specEntry_1.entrySrc, specEntry_1.optType, 
                    specEntry_1.flag AS EntryFlag, specEntryContent_1.entryCID, specEntryContent_1.entryCode, 
                    specEntryContent_1.entryCName, specEntryContent_1.entryEName, specEntryContent_1.funcDesc, 
                    specEntryContent_1.remark, specEntryContent_1.virtualSpec, specEntryContent_1.standard, 
                    specEntryContent_1.isShare, specEntryContent_1.isPerform, specEntryContent_1.supCase, 
                    specEntryContent_1.implCase, specEntryContent_1.mergVer, specEntryContent_1.explain, 
                    specEntryContent_1.ImpCount, specEntryContent_1.RefCount, specEntryContent_1.entryParam, 
                    dbo.specMS_SpecBaseLine.lTitle, dbo.specMS_SpecBaseLine.bLevel, dbo.specMS_SpecBaseLine.status, 
                    dbo.specMS_SpecBaseLine.dataSrc, dbo.specMS_SpecBaseLine.description, specEntry_1.IDCode, 
                    ISNULL(Module_1.smID, 0) AS smID, ISNULL(Module_1.smPID, 0) AS smPID, Module_1.smName, 
                    ISNULL(Module_1.smLvl, 0) AS smLvl, Module_1.mCode, Module_1.explain AS Mexplain, 
                    CASE WHEN specEntry_1.entrySrc = 0 THEN
                        (SELECT   TOP 1 CAST(Template.tempID AS VARCHAR)
                         FROM      Template
                         WHERE   Template.blID = specMS_SpecBLEntryRel.blID) ELSE Module_1.verTreeCode END AS verTreeCode, 
                    CASE WHEN specEntry_1.entrySrc = 0 THEN
                        (SELECT   TOP 1 Template.tempName
                         FROM      Template
                         WHERE   Template.blID = specMS_SpecBLEntryRel.blID) ELSE Module_1.Release_Name END AS ReleaseName, 
                    Module_1.mmanagerID, Module_1.mmanager, Module_1.type AS ModuleType, specEntryContent_1.ImplCaseCh, 
                    specEntryContent_1.ImplCaseEn, 0 AS IsQueryResult, dbo.specMS_SpecBLEntryRel.entryModifyBlId, 
                    EntryModifyVer_1.EntryModifyVer, specEntryContent_1.levelOrder,temp.isProduct AS IsProduct 
    FROM      dbo.specMS_SpecBLEntryRel WITH (NOLOCK) LEFT OUTER JOIN
                    specEntry AS specEntry_1 WITH (NOLOCK) ON 
            dbo.specMS_SpecBLEntryRel.entryID = specEntry_1.entryID LEFT OUTER JOIN
                    specEntryContent AS specEntryContent_1 WITH (NOLOCK) ON 
                    dbo.specMS_SpecBLEntryRel.entryID = specEntryContent_1.entryID LEFT OUTER JOIN
                    dbo.specMS_SpecBaseLine WITH (NOLOCK) ON 
                    dbo.specMS_SpecBLEntryRel.blID = dbo.specMS_SpecBaseLine.blID LEFT OUTER JOIN
                    Module AS Module_1 WITH (NOLOCK) ON dbo.specMS_SpecBLEntryRel.blID = Module_1.blID LEFT OUTER JOIN
                    EntryModifyVer AS EntryModifyVer_1 ON dbo.specMS_SpecBLEntryRel.entryModifyBlId = EntryModifyVer_1.blID
					LEFT JOIN specMS_TemplateSpecBLRel  blrel WITH (NOLOCK)  ON blrel.blID=specMS_SpecBLEntryRel.blID
					LEFT JOIN specMS_TemplateSpec temp WITH (NOLOCK)  ON temp.tempID = blrel.tempID



GO


