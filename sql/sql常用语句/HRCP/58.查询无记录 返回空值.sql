--查询无记录  返回值为''

select
(
case  (select COUNT(Name)  from  VEmployee  d  where LOWER(d.ChnNamePY)+' '+d.Code='流程结束')
	when  0   then  ''
	else  
	(select Name    from  VEmployee  d  where LOWER(d.ChnNamePY)+' '+d.Code='流程结束')  
end
)  as  AUTHORNAME