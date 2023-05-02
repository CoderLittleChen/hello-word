select  *  from  specMS_SpecPermission  a  where dataSetID   in
(
	select  b.dataSetID  from  specMS_SpecDataIDSet  b  where  b.IDLevel<4  and b.isSync=1
)
or    a.dataSetID is null;

select *  from  specMS_SpecDataIDSet  b   where b.dataSetID  in
(
	select  a.dataSetID  from  specMS_SpecPermission  a  where dataSetID not  in
(
	select  b.dataSetID  from  specMS_SpecDataIDSet  b  where  b.IDLevel<4  and b.isSync=1
)

);

select  *  from   specMS_SpecModuleBLRel  a;

select  *  from  specMS_SpecPermission  a  where  a.userName='00428';

select  *  from  specMS_SpecPermission  a  where  a.dataSetID is null;

select  *  from  specMS_SpecBaseLine  a  where  a.blID=16679;

--PB003493  SeerSE V100R001
--PR003511	 竞争战略 国拨 科技部 可重构高通量智能网络检测仪应用示范 (在研)
--PB003853  AIOS 自筹 发改委 人工智能计算平台 (在研)
select  *  from  specMS_SpecDataIDSet  a  where  a.srcID='PB003493';

select  *  from  specMS_SpecList a  where  a.verTreeCode='PB003853';

select  *  from  specMS_SpecBaseLine  a  where  a.blID=16735;

select  *  from  specMS_SpecBaseLine  a  where  a.blID=16736;

select  *  from  specMS_TabRefBaseLine  a  where  a.listID=7683;

select  *  from  specMS_SpecList a  where  a.blID=16679;

select  *  from  specMS_SpecListTab   a   where   a.listID=7683;

select  *  from  specMS_SpecListExtCol  where listID=7639;

select  *  from  specMS_SpecListTabExtCol  a where a.extColID=24103;

select  *  from  specMS_SpecModule  a  where  a.verTreeCode='PB003853';

select  *  from  specMS_SpecModuleBLRel  a  where  a.blID=16736;

select  *  from  specMS_SpecList   a   
inner join 
specMS_SpecListTab  b on a.listID=b.listID
where  a.verTreeCode='PB003493';

select  *  from specMS_SpecList  specList
inner join specms_SpecBaseLine  specBaseLine  on specList.blId=specBaseLine.blId
where  (specBaseLine.DeleteFlag=0  or specBaseLine.DeleteFlag  is null)  and  verTreeCode ='PB003853'; 


select  *   from specMS_SpecModule module
inner join  specMS_SpecModuleBLRel  moduleRel  on  module.smId=moduleRel.smId
inner join  specMS_TabRefBaseLine  tabRef  on   tabRef.blID=moduleRel.blID
inner join  specms_SpecBaseLine  baseLine  on  baseLine.blId=tabRef.listblID
where  
(baseLine.DeleteFlag=0 or baseLine.DeleteFlag  is  null)  and  
verTreeCode ='PB003853';


select specMS_SpecList.* from specMS_SpecList where verTreeCode='PB003853' and blId=0
union 
select specMS_SpecList.* from specMS_SpecList    
inner join specms_SpecBaseLine  b  on  specMS_SpecList.blId=b.blId
where verTreeCode='PB003853'  and  (b.DeleteFlag=0  or b.DeleteFlag  is null);

select COUNT(*) from dbo.specMS_SpecList  a
inner join  specms_SpecBaseLine  b  on  a.blid=b.blid
where verTreeCode ='PB003853' and a.blID !=0  and  (b.DeleteFlag=0  or  b.DeleteFlag is  null)


select  *  from  specMS_TabRefBaseLine   a  where  a.listID='7628';

--delete specMS_SpecBaseLine  where blID=16671;
--delete specMS_SpecListTab where  listID=7628;
--delete specMS_TabRefBaseLine	where  listID='7628';
--delete  specMS_SpecList  where verTreeCode='PB003493';

--delete specMS_SpecListExtCol  where listID=7628;

--delete specMS_SpecListTabExtCol where extColID=24099


select  *  from  specMS_SpecModule  a  where a.verTreeCode='PB003493';

select  *  from  specMS_SpecModuleBLRel  a;

