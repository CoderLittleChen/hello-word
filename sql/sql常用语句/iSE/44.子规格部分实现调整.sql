-- =============================================
-- Author:cys2689
-- Create date: 2020-11-30
-- Description:子规格部分实现改为未实现  同时调用卷积更新父级规格的支持实现情况
-- =============================================
CREATE procedure  P_UpdateData
as
begin
	select  *  into   #tempRel   from  specMS_SpecBLEntryRel  a 
	where a.isLeaf=0 and a.flag=0;	
	Create NOnClustered Index IDX_BlEntryID1 ON #tempRel(BlEntryID);
	--Create NOnClustered Index IDX_BlEntryID2 ON #tempRel(isLeaf);
	--Create NOnClustered Index IDX_BlEntryID3 ON #tempRel(flag);
	select  *  into   #tempExtColData  from  specMS_SpecListExtColData   b
	where b.implCase=3;
	Create NOnClustered Index IDX_BlEntryID4 ON #tempExtColData(BlEntryID);
	--Create NOnClustered Index IDX_BlEntryID5 ON #tempExtColData(implCase);
	select  b.*  into   #finalDataTable     from  #tempRel   a
    inner join  #tempExtColData b on  a.blEntryID=b.blEntryID;

	select  distinct blid  into  #blidTable  from  #finalDataTable;

	select  *  from  #finalDataTable;
	--select  *  from  #blidTable;


	--更新部分实现子节点
	update  a  set  implCase=2
	from   specMS_SpecListExtColData  a
	inner join  #finalDataTable  b  on  a.extDataID=b.extDataID;

	--游标循环更新当前基线
	declare  blidCursor  cursor  for  select  *  from   #blidTable;
	declare  @newBlId  int;
	open blidCursor
	fetch next  from blidCursor  into  @newBlId;
	while @@FETCH_STATUS=0
		begin
			exec SP_UpdateSpecMSSupper @newBlId,'','','';
			fetch next  from blidCursor  into  @newBlId;
		end


	drop  table   #tempRel;
	drop  table   #tempExtColData;
	drop  table   #finalDataTable;
	drop  table   #blidTable;
	
end





