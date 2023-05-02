USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[P_SolBatchDeleteEntry]    Script Date: 2021/1/27 14:23:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:cys2689
-- Create date: 2021-01-26
-- Description:批量删除规格
-- =============================================
CREATE  procedure  [dbo].[P_SolBatchDeleteEntry]
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
	
	--将字符串通过关键字分割保存到临时表
	select  *  into  #tempEntry  from   f_SplitToTable(@strParams,';');
	--声明游标
	declare  entryCursor  cursor   for   select  *  from   #tempEntry;
	declare  @tempEntryStr  nvarchar(20);
	set @tempEntryStr='';
	declare  @tempEntryPidStr nvarchar(20);
	set @tempEntryPidStr='';
	--声明临时变量 存储游标循环的值
	declare @tempStr  nvarchar(20);
	set @tempStr='';
	--打开游标
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

	--更新基线状态
	update  Sol_BaseLine  set  Status=-1  where  BlID=(select  BlID  from Sol_Entry  where  EntryID=(select  top 1  EntryID   from  #Entry));

	--zys2824 部件产品不可撤销
	----更新规格对应的部件产品状态为0的  更新为-2  
	--with cte2 as
	--(
	--	select  a.EntryID,a.EntryPid  from  #Entry 
	--	inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
	--	where  a.Status=0
	--	union all
	--	select  b.EntryId,b.EntryPid  from  cte2  
	--	inner join  Sol_Entry  b  on  cte2.EntryId=b.EntryPID
	--	where  b.DeleteFlag=0  
	--)
	--update   Sol_PartProductAttribute  set  status=-2
	--from  cte2  a  
	--inner join  Sol_EntryRelation  b  on  a.EntryId=b.EntryId  
	--inner join  Sol_PartProductAttribute  c  on  b.relId=c.relId;

	--zys2824 每期版本号不可撤销
	----更新规格对应的每期版本号 状态为0的  更新为-2  
	--with cte3 as
	--(
	--	select  a.EntryID,a.EntryPid  from  #Entry 
	--	inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
	--	where  a.Status=0
	--	union all
	--	select  b.EntryId,b.EntryPid  from  cte3
	--	inner join  Sol_Entry  b  on  cte3.EntryId=b.EntryPID
	--	where  b.DeleteFlag=0  
	--)
	--update   Sol_Features  set  status=-2
 --   from  cte3  a
 --   inner join  Sol_EntryRelation  b  on  a.EntryId=b.EntryId
 --   inner join  Sol_Features  c  on  b.relId=c.relId;


	--更新规格当前状态
	--删除的时候 规格的几种状态
	--1、新增后已保存  status=0  没有-2		backid=0
	--2、新增后未保存  status=-1   没有-2  backId=0
	--3、保存后再次修改 status=-1  有-2
	
	--Status=0   更新后  DeleteFlag=1  Status=-2
	with  cte  as
	(
		select  a.EntryID,a.EntryPid  from  #Entry 
		inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
		where  a.Status=0  and  a.DeleteFlag=0  
		union all
		select  b.EntryId,b.EntryPid  from  cte  
		inner join  Sol_Entry  b  on  cte.EntryId=b.EntryPID
	)
	update   Sol_Entry  set  deleteFlag=1,Status=-2,optType=2,Modifier=@user,ModifyTime=GETDATE()
	where  exists( select  1  from CTE   where Sol_Entry.EntryId=CTE.EntryID );

	--Status=-1  更新后  DeleteFlag=1
	with  cte1  as
	(
		select  a.EntryID,a.EntryPID  from  #Entry 
		inner join  Sol_Entry  a  on  #Entry.EntryId=a.EntryID 
		where  a.Status=-1  and  a.DeleteFlag=0  
		union all
		select  b.EntryId,b.EntryPid  from  cte1  
		inner join  Sol_Entry  b  on  cte1.EntryId=b.EntryPID
	)
	update   Sol_Entry  set  deleteFlag=1,optType=2,Modifier=@user,ModifyTime=GETDATE()
	where  exists( select  1  from CTE1   where Sol_Entry.EntryId=CTE1.EntryID );


	--更新是否为叶子节点
	update  Sol_Entry   set  
	IsLeaf=
	(case 
		when (select  count(*)  from  Sol_Entry  where  EntryPid=b.EntryPid  and Status in(0,-1) and DeleteFlag=0   )>0   then  0
		else 1  end 	
	)
	from  Sol_Entry  a
	inner join #Entry  b on  a.EntryID=b.EntryPid;

	drop  table #Entry;

end

GO


