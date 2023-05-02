-- =============================================
-- Author:cys2689
-- Create date: 2020-11-25
-- Description:	删除父规格下属所有子节点，更新父规格的实现  支持情况
-- =============================================
Alter procedure [dbo].[P_UpdateParentEntryWhenDelete]
(
	--父规格EntryId  字符串形式  1,2,3
	@parentEntryIdStr  varchar(2000),
	--当前子基线Id
	@subBlId int,
	--当前TabId
	@tabId int
)
as
begin
	--主基线Id
	declare @blId  int;
	select @blId=IsNull((select  listBlId from specMS_TabRefBaseLine  where blID=@subBlId   and  status=2),0);

	IF OBJECT_ID('tempdb..#ParentEntryIdTable') IS NOT NULL DROP TABLE #ParentEntryIdTable;   
	--临时表保存父级规格Id
	CREATE TABLE #ParentEntryIdTable
	(
		entryId int
	);
	insert  into  #ParentEntryIdTable 
	select  *  from  dbo.f_SplitToTable(@parentEntryIdStr,',');

	if @blId=0
		begin
			--模块
			--恢复默认值  完全支持  未实现
			update  extColData set  implCase=2
			--select  * 
			from  #ParentEntryIdTable   temp
			inner join specMS_SpecBLEntryRel  rel on  temp.entryId=rel.entryID 
			inner join specMS_SpecListExtColData  extColData  on   extColData.blEntryID=rel.blEntryID  
			where  rel.isLeaf=0  and rel.blID=@subBlId  
			and  (extColData.status=-1  or extColData.status=0) and extColData.implCase=3;
		end
	else
		begin
			--产品 平台
			--恢复默认值  完全支持  未实现
			update  extColData  set  implCase=2
			--select  * 
			from  #ParentEntryIdTable   temp
			inner join specMS_SpecBLEntryRel  rel on  temp.entryId=rel.entryID 
			inner join specMS_SpecListExtColData  extColData  on   extColData.blEntryID=rel.blEntryID  
			where  rel.isLeaf=0  and rel.blID=@subBlId   and  extColData.blID=@blId 
			and  (extColData.status=-1  or extColData.status=0) and extColData.implCase=3;
		end
	

	drop table #ParentEntryIdTable;

end
