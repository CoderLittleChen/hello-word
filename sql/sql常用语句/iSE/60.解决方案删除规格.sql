-- =============================================
-- Author:cys2689
-- Create date: 2021-01-26
-- Description:����ɾ�����
-- =============================================
Alter  procedure  P_SolBatchDeleteEntry
(
	--30|22;31|22
	@strParams  nvarchar(max),
	@user nvarchar(20)
)
as
begin
	if(OBJECT_ID('tempdb..#Entry')) is not null  drop  table  #Entry;
	create  table #Entry
	(
		EntryId  int,
		EntryPid int
	)

	if(OBJECT_ID('tempdb..#ParentEntry')) is not null  drop  table  #ParentEntry;
	create  table #ParentEntry
	(
		EntryId int,
		ChildCount int
	)
	--���ַ���ͨ���ؼ��ַָ�浽��ʱ��
	select  *  into  #tempEntry  from   f_SplitToTable(@strParams,';');
	--�����α�
	declare  entryCursor  cursor   for   select  *  from   #tempEntry;
	declare  @tempEntryStr  nvarchar(20);
	set @tempEntryStr='';
	declare  @tempEntryPidStr nvarchar(20);
	set @tempEntryPidStr='';
	--������ʱ���� �洢�α�ѭ����ֵ
	declare @tempStr  nvarchar(20);
	set @tempStr='';
	--���α�
	open  entryCursor;
	fetch  next  from  entryCursor  into   @tempStr;
	while(@@FETCH_STATUS=0) 
		begin
			set  @tempEntryStr=SUBSTRING(@tempStr,0,CHARINDEX('|',@tempStr));
			set  @tempEntryPidStr=SUBSTRING(@tempStr,CHARINDEX('|',@tempStr)+1,LEN(@tempStr)-CHARINDEX('|',@tempStr));
			insert  into  #Entry
			select  @tempEntryStr,@tempEntryPidStr
			fetch next  from  entryCursor  into  @tempStr;
		end
	close  entryCursor;
	deallocate entryCursor;

	--��EntryPid���������
	--insert  into  #EntryPid  
	--select  EntryPid  from  #Entry;


	--���»���״̬
	update  Sol_BaseLine  set  Status=-1  where  BlID=(select  BlID  from Sol_Entry  where  EntryID=(select  top 1  EntryID   from  #Entry));

	--���¹���Ӧ�Ĳ�����Ʒ״̬Ϊ0��  ����Ϊ-2  
	with cte2 as
	(
		select  a.EntryID,a.EntryPid  from  #Entry 
		inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
		where  a.Status=0
		union all
		select  b.EntryId,b.EntryPid  from  cte2  
		inner join  Sol_Entry  b  on  cte2.EntryId=b.EntryPID
		where  b.DeleteFlag=0  
	)
	update   Sol_PartProductAttribute  set  status=-2
	from  cte2  a  
	inner join  Sol_EntryRelation  b  on  a.EntryId=b.EntryId  
	inner join  Sol_PartProductAttribute  c  on  b.relId=c.relId;

	--���¹���Ӧ��ÿ�ڰ汾�� ״̬Ϊ0��  ����Ϊ-2  
	with cte3 as
	(
		select  a.EntryID,a.EntryPid  from  #Entry 
		inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
		where  a.Status=0
		union all
		select  b.EntryId,b.EntryPid  from  cte3
		inner join  Sol_Entry  b  on  cte3.EntryId=b.EntryPID
		where  b.DeleteFlag=0  
	)
	update   Sol_Features  set  status=-2
    from  cte3  a
    inner join  Sol_EntryRelation  b  on  a.EntryId=b.EntryId
    inner join  Sol_Features  c  on  b.relId=c.relId;


	--���¹��ǰ״̬
	--ɾ����ʱ�� ���ļ���״̬
	--1���������ѱ���  status=0  û��-2		backid=0
	--2��������δ����  status=-1   û��-2  backId=0
	--3��������ٴ��޸� status=-1  ��-2
	
	--Status=0   ���º�  DeleteFlag=1  Status=-2
	with  cte  as
	(
		select  a.EntryID,a.EntryPid  from  #Entry 
		inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
		where  a.Status=0  and  a.DeleteFlag=0  
		union all
		select  b.EntryId,b.EntryPid  from  cte  
		inner join  Sol_Entry  b  on  cte.EntryId=b.EntryPID
		--where  b.DeleteFlag=0  
	)
	update   Sol_Entry  set  deleteFlag=1,Status=-2,optType=2,Modifier=@user,ModifyTime=GETDATE()
	where  exists( select  1  from CTE   where Sol_Entry.EntryId=CTE.EntryID );

	--Status=-1  ���º�  DeleteFlag=1
	with  cte1  as
	(
		select  a.EntryID,a.EntryPID  from  #Entry 
		inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
		where  a.Status=-1  and  a.DeleteFlag=0  
		union all
		select  b.EntryId,b.EntryPid  from  cte1  
		inner join  Sol_Entry  b  on  cte1.EntryId=b.EntryPID
		--where  b.DeleteFlag=0  
	)
	update   Sol_Entry  set  deleteFlag=1,optType=2,Modifier=@user,ModifyTime=GETDATE()
	where  exists( select  1  from CTE1   where Sol_Entry.EntryId=CTE1.EntryID );

	--select  *  from  #Entry;

	--ɾ������ û���ӽڵ�ĸ��ڵ�  ����isLeaf�ֶ�Ϊ1
	--with  cte4  as
	--(
	--	select   a.EntryID,a.EntryPID,a.Status  from  Sol_Entry  a
	--	--inner join  #Entry   on  a.EntryID=#Entry.EntryPid
	--	where    a.EntryID in  (select distinct  EntryPID  from   #Entry)  and
	--	a.DeleteFlag=0  
	--	union all
	--	select   b.EntryID,b.EntryPID,b.Status  from  cte4  
	--	inner  join  Sol_Entry  as  b
	--	on  cte4.EntryID=b.EntryPID   and  cte4.Status in (0,-1)
	--),cte5 as
	--(
	--	select  a.EntryID,a.EntryPID  from  Sol_Entry  a
	--	inner join  #Entry   on  a.EntryID=#Entry.EntryPid
	--),cte6  as
	--(
	--	select  cte5.EntryID  from  cte5  left  join  cte4  on  cte4.EntryPID=cte5.EntryID  where  cte4.EntryID  is null and cte4.Status in (0,-1)
	--)
	--update  Sol_Entry  set IsLeaf=1 where   exists(select  1 from cte6  where Sol_Entry.EntryID=cte6.EntryID);

	update  Sol_Entry   set  
	IsLeaf=
	(
		case 
			when (select  count(*)  from  Sol_Entry  where  EntryPid=b.EntryPid  and Status in(0,-1) and DeleteFlag=0   )>0   then  0
			else 1  
		end 	
	)
	from  Sol_Entry  a
	inner join #Entry  b on  a.EntryID=b.EntryPid;

	--select  *  from  Sol_Entry  where  EntryPid in  (select  distinct  EntryPid  from  #Entry)  and Status in(0,-1);

	--select  *,
	--(select  count(*)  from  Sol_Entry  where  EntryPid in  (select  distinct  EntryPid  from  #Entry)  and Status in(0,-1)    
	--)
	--from  Sol_Entry  a
	--where  EntryID in  (select  distinct  EntryPid  from  #Entry)

	drop  table #Entry;

end