-- =============================================
-- Author:cys2689
-- Create date: 2020-08-14
-- Description:	��ָ���ַ�str������paddingChar�����㳤��totalWidth
-- =============================================
use iSEDB;
go
Create function F_PadLeft
(
	--�ַ�������
	@str varchar(200),
	--���ؽ���ܳ���
	@totalWidth  int,
	--��λ��
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
	--��ʵ�ַ���
	--replicate  ��@totalWidth<len(@str) ����Ϊnull
	set @returnValue= isnull(replicate(@paddingChar,@totalWidth - len(isnull(@str ,0))), '') + @str;
	return @returnValue;
end