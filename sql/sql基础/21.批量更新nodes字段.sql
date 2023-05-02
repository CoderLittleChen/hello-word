with entryInfo as
                    (
                          select EntryID,EntryPID,blID,EntryOrder,
                          ''+
                          CAST(EntryOrder as nvarchar(max)) charOrder 
						  from Sol_Entry 
                          where EntryPID=0 and blID=1 and EntryOrder>=10006
                          union all 
						  select B.EntryID,B.EntryPID,B.blID,B.EntryOrder,
                          entryInfo.charOrder+'.'+CAST(b.EntryOrder as nvarchar(max)) from entryInfo
                          inner join  Sol_Entry  B  on  entryInfo.EntryID=B.EntryPID  and   B.blID=entryInfo.blID
                    ) 

                    update t1 set 
                    t1.EntryTreeOrder=entryInfo.charOrder
                    from Sol_Entry t1,entryInfo 
                    where t1.entryID=entryInfo.entryID  and t1.blID=1