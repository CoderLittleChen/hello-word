
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
	--������ʱ��  ����newEntryId��oldEntryId�Ĺ�ϵ
	create table  #tempTable
	(
		OldEntryId int,
		NewEntryId int
	)
	--������ʱ�� ����colID�ַ���ת���ɵ�Table
	create table #oldColIdTable
	(
		colId int
	)
	--������ʱ��  ����Sol_EntryColName�²����ColId
	create table #newColIdTable
	(
		newColId int,
		oldColId int,
		blid int,
		tabId int
	)
	--������ʱ�� �������Sol_EntryRelation�²������ݵ�RelID��EntryID
	create table #relationTable
	(
		relId int,
		newEntryId int
	)

	--���÷������ַ���ת����Table
	insert  into #oldColIdTable
	select *  from f_SplitToTable(@colId,',');
	--��¼��ǰ��������id
	declare @curMaxEntryOrder int;
	--�õ���ǰ�����µ��������ֵ
	declare @maxEntryOrder int;
	select  @maxEntryOrder=MAX(EntryOrder)  from Sol_Entry  where BlID=@currentBlId;
	set  @curMaxEntryOrder=@maxEntryOrder;
	--�����α�
	declare  entryIdCursor  cursor   for select  EntryID  from  Sol_Entry where BlID=@refBlId order by EntryID;
	--��������  ����ÿ�β�����µ�idֵ
	declare @newEntryId int;
	--�������� �����α��е�ֵ
	declare @oldEntryId  int;
	--�������� ����relation�������ɵ�relID
	declare @relId int;
	--���α�
	open  entryIdCursor;
	fetch next from entryIdCursor  into  @oldEntryId;
	while @@FETCH_STATUS=0
		begin 
			--Entryorder +1
			set  @maxEntryOrder=@maxEntryOrder+1;
			--Sol_Entry��������
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

			--�õ����ص��µ�id
			set @newEntryId=@@IDENTITY;

			--���¾�id������ʱ�� 
			insert  into #tempTable
			select @oldEntryId,@newEntryId;

			--��ϵ���������
			insert  into Sol_EntryRelation 
			select @newEntryId,0

			--�õ����ص��µ�id
			set @relId=@@IDENTITY;

			--���µ�relId,entryId������ʱ�� 
			insert  into #relationTable
			select @relId,@newEntryId;

			print @oldEntryId;
			print @newEntryId;

			--�α��ƶ�����һ��
			fetch next from entryIdCursor  into  @oldEntryId;
			
		end
	close entryIdCursor;
	--ɾ���α�
	deallocate  entryIdCursor;

	--�����²������ݵĸ���id
	update  Sol_Entry  set EntryPID=b.NewEntryId
	from  Sol_Entry  a
	inner join  #tempTable b  on  a.EntryPID=b.OldEntryId
	where a.BlID=@currentBlId  and  a.EntryPID<>0;


	--����EntryOrder EntryTree
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

	--�����õ��¹��  �������õĲ�����Ʒ�Ķ�Ӧ����
	if(@colId<>'')
		begin
			--�����α�  
			declare colNameCursor  cursor  for select  a.ColID  from  #oldColIdTable  a;
			--�������� �����α��е�ֵ 
			declare @oldColId int;
			--�������� ����ÿ�������ɵ�colId
			declare @newColId int;
			--���α�
			open colNameCursor;
			fetch next from colNameCursor  into  @oldColId;
			while	(@@FETCH_STATUS=0)
				begin
					--���ò�����Ʒ
					--Sol_EntryColName ��������
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
					--�����ɵ��µ�colId���浽������
					set @newColId=@@IDENTITY;
					--��newColid oldColid  blid  tabid  ���뵽��ʱ����
					insert into #newColIdTable
					select @newColId,@oldColId,@currentBlId,@currentTabId;

					fetch next from colNameCursor  into  @oldColId;
				end
			close colNameCursor;
			deallocate colNameCursor;

			--Sol_PartProductAttribute��������
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

			--���ù��  ���ò�����Ʒ   �Ƿ�ȷ��  �Ƿ�ͬ��  ȫ������
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
			
			--ԭ��� ���ò�����Ʒ   �Ƿ�ȷ��  ��Ĭ��ֵ  �����ֶ�Ϊ��
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

	
	
	--�����õ��¹��  ����ԭ���߲�����Ʒ�Ķ�Ӧ����
	--Sol_PartProductAttribute��������
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

	--�����ñ��������
	insert   into  Sol_Reference
	select  @currentBlId,@refBlId,@userId,GETDATE()

	drop  table  #oldColIdTable;
	drop  table  #tempTable;
	drop  table  #newColIdTable;
	drop  table  #relationTable;
end
