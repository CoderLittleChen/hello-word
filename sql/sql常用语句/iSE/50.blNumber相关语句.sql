select  
	(
		select COUNT(*) from dbo.specMS_SpecModule where 
		verTreeCode ='PR99990041' and smSort = 3 and type = 0 
	)+
    (  
    select COUNT(*) from dbo.specMS_SpecList  a
    inner join  specms_SpecBaseLine  b  on  a.blid=b.blid
    where verTreeCode ='PR99990041' and a.blID !=0  and  (b.DeleteFlag=0  or  b.DeleteFlag is  null)
    )