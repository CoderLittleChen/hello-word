
	--ys2689
declare 	@userId varchar(10);
declare	@currentBlId int;
declare	@currentTabId int;
declare	@refBlId int;
declare	@refTabId int;
declare	@colId varchar(4000);

set @userId='00428';
set @currentBlId=1;
set @currentTabId=2;
set @refBlId=7;
set @refTabId=86;
set @colId='62,63';

begin
	--声明临时表  保存newEntryId和oldEntryId的关系
	create table  #tempTable
	(
		OldEntryId int,
		NewEntryId int
	)
	--声明临时表 保存colID字符串转换成的Table
	create table #oldColIdTable
	(
		colId int
	)
	--声明临时表  保存Sol_EntryColName新插入的ColId
	create table #newColIdTable
	(
		newColId int,
		oldColId int,
		blid int,
		tabId int
	)
	--声明临时表 保存插入Sol_EntryRelation新插入数据的RelID和EntryID
	create table #relationTable
	(
		relId int,
		newEntryId int
	)

	--调用方法将字符串转换成Table
	insert  into #oldColIdTable
	select *  from f_SplitToTable(@colId,',');
	--记录当前最大的排序id
	declare @curMaxEntryOrder int;
	--拿到当前基线下的排序最大值
	declare @maxEntryOrder int;
	select  @maxEntryOrder=MAX(EntryOrder)  from Sol_Entry  where BlID=@currentBlId;
	set  @curMaxEntryOrder=@maxEntryOrder;
	--声明游标
	declare  entryIdCursor  cursor   for select  EntryID  from  Sol_Entry where BlID=@refBlId order by EntryID;
	--声明变量  保存每次插入的新的id值
	declare @newEntryId int;
	--声明变量 保存游标中的值
	declare @oldEntryId  int;
	--声明变量 保存relation的新生成的relID
	declare @relId int;
	--打开游标
	open  entryIdCursor;
	fetch next from entryIdCursor  into  @oldEntryId;
	while @@FETCH_STATUS=0
		begin 
			--Entryorder +1
			set  @maxEntryOrder=@maxEntryOrder+1;
			--Sol_Entry复制数据
			insert  into Sol_Entry  
			select  
				 [EntryPID]
				,@currentBlId
				,[NetID]
				,@currentTabId
				,[Lvl]
				,[IsLeaf]
				,[EntryCName]
				,[EntryEName]
				,[PriorityLevel]
				,[Remark]
				,[Description]
				,GETDATE()
				,@userId
				,null
				,null
				,0
				,1
				,[DeleteFlag]
				,@maxEntryOrder
				,''
				,[IDCode]
			from  Sol_Entry  a  where a.EntryID=@oldEntryId;

			--拿到返回的新的id
			set @newEntryId=@@IDENTITY;

			--将新旧id插入临时表 
			insert  into #tempTable
			select @oldEntryId,@newEntryId;

			--关系表插入数据
			insert  into Sol_EntryRelation 
			select @newEntryId,0

			--拿到返回的新的id
			set @relId=@@IDENTITY;

			--将新的relId,entryId插入临时表 
			insert  into #relationTable
			select @relId,@newEntryId;

			print @oldEntryId;
			print @newEntryId;

			--游标移动到下一行
			fetch next from entryIdCursor  into  @oldEntryId;
			
		end
	close entryIdCursor;
	--删除游标
	deallocate  entryIdCursor;

	--更新新插入数据的父级id
	update  Sol_Entry  set EntryPID=b.NewEntryId
	from  Sol_Entry  a
	inner join  #tempTable b  on  a.EntryPID=b.OldEntryId
	where a.BlID=@currentBlId  and  a.EntryPID<>0;


	--更新EntryOrder EntryTree
	with cte as
    (
            select EntryID,EntryPID,blID,EntryOrder,(''+CAST(EntryOrder as nvarchar(max))  ) charOrder 
			from Sol_Entry 
            where EntryPID=0 and blID=@currentBlId and EntryOrder>@curMaxEntryOrder
            union all 
			select B.EntryID,B.EntryPID,B.blID,B.EntryOrder,
            cte.charOrder+'.'+CAST(b.EntryOrder as nvarchar(max)) from cte
            inner join  Sol_Entry  B  on  cte.EntryID=B.EntryPID  and   B.blID=cte.blID
    ) 
    update t1 set t1.EntryTreeOrder=cte.charOrder  from Sol_Entry t1
	inner join  cte on t1.entryID=cte.entryID  and t1.blID=@currentBlId

	--对引用的新规格  插入引用的部件产品的对应数据
	if(@colId<>'')
		begin
			--声明游标  
			declare colNameCursor  cursor  for select  a.ColID  from  #oldColIdTable  a;
			--声明变量 保存游标中的值 
			declare @oldColId int;
			--声明变量 保存每次新生成的colId
			declare @newColId int;
			--打开游标
			open colNameCursor;
			fetch next from colNameCursor  into  @oldColId;
			while	(@@FETCH_STATUS=0)
				begin
					--引用部件产品
					--Sol_EntryColName 插入数据
					insert  into  Sol_EntryColName
					select
					@currentBlId
					,@currentTabId
					,0
					,[Name]
					,0
					,1
					,[Description]
					,GETDATE()
					,@userId
					,null
					,null
					from Sol_EntryColName  a
					where a.ColID=@oldColId;
					--将生成的新的colId保存到变量中
					set @newColId=@@IDENTITY;
					--将newColid oldColid  blid  tabid  插入到临时表中
					insert into #newColIdTable
					select @newColId,@oldColId,@currentBlId,@currentTabId;

					fetch next from colNameCursor  into  @oldColId;
				end
			close colNameCursor;
			deallocate colNameCursor;

			--Sol_PartProductAttribute插入数据
			--insert into  Sol_PartProductAttribute
			--select 
			--	   a.[newColId]
			--	  ,a.blid
			--	  ,a.tabId
			--	  ,b.relId
			--	  ,[IsSupport]
			--	  ,[IsAgree]
			--	  ,[DefectFeedBack]
			--	  ,[OtherFeedBack]
			--	  ,0
			--	  ,GETDATE()
			--	  ,@userId
			--	  ,null
			--	  ,null
			--from #newColIdTable  a 
			--inner join Sol_EntryRelation b   on 1=1
			--inner join Sol_Entry  c on  b.EntryID=c.EntryID  and c.BlID=@currentBlId
			--left join Sol_PartProductAttribute   d on  a.oldColId=d.ColID

			--引用规格  引用部件产品   是否确认  是否同意  全部复制
			insert into  Sol_PartProductAttribute
			select 
				   e.[newColId]
				  ,e.blid
				  ,e.tabId
				  ,b.relId
				  ,[IsSupport]
				  ,[IsAgree]
				  ,[DefectFeedBack]
				  ,[OtherFeedBack]
				  ,0
				  ,GETDATE()
				  ,@userId
				  ,null
				  ,null
			from #tempTable  a 
			left  join  #relationTable  b  on  a.NewEntryId=b.newEntryId
			left  join  Sol_EntryRelation  c  on  a.OldEntryId=c.EntryID
			left  join  Sol_PartProductAttribute  d  on  d.RelID=c.RelID
			left  join  #newColIdTable  e  on e.oldColId=d.ColID
			
			--原规格 引用部件产品   是否确认  给默认值  其他字段为空
			insert into  Sol_PartProductAttribute
			select 
				   a.[newColId]
				  ,a.blid
				  ,a.tabId
				  ,c.relId
				  ,'Y'
				  ,''
				  ,''
				  ,''
				  ,0
				  ,GETDATE()
				  ,@userId
				  ,null
				  ,null
			from #newColIdTable  a 
			inner join Sol_Entry  b  on a.blid=b.BlID
			inner join Sol_EntryRelation c on  b.EntryID=c.EntryID
			where  not  exists(select  1 from  #tempTable  d where  b.EntryID=d.NewEntryId)

		end

	
	
	--对引用的新规格  插入原基线部件产品的对应数据
	--Sol_PartProductAttribute插入数据
	insert into  Sol_PartProductAttribute
	select 
			a.ColID
			,a.blid
			,a.tabId
			,b.relId
			,'Y'
			,''
			,''
			,''
			,0
			,GETDATE()
			,@userId
			,null
			,null
	from Sol_EntryColName  a 
	inner join Sol_EntryRelation b  on 1=1
	inner join #tempTable  c  on  b.EntryID=c.NewEntryId
    where a.BlID=@currentBlId and a.TabID=@currentTabId  and  a.Status in(0,-1)
	and  not exists(select  1 from  #newColIdTable  d  where  d.newColId=a.ColID)

	--给引用表插入数据
	insert   into  Sol_Reference
	select  @currentBlId,@refBlId,@userId,GETDATE()

	drop  table  #oldColIdTable;
	drop  table  #tempTable;
	drop  table  #newColIdTable;
	drop  table  #relationTable;
end
