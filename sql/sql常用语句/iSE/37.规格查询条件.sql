--有间接引用 非选中 
--select * from SpecBaseLineEntryView   where flag=0 and refID=101320 and blId=17095 and isShare=1;

--select * from SpecBaseLineEntryView   where (blId in (7235) or flag=0 and refID!=101320 and blId=17095) and isShare=1;


select * from SpecBaseLineEntryView   where flag=0 and refID=101320 and blId=17095 and isShare=1;

select * from SpecBaseLineEntryView   where ( flag=0  and blId=17095) and isShare=1;

select  *  from  specMS_TabRefBaseLine  a   where  a.listblID=17108;

select * from specMS_TabRefBaseLine with(nolock) where listblID =17108  and  (status=2 or (status=1  and tabID=101550 ) ) order by status desc;

SELECT tabRefBLID,listID,tabID,dataSrc,refID,blID,refVer,status,explain,manager,hasChange,createTime,createBy,listblID,oldblID,specLblID,oldSpecLblID,parentBlid,IsOutomaticNew
                            FROM dbo.specMS_TabRefBaseLine WHERE listblID IN (17108)  and status=2
							--AND dataSrc=1

select  *  from  specMS_SpecList   a   where   a.blID=17108;
--产品软件特性		101549
--S5560-G硬件特性  101550
--S6520X-G硬件特性 101551
--平台软件特性	101552
--S7500X-G硬件特性	101553
select  *  from  specMS_SpecListTab   a   where   a.listID=8019;

select  *  from  specMS_SpecListTab   a   where   a.tabID=93110;

select  *  from  specMS_SpecBLEntryRel  a  where  a.blID=17109 and  refID='101550';

