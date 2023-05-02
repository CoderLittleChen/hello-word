--
--update specMS_SpecBLEntryRel 
--set orderNo=(select orderNo from specMS_SpecBLEntryRel where blEntryID=6861839)-0.5 where blEntryID=6862120;

--update specMS_SpecBLEntryRel 
--set orderNo=m2.newIndex + 100011 
--from 
--( 
--	select m1.blEntryID,ROW_NUMBER() OVER (order by orderNo) as newIndex
--	from specMS_SpecBLEntryRel m1 where m1.entryPID=(select entryPID from specMS_SpecBLEntryRel where blEntryID=6862120)
--	and m1.orderNo > 100010
--)	m2 where m2.blEntryID=specMS_SpecBLEntryRel.blEntryID;


--ÐÞ¸ÄvOrderNo
--with entryInfo as
--(
--	select blEntryID,refID,entryID,entryPID,blID,2 lvl,orderNo,'100013.'+CAST(orderNo as nvarchar(max)) charOrder from specMS_SpecBLEntryRel
--	where entryPID=3170420 and blID=15774 and orderNo>=100029 
--	union all 
--	select B.blEntryID,entryInfo.refID,B.entryID,B.entryPID,B.blID ,
--	entryInfo.lvl+1 lvl,B.orderNo,
--	entryInfo.charOrder+'.'+CAST(b.orderNo as nvarchar(max)) from specMS_SpecBLEntryRel B,entryInfo 
--	where B.entryPID=entryInfo.entryID 
--	and B.blID=entryInfo.blID
--) 
--update t1 set t1.refID=entryInfo.refID,
--t1.lvl=entryInfo.lvl,t1.vOrderNo=entryInfo.charOrder from specMS_SpecBLEntryRel t1,entryInfo 
--where t1.entryID=entryInfo.entryID  and t1.blID=15774

select  top 1 *  from specMS_SpecBLEntryRel  a  where  a.orderNo='100013';

select  *  from  specMS_SpecBLEntryRel  a   where  a.blEntryID='3170787'

select  *  from  specMS_SpecEntry  ;

select  c.entryCName,a.*  from  specMS_SpecBLEntryRel  a   
inner join  specMS_SpecEntry b   on  a.entryID=b.entryID
inner join  specMS_SpecEntryContent  c  on  a.entryID=c.entryID
where  a.blID='15649'  and a.flag=0;


select  c.entryCName,a.*  from  specMS_SpecBLEntryRel  a   
inner join  specMS_SpecEntry b   on  a.entryID=b.entryID
inner join  specMS_SpecEntryContent  c  on  a.entryID=c.entryID
where  a.blID='15955'  and a.flag=0  ;