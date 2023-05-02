USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[P_BatchEditSolEntry]    Script Date: 2020/9/9 13:52:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:cys2689		
-- Create date: 2020.08.01
-- Description:	������������༭���
-- =============================================


Create  procedure  [dbo].[P_BatchEditSolEntry]
(
	@entryIdStr  varchar(4000),
	@netWorkingId  int,
	@priorityLevelId int,
	@isBatchEditSubEntry bit,
	@isEntryConfirm bit,
	@createBy varchar(20)
)
as
begin
	set nocount on;
	--@entryIdStr��Ӧ��ʱ��
	create  table #selectEntryTable
	(
		entryId int
	)
	--������ʱ�� ����entryIdStr�ַ���ת�����
	create  table #backUpTable
	(
		entryId int
	)
	--����Ҫ�������ݵ�entryId����������ѡ�е�entryId����Ҫ����
	create  table #entryIdTable
	(
		entryId int
	)
	--��ϵ��ʱ��
	create table #relationTable
	(
		entryId int,
		backUpEntryid int
	)

	--�û���ѡ��idת���ɱ�
	insert  into  #selectEntryTable
	select  a from  dbo.f_SplitToTable(@entryIdStr,',');

	--��ȡ����һ��entryId ����ѯ����
	declare @entryId  int;
	select   @entryId=SUBSTRING(@entryIdStr,0,CHARINDEX(',',@entryIdStr));
	
	--���»���״̬
	update Sol_BaseLine SET Status = -1 
	from Sol_BaseLine  WHERE  exists
	(
		select  blId  from  Sol_Entry   where EntryID=@entryId  and Sol_BaseLine.BlID=Sol_Entry.BlID
	)

	if(@isBatchEditSubEntry=1)
		begin
			with  temp  as
			(
				select  Sol_Entry.EntryID  from Sol_Entry  
				inner join #selectEntryTable  on  Sol_Entry.EntryID=#selectEntryTable.entryId
				union all
				select  sol.EntryID  from  Sol_Entry  sol  inner join temp  on  temp.EntryID=sol.EntryPID  and sol.DeleteFlag=0 and sol.Status in(0,-1)
			)
			insert into #entryIdTable
			select distinct  entryId  from temp;
		end
	else
		begin
			with  temp  as
			(
				select  Sol_Entry.EntryID  from Sol_Entry  
				inner join #selectEntryTable  on  Sol_Entry.EntryID=#selectEntryTable.entryId
			)
			insert into #entryIdTable
			select  entryId  from temp;
		end

	--�õ�entryIdTable������Ҫ����������entryId����
	--������ɸѡ��Ҫ���ݵ�entryId
	insert  into  #backUpTable
	select  a.entryId from #entryIdTable a
	inner join  Sol_EntryRelation  b  on  a.entryId=b.EntryID  and BackEntryID=0;

	--�������� �����µ�entryId
	declare @newEntryId int;
	set @entryId=0;
	--�����α�
	declare  entryIdCursor  cursor  for  select  entryId   from  #backUpTable;
	open entryIdCursor;
	fetch next  from  entryIdCursor  into  @entryId;
	while @@FETCH_STATUS=0
		begin
			if @entryId<>0
				begin
					insert  into  Sol_Entry
					select  EntryPID,BlID,NetID,TabID,Lvl,IsLeaf,EntryCName,EntryEName,PriorityLevel,Remark,
					Description,GETDATE(),@createBy,Modifier,ModifyTime,-2,OptType,DeleteFlag,
					EntryOrder,EntryTreeOrder,IDCode 
					from  Sol_Entry  a
					where  (Status=0  or Status=-1)  and  EntryID=@entryId ;
					--�õ�������µ�id
					select  @newEntryId=@@IDENTITY;

					--����Entryid����Entryid����   ��������relation��
					insert into #relationTable
					select @entryId,@newEntryId
				end
			fetch next  from  entryIdCursor  into  @entryId;
		end
	close entryIdCursor;
	deallocate entryIdCursor;

	--��relation�� ����ԭ���id
	update  Sol_EntryRelation  set  BackEntryID=b.backUpEntryid
	from  Sol_EntryRelation  a
	inner join #relationTable  b  on a.entryId=b.EntryID;

	if(@isEntryConfirm=1)
		begin
			--��û���ݵ��ȱ���
			insert  into  Sol_PartProductAttribute
            select  a.ColId,a.BlId,a.TabId,a.RelId,a.IsSupport,a.IsAgree,
            a.DefectFeedBack,a.OtherFeedBack,-2,Getdate(),@createBy,
            a.Modifier,a.ModifyTime  
            from  Sol_PartProductAttribute a
            inner join Sol_EntryRelation  b  on a.RelID=b.RelID  
            inner join Sol_Entry  c  on  b.EntryID=c.EntryID  
			inner join #entryIdTable  d  on  c.EntryID=d.entryId
            where  c.DeleteFlag=0   and a.status=0  and  a.IsAgree<>'';

			--����Ѿ�ȷ��  ����Ƿ�ͬ��  ����
			update  Sol_PartProductAttribute  set  IsAgree='',DefectFeedBack='',OtherFeedBack='',Status=-1
			from Sol_PartProductAttribute  a
			inner join Sol_EntryRelation  b  on a.RelID=b.RelID
			inner join Sol_Entry  c  on  b.EntryID=c.EntryID
			where  c.DeleteFlag=0  and  a.IsAgree<>''  and  a.Status in (0,-1)  and  exists( select  1  from  #entryIdTable   where  #entryIdTable.EntryID=c.EntryID);
		end
	--��������ͼid  ���ȼ�
	update  Sol_Entry  set  NetID=@netWorkingId,PriorityLevel=@priorityLevelId
	from Sol_Entry  inner join   #entryIdTable   on  Sol_Entry.EntryID=#entryIdTable.EntryID

	set nocount off;

	drop table #entryIdTable;
	drop table #relationTable;
	drop table #backUpTable;
	drop table #selectEntryTable;
end



GO


