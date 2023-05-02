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
-- Description:����������������
-- =============================================

Create procedure  [dbo].[P_SolUpgradeOrDemoteEntry]
(
	--702|697|0,705|697|0
	--702 ��ǰ���id
	--697 ��ǰ���id
	--9	  �ƶ���Ĺ��id
	@strParam varchar(4000),
	@user varchar(20)
)
as
begin
	set nocount on;
	--�Թ���ַ�����һ�δ��� 
	create  table #temp
	(
		entryIdStr  varchar(200)
	)
	--�Թ���ַ����ڶ��δ���
	create  table #strParamTable
	(
		entryId  int,
		oldEntryPid int,
		newEntryPid int,
		lvl int
	)
	--���浱ǰѡ�нڵ�������ӽڵ��Լ��ɵĸ��ڵ���µĸ��ڵ��id
	create  table  #entryIdTable
	(
		entryId int
	)
	--������Ҫ�޸�״̬�Ĺ�񼯺�
	create  table  #statusChangeTable
	(
		entryId int
	)
	--������Ҫ���ݵ�entryId����
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
	--�����α� �Բ����ַ���������
	declare  strCursor  cursor  for  select  *  from  #temp;
	--������ʱ����  �����α��ֵ
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
	
	--���»���״̬
	update Sol_BaseLine SET Status = -1 
	from Sol_BaseLine  WHERE  exists
	(
		select  blId  from  Sol_Entry   where EntryID=@currentEntryId  and Sol_BaseLine.BlID=Sol_Entry.BlID
	);

	--�жϱ���  ��Ҫ�жϵ�ǰѡ�нڵ�������ӽڵ��Լ��ɵĸ��ڵ���µĸ��ڵ�  �Ƿ���ڱ���
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

	--ɸѡ�� ��Ҫ�޸�״̬�Ĺ�񼯺�
	with  temp  as
	(
		select  Sol_Entry.EntryID  from Sol_Entry  
		inner join #strParamTable  on  Sol_Entry.EntryID=#strParamTable.entryId
		union all
		select  sol.EntryID  from  Sol_Entry  sol  inner join temp  on  temp.EntryID=sol.EntryPID  and sol.DeleteFlag=0  and sol.Status in(0,-1)
	)
	insert into #statusChangeTable
	select  distinct  entryId  from temp;

	--����ǰѡ�нڵ㼰���ӽڵ��״̬��Ϊ-1
	update  Sol_Entry  set Status=-1
	from  Sol_Entry    a
	inner join  #statusChangeTable  b  on a.EntryID=b.entryId


	--�õ�entryIdTable������Ҫ����������entryId����
	--������ɸѡ��Ҫ���ݵ�entryId
	insert  into  #backUpEntryIdTable
	select  a.entryId from #entryIdTable a
	inner join  Sol_EntryRelation  b  on  a.entryId=b.EntryID  and BackEntryID=0;

	declare @entryId int;
	declare @newEntryId int;
	set @entryId=0;
	set @newEntryId=0;
	--�����α�
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

			--�õ�������µ�id
			select  @newEntryId=@@IDENTITY;

			--����Entryid����Entryid����   ��������relation��
			insert into #relationTable
			select @entryId,@newEntryId
			fetch next  from  entryIdCursor  into  @entryId;
		end
	close entryIdCursor;
	deallocate entryIdCursor;

	--�Ա��ݹ��ĸ��ڵ����
	--update  Sol_Entry  set EntryPID=b.backUpEntryid
	--from  Sol_Entry  a
	--inner join  #relationTable b  on  a.EntryPID=b.entryId
	--where  a.Status=-2   and  a.EntryPID<>0;

	--����relation��
	update  Sol_EntryRelation  set  BackEntryID=b.backUpEntryid
	from  Sol_EntryRelation  a
	inner join #relationTable  b  on a.entryId=b.EntryID;

	--����ѡ�нڵ��entryPid lvl
	update  Sol_Entry   set  EntryPID=b.newEntryPid,Lvl=b.Lvl  from  Sol_Entry  a
	inner join #strParamTable b  on  a.EntryID=b.EntryId;

	--����ѡ�нڵ��ԭ���ڵ��isLeaf����
	update  Sol_Entry   set  
	IsLeaf=
	(case 
		when (select  count(*)  from  Sol_Entry  where  EntryPid=b.oldEntryPid and Status in(0,-1)    )>0   then  0
		else 1  end 	
	) from  Sol_Entry  a
	inner join #strParamTable  b on  a.EntryID=b.oldEntryPid;

	--����ѡ�нڵ���¸��ڵ��isLeaf
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


