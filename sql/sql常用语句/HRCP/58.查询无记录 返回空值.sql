--��ѯ�޼�¼  ����ֵΪ''

select
(
case  (select COUNT(Name)  from  VEmployee  d  where LOWER(d.ChnNamePY)+' '+d.Code='���̽���')
	when  0   then  ''
	else  
	(select Name    from  VEmployee  d  where LOWER(d.ChnNamePY)+' '+d.Code='���̽���')  
end
)  as  AUTHORNAME