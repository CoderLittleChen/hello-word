-- =============================================
-- Author:cys2689
-- Create date: 2020-11-25
-- Description:	ɾ����������������ӽڵ㣬���¸�����ʵ��  ֧�����
-- =============================================
Alter procedure [dbo].[P_UpdateParentEntryWhenDelete]
(
	--�����EntryId  �ַ�����ʽ  1,2,3
	@parentEntryIdStr  varchar(2000),
	--��ǰ�ӻ���Id
	@subBlId int,
	--��ǰTabId
	@tabId int
)
as
begin
	--������Id
	declare @blId  int;
	select @blId=IsNull((select  listBlId from specMS_TabRefBaseLine  where blID=@subBlId   and  status=2),0);

	IF OBJECT_ID('tempdb..#ParentEntryIdTable') IS NOT NULL DROP TABLE #ParentEntryIdTable;   
	--��ʱ���游�����Id
	CREATE TABLE #ParentEntryIdTable
	(
		entryId int
	);
	insert  into  #ParentEntryIdTable 
	select  *  from  dbo.f_SplitToTable(@parentEntryIdStr,',');

	if @blId=0
		begin
			--ģ��
			--�ָ�Ĭ��ֵ  ��ȫ֧��  δʵ��
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
			--��Ʒ ƽ̨
			--�ָ�Ĭ��ֵ  ��ȫ֧��  δʵ��
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
