 select  *  from  specms_SpecBlEntryRel  a  
 inner join   specms_TabRefBaseLine  b  on  a.blId=b.blId 
 inner join   specms_SpecBaseLine  c  on  b.blId=c.blId  
 where  b.listId=8349 and  a.refId=105206  and  b.status=2 and c.status<>1;


-- update  specms_SpecEntry  set  verStatus=0,optType=0  
-- from 
--	(     
--		select  a.entryId  from specms_SpecEntry  a     
--		inner join   specms_SpecBlEntryRel   b   on  a.EntryId=b.EntryId    
--		inner join   specms_TabRefBaseLine  c   on  b.BlId=c.BlId    
--		inner join   specms_SpecBaseLine   d  on  c.BlId=d.BlId    
--		where  c.listId=8349  and b.refId=105206  and c.Status=2  
--		and d.Status<>1  and  verStatus=-1   
--		union  all    
--		select  a.entryId  from specms_SpecEntry  a     
--		inner join   specms_SpecBlEntryRel   b   on  a.EntryId=b.EntryId    
--		inner join   specms_TabRefBaseLine  c   on  b.BlId=c.BlId    
--		inner join   specms_SpecBaseLine   d  on  c.BlId=d.BlId    
--		where  c.listId=8349  and  b.refId=105206  and c.Status=2  and d.Status<>1  and  verStatus=0 
--	)  temp  where  temp.entryId=specms_SpecEntry.entryId;   
--update  specms_StandardSupport  set  status=0 
--from 
--	(     
--		select  a.entryId  from specms_SpecEntry  a     
--		inner join   specms_SpecBlEntryRel   b   on  a.EntryId=b.EntryId    
--		inner join   specms_TabRefBaseLine  c   on  b.BlId=c.BlId    
--		inner join   specms_SpecBaseLine   d  on  c.BlId=d.BlId    
--		where  c.listId=8349  and b.refId=105206  and c.Status=2  and d.Status<>1  and  verStatus=0 
--	)  temp  where  temp.entryId=specms_StandardSupport.entryId  and  specms_StandardSupport.flag=0;   
--update  specms_EntryParam  set  status=0  from 
--	(     
--		select  a.entryId  from specms_SpecEntry  a     
--		inner join   specms_SpecBlEntryRel   b   on  a.EntryId=b.EntryId    
--		inner join   specms_TabRefBaseLine  c   on  b.BlId=c.BlId    
--		inner join   specms_SpecBaseLine   d  on  c.BlId=d.BlId    
--		where  c.listId=8349 and  b.refId=105206 and c.Status=2  and d.Status<>1  and  verStatus=0 
--	)  temp  where  temp.entryId=specms_EntryParam.entryId  and  specms_EntryParam.type=0;   