
select   
(
	case  
	when  a.PersonId>2
		then 
			case  
			when   a.Age>30 and  a.Age>29  then  '30以上的老师'
			else '30以下的老师'
			end
	else '测试'
	end
),*   from  Teacher  a;