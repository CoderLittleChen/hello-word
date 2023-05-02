select distinct name from sysobjects as s
inner  join syscomments as o
on s.id=o.id 
where text like N'%User_Role_Relation%';

--select distinct name from sysobjects as s
--inner  join syscomments as o
--on s.id=o.id 
--where text like N'%Product_Share%'


--SELECT OBJECT_NAME(id) FROM syscomments
--WHERE id IN(SELECT object_id FROM sys.objects WHERE type='V')
--AND text LIKE '%V_HourInfo_New%'