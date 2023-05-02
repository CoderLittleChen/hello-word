Create function F_Tets
(
	@str  varchar(max),
	@spltSeparator varchar(10)
)
returns @temp  table (
	a nvarchar(300)
)
as
begin
	--ȥ���ո�	ddsa,qweqw
	set @str=RTRIM(LTRIM(@str));
	--�õ��ָ������λ��
	declare @separatorCharIndex int;
	set @separatorCharIndex=CHARINDEX(@spltSeparator,@str);
	while @separatorCharIndex>=1
		begin
			insert into @temp  (a)
			values (LEFT(@str,@separatorCharIndex-1));
			set @str=SUBSTRING(@str,@separatorCharIndex+1,LEN(@str)-@separatorCharIndex)
			set @separatorCharIndex=CHARINDEX(@spltSeparator,@str);
		end
	if(@str<>'')
		insert into @temp  (a)
			values (@str);
	return
end