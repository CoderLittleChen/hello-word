USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[P_UpdateParentEntryWhenDelete]    Script Date: 2020-12-18 16:26:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:cys2689
-- Create date: 2020-11-25
-- Description:	ɾ����������������ӽڵ㣬���¸�����ʵ��  ֧�����
-- =============================================
ALTER procedure [dbo].[P_UpdateParentEntryWhenDelete]
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
			--where  rel.isLeaf=0  and rel.blID=@subBlId  
			where not exists
			(
				select 1  from  specMS_SpecBLEntryRel  a  where  a.entryPID=temp.entryId	and a.flag=0
			)  and rel.blID=@subBlId  
			and  (extColData.status=-1  or extColData.status=0) and extColData.implCase=3 and rel.flag=0;
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
			--where  rel.isLeaf=0  and rel.blID=@subBlId   and  extColData.blID=@blId 
			where not exists
			(
				select 1  from  specMS_SpecBLEntryRel  a  where  a.entryPID=temp.entryId	and a.flag=0
			)  and rel.blID=@subBlId   and  extColData.blID=@blId 
			and  (extColData.status=-1  or extColData.status=0) and extColData.implCase=3  and rel.flag=0;
		end
	

	drop table #ParentEntryIdTable;

end





GO


