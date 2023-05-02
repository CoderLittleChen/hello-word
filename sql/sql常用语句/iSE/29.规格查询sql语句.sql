with  curblids as(
		select sl.blID as blID 
		FROM specMS_SpecList sl
		where   verTreeCode  in ('PR002876','PR002455','PR003544' )  

		union 
		select moduleRel.blID
		from specMS_SpecModule module 
		inner join specMS_SpecModuleBLRel moduleRel on module.smID = moduleRel.smID
		where module.verTreeCode in ('PR002876','PR002455','PR003544' ) 
) ,
blps as 
(
		select blID from specMS_SpecBaseLine 
			where blID in
				( 
					select specMS_TabRefBaseLine.blID from 
                    specMS_TabRefBaseLine,specMS_SpecList,specMS_SpecBaseLine
	                where specMS_TabRefBaseLine.listID = specMS_SpecList.listID 
	                and specMS_TabRefBaseLine.listblID =specMS_SpecBaseLine.blID
	                and specMS_SpecBaseLine.status = 1 
	                and  specMS_SpecList.verTreeCode in ('PR002876','PR002455','PR003544' ) 
                    union  
                    select moduleRel.blID
                    from specMS_SpecModule module,specMS_SpecModuleBLRel moduleRel
                    where module.smID = moduleRel.smID and module.verTreeCode in ('PR002876','PR002455','PR003544' ) )  and status=1
),
blids as 
(select * from blps ) ,
bls as
(
	select ROW_NUMBER() over(partition by entryItemID order by entryID desc,entryView.blId desc) as number,
         entryItemID, entryID,entryCName,entryEName,funcDesc,remark,standard,entryParam,entryView.blID,entryPID  
         from SpecBaseLineEntryView entryView
	                        inner join blids on   entryView.blID = blids.blID 
	                        where 1=1  and status=1 and flag=0 
							)

select Entryid,EntrycName,EntryeName,FuncDesc,Remark,Standard,entryParam,Blid,Entrypid,EntryItemid,0 as IsCteResult 
from  bls  where number=1 