--92780  整机硬件特性   92782  网管
--blid 16467  

select  *  from  specMS_TabRefBaseLine  a  where  a.listblID='16467' and tabID='92780';

select  *  from  specMS_TabRefBaseLine  a  where  a.tabRefBLID='344981';

select  *  from  specMS_TabRefBaseLine  a  where  a.listID=7457;

select  *  from  specMS_SpecBaseLine  a  where  a.blID=16468;
select  *  from  specMS_SpecBaseLine  a  where  a.blID=16467;
select  *  from  specMS_SpecBaseLine  a  where  a.blID=13469;

select  *  from  specMS_TabRefBaseLine   a   where  a.listID=7457;

select  *  from  specMS_SpecBLEntryRel  a;

select  *  from  specms_specBaseLine  a   where  a.blID='16036';

select  *  from  specMS_SpecList  a  where  a.verTreeCode='PR003527';


select  *  from  specMS_SpecEntryChangeRel  a   where  a.entryID='3238325';

--3237325
select  *  from  specMS_SpecEntryChangeRel  a   where  a.entryID='3237325';

select  *  from  specMS_SpecEntryChangeRel  a   where  a.blID=16501;

select  *  from  specMS_SpecEntryChangeRel  a   where  a.blID=16500;

--blId 16500
--default  entryId  3238325
select  *  from  specMS_TabRefBaseLine  a  where  a.listblID='16502';

select  *  from  specMS_SpecBaseLine  a  where   a.blID='16502';

select  *  from  specMS_SpecBaseLine  a  where   a.blID='16503';

select  *  from  specMS_SpecList   a   where  a.blID='16502';

--AI研究院  SeerSe  V100R001
--网管 93286  blId 7029  blEntryId  1960889
--产品可靠性 93290   blId  15439   blEntryId   6701704  
select  *  from  specMS_SpecListTab   a  where a.listID=7477;

select  *  from  specMS_SpecListExtColData    a   where  a.blID=16503;

select  *  from  specMS_SpecBLEntryRel  a  where a.blID=15439;

select  *  from  specMS_SpecBLEntryRel  a  where a.blID=16503;

select  *  from  specMS_SpecBLEntryRel  a  where a.blEntryID=6974466;

select  *  from  specMS_SpecEntryChangeRel   a;

select  *  from  specMS_StandardSupport   a  where  a.blID=15439;

select  *  from  specMS_Standard   a;

select  *  from  specMS_StandardSupport   a;

select  *  from  specMS_EntryDepend  a;

--SeerSE V100R001B02 17418

select  *  from  specMS_TabRefBaseLine   a  where  a.listblID=17418;

select  *  from  specMS_SpecBLEntryRel    a   where   a.blID=17419;

select  *  from  specMS_SpecListTab  a;

--17690 
--b		blEntryId  8376597		EntryId		3855133
--c		blEntryId  8376605		EntryId		3855138
--aa		blEntryId  8379034 

select  *  from  specMS_SpecBLEntryRel  a  where  a.blID=17691;

select  *  from  specMS_SpecEntry   a  where  a.entryID='3855145';

select  *  from  specMS_SpecEntryChangeRel   a  where blID=17691;

--blid 17441  17442
--listId  8350
--Default	105244	Default1	105281
--节能   105251			环保			105252

select   *  from  specMS_SpecList   a  where  a.blID=17441;

select   *  from  specMS_SpecListTab   a  where  a.listID=8350;

select   *  from  specMS_TabRefBaseLine   a   where  a.listblID=17441;

select   *  from  specMS_SpecListExtColData  a  where  a.blID=17441

--and  status=-1  
and blEntryID in
(
	select  blEntryID  from  specMS_SpecBLEntryRel   b  where  b.refID=105244
	union
	select  blEntryID  from  specMS_SpecBLEntryRel  c  
	inner join  specMS_TabRefBaseLine  d   on  c.blID=d.blID
	where    d.tabID=105244
);

--中国CQC节能认证—  6758728
select  *  from   specMS_SpecListExtColData a  where  a.blEntryID=6758728  and blID=17441;

--15439
select  *   from  specMS_SpecBLEntryRel  where blID=15439;

select  *   from  specMS_SpecBLEntryRel  where refID=105244;


--扩展列撤销   扩展列支持情况 
select  *  from   specMS_SpecListExtColData 
                                where blEntryID in
                                (
                                    select ext.blEntryID from specMS_SpecListExtColData ext
									inner join  specMS_SpecBLEntryRel rel  on ext.blEntryID =rel.blEntryID
									inner join  specMS_TabRefBaseLine  tabRef   on  tabRef.blID=rel.blID
                                    where   ext.status = -2 and ext.blID = 17441  --and  tabRef.tabID=105281
                                    and rel.blID in 
                                    (
                                        select blID from specMS_TabRefBaseLine
                                        where listblID=17441
                                        union 
                                        select 17441
									)
									
                                ) and status=-2  and blID=17441;

