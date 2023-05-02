declare @startDate datetime,@endDate datetime,@ProjectLevel nvarchar(6),@GroupBySql nvarchar(84),@conditionFlag nvarchar(8),@UserId nvarchar(16),
@sysRole int,@sysProjectManager int,@sysPoP int,@sysDeptManager int,@sysDeptSecretary int,@projectCode nvarchar(4000),@proTreeNode nvarchar(4000),@deptTreeNode nvarchar(4000),@rowID nvarchar(4000)
select @startDate='2019-12-01 00:00:00',@endDate='2019-12-31 00:00:00',@ProjectLevel=N'Normal',
@GroupBySql=N'  ProductLineCode,ProductLineName,PDTCode,PDTName,BVersionCode,BVersionName',
@conditionFlag=N'5,6,7,8,',@UserId=N'liucaixuan 03806',@sysRole=1,@sysProjectManager=1,@sysPoP=0,
@sysDeptManager=1,@sysDeptSecretary=0,@projectCode=N'',@proTreeNode=N'PT000183',@deptTreeNode=N'',@rowID=N''
DECLARE @Split_projectCode NVARCHAR(MAX); set  @Split_projectCode='';

--drop table  #checkedProTable;
--drop  table #tempCheckedProductInfo;
--drop  table #tempProductInfo;
create table  #checkedProTable
(
	ProCode  varchar(100)
);

create table #tempCheckedProductInfo
(
	ProCode varchar(100)
);

if(@projectCode<>'')
		begin
			set @Split_projectCode=@Split_projectCode+@projectCode;
			if(@proTreeNode<>'')
				begin
					set @Split_projectCode=@Split_projectCode+','+@proTreeNode;
					--set @Split_projectCode='dsa'
				end
		end
else 
	if(@proTreeNode<>'')
				begin
					set @Split_projectCode=@proTreeNode;
					--set @Split_projectCode=@proTreeNode
				end

--将用户选择的产品树和手动填写的部门编码保存在表中
insert  into   #checkedProTable  
select tableColumn from F_SplitStrToTable(@Split_projectCode);

--select  @Split_projectCode
--select  *  from #checkedProTable

WITH    tempCheckedProduct  AS 
	( 
		SELECT ProCode,ProLevel,ParentCode
		FROM     ProductInfo
		where DeleteFlag=0
		UNION ALL
		SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a 
		INNER JOIN tempCheckedProduct b ON  a.ParentCode=b.ProCode 
		inner join   #checkedProTable  c  on b.ProCode=c.ProCode
		where a.DeleteFlag=0  
	)
--所选的项目节点递归  然后和权限join之后保存到#tempCheckedProductInfo临时表
insert INTO #tempCheckedProductInfo
SELECT a.ProCode  FROM tempCheckedProduct  a  join #tempProductInfo  b  on  a.ProCode=b.ProCode ; 

select  *   from #tempCheckedProductInfo;