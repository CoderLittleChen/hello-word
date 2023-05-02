select * from (select ROW_NUMBER() over(order by  levelOrder DESC ,case when blID = 16762 then 2147483647 else blID end asc,vOrderNo asc) rowNumber,
BlEntryid,Refid,Refblid,Entryid,Blid,SpecType,OrderNo,CreateBy,CreateTime,Flag,
Entrypid,IsLeaf,EditEntryid,EntryItemid,EntryVer,Lvl,PreVer,EntryCreateTime,EntryCreateBy,
VerStatus,EntrySrc,OptType,EntryFlag,Entrycid,EntryCode,EntrycName,EntryeName,FuncDesc,
Remark,VirtualSpec,Standard,IsShare,IsPerform,SupCase,ImplCase,MergVer,Explain,
LTitle,BLevel,Status,DataSrc,Description,IdCode,Smid,Smpid,SmName,SmLvl,
MCode,Mexplain,VerTreeCode,Mmanagerid,Mmanager,ReleaseName,ImplCaseCh,ImplCaseEn,vOrderNo,EntryParam,
EntryModifyBlid,EntryModifyVer,ModuleType,
(
	Select COUNT(*) from specMS_EntryDepend EntryDepend,
	(
		select * from  specMS_SpecBLEntryRel
		where blID=16761 or blId in (select blID from specMS_tabRefBaseLine where listblID=16761)
	)  SpecBLEntryRel
	Where EntryDepend.flag>-2 and SpecBLEntryRel.flag = 0  and
	EntryDepend.dependEntryID = SpecBLEntryRel.entryID and 
	EntryDepend.blId = 16761 and EntryDepend.entryID = SpecBaseLineEntryView_11.entryId) ImpCount,
	(Select COUNT(*) from specMS_EntryDepend EntryDepend,specMS_SpecBLEntryRel SpecBLEntryRel
	Where EntryDepend.flag>-2 and SpecBLEntryRel.flag = 0  and
	EntryDepend.entryID = SpecBLEntryRel.entryID and 
	( EntryDepend.srcBlId = 16762 and EntryDepend.refBlId = 0 or EntryDepend.blId = 16761 ) and 
	EntryDepend.dependEntryId = SpecBaseLineEntryView_11.entryId
) RefCount,
(select top 1 entryEditors from dbo.specMS_SpecEditor2 where 
smID in (select smID from dbo.specMS_SpecModuleBLRel where blID = 16762) 
and entryItemID = SpecBaseLineEntryView_11.entryItemID) EntryEditors, 
CASE WHEN levelOrder IS NULL OR levelOrder='' THEN '1' ELSE levelOrder END levelOrder,
	(select count(*) from [specMS_EntryAttachment] att where att.entryid=SpecBaseLineEntryView_11.entryId ) attachCount  
from SpecBaseLineEntryView_11 
                where 1=1  and (blID in (16881) and isShare=1 or flag=0 and refID=100583 and blID = 16762) and Entrypid='0' 
) SpecEntry where SpecEntry.rowNumber between 1 and 100