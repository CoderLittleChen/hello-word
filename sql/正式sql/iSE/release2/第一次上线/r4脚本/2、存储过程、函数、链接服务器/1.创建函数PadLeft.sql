-- =============================================
-- Author:cys2689
-- Create date: 2020-08-14
-- Description:	给指定字符str左侧添加paddingChar后，满足长度totalWidth
-- =============================================
use iSEDB;
go
Create function F_PadLeft
(
	--字符串对象
	@str varchar(200),
	--返回结果总长度
	@totalWidth  int,
	--补位符
	@paddingChar varchar(10)
)
returns  varchar(200)
as 
begin
	declare @returnValue  varchar(200);
	set @returnValue='';
	--if(@totalWidth<=LEN(@str))
	--	begin
	--		set @returnValue=@str;
	--	end
	--else	
	--	begin
	--		while	(@totalWidth-LEN(@str)>0)
	--			begin  
	--				set @returnValue=@returnValue+@paddingChar;
	--				set @totalWidth=@totalWidth-1;
	--			end
	--		set @returnValue=@returnValue+@str;
	--	end
	--	return @returnValue;
	--简单实现方法
	--replicate  当@totalWidth<len(@str) 返回为null
	set @returnValue= isnull(replicate(@paddingChar,@totalWidth - len(isnull(@str ,0))), '') + @str;
	return @returnValue;
end