select  *   from specMS_SpecModule module
inner join  specMS_SpecModuleBLRel  moduleRel  on  module.smId=moduleRel.smId
inner join  specms_SpecBaseLine  baseLine  on  baseLine.blId=moduleRel.blId
where    verTreeCode='PB003493';

--S7500E V700R011

--PB003493

--update  specMS_SpecDataIDSet  set  BlNumber=0 where srcID='PB003853';

SELECT 1 FROM SPECMS_SPECLIST AS S WITH (NOLOCK) 
				INNER JOIN SPECMS_SPECBASELINE AS B WITH (NOLOCK) ON S.BLID = B.BLID	 
				LEFT JOIN SYNC_EMPLOYEE E WITH (NOLOCK) ON B.CREATEBY = E.CODE  
			WHERE  S.VERTREECODE='PB003493'  and B.DeleteFlag=0;

SELECT b.* FROM SPECMS_SPECLIST AS S WITH (NOLOCK) 
				INNER JOIN SPECMS_SPECBASELINE AS B WITH (NOLOCK) ON S.BLID = B.BLID	 
				LEFT JOIN SYNC_EMPLOYEE E WITH (NOLOCK) ON B.CREATEBY = E.CODE  
			WHERE  S.VERTREECODE='PB003493'  and B.DeleteFlag=1;

SELECT COUNT(*) FROM SPECMS_SPECBASELINE WHERE PREBLID=0 AND (STATUS=0 OR STATUS=-1) and DeleteFlag=0
					AND BLID IN (SELECT BLID FROM SPECMS_SPECLIST WHERE VERTREECODE='PB003493');

SELECT COUNT(*) FROM SPECMS_SPECBASELINE WHERE BLID=0 AND (STATUS=0 OR STATUS=-1) and DeleteFlag=0
		AND BLID IN (SELECT BLID FROM SPECMS_SPECLIST WHERE VERTREECODE='PB003493' ) ;

select  *  from  specMS_SpecDataIDSet  a  where  a.srcID='';

select  *  from  specMS_SpecDataIDSet  a  where  LEN(srcName)>=50;

select  *  from  specMS_SpecDataIDSet  a  where  a.srcID='PB003853';

select  *  from  specMS_SpecList   a;

select  *  from  specMS_SpecModule  a;

select  *  from  specMS_SpecBaseLine  a
--inner join  specMS_SpecModuleBLRel  b  on  a.blID=b.blID
--inner join  specMS_SpecModule   c   on  b.smID=c.smID
where  a.DeleteFlag is null or  a.DeleteFlag=0;

select  *  from  BVersionTemp  a
inner  join  specMS_SpecDataIDSet   b  on   a.bversionno=b.srcID  and  b.IDLevel=4  and LEN(srcName)>=50;

--update  specMS_SpecDataIDSet   set  srcName=b.bversioncname
--from   specMS_SpecDataIDSet  a 
--inner join   BVersionTemp  b  on  a.srcID=b.bversionno  and  a.IDLevel=4;

select  *  from   specMS_SpecDataIDSet a  where a.srcID='PB003493';

select  *  from   specMS_SpecList   a  where  a.verTreeCode='PB003493';

 select specMS_SpecList.* from specMS_SpecList  
    inner join specms_SpecBaseLine  b  on specMS_SpecList.blId=b.blId
    where verTreeCode='PB003493'  and  b.DeleteFlag=1;

select  *  from  specMS_SpecBaseLine   a   where  a.blID='16671';

select  *  from  specMS_SpecBaseLine   a;
--PT000219   园区核心交换机
--PT000207   无线控制器
 with temp as
                                                           (
                                                                select  srcID,srcPID,IDLevel  from  specms_SpecDataIDSet  a  where a.srcID='PT000207'
                                                                union all
                                                                select  a.srcID,a.srcPID,a.IDLevel  from  specms_SpecDataIDSet  a 
                                                             inner join temp  b  on  a.srcPID=b.srcID
                                                           )
                                                           update  specms_SpecDataIDSet  set  show=1
														   --select  * 
                                                           from  specms_SpecDataIDSet  a  
                                                           inner join  temp  b  on   a.srcID=b.srcID  and a.IDLevel=4 ;

