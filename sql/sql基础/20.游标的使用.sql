Alter procedure P_CopyRefEntry
(
	@currentBlId int,
	@currentTabId int,
	@refBlId int,
	@colId varchar(4000)
)
as 
begin
	--声明临时表  保存新id和旧id的关系
	create table  #tempTable
	(
		OldId int,
		NewId int
	)
	--拿到当前最大的id
	declare @maxId int;
	select @maxId= MAX(id)  from Book;
	--声明游标
	declare  idCursor  cursor   for select  id  from  Book where id<=@maxId;
	--声明变量  保存每次插入的新的id值
	declare @newId int;
	--声明变量 保存游标中的值
	declare @id  int;
	--打开游标
	open  idCursor;
	fetch next from idCursor  into  @id;
	while @@FETCH_STATUS=0
		begin 
			insert  into Book  
			select  text,pid  from  Book  a  where a.id=@id;
			--拿到返回的新的id
			set @newId=@@IDENTITY;
			--将新旧id插入临时表 
			insert  into #tempTable
			select @id,@newId;
			--print @id;
			fetch next from idCursor  into  @id;
			
		end
	close idCursor;
	--删除游标
	deallocate  idCursor;

	--更新新插入数据的父级id
	update  Book  set pid=NEWID
	from  Book  a
	inner join  #tempTable b  on  a.pid=b.OldId
	where a.id>@maxId;

	select *  from  #tempTable;

end
