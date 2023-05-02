exec sp_executesql N'exec dbo.SP_GetExtColDataByEntryIds @blId,@tabIds,@entryIds,@isNeedSrc,@userId,@rCode,@extColIds',N'@blId int,@tabIds nvarchar(5),@entryIds nvarchar(965),@isNeedSrc int,@userId nvarchar(5),@rCode nvarchar(8),@extColIds nvarchar(4000)',@blId=16761,@tabIds=N'96395',@entryIds=N'select blEntryID from (select ROW_NUMBER() over(order by  levelOrder DESC ,case when blID = 16762 then 2147483647 else blID end asc,vOrderNo asc) rowNumber,BlEntryid from specMS_SpecBLEntryRel 
                                    left join (
	                                     SELECT entryContent.entryID, entryContent.levelOrder,entryContent.isShare
                                       FROM dbo.specMS_SpecEntryContent AS entryContent WITH (NOLOCK) 
                                             LEFT OUTER JOIN dbo.specMS_Dict AS dict WITH (NOLOCK) ON 
                                     entryContent.implCase = dict.dictKey AND dict.dictParentId = 102000 
                                    ) EntryContent on specMS_SpecBLEntryRel.entryID=EntryContent.entryID 
                where 1=1  and (blID in (17067,17002) and isShare=1 or flag=0 and refID=''96395'' and blID = 16762) and Entrypid=''0'' ) SpecEntry where SpecEntry.rowNumber between 1 and 100',@isNeedSrc=0,@userId=N'00428',@rCode=N'PR003527',@extColIds=N''