
select   
(
	case  
	when  a.PersonId>2
		then 
			case  
			when   a.Age>30 and  a.Age>29  then  '30���ϵ���ʦ'
			else '30���µ���ʦ'
			end
	else '����'
	end
),*   from  Teacher  a;