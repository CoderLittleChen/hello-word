Alter procedure P_CopyRefEntry
(
	@currentBlId int,
	@currentTabId int,
	@refBlId int,
	@colId varchar(4000)
)
as 
begin
	--������ʱ��  ������id�;�id�Ĺ�ϵ
	create table  #tempTable
	(
		OldId int,
		NewId int
	)
	--�õ���ǰ����id
	declare @maxId int;
	select @maxId= MAX(id)  from Book;
	--�����α�
	declare  idCursor  cursor   for select  id  from  Book where id<=@maxId;
	--��������  ����ÿ�β�����µ�idֵ
	declare @newId int;
	--�������� �����α��е�ֵ
	declare @id  int;
	--���α�
	open  idCursor;
	fetch next from idCursor  into  @id;
	while @@FETCH_STATUS=0
		begin 
			insert  into Book  
			select  text,pid  from  Book  a  where a.id=@id;
			--�õ����ص��µ�id
			set @newId=@@IDENTITY;
			--���¾�id������ʱ�� 
			insert  into #tempTable
			select @id,@newId;
			--print @id;
			fetch next from idCursor  into  @id;
			
		end
	close idCursor;
	--ɾ���α�
	deallocate  idCursor;

	--�����²������ݵĸ���id
	update  Book  set pid=NEWID
	from  Book  a
	inner join  #tempTable b  on  a.pid=b.OldId
	where a.id>@maxId;

	select *  from  #tempTable;

end
