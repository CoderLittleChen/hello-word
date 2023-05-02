USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[P_SolUpgradeOrDemoteEntry]    Script Date: 2020/9/14 16:59:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:cys2689
-- Create date: 2020.08.02
-- Description:解决方案规格升降级
-- =============================================

Create procedure  [dbo].[P_SolUpgradeOrDemoteEntry]
(
	--702|697|0,705|697|0
	--702 当前规格id
	--697 当前规格父id
	--9	  移动后的规格父id
	@strParam varchar(4000),
	@user varchar(20)
)
as
begin
	set nocount on;
	--对规格字符串第一次处理 
	create  table #temp
	(
		entryIdStr  varchar(200)
	)
	--对规格字符串第二次处理
	create  table #strParamTable
	(
		entryId  int,
		oldEntryPid int,
		newEntryPid int,
		lvl int
	)
	--保存当前选中节点的所有子节点以及旧的父节点和新的父节点的id
	create  table  #entryIdTable
	(
		entryId int
	)
	--保存需要修改状态的规格集合
	create  table  #statusChangeTable
	(
		entryId int
	)
	--保存需要备份的entryId集合
	create  table  #backUpEntryIdTable
	(
		entryId int
	)
	create table #relationTable
	(
		entryId int,
		backUpEntryid int
	)

	insert into  #temp
	select  *  from   dbo.f_SplitToTable(@strParam,',');
	--申明游标 对参数字符串做处理
	declare  strCursor  cursor  for  select  *  from  #temp;
	--申明临时标量  保存游标的值
	declare @entryIdStr  varchar(200);
	declare @currentEntryId int;
	declare @oldEntryPid int;
	declare @newEntryPid int;
	declare @lvl int;
	open strCursor;
	fetch next from strCursor  into @entryIdStr;
	while @@FETCH_STATUS=0
		begin
			set @currentEntryId=SUBSTRING(@entryIdStr,0,CHARINDEX('|',@entryIdStr));
			set @entryIdStr=SUBSTRING(@entryIdStr,CHARINDEX('|',@entryIdStr)+1,LEN(@entryIdStr));
			set @oldEntryPid=SUBSTRING(@entryIdStr,0,CHARINDEX('|',@entryIdStr));
			set @entryIdStr=SUBSTRING(@entryIdStr,CHARINDEX('|',@entryIdStr)+1,LEN(@entryIdStr));
			set @newEntryPid=@entryIdStr;
			if (@oldEntryPid=0 or @newEntryPid=0)
				begin
					set @lvl=1;
				end
			else 
				begin
					select @lvl=lvl+1  from  Sol_Entry  a  where  a.EntryID=@newEntryPid;
				end
			insert into #strParamTable 
			select @currentEntryId,@oldEntryPid,@newEntryPid,@lvl;
			fetch next from strCursor  into @entryIdStr;
		end
	close strCursor;
	deallocate strCursor;
	
	--更新基线状态
	update Sol_BaseLine SET Status = -1 
	from Sol_BaseLine  WHERE  exists
	(
		select  blId  from  Sol_Entry   where EntryID=@currentEntryId  and Sol_BaseLine.BlID=Sol_Entry.BlID
	);

	--判断备份  需要判断当前选中节点的所有子节点以及旧的父节点和新的父节点  是否存在备份
	with  temp  as
	(
		select  Sol_Entry.EntryID  from Sol_Entry  
		inner join #strParamTable  on  Sol_Entry.EntryID=#strParamTable.entryId
		union all
		select  Sol_Entry.EntryID  from Sol_Entry  
		inner join #strParamTable  on  Sol_Entry.EntryID=#strParamTable.oldEntryPid  
		union all
		select  Sol_Entry.EntryID  from Sol_Entry  
		inner join #strParamTable  on  Sol_Entry.EntryID=#strParamTable.newEntryPid 
		union all
		select  sol.EntryID  from  Sol_Entry  sol  inner join temp  on  temp.EntryID=sol.EntryPID  and sol.DeleteFlag=0  and sol.Status in(0,-1)
	)
	insert into #entryIdTable
	select  distinct  entryId  from temp;

	--筛选出 需要修改状态的规格集合
	with  temp  as
	(
		select  Sol_Entry.EntryID  from Sol_Entry  
		inner join #strParamTable  on  Sol_Entry.EntryID=#strParamTable.entryId
		union all
		select  sol.EntryID  from  Sol_Entry  sol  inner join temp  on  temp.EntryID=sol.EntryPID  and sol.DeleteFlag=0  and sol.Status in(0,-1)
	)
	insert into #statusChangeTable
	select  distinct  entryId  from temp;

	--将当前选中节点及其子节点的状态改为-1
	update  Sol_Entry  set Status=-1
	from  Sol_Entry    a
	inner join  #statusChangeTable  b  on a.EntryID=b.entryId


	--拿到entryIdTable是最终要操作的所有entryId集合
	--在其中筛选出要备份的entryId
	insert  into  #backUpEntryIdTable
	select  a.entryId from #entryIdTable a
	inner join  Sol_EntryRelation  b  on  a.entryId=b.EntryID  and BackEntryID=0;

	declare @entryId int;
	declare @newEntryId int;
	set @entryId=0;
	set @newEntryId=0;
	--声明游标
	declare  entryIdCursor  cursor  for  select  entryId   from  #backUpEntryIdTable;
	open entryIdCursor;
	fetch next  from  entryIdCursor  into  @entryId;
	while @@FETCH_STATUS=0
		begin
			insert  into  Sol_Entry
			select  EntryPID,BlID,NetID,TabID,Lvl,IsLeaf,EntryCName,EntryEName,PriorityLevel,Remark,
			Description,GETDATE(),@user,Modifier,ModifyTime,-2,OptType,DeleteFlag,
			EntryOrder,EntryTreeOrder,IDCode 
			from  Sol_Entry  a
			where  (Status=0  or Status=-1)  and  EntryID=@entryId ;

			--拿到插入的新的id
			select  @newEntryId=@@IDENTITY;

			--将旧Entryid和新Entryid关联   用来更新relation表
			insert into #relationTable
			select @entryId,@newEntryId
			fetch next  from  entryIdCursor  into  @entryId;
		end
	close entryIdCursor;
	deallocate entryIdCursor;

	--对备份规格的父节点更新
	--update  Sol_Entry  set EntryPID=b.backUpEntryid
	--from  Sol_Entry  a
	--inner join  #relationTable b  on  a.EntryPID=b.entryId
	--where  a.Status=-2   and  a.EntryPID<>0;

	--更新relation表
	update  Sol_EntryRelation  set  BackEntryID=b.backUpEntryid
	from  Sol_EntryRelation  a
	inner join #relationTable  b  on a.entryId=b.EntryID;

	--更新选中节点的entryPid lvl
	update  Sol_Entry   set  EntryPID=b.newEntryPid,Lvl=b.Lvl  from  Sol_Entry  a
	inner join #strParamTable b  on  a.EntryID=b.EntryId;

	--更新选中节点的原父节点的isLeaf属性
	update  Sol_Entry   set  
	IsLeaf=
	(case 
		when (select  count(*)  from  Sol_Entry  where  EntryPid=b.oldEntryPid and Status in(0,-1)    )>0   then  0
		else 1  end 	
	) from  Sol_Entry  a
	inner join #strParamTable  b on  a.EntryID=b.oldEntryPid;

	--更新选中节点的新父节点的isLeaf
	update  Sol_Entry   set  
	IsLeaf=
	(case 
		when (select  count(*)  from  Sol_Entry  where  EntryPid=b.newEntryPid  and Status in(0,-1)    )>0   then  0
		else 1  end 	
	)
	from  Sol_Entry  a
	inner join #strParamTable  b on  a.EntryID=b.newEntryPid;

	drop table #temp;
	drop table #strParamTable;
	drop table #entryIdTable;
	drop table #backUpEntryIdTable;
	drop table #relationTable;
	drop table #statusChangeTable;
end
GO


