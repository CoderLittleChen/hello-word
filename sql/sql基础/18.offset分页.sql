select * from Area  
where ParentId=3
order by Id 
offset (pageIndex-1)*pageSize   rows
fetch next pageSize rows only