-- -2改成0  
select  *  from   specMS_SpecListExtColData 
                                where blEntryID in
                                (
                                    select ext.blEntryID from specMS_SpecListExtColData ext
									inner join  specMS_SpecBLEntryRel rel  on ext.blEntryID =rel.blEntryID
									inner join  specMS_TabRefBaseLine  tabRef   on  tabRef.blID=rel.blID
                                    where   ext.status = -2 and ext.blID = 17441  and  tabRef.tabID=105281
                                    and rel.blID in 
                                    (
                                        select blID from specMS_TabRefBaseLine
                                        where listblID=17441
                                        union 
                                        select 17441
									)
									union 
									select ext.blEntryID from specMS_SpecListExtColData ext
									inner join  specMS_SpecBLEntryRel rel  on ext.blEntryID =rel.blEntryID
									--inner join  specMS_TabRefBaseLine  tabRef   on  tabRef.blID=rel.blID
                                    where   ext.status = -2 and ext.blID = 17441  and  rel.refID=105281
                                    and rel.blID in 
                                    (
                                        select blID from specMS_TabRefBaseLine
                                        where listblID=17441
                                        union 
                                        select 17441
									)
                                ) and status=-2  and blID=17441;


select  *   from specMS_SpecListExtColData where status=-2 and blID=17441
                                and  blEntryId  in
                                ( 
                                    select  blEntryID  from  specMS_SpecBLEntryRel   b  where  b.refID=105252
	                                union
	                                select  blEntryID  from  specMS_SpecBLEntryRel  c  
	                                inner join  specMS_TabRefBaseLine  d   on  c.blID=d.blID
	                                where    d.tabID=105252
                                ) ;

--标准协议

select  *  from  specMS_Standard  a;

select  *  from  specMS_StandardSupport  a;

select  *   from specMS_StandardSupport where flag=1 and status=-1 and blID={0}  and  blEntryId  in( select   blEntryId  from   specMS_SpecBLEntryRel  a  where  a.blid={1} );

--set status=0 
select  *   from specMS_StandardSupport 
where  blEntryID in 
	(
		select ext.blEntryID from specMS_StandardSupport ext,specMS_SpecBLEntryRel rel 
		where ext.blEntryID =rel.blEntryID and ext.flag=1  and 
		ext.status = -2 and ext.blID = {0} and rel.blID in 
		(
			select blID from specMS_TabRefBaseLine
			where listblID={0} 
			union 
			select {0}
		)
	) and flag=1 and status=-2 and blID={0};

--set status=0
select  *  from specMS_StandardSupport  where  blEntryID in
(
 select  blEntryID  from  specMS_SpecBLEntryRel   b  where  b.refID=105252
	                                union
	                                select  blEntryID  from  specMS_SpecBLEntryRel  c  
	                                inner join  specMS_TabRefBaseLine  d   on  c.blID=d.blID
	                                where    d.tabID=105252
) and flag=1 and status=-2 and blID={0};

--规格参数

select  *  from specMS_SpecListExtCol  ;

select  *  from specMS_SpecListExtColData  ;

select  *  from  specMS_EntryParam  where blID=17441;

 select  *   from specMS_EntryParam where type=1  and blID=17441
                                and  entryID  in
                                ( 
                                    select  entryID  from  specMS_SpecBLEntryRel   b  where  b.refID=105251
	                                union
	                                select  entryID  from  specMS_SpecBLEntryRel  c  
	                                inner join  specMS_TabRefBaseLine  d   on  c.blID=d.blID
	                                where    d.tabID=105251
                                );

--set status=0
select  *  from  specMS_EntryParam  where entryID in
(
	select ext.entryID from specMS_EntryParam ext,specMS_SpecBLEntryRel rel 
	where ext.entryID =rel.entryID and ext.type=1  and
	ext.status = -2 and ext.blID = {0} and rel.blID in (select blID from specMS_TabRefBaseLine
	where listblID={0}  union select {0}
	)
) and type=1 and status=-2 and blID={0};


--关联关系	specMS_EntryDepend
select  *  from  specMS_EntryDepend  a  where  a.blId=17441;

--set flag=0
select  *  from   specMS_EntryDepend  where blId=17441  and  refBlId=17441 and flag=-2
 and  entryID  in
                                ( 
                                    select  entryID  from  specMS_SpecBLEntryRel   b  where  b.refID=105251
	                                union
	                                select  entryID  from  specMS_SpecBLEntryRel  c  
	                                inner join  specMS_TabRefBaseLine  d   on  c.blID=d.blID
	                                where    d.tabID=105251
                                );
--delete from specMS_EntryDepend where blId={1}  and  refBlId={1}  and flag=-1 ;
--update specMS_EntryDepend set status=0 where blId={2}  and  refBlId={1}  and status=-1;

--删除多余扩展列数据	17441
	
select *   from specMS_SpecListExtColData where blID = {0} and not exists
(
	select * from specMS_SpecBLEntryRel rel where rel.blId in 
	(
		select blID from specMS_TabRefBaseLine where listblID={0}  union select {0}
	)
	and rel.blEntryID = blEntryID  
)