--PR990032
--update  specMS_SpecDataIDSet   set   IsMerge=null  where srcID='PR990032';

--blId 15631  TabId  82288  ListId  7023

--blid 16586  tabid 94434   硬件  82198
select  *  from   specMS_SpecBaseLine a   where	a.blID=16604;

select  *  from   specMS_SpecBaseLine a   where	a.blID=16606;

select  *  from   specMS_SpecListTab a  where  a.listID=7564;

select  *  from   specMS_SpecListTab a  where  a.tabID=94687;

select  *  from   specMS_SpecList a  where  a.blID=16604;

select  *  from   specMS_SpecList a  where  a.listID=7563;

select  *  from   specMS_SpecDataIDSet a  where  a.isSync=0;

select  *  from   specMS_SpecDataIDSet a  where  a.srcName  like '%新增R版本%';

select  *  from   specMS_SpecListExtCol  a  where  a.listID=7563;
--extColid  24041
select  *  from   specMS_SpecListExtCol  a  where  a.extColID=22882;

 --union
                        --select dataSetID from specMS_SpecDataIDSet where srcID in (
                        --select list.verTreeCode from dbo.specMS_SpecListTab tab, specMS_SpecList list
                        --where  tab.listID = list.listID and tab.manager like '%ys2689%'
                        --)

select  *  from   specMS_SpecListExtColData  a  where  a.blID=15609  and  blEntryID=6849122;
--70775930  70775931
--update specMS_SpecListExtColData set explain='平台v1.0Draft'  where extDataID=62692155;

select  *  from   specMS_SpecListExtColData  a  where a.blEntryID=6849102;

select  *  from   specMS_TabRefBaseLine   a where  a.listID=7018;

select  *  from   specMS_SpecBLEntryRel   a  where  a.blEntryID=6849102;

SELECT top 1 IsSwitch FROM [dbo].[specMS_IsSwitch];

SELECT * FROM [dbo].[specMS_IsSwitch];

--update  specMS_IsSwitch  set  IsSwitch=0;

--update specMS_TabRefBaseLine  set specMS_TabRefBaseLine.dataSrc=specMS_SpecBaseLine.dataSrc
select  *
from specMS_SpecBaseLine where specMS_TabRefBaseLine.blID=specMS_SpecBaseLine.blID
and specMS_TabRefBaseLine.dataSrc=999;

select  *  from  specMS_SpecBaseLine  a  
inner  join  specMS_TabRefBaseLine   b
on  a.blID=b.blID  and  b.dataSrc=999;

--6849102  blEntryId
select  *  from  specMS_SpecBLEntryRel where refID=15610 and  blEntryID=6849102;

select  *  from  specMS_SpecBLEntryRel where blEntryID=6849102;

select  *  from  specMS_SpecBLEntryRel  a
inner join specMS_SpecEntryContent  b  on a.entryID=b.entryID
 where  a.refID=82198;

 select  *  from  specMS_SpecBLEntryRel  a  where a.blID in (16606,16607) and  refID=94722;

select  *  from  specMS_TabRefBaseLine   a  where a.listID=7563  and  tabID=94687;

--公共产品线  SeerSe  V100R001    blId 16502   listId  7477		Default   tabId  93284    
--CCLSW SOFT_DRV						blId 7211  listId 2538		    软件特性  tabId  21768    extColId 5123
--16761   7713	  96395
--16690   7649  95625

select  *  from   specMS_SpecList   a    where  a.blID=16690;

select  *  from   specMS_SpecListTab  a   where  a.listID=7649;

select  *  from  specMS_TabRefBaseLine  a  where  a.listblID=16761  and a.tabID=96395;

select  a.*  from  specMS_SpecBLEntryRel   a  
inner join specMS_SpecEntry  b  on  a.entryID=b.entryID
inner join specMS_SpecEntryContent  c on b.entryID=c.entryID
where  a.blID=16691 ;

select  *  from  specMS_SpecBaseLine  a  where  a.blID=42767;

select  *  from  specMS_SpecBLEntryRel  a where blID=16761;

select  *  from  specMS_SpecBLEntryRel  a where blID=16762;

select  *  from  specMS_SpecBLEntryRel  a where blID=16691;