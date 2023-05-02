--from  
--(left  inner  right)  join
--on 
--where 
--Group  by
--having 
--select
--distinct
--top
--新增产品列数据
--  -1可撤销0草稿1基线
--xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756
--产品列及模板与产品列的关系表
SELECT * FROM [dbo].[specMS_ProductColumn]
--delete specMS_ProductColumn where prodColID=14
SELECT * FROM [dbo].[specMS_ProColContent]

select* from [dbo].[specMS_SpecBLEntryRel]  a   where  a.blID='15590'

select entryID from [dbo].[specMS_SpecEntryContent]  a   where a.entryID in
(
	select a.entryID from [dbo].[specMS_SpecBLEntryRel]  a   where  a.blID='15595'
)
--产品工程通用页面
--基线表
select * from [dbo].[specMS_SpecBaseLine]  a  where   a.blID  in
(
	select a.blID  from  dbo.specMS_TemplateSpecBLRel  a
	inner join  dbo.specMS_TemplateSpec  b   on  a.tempID=b.tempID
	where b.tempName='cmtest_20200325'
)
--基线id  15590

--insert   into  specMS_ProductColumn
--select  '产品列1','测试1',15595,'xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756','xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756',GETDATE(),'ys2689'
--union
--select  '产品列2','测试2',15595,'xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756','xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756',GETDATE(),'ys2689'
--union
--select  '产品列3','测试3',15596,'xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756','xuqiang YS2338,wangweidong KF6468,chenmin YS2689,maweihai 19756',GETDATE(),'ys2689'

----3161313  3161314  3161315
--insert  into specMS_ProColContent
----规格1
--select  1,3161313,'3','模板参数1',GETDATE(),'YS2689',0
--union
--select  2,3161313,'1','',GETDATE(),'YS2689',0
--union
--select  3,3161313,'2','',GETDATE(),'YS2689',0
--union
----规格2
--select  1,3161314,'2','',GETDATE(),'YS2689',0
--union
--select  2,3161314,'3','模板参数2',GETDATE(),'YS2689',0
--union
--select  3,3161315,'2','',GETDATE(),'YS2689',0
--union
----规格3
--select  1,3161315,'1','',GETDATE(),'YS2689',0
--union
--select  2,3161315,'2','',GETDATE(),'YS2689',0
--union
--select  3,3161315,'3','模板参数3',GETDATE(),'YS2689',0

--insert  into specMS_ProColContent
select '11',entryID from [dbo].[specMS_SpecEntryContent]  a   where a.entryID in
(
	select a.entryID from [dbo].[specMS_SpecBLEntryRel]  a   where  a.blID='15595'
)

select  *  from  specMS_AppConstantValue  a  order by  a.CreationDate  desc;

--FF3699EA-DD8F-4761-B010-8F623457886F		其他
--A6AD4B99-5DD7-44EA-839C-D0B51372D95A	不支持
--1769D3DB-4246-4C18-8996-68B3101CA367	支持

--update  specMS_AppConstantValue  set ConsValue='Other'  where  AppConstantValueID='FF3699EA-DD8F-4761-B010-8F623457886F';
--update  specMS_AppConstantValue  set ConsValue='UnSupport'  where  AppConstantValueID='A6AD4B99-5DD7-44EA-839C-D0B51372D95A';
--update  specMS_AppConstantValue  set ConsValue='Support'  where  AppConstantValueID='1769D3DB-4246-4C18-8996-68B3101CA367';

select  *  from  specMS_SpecBaseLine   a where a.blID=15595 ;

select  *  from  specMS_SpecEntry     a;

select  * from [dbo].[specMS_SpecBLEntryRel]    a   where   a.blID=15595;

select top 100 *   from  Log order by LogTime desc;

select  *  from  specMS_ProductColumn  a  where  a.Editpermission  like '%chenmin ys2689%';
select * from FormDefaultValue

 select   count(*)  from  specMS_ProductColumn  a   where  a.ProdColID='1'   and Editpermission like '%wangweidong KF6468%'   

 select prpID,prpName,prpValue,prpUnit,verTreeCode,createBy,createTime  from specMS_PredefineParam;

 --产品列及模板与产品列的关系表
SELECT * FROM [dbo].[specMS_ProductColumn]
--drop table [specMS_ProductColumn]
--产品列内容表
SELECT * FROM [dbo].[specMS_ProColContent]  

 select *  from  specMS_SpecListExtCol  a;

 select *  from  specMS_SpecListExtColData  a  where a.param is not null  and a.param!='';

 select  *  from  specMS_EntryParam  a  where  a.blID=15595;
 
select  *  from  specMS_ProColContent a  where  blEntryId='6845209';

select count(*) from specMS_ProColContent where blEntryID=6845209 and ProdColId=28  and VerStatus=-2;

select   count(*)  from  specMS_ProductColumn  a   where  a.ProdColID=11   and Editpermission like  '%chenmin%'
union
select  count(*)		from  specMS_ProductColumn;

--specMS_TemplateSpecBLRel     specMS_TemplateSpec

select a.epID,a.entryID,a.paramName,a.paramValue,a.unit,a.summary,a.createTime,a.flag,
b.Name + ' '+ b.Code as createBy,a.type,a.blID,a.status,a.extColID,
a.modifyFlag,a.sourceFlag
from specMS_EntryParam a 
left join Sync_Employee b on a.createBy = b.Code 
where a.type=2   and a.flag=0 
and a.entryID = 3160549 
and a.blId = 15584 
and a.status>-2 
and a.extColID=19;


select a.epID,a.entryID,a.paramName,a.paramValue,a.unit,a.summary,a.createTime,a.flag,
b.Name + ' '+ b.Code as createBy,a.type,a.blID,a.status,a.extColID,
a.modifyFlag,a.sourceFlag
from specMS_EntryParam a 
left join Sync_Employee b on a.createBy = b.Code 
where a.type=2   and a.flag=0 and a.entryID = 3160550 and a.blId = 15584 and a.status>-2 and a.extColID=19;


select   count(*)  from   specMS_ProductColumn    a   
inner  join  specMS_TemplateSpecBLRel  b  on  a.BlId=b.blID
inner  join  specMS_TemplateSpec  c   on  b.tempID=c.tempID
where a.ProdColID=11;

SELECT * FROM  specMS_ProductColumn   a  where  a.BlId=15582 ;

select  *  from  specMS_SpecEntry ;

select  * from [dbo].[specMS_SpecBLEntryRel]  a  where  a.entryID= 3160550;
--3160516
select  * from [dbo].[specMS_SpecBLEntryRel]  a  where  a.entryID= 3160516;

select  * from [dbo].[specMS_SpecBLEntryRel]  a  where  a.blID=15584;

--fromId  新的blentryId  toId  selectNodeId 
--update specMS_SpecBLEntryRel set orderNo=(select orderNo from specMS_SpecBLEntryRel where blEntryID=:idColumnTo)-0.5 where blEntryID=:idColumnFrom

select  *  from  specMS_EntryItemID   a  order by  a.createTime desc;

select  *  from  specMS_SpecEntry  a;

select  *  from  specMS_SpecEntryContent  a;

select  *  from   specMS_EntryContentExt  a   where  a.EntryID='3160583'

select  *  from  specMS_AppConstant   a;

--and status=-2
select  *  from  specMS_EntryParam  a  where  a.type=2  order  by createTime  desc;
select  *  from  specMS_EntryParam  a  where  status=-2 order  by createTime  desc;



select  *  from  specMS_SpecEntryChangeRel  a;

select  *  from  specMS_SpecBLEntryRel  a  where  a.blEntryID='6844608'

select  *  from  specMS_SpecListTabExtCol  a;

select  *  from  specMS_SpecModule  a;

select  *  from  FormDefaultValue   a;

select  *  from  specMS_TabRefBaseLine  a;

select  *  from specMS_SpecBaseLine   a   where  a.blID=15584;

select  *  from specMS_SpecBLEntryRel  a  where a.blID=15584

select  *  from specMS_ProColContent a  where  a.blEntryID='6844609';

select  *  from  specMS_ProductColumn  a;

select  *  from specMS_ProColContent a  where  a.blEntryID='6844609';
select  *  from  specMS_EntryParam  where entryID = 3160586

select  *  from  specMS_TemplateSpec  a;

select  *  from   specMS_AppConstantValue  a   order by a.CreationDate desc;

select  *  from  specMS_ROLE  a;
select  *  from  specMS_SpecBaseLine a where  a.blID=15593;
select  *  from  specMS_EntryContentExt  a  where  a.EntryID='3160753';
select  *  from  specMS_ProColContent  a  where  a.blEntryID  in
(
	select  a.blEntryID   from   specMS_SpecBLEntryRel  a  where  a.entryID='3160746'  and a.blID=15593
)

select  *  from  specMS_SpecBLEntryRel  a  where  a.entryID='3160746';
 

select  *  from  specMS_SpecBaseLine  a  where  a.blID=15593;

select  *  from   specMS_SpecEntryContent

select * from dbo.specMS_SpecPermission a,specMS_ROLE  b where a.rCode = b.RL_CODE  and b.RL_NAME='通用页面管理员'
and b.RL_ACTIVE =0 and b.Flag=0 and a.userName='ys2689';

select  *  from  specMS_SpecEntryChangeRel;

select  *  from   specMS_TemplateSpecBLRel a   where a.blID=15671;

select  *  from   specMS_TemplateSpec  a  where a.tempID=143;

select  *  from   specMS_SpecBLEntryRel  a  where  a.blID=15584;

select  *  from   specMS_EntryDepend  a  where  a.blId=15584;

select  *  from   specMS_SpecList  a where  a.blID=15593
order by  a.createTime desc;

select  *  from  specMS_SpecBaseLine  a  where a.blID=15583;

select  *  from  specMS_SpecBaseLine  a  order by  a.createTime desc;


select  *  from  specMS_SpecEntry   a where  a.entryID=3160521;
select  *  from  specMS_SpecEntryContent   a  where   a.entryID=3160819;

select  *  from  specMS_SpecEntry   a where  a.entryID=3160633;
select  *  from  specMS_SpecEntryContent   a  where   a.entryID=3160821;



select  *  from specMS_SpecBLEntryRel  a  where a.blID=15594;
select  *  from specMS_SpecBLEntryRel  a  where a.blID=15627;
--blentryId  6860920   entryId 3134387   3172876   blid 15888  
select  *  from specMS_SpecBLEntryRel  a  where a.blEntryID=6860920;

select  *  from specMS_SpecBLEntryRel  a  where a.blEntryID=6845379;
select  *  from specMS_SpecBLEntryRel  a  where a.entryID=3160780;

--b  entryId 3160793   blEntryId  6844876
select  *  from specMS_EntryContentExt  a  where a.EntryID=3134387;
select  *  from specMS_EntryContentExt  a  where a.EntryID=3160821;
select  *  from specMS_EntryContentExt  a  order by  a.CreateTime desc;
--3161598
--update  specMS_EntryContentExt  set  VerStatus=-1  where EntryID=3160834;

select  *  from  specMS_SpecListExtCol  a;

select  *  from  specMS_SpecListExtColData  a  where a.blEntryID='6846514'    and a.blID='15790'


select  *  from specMS_ProductColumn  a  where a.BlId=15610;

select  *  from specMS_ProColContent  a  where  a.blEntryID=6845332;

select  *  from specMS_ProColContent  a  where  a.blEntryID  in
(
	select  c.blEntryID from specMS_SpecBLEntryRel  c  where c.blID=15589
)

select  *  from  specMS_AppConstantValue   a   order  by  a.CreationDate desc;

select  *  from  specMS_EntryParam  a  where  a.blID=15625;
--3161149		3161150
select  *  from  specMS_EntryParam  a  where  a.entryID='3161157';

select  *  from  specMS_SpecEntry   a where  a.entryID=3160822;
select  *  from  specMS_SpecEntryContent   a  where   a.entryID=3160822;

select  *  from  specMS_SpecEntry   a where  a.entryID=3160825;
select  *  from  specMS_SpecEntryContent   a  where   a.entryID=3160825;

select  *  from  specMS_SpecEntry   a where  a.entryID=3160826;
select  *  from  specMS_SpecEntryContent   a  where   a.entryID=3160826;
select  *  from specMS_ProColContent  a  where  a.blEntryID  in
(
	select  c.blEntryID from specMS_SpecBLEntryRel  c  where  c.flag=0 and c.blID=15627  
)

select top 1 '41' as rCode from specMS_TemplateSpec where tempManager like '%chenmin ys26891%';

select  *  from  specMS_SpecPermission   a;

select  *  from  specMS_RESOURCE   a;

select  *  from  specMS_SpecList  a;

select  *  from  specMS_AppConstantValue;

select  *  from  Log  a;

select  *  from  specMS_ProductColumn;

--SpecMS_BaselineProductRel

select  *  from  SpecMS_BaselineProductRel  a;

select  c.pageName,c.tempSName,c.tempName,c.isProduct,c.tempID  from  specMS_TabRefBaseLine  a  
inner join  specMS_TemplateSpecBLRel  b  on  a.blID=b.blID
inner join  specMS_TemplateSpec  c  on b.tempID=c.tempID
where a.tabID=82161;

select  *  from  specMS_TemplateSpecBLRel  a  where  a.tempID=140;
select  *  from  specMS_TemplateSpecBLRel  a  where  a.blID=15547;

select  *  from  specMS_SpecBLEntryRel   a  where  a.blID=15548  and  a.lvl=1;

select  * from  specMS_SpecEntryContent  a  where  a.entryID='2577017';

  

select  
	(select c.ConsCNName from specMS_AppConstantValue  c  where  b.Importance=c.AppConstantValueID) as  Importance
	,(select c.ConsCNName from specMS_AppConstantValue  c  where  b.Entrysource=c.AppConstantValueID) as Entrysource
	,(select c.ConsCNName from specMS_AppConstantValue  c  where  b.Verificationmode=c.AppConstantValueID) as Verificationmode
	,a.*  from SpecBaseLineEntryView a
left join  specMS_EntryContentExt b  on  a.entryID=b.EntryID
where a.entryCName='a';

select  *  from specms_ProColPermission a;
--drop  table  specms_ProColPermission;
--delete  specms_ProColPermission  where ProColId  in  (268,269);
--4890355,4890397

select top 1 '51' as rCode from specms_ProColPermission where UserId like '%ys2689%';

select  *  from  specMS_EntryParam a   where  a.type=2;

select  *  from  specMS_EntryParam a   where   a.flag<>0;

select  *  from  specMS_AppConstantValue;

--Base  14865   target   15731
select  *  from   specMS_SpecBLEntryRel  a   where  a.blID=15731;

--0,215000,218000,218001

--select  *  from  Log   a  where  a.    like '%导入标准协议数据%'

--blid 15733  refblid 15717


SELECT *  FROM SpecMS_BaselineProductRel  rel  WHERE ListBlid='15733' And Blid='15717';

SELECT *  FROM SpecMS_BaselineProductRel;

select  *  from  specMS_ProColContent  a;

select  *  from  Sol_ProductInfo   a;

select  *  from  Sol_DataIDSet   a ;

select  *  from  specMS_SpecBaseLine   a;

select count(*) from specMS_EntryContentExt where  EntryID=3172876 and verStatus=-2 ;

select  '3172876',Importance,Entrysource,Verificationmode,CreateBy,GetDate(),-1
from specMS_EntryContentExt where   EntryID=3172876 and (verStatus=0 or verStatus=1) ;

select  * from  specMS_SpecList  a  where a.verTreeCode='PR003675';

select  * from  specMS_SpecBaseLine a;

select  * from  specMS_SpecDataIDSet  a  where  a.srcName='解决方案';

select  *  from  specMS_SpecEntry  a  order  by  a.createTime desc;

select  *  from  specMS_SpecEntry  a  where  a.isLeaf=1 and flag=0;

select  *  from  specMS_SpecEntryContent  a  order  by  a.createTime desc;

select  *  from specMS_EntryItemID  a;

select *  from Sol_DataIDSet   a;

select  * from Sol_BaseLine ;

select  *  from  specMS_Dict a;

select  *  from  Sol_EntryRelation  a  where  a.EntryID='464';
--a.EntryID=temp.OldParentId


select  *  from Sol_Entry  a where a.BlID=1  and  a.TabID=2;

--delete Sol_Entry  where BlID=1

select  CHARINDEX(',','dsa,rwerw');
select  LEN('dsa,rwerw')-CHARINDEX(',','dsa,rwerw');

select  CONVERT(varchar(100),getdate(),112);


--6862181	
select  *  from specMS_SpecBLEntryRel  a  where  a.blEntryID='6862181';

select  *  from specMS_SpecBLEntryRel  a  where   a.refID!=0;

select  *  from specMS_SpecBaseLine  a   where  a.blID=3866;

select  *  from specMS_SpecBaseLine  a   where  a.blID=3248;

select  top 1 *  from specMS_SpecBLEntryRel  a  order by  a.createTime desc;

select  top 1 *  from specMS_SpecBLEntryRel  a  where  a.orderNo='100013';

select  * from  Sol_PageConfig  a;

select  *  from  Sol_EntryColName   a   where a.BlID=2  and  a.Type=1;

select  *  from Sol_PartProductAttribute  a  
inner join Sol_EntryColName  b  on  a.ColID=b.ColID
inner join Sol_TabConfig  c  on   a.TabID=c.TabID
where a.BlID=1;

select *  from Sol_DataIDSet a;

select  *  from  Sol_ProductInfo  a;

select * from Sol_Permission   a  where a.UserName='kf6468'

select *  from 
(
	select  a.ColID,c.ConfigID,a.Name,b.TabName,a.BlID,a.TabID
	,d.ProductLine_Code,d.ProductLine_Name,d.PDT_Code,d.PDT_Name
	,c.PDTManager,c.InterfaceManager
	,ROW_NUMBER() over(partition by a.ColID order  by  a.ColID)   as rankNum
	from Sol_EntryColName   a
	left join Sol_TabConfig  b  on  a.BlID=b.BlID  and a.TabID=b.TabID
	left join Sol_PageConfig c  on a.ColID=c.ColID and a.BlID=c.BlID
	left join Sol_ProductInfo d on  d.ProductLine_Code=c.ProductLine_Code and d.PDT_Code=c.PDT_Code 
	where a.BlID=1 and (a.Status=0 or  a.Status=1 or a.Status=-1)
) temp
where temp.rankNum=1


select  *  from Sol_BaseLine  a ;

select  *  from  Sol_PartProductAttribute   a where a.BlID=1;

select  *  from Sol_EntryColName  where  BlID=1;

select  *  from Sol_TabConfig  where BlID=1;
select  *  from  Sol_Features  a;

--delete Sol_Features  where EntryID=71
--delete  Sol_PartProductAttribute  where BlID=1;
--delete Sol_EntryColName  where BlID=1;
select  *  from  SpecBaseLineEntryView  a;

select  *  from  specMS_SpecEntry  a;

select  *  from  specMS_SpecBLEntryRel  a;

select  *  from  specMS_EntryParam a;

select  *  from  Sol_EntryColName   a;

select  *  from  Sol_NetWorking  a;

select  *  from  specMS_SpecListExtColData  a;

select  *  from  specMS_AppConstantValue  a order by a.CreationDate  desc;

select  *  from  SpecBaseLineEntryView   a;

select  *  from  Sol_TabConfig a  where a.BlID=2;

select  *  from  Sol_Permission ;

select  *  from  Sol_DataIDSet  a;

--update Sol_DataIDSet set Status=1 where Status=0;

select  *  from  specMS_RESOURCE a where  RES_CODE='218003';
select max(EntryOrder) from Sol_Entry where DeleteFlag=0 and BlID = 1;

select  *  from  Sol_NetWorking   a;

select  *  from  specMS_RESOURCE  a  where RES_CODE='205001';

select  c.RL_NAME  from  specMS_ROLE_RESOURCE_RELATION  a  
inner join  specMS_RESOURCE b  on  a.RES_ID=b.RES_ID
inner join  specMS_ROLE  c on a.RL_ID=c.RL_ID 
where b.RES_CODE='203001';

select  *  from specMS_SpecBaseLine  a where a.blID=15955;

select  *  from Sol_BaseLine  a;

select  *  from  specMS_SpecBaseLine a;

select  *  from Sol_Entry  a  where  a.BlID=1;
select  *  from Sol_Entry  a  where  a.BlID=6;
select  *  from Sol_EntryRelation  a  order by a.RelID desc
--delete Sol_Entry  where BlID=1

--delete Sol_Entry  where BlID=11;
--truncate table sol_reference;

select  *  from Sol_EntryRelation  a  where a.EntryID=79595

select  *  from  Sol_PartProductAttribute  a  where a.BlID=6;
--update  Sol_PartProductAttribute  set IsAgree='Y',DefectFeedBack='test',OtherFeedBack='test1'  where  RelID='79150';

select  *  from  Sol_EntryRelation a where a.RelID=546;

select  *  from Sol_EntryColName a;

select  *  from Sol_TabConfig a;

select  *  from  specMS_SpecEntry order by  entryItemID;

select  *  from  specMS_SpecListExtColData  a;

select  c.*,a.EntryCName  from  Sol_Entry   a
inner join   Sol_EntryRelation   b   on   a.EntryID=b.EntryID
inner join   Sol_PartProductAttribute c  on  b.RelID=c.RelID
where  a.DeleteFlag=0 ;

select  * from  Sol_DataIDSet  a;

select  * from  Sol_PartProductAttribute  a;

select  * from  Sol_ProductInfo a;

select  *  from  specMS_EntryItemID;

select  dbo.F_PadLeft(123,10,'0');

select  CONVERT(varchar(50),GETDATE(),112);

SELECT REPLICATE('abc',3); 

select  isnull(replicate('0',2 - len(isnull('dsadsad' ,0))), '') +'dsadas';

select replicate('0',2 - len(isnull('dsadsad' ,0)))

select dbo.F_PadLeft('PD455645',20,'0')+'_'+CONVERT(varchar(50),GETDATE(),112)+'_'+dbo.F_PadLeft(123,10,'0');

select  *  from EmailTemplate a;

select  *  from BusinessNode  a;

select  *  from   specMS_ROLE  a ;

select  a.*,b.RES_CODE  from   specMS_RESOURCE_Lang  a 
inner join specMS_RESOURCE  b on a.RES_ID=b.RES_ID
where  a.RES_ID>=273;

select  *  from   specMS_RESOURCE a  where  a.RES_PID=291;
select  *  from   specMS_RESOURCE a  where  a.RES_PID=293;

select  *  from   specMS_RESOURCE a  where  a.RES_PID in(select  a.RES_ID   from   specMS_RESOURCE a  where  a.RES_PID=293);

select  *  from   specMS_ROLE_RESOURCE_RELATION  a   where  a.RL_ID=53 ;

select  a.*,b.RL_NAME,b.RL_CODE,c.FULL_NAME,c.RES_CODE  from   specMS_ROLE_RESOURCE_RELATION  a
inner join specMS_ROLE  b  on a.RL_ID=b.RL_ID
inner join specMS_RESOURCE c on  a.RES_ID=c.RES_ID
where  
--c.RES_CODE='230009'  and
(a.RES_ID>=273  or a.RL_ID>=54 )
order by RL_ID,RES_ID ;

select  *  from   specMS_SpecPermission  a;

select  *  from  Sol_DataIDSet  a where a.DataSetID=234;

select  *  from  Sol_Permission  a;

select  *  from   Sol_BaseLine a;


select  *  from  specMS_RESOURCE   a  where  a.RES_CODE='104004';

--update  Sol_PartProductAttribute  set  IsAgree='Y',DefectFeedBack='test',OtherFeedBack='test'
--from Sol_PartProductAttribute  a
--inner join Sol_EntryRelation  b  on a.RelID=b.RelID
--inner join Sol_Entry  c  on  b.EntryID=c.EntryID
--where  c.DeleteFlag=0 and  c.EntryID=912


--exec sp_dropserver 'iSplan', 'droplogins ';

--select  * into Sol_DataIDSetTest  from Sol_DataIDSet where 1=2;

--select  * into Sol_ProductInfoTest  from Sol_ProductInfo where 1=2;

--select  * into Sol_PermissionTest  from Sol_Permission where 1=2;

--drop table Sol_PermissionTest

--truncate table Sol_PermissionTest
select  *  from  specMS_TemplateSpec   a;

select  *  from  specMS_TabRefBaseLine a where a.listID=7230 order by createTime desc,refID desc;

select  *  from  specMS_SpecList  a   where a.blID=16012;

select  COUNT(*)  from  specMS_SpecEntryContent;
select  COUNT(*)  from  specMS_SpecBLEntryRel;
select  COUNT(*)  from  specMS_TabRefBaseLine;
select  COUNT(*)  from  specMS_StandardSupport;
select  COUNT(*)  from  specMS_EntryParam;
select  COUNT(*)  from  specMS_SpecListExtColData;


--UPDATE STATISTICS specMS_SpecEntryContent;
--UPDATE STATISTICS specMS_SpecBLEntryRel;
--UPDATE STATISTICS specMS_TabRefBaseLine ;
--UPDATE STATISTICS specMS_StandardSupport ;
--UPDATE STATISTICS specMS_EntryParam ;
--UPDATE STATISTICS specMS_SpecListExtColData ;

--3197879  3197880
select  *  from  specMS_SpecEntryChangeRel  a  where a.oldEntryID='3197880';

--16117  87677  1
--16117  87693  1
exec SP_GetEntryChangeList 16117,87677,1;
exec SP_GetEntryChangeListTest 16117,87677,1;

exec SP_GetEntryChangeList 16117,87693,1;
exec SP_GetEntryChangeListTest 16117,87693,1;

--16117  87677  1
exec SP_GetEntryChangeListTest  16071;




select  *  from  specMS_SpecListTab  a  where  a.tabID='86469';

select  *  from  specMS_SpecBaseLine  a  where a.blID=16012;
select  *  from  specMS_SpecBaseLine  a  where a.blID=16013;
select  *  from  specMS_SpecBaseLine  a  where a.blID=15598;

select  *  from  specMS_TemplateSpecBLRel  a where a.blID=15598;

select  *  from  specMS_TemplateSpec a where a.tempID=142;

select  *  from  specMS_TabRefBaseLine  a  where   a.listID=7230;


select base.blID,* FROM specMS_TabRefBaseLine  ref  
INNER JOIN specMS_SpecBaseLine base ON ref.blID=base.blID WHERE ref.listID=7230
and (base.status=-1 or base.status=0) and ref.status=2 AND base.status<>1;


select entryID from specMS_SpecEntry where entryId in 
(select entryID from specMS_SpecBLEntryRel where blID IN
	(
	select base.blID FROM specMS_TabRefBaseLine  ref
	INNER JOIN specMS_SpecBaseLine base ON ref.blID=base.blID 
	WHERE ref.listID=7230 
	and (base.status=-1 or base.status=0) and ref.status=2 AND base.status<>1
	) 
) AND verStatus=0;


--select  *   from  [iSplan].[JSZL].dbo.[View_SolutionProductLineInfo];

select  *   from  iSplan.JSZL.dbo.View_SolutionProductLineInfo;



select  *  from  Sol_Permission  a  where a.UserName='ys2689';
select  *  from  Sol_Permission  a  order by a.CreateTime desc;
select  *  from  Sol_PageConfig  a;
--truncate  table  Sol_PageConfig;

select  top 1  *  from  Log  order by  LogTime desc;

delete  Sol_Permission  from
(
select  a.*  from 	Sol_Permission  a  
inner join  Sol_PageConfig  b on  a.UserName=b.PDTManager
UNION
select  a.*  from 	Sol_Permission  a  
inner join  Sol_PageConfig  b on  a.UserName=b.InterfaceManager
) temp   where temp.UserName=Sol_Permission.UserName

--truncate  table  Sol_Reference;
--delete  from Sol_Entry  where BlID=1;


--refBlid 63 
--currentTabId 2
 select  TabId,*  from   Sol_TabConfig  a  where   a.BlId=63  and  a.TypeCode=(select  b.TypeCode  from  Sol_TabConfig  b where  b.TabId=2  )  ;

select  *  from   Sol_EntryColName  a  where  a.Type=1

 select  b.TypeCode,*  from  Sol_TabConfig  b where  b.TabId=2;

 select * from  Sol_EntryColName  a  where  a.blId=63 
 --and  a.Status=1 
 and  a.TabId=822;

select  *  from  Sol_Reference a;

select * from  Sol_Permission  a;

select * from  Sol_EntryColName  a  where  a.blId=63 and  a.Status in (0,-1) and  a.TabId=822

select  * from  Sol_DataIDSet  where SrcID='VD20200516175944332';

select  *  from Sol_Entry  a order by a.CreateTime desc;

select  *  from Sol_EntryColName  a ;

select  *  from  Sol_Entry  a  where a.BlID=63;

select  *  from  Sol_Entry  a  where a.BlID=1;

select  *  from  Sol_Entry  a  where a.EntryID=79821

select  *  from  Sol_EntryRelation  a  where a.EntryID=79857;

select  *  from  Sol_PageConfig  a;

select  *  from  Sol_PartProductAttribute a  where a.RelID='79393';

select  *  from  Sol_Features a;

select  *  from  Sol_Permission a  where a.RCode=30 group  by  a.UserName

--delete  Sol_Entry  where EntryID=79810;

select MAX(EntryOrder)  from Sol_Entry  where BlID=1;

select * from  specMS_SpecPermission    a  where   a.userType=1  and  rCode=30;

select  *  from  Sync_Employee  a;

select  *  from  specMS_SpecDataIDSet  a
where  a.srcPID='PL000016'

--PL000017
select  a.userName  from  specMS_SpecPermission  a
inner join specMS_SpecDataIDSet  b  on  a.dataSetID=b.dataSetID
where  b.PDT_Code='PT000206'  and rCode=30
group by a.userName;

select  a.PDT_Code,a.PDT_Name from Sync_ProductInfo  a  group by a.PDT_Code,a.PDT_Name;

 select * 
 from Sol_PartProductAttribute  a 
 inner join Sol_EntryRelation  b  on a.RelID=b.RelID 
 inner join Sol_Entry  c  on  b.EntryID=c.EntryID 
 where  c.DeleteFlag=0 and  c.EntryID=79803  and a.Status=-1;

 use iSEDB_Solution;
 select   *  from  Sol_Entry   a  where a.EntryID=79603;

 select  *  from  Sol_Permission  a where a.UserName='kf7785'  order by  a.CreateTime desc;

 select  SUBSTRING('1,2,3',0,CHARINDEX(',','1,2'));

 select  * from  dbo.f_SplitToTable('1,2',',');

 select  *  from  dbo.f_SplitToTable('79808,79811',',')  a
 inner join Sol_Entry b  on  a.a=b.EntryID 
 where  not exists  (select 1  from  Sol_Entry  where a.a=b.EntryID and b.Status=-2);


  select  *  from  dbo.f_SplitToTable('79808,79811',',')  a
  inner join  Sol_EntryRelation  b  on  a.a=b.EntryID  and BackEntryID=0;

  use iSEDB_Solution;

  select  *  from  sol_baseline  a   where a.BlID=94;

--  truncate table  sol_pageconfig

select  *  from  Sol_Entry a  where a.BlID=1;

select  *  from  sol_permission  a  where  a.username='02421';

select * 
from Sol_BaseLine  WHERE  exists
(
	select  blId  from  Sol_Entry   where EntryID=81088  and Sol_BaseLine.BlID=Sol_Entry.BlID
)

select  *  from  Sol_Permission  a where  a.UserName='00848';

select  ProductLine_Name  from  Sol_ProductInfo a   group by a.ProductLine_Name ;

select  *  from  specMS_RESOURCE   a  where  a.FULL_NAME   like '%flash%';

select  *  from  specMS_RESOURCE  a   where  a.RES_CODE='104004';

select  *  from  specMS_RESOURCE  a  where  a.Flag=1;

select  *  from  specMS_RESOURCE_Lang a;

--update  specMS_RESOURCE  set  flag=1  where RES_ID='267';

select  *   from  specMS_SpecPermission  a ;

select  *   from  specMS_ROLE_RESOURCE_RELATION  a;

select  *   from  specMS_SpecDataIDSet  a   where srcPID='PT000219';

select  * from Sync_Employee;

select  *  from  specMS_ROLE_RESOURCE_RELATION  a  where a.RL_ID=37;

--insert   into  specMS_SpecPermission
--select 1,'ys2045',1999,30,'',getdate();

select  *   from  specMS_SpecList  a;

select  *   from  specMS_TabRefBaseLine  a;

select  *   from  specMS_SpecBaseLine  a  where  a.blID=2995;

select  *   from  Sol_DataIDSet  a  where  a.SrcID='PD022266';
--PB022280
select  *   from  Sol_DataIDSet  a  where  a.SrcID='PB022280';

select  *   from  Sol_Permission  a  where  a.UserName='00764';

select  *   from  Sol_PartProductAttribute   a;

select  *  from  Sol_PageConfig  a   where  a.BlID=178;



select  *  from  Sol_Entry  a  where  a.EntryID='79880';

select  *  from  Sol_Entry   a  
inner join  Sol_EntryRelation  b  on  a.EntryID=b.EntryID
where  a.EntryID='79880';

--VD20200516175944332
--VD20200803152506526
select  *  from  Sol_DataIDSet  a   where  a.SrcID='VD20200729170958853';

select  a.*  from  Sol_PartProductAttribute a
inner join Sol_EntryRelation  b  on a.RelID=b.RelID
inner join Sol_Entry  c  on  b.EntryID=c.EntryID
where  
c.DeleteFlag=0 and  
c.EntryID in(79931);

--attributes

select  * from Sol_BaseLine  a  where  a.BlID=128;

select  *  from  Sol_Entry   a    where  a.BlID=11;

select  *  from  specMS_SpecBaseLine;

select  *  from  Sol_BaseLine  a;

select  *  from  Sol_EntryColName  a  where a.BlID=1;

select  *  from  Sol_PartProductAttribute  a  where a.BlID=1;

select  *  from  Sol_Features  a  where a.BlID=1;

--blid  16046   listId  7243
select  *  from  specMS_SpecList a  where  a.blID='16046';

select  *  from  specms_TabRefBaseLine  a;

select  *  from  Sync_ProductInfo  a;

select  CHARINDEX('d','ddfs');

select  *  from  bversionTemp  where LEN(bversioncname)>50;

select  *  from  bversionTemp  where productline_name  like '%软件%';

select  MAX(srcID)  from  specMS_SpecDataIDSet  a  
--where srcID='PR002714';
order by srcID;

--update specMS_SpecDataIDSet  set issync=1

select  *  from  specMS_SpecDataIDSet  a  where a.srcPID='PT000219';

select  *  from  specMS_SpecDataIDSet  a  where a.srcID='PR990001';

select  *  from  specMS_SpecDataIDSet  a  where a.Status=0;

select  *  from  specMS_SpecDataIDSet  a  order by a.dataSetID desc;

select  *  from  EmailTemplate  a;

--update specMS_SpecDataIDSet  set verType=1  where dataSetID=25559;

select  *  from  Sol_Permission  a   order  by  a.CreateTime desc;

select  *  from  Sol_Permission  a  where 
--a.RCode=1  and 
a.DataSetID=13;

select  *  from  Sol_PageConfig  a;

select  *  from  specMS_SpecListTab  a;

select  *  from  Sol_BaseLine  a where a.BlID=11;

select  *  from  Sol_DataIDSet  a  where a.DataSetID=13;

--delete  Sol_Permission  where dataSetId=13
--delete Sol_PageConfig   where dataSetId=13;

--1 在研
--2 正常终止
--3 异常终止
--4 挂起

--S10500 V700R003

select  *  from  specMS_SpecDataIDSet  a  where a.srcName='S10500 V700R009';

select  *  from  specMS_SpecDataIDSet  a  where a.srcName='S10500 V700R007';

select  *  from  specMS_SpecDataIDSet  a  where a.srcName='S10500 V700R003';

select  *  from  specMS_SpecDataIDSet  a  where a.srcName='S10500 V700R012';

select  *  from   Sol_Entry  a  where a.BlID=9;

select  *  from  f_SplitToTable('ds,eqw',',');
--.dbo.f_SplitToTable('ds,ewq',',');


select  *  from  specMS_SpecDataIDSet  a  where a.srcID='PB002498';

select  *  from  specMS_SpecDataIDSet  a  where a.srcID='PT000190'
--3585
--3598
--3616
--3687

select  *  from  specMS_SpecDataIDSet  a  where  a.dataSetID=3585;

select  *  from  Sol_DataIDSet  a;  

--PR990031  PR002193
--update specMS_SpecDataIDSet  set  Status=1  where IDLevel=4;

select  *  from specMS_SpecDataIDSet  a  where a.IDLevel=4;

select  *  from  Sol_DataIDSet   a  where a.SrcName='P5G V200R001 自筹 科技部 科技冬奥课题三项目B11D001';

select  * from  Sol_Permission  a  where  a.DataSetID=238  order by a.RCode ;

select  * from  Sol_Permission  a  where  a.DataSetID=241   order by a.RCode ;

--父 VD20181207094527877  134
--子 VD20190905171351270   135

select  *  from  Sol_DataIDSet  a  where  a.SrcID='VD20190905171351270';

select  *  from  Sol_Permission  a where  a.DataSetID=134;

select  *  from  Log  a  where  a.Summary='配置PDT经理发送邮件'
order by  a.LogTime desc;

select  *  from  Sol_DataIDSet  a where a.SrcID='VD20190905171351270';

select  * from EmailTemplate a;

select  *  from  Sol_PageConfig  a;

select  *  from  specMS_SpecDataIDSet  a  where  srcID  like '%pb%';

--PR000207

select  *  from  specMS_SpecDataIDSet  a  where  srcID='PR003463';

select  *  from  specMS_SpecList   a  where  a.verTreeCode='PR003463';

select specMS_SpecList.* from specMS_SpecList    
    left join specms_SpecBaseLine  b  on  specMS_SpecList.blId=b.blId
    where verTreeCode='PR003463' ;
--and  (b.DeleteFlag=0  or b.DeleteFlag  is null);

with temp as
(
	select  * from Sol_DataIDSet   a  where  a.SrcID='VD20190905171351270'
	union all
	select  a.* from Sol_DataIDSet   a
	inner join temp  b  on  a.SrcID=b.SrcPID
)

select  *  from  temp  where IDLevel=2;

select  * from specMS_SpecDataIDSet  a  where a.srcID like  '%PB%';

select  * from specMS_SpecDataIDSet  a where a.srcID='PR990032';
select  * from specMS_SpecDataIDSet  a where a.srcID='PR990001';

--update specMS_SpecDataIDSet set srcID='PB990001' where dataSetID=25557;

select  * from specMS_SpecDataIDSet  a  order by a.dataSetID desc;

select  * from specMS_SpecBaseLine  a  where a.ApplyID='f091b32f-5d90-4f48-9ab5-43c5700c5f95';

select  * from specMS_SpecPermission;

select  *  from BusinessNode  a;

select  *  from  EmailTemplate  a;

select  distinct  b.RegionAccount,a.*  from  specMS_SpecPermission  a
inner join  Sync_Employee b on a.userName=b.NotesAccount
where  a.rCode=1001;

select  distinct  b.RegionAccount  from  Sol_Permission  a
inner join  Sync_Employee b on a.userName=b.NotesAccount
where  a.rCode=1  and   a.dataSetID=4;

select  *  from  Sol_DataIDSet   a  where a.SrcID='PD022244';

select  *  from   Sync_Employee  a;

--PT000219
select  *  from  specMS_SpecBaseLine  a;

select  *  from  specMS_SpecList  a  where a.verTreeCode='PR990032';

select   b.*  from  specMS_SpecList  a
inner join  specMS_SpecBaseLine  b  on  a.blID=b.blID
inner join  specMS_SpecDataIDSet   c   on   a.verTreeCode=c.srcID
where b.status=0  and c.srcPID='PT000219';

select  *  from  specMS_SpecDataIDSet  a  where a.srcID='PR990001';

select * from specMS_SpecDataIDSet  a ;

select  *  from   specMS_SpecPermission  a where a.rCode=30;

select  *  from  specMS_SpecDataIDSet  a  order by a.dataSetID desc;
--update  specMS_SpecDataIDSet   set srcID='PR99990001'  where dataSetID=25559;

select  top 100  *  from   Log  a  order by  a.LogTime desc;

select  *  from  Sol_PageConfig   a  where a.BlID=11;

select  *  from  Sync_ProductInfo  a   where a.ProductLine_Code='PL000017';

select  *  from  Sol_PageConfig  a  
left join Sync_ProductInfo  b  on  a.ProductLine_Code=b.ProductLine_Code and a.PDT_Code=b.PDT_Code
where  a.ConfigID=55;

--PL000017   PT000237
select   *  from   Sync_ProductInfo   a   where  a.ProductLine_Code='PL000017'  and a.PDT_Code='PT000237';


select  *  from  specMS_SpecDataIDSet   a;

select  *  from  Sol_EntryRelation  a;
--CloudNet V100R001 TR5规格

truncate table  sol_reference;

select  *  from  Sol_BaseLine  a  where a.BlID=154;

select  *  from  Sol_Entry  a where a.BlID=154;

select  *  from  Sol_Entry  a where a.BlID=191;

select  *  from  Sol_PartProductAttribute  a  where  a.BlID=154;

select  *  from  Sol_PartProductAttribute  a  where  a.BlID=11;

select  *  from  specMS_Dict   a  where a.dictId='107002';

select  *  from  Sol_BaseLine  a;

select  *  from  Sol_NetWorking   a;

--update Sol_BaseLine   set  flowStatus=1  where BlID=32;

--delete Sol_Entry  where BlID=11;
--delete Sol_PartProductAttribute  where BlID=11;
--delete Sol_Features  where BlID=11;
--truncate table sol_reference;

select  count(*)  from  Sol_PartProductAttribute  a  where a.blId=30;

select  * from  Sol_EntryColName  a;

select  *  from   specMS_SpecBaseLine  a;

--PL000017

with temp as 
(
	select  srcID,srcPID,IDLevel  from  specms_SpecDataIDSet  a  where a.srcID='PT000219'
	union all
	select  a.srcID,a.srcPID,a.IDLevel  from  specms_SpecDataIDSet  a 
	inner join temp  b  on  a.srcPID=b.srcID
)

--select  *  from  temp  a;

select  *
from  specms_SpecBaseLine  a  
inner join  specMS_SpecList  b  on  a.blId=b.blId
inner join  temp  c  on   b.verTreeCode=c.srcID  and c.IDLevel=3
--where  d.srcID='PL000017';


select  *  from  specMS_SpecDataIDSet  a   where  a.srcID='PB990034';

select  *  from  specMS_SpecDataIDSet  a   where  a.srcPID='PR003314';

select  *  from  specMS_SpecDataIDSet  a   where  a.isSync=0;

select  *  from specMS_TabRefBaseLine with(nolock) where listblID =16533 and status = 2;

select  *  from  specMS_SpecBaseLine  a  where a.blID=15638;

select  *  from  specMS_SpecBaseLine  a  where a.blID=7350;

select  *  from  specMS_SpecDataIDSet  a  where  a.srcID='PR002898';

select  *  from  specMS_SpecDataIDSet  a  where  a.srcID  like 'PR99%';

--PR003527
select  *  from  specMS_SpecDataIDSet  a  where  a.srcID='PR002965';

select  *  from  Sync_ProductInfo  a  where  a.Release_Code='PR99990016';

select  *  from  specMS_IsSwitch  a;

--delete specMS_SpecDataIDSet  where srcID='PR99990016';

--delete Sync_ProductInfo  where Release_Code='PR99990016';

--update  specMS_IsSwitch  set isswitch=0;

select  *  from  specMS_SpecList   a where a.blID='16119';

select  *  from  specMS_SpecListTab  a where  a.listID='7280';

--PT000227

select  b.*,c.*  from  specMS_SpecList     a   
inner join  specMS_SpecBaseLine  b  on  a.blID=b.blID
inner join  specMS_SpecDataIDSet   c   on   a.verTreeCode=c.srcID
where 
b.status!=1   and  
c.status=1 and 
c.srcPID='PT000227'; 

--7280
select  *  from   specMS_SpecList  a  where   a.blID=16119;

select  *  from   specMS_SpecListTab   a   where   a.listID=7280;

select  *  from   specMS_SpecDataIDSet   a;

select  *  from  specMS_SpecBLEntryRel  a  
inner join   specMS_SpecEntryContent  b  on  a.entryID=b.entryID
where a.blEntryID in (7064489);

select  *  from  specMS_SpecBLEntryRel  a  
inner join   specMS_SpecEntryContent  b  on  a.entryID=b.entryID
where a.blEntryID in (7049133
,7049134
,7049135
,7049136
,7049137
,7049138
,7049139
,7049140
,7049141
,7049142);


select  *  from  specMS_SpecBLEntryRel  a  
inner join   specMS_SpecEntryContent  b  on  a.entryID=b.entryID
where a.blEntryID in (7049138,7049139,7049140);

--7056287   先知精灵

select  *  from   specMS_SpecListExtColData   a  where a.blEntryID='7064489';

--16761		
--引用基线2			16791

--引用基线1108		16880

--PR990032	
--panxiyuan 01056,huhongliang 07652,qinchuan 07807,fengchaojin 08416,jichengzhi 08604,
--yanwei 08693,songkeke 09757,fangsen 11287,liaoqiang 12554,jinbin KF2043, YS1421,
select  b.*  from  specMS_SpecDataIDSet  a  
inner join  specMS_SpecPermission  b  on  a.dataSetID=b.dataSetID
where  a.srcID='PR990032'  and   b.rCode=9

--7058617
--7064489
--7059431
--7059433
--7064279
--7064278
--7064280
--7064282
--7064283

select  *  from   Sync_Employee  a;

select  *  from   specMS_SpecListExtColData   a where blID=16761 and srcblID=16880;

select  *  from   specMS_SpecListExtColData   a where blID=16761 and srcblID=16791;

select  *  from   specMS_SpecListExtColData   a where blID=16761 and srcblID=17094;

--智能引擎  间接引用基线  100968  Default
select  *  from   specMS_SpecListExtColData   a where blID=16761 and srcblID=17066;

select  *  from   specMS_SpecListExtColData   a where blID=16761 and tecID=24299;

select  *  from   specMS_SpecListExtColData   a where blID=16761 and tecID=24298;

select  *  from   specMS_SpecListExtColData   a  where  a.blEntryID='7064283'  order by  a.createTime desc,tecID;

select  *  from   specMS_SpecListExtCol   a  where  a.extColID='24299';

select  *  from   specMS_SpecEntryContent;

select  len(queryCondition)  from  specms_CustomerSearch where cusSearchId=1;

select  *  from  specMs_CustomerSearch;


--truncate table specMs_CustomerSearch

select  *  from  specMS_SpecBLEntryRel  a  
inner join   specMS_SpecEntryContent  b  on  a.entryID=b.entryID
where  a.blID=16792  order  by a.blEntryID;

select  *  from  specMS_SpecBLEntryRel  a  
inner join   specMS_SpecEntryContent  b  on  a.entryID=b.entryID
where  a.blID=16881    order  by a.blEntryID;

select  *  from  specMS_SpecDataIDSet   a  where  a.dataSetID=2779; 

--select  * into  RDMDS_V_PDT_TMP from   [RDMDSDB].[rd_mds].[mdm].[V_PDT];

select  *  from  RDMDS_V_PDT_TMP  where  pdt_Manager  like '%02786%';

--PR99990039	dingyuanpu 08728

select  *  from  RDMDS_V_PDT_TMP  a;

select  *  from   specMS_SpecDataIDSet  a  where  a.srcName='园区核心交换机';

select  a.srcName,b.userName,a.dataSetID  from  specMS_SpecDataIDSet  a 
left join   specMS_SpecPermission   b  on  a.dataSetID=b.dataSetID
where b.rCode=30 and  show=1  and  Status=1 and flag=1
and  a.srcName='CCLSW SOFT_BMWC89'
order by  a.orderNo;


select  
t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge,
per.userName,emp.ChnNamePY,emp.RegionAccount
--t3.SrcName PRName
from  specMS_SpecDataIDSet  t1
LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
left join specMS_SpecPermission   per  on  t3.dataSetID=per.dataSetID
left join Sync_Employee  emp  on  emp.Code=per.userName
where t1.IDLevel=1     and (t4.flag=1  or t4.flag is null) and t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193')) 

--and  per.rCode=30
order by PROorderNo,PDTorderNo,PRorderNo desc,PBCode;


select distinct PDTName,PDT_Manager  from
(
select  
t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge,
PDT_Manager
from  specMS_SpecDataIDSet  t1
LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
left join RDMDS_V_PDT_TMP  temp on t2.srcID=temp.code
where t1.IDLevel=1     and (t4.flag=1  or t4.flag is null) and t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193')) 


)s  group   by  s.PDTName,PDT_Manager,PROorderNo,PDTorderNo,PRorderNo
--order by PROorderNo,PDTorderNo,PRorderNo desc;



select  a.code,b.srcName,a.PDT_Manager,b.*  from  RDMDS_V_PDT_TMP  a
inner join  specMS_SpecDataIDSet   b  on  a.code=b.srcID
where b.IDLevel=2 and b.show=1 and flag=1;

select  c.*,a.*,b.*  from  specMS_SpecList     a   
inner join  specMS_SpecBaseLine  b  on  a.blID=b.blID
inner join  specMS_SpecDataIDSet   c   on   a.verTreeCode=c.srcID
where b.status!=1   and  c.status=1 and c.srcPID='PT000289';

select  *  from    specMS_SpecList   a   where    a.verTreeCode='PR003463';

select  *  from    specMS_SpecDataIDSet   a   where   a.srcID='PR003359';
--PR003778

--update specMS_SpecDataIDSet set
--                           BLNumber=
--                              (select COUNT(*) from dbo.specMS_SpecModule where 
--                              verTreeCode ='PR003778' and smSort = 3 and type = 0 )+
--                             (  
--                                select COUNT(*) from dbo.specMS_SpecList  a
--                                inner join  specms_SpecBaseLine  b  on  a.blid=b.blid
--                                where verTreeCode ='PR003778' and a.blID !=0  and  (b.DeleteFlag=0  or  b.DeleteFlag is  null)
--                             )
--                           where srcID='PR003778';

select  *  from  sepcMS_SpecListExtColGroup;
--基础软件  jiaoxupo 00595

select  
t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge
from  specMS_SpecDataIDSet  t1
LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
where t1.IDLevel=1     and (t4.flag=1  or t4.flag is null) and t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193'));

select   *  from  specMS_SpecDataIDSet   a  where a.IDLevel>=3   and flag=1 and  a.show=1
--where   a.srcID='PR002193';

select   *  from  specMS_SpecListTabExtCol   a   where  a.tabID=101552  and  (a.status=0  or a.status=-1);

select   *  from  FormDefaultValue  a;



--1000
select distinct    blID  from  specMS_SpecBaseLine;

select  *  from  Sync_Employee a  where  a.EnterDateTime>'2020-11-02'  where  RegionAccount is not null  and ChnNamePY='chenmin';

select  distinct UserID,UserName  from  LoginUserLogInfo  a  where  a.LoginDate>='2020-01-01' ;

select  *  from  LoginUserLogInfo  a;

select  *  from  Log  a;

--有一种情况  选中页面的扩展列 在非选中页面 不存在  
--insert into specMS_SpecListExtColData(blEntryID,tecID,supCase,implCase,mergVer,standard,explain,
--param,virtualSpec,xmlData,oldVersion,createTime,createBy,status,blID,srcTecID,srcblID,extModifyBlId,IsAutoMatchRVersion) 
select blEntryID,24299,-1,2,'','','','',virtualSpec,xmlData,'' ,getdate(),createBy,0,16761,0,0,16761,0,tecID from specMS_SpecListExtColData 
where blEntryID in ('7064280','7064282','7064283')  and blID=17066 and status>=0 and tecID=24604 ;


select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR003930';
--CCLSW SOFT_BMWC88B02

select  *  from   specMS_SpecDataIDSet  a  where  a.srcName='CCLSW SOFT_BMWC88B02';

with temp as
(
	select  *  from  specMS_SpecDataIDSet  a  where  a.IDLevel>1 and  a.srcPID  not in (select  srcID from  specMS_SpecDataIDSet)
)

--delete  specMS_SpecPermission   where   dataSetID in (select  dataSetID  from temp);
--delete  specMS_SpecDataIDSet  where  dataSetID in (select  dataSetID  from temp);

--当前选中规格blEntryid			7073585  7073586
--当前选中规格entryId				3268191  3268192
--当前选中规格父级blEntryId		7073579	7073580
--当前选中父级规格Entryid		3268185  3268186

select  *  from  specMS_SpecListTab   a  where  a.tabID='100583';

select   *  from  specMS_SpecListExtColData  a  where a.blID=16761 and blEntryID='7073585';

select  *  from  specMS_TabRefBaseLine  a  where  a.blID=16762

select  *  from  specMS_SpecEntry  a   where a.entryID='3268186';

select  *  from  specMS_SpecBLEntryRel   a  where  a.blEntryID='7073585';

select  *  from  specMS_SpecBLEntryRel  a  where  a.entryID='3268185' and blID=16762;

select * from dbo.f_SplitToTable('1,2,3',',');

select  top 100  *  from  Log  order by LogTime desc;

--7073623

--3268185
--exec P_UpdateParentEntryWhenDelete '3268185',16762,100583;

--3268257  16608  ""

exec P_UpdateParentEntryWhenDelete '3268257',16608,'';

select  *  from  specMS_TabRefBaseLine  a  where  a.listblID=16608;

select  ISNULL((select  listblID from specMS_TabRefBaseLine  where 1!=1 ),0)
select  listBlId from specMS_TabRefBaseLine  where blID=16608   and  status=2;

select  * 
	from  #ParentEntryIdTable   temp
	inner join specMS_SpecBLEntryRel  rel on  temp.entryId=rel.entryID 
	inner join specMS_SpecListExtColData  extColData  on   extColData.blEntryID=rel.blEntryID  
	where  rel.isLeaf=0  and rel.blID=@subBlId   and  extColData.blID=@blId 
	and  (extColData.status=-1  or extColData.status=0);

select  *  from  specMS_SpecListExtColData  a  where  a.blID=16608;

select  * from  SpecBaseLineEntryView  where  blEntryID='7073636';

select  *  from  specMS_SpecEntryContent  a  where a.entryID='3268186'

select  *  from  specMS_SpecBLEntryRel  a  where  a.blEntryID='7073636';

select  *  from  specMS_SpecBaseLine   a   where   a.blID=16608;

select  *  from  specMS_SpecList  a  where   a.blID=16608;

select  *  from  specMS_SpecListExtColData a
inner join   specMS_SpecBLEntryRel  b on  a.blEntryID=b.blEntryID
inner join   specMS_SpecEntryContent  c on  b.entryID=c.entryID
where  a.blID=16608 and  b.flag=0;

--exec BatchSpecListExtColData_Edit '7073573',2,2,-1,'','',0,16761,16762,24298;

--exec BatchSpecListExtColData_Edit '7056289',1,3,-1,'','',0,16761,16762,24298;

--PB003770
select  *  from  specMS_SpecDataIDSet  a  where  a.srcName='UNIS SNA Center V100R001B01';

select  *  from  specMS_SpecList  a 
inner join  specMS_SpecBaseLine  b  on  a.blID=b.blID
where  a.verTreeCode='PB003770';


select  *  from   specMs_IsSendEmailWhenAddVersion;

--truncate table  specMs_IsSendEmailWhenAddVersion

select  *  from  specms_specdataIDSET   A  where  a.srcID='PB990075';

select  *  from  Sync_Employee  a  where  a.ChnNamePY like '%yaopinjiang%';

select  *  from  specMS_SpecPermission  a  order by a.createTime desc;

select  *  from  specMS_SpecPermission  a  where  a.dataSetID is null;

--exec SP_UpdateSpecMSSupper 16761,'24298','7074084,7074086,','';

--exec SP_GetBaseLineRefInfo @blId;

select  * from  specMS_SpecListTab   a  where  a.tabID='100583';

select  *  from  specMS_TabRefBaseLine  a  where  a.listblID=16761;

select  c.* from
(
select  *  from  specMS_SpecBLEntryRel  a  where a.blID=16762  and flag=0  and  
union
select  *  from  specMS_SpecBLEntryRel  a  where a.blID=16881 and flag=0
) temp
inner  join  specMS_SpecEntryContent  c  on  temp.entryID=c.entryID  

select  *  from  specMS_SpecBLEntryRel  a  
inner  join  specMS_SpecEntryContent  c  on  a.entryID=c.entryID  
where a.blID=16762  and flag=0  and  refID=100583
union
select  *  from  specMS_SpecBLEntryRel  a  
inner  join  specMS_SpecEntryContent  c  on  a.entryID=c.entryID  
where a.blID=16881 and flag=0  and  c.isShare=1;

select  *  from SpecBaseLineEntryView 
where 1=1  and (blID in (16881) and isShare=1 or flag=0 and refID=100583 and blID = 16762);

--PB990021
select  a.*  from  specms_SpecBaseLine  a
inner join  specMS_SpecList   b  on a.blID=b.blID
where (a.deleteFlag is  null  or  a.deleteFlag=0 )  and  b.verTreeCode='PB990021';

select  distinct *  from  Sync_ProductInfo  a  order  by  Release_Code  ;

select  *  from  specMS_SpecList  where verTreeCode='PR990077';

select  *  from  specMS_SpecDataIDSet a  where  a.srcID='PB990021';

select  *  from  specMS_SpecDataIDSet a  where  a.srcID='PR99990036';

--update  specMS_IsSwitch set IsSwitch=0;


select a.* from specMS_TabRefBaseLine a
inner join  specMS_SpecBaseLine b  on  a.listblID=b.blID
where a.listblID=16947 and a.DataSrc != 2;

select  *  from  specMS_SpecDataIDSet  a  where  a.srcID='PR99990033';

select  IsNull(Max(srcID),0)  from  specms_SpecDataIDSet  a where  
a.isSync=0  and 
a.srcId  like 'PR%';

--子规格  部分实现数据处理
--版本存在重复code数据处理

select  *  from specMS_SpecDataIDSet   a   where  a.srcID  like '%PR9999%'  and issync=1;

--update  specMS_SpecDataIDSet  set  issync=0  where  srcID  like '%PR9999%'  and issync=1;


--exec P_UpdateData;

--drop  procedure  P_UpdateData;

select  *  from   specms_specDataIdSet  a  where  a.srcId='PT000219';

select  *  from   specMS_EntryDepend  a;

select  *  from   Sync_ProductInfo  a  where  a.ProductInfoID in('9A3CBFC1-A320-4C56-A3C1-0002008C6B97','741EE5FA-5E56-424C-8777-000B60C65F96')

--Sync_Deliverables
SELECT * FROM specMS_Deliverables  a;

SELECT * FROM Sync_Deliverables  a;


SELECT * FROM specMS_Character   a;

select   *  from  specMS_ChangeControl_Apply  a;

select  *  from  specMS_SpecDataIDSet  a  where  a.srcID  like '%PR99%';

select MAX(srcid)  from   specMS_SpecDataIDSet  a  where a.srcID  like '%PR99%';

select  IsNull(Max(srcID),0)  from  specms_SpecDataIDSet  a where  a.isSync=0  and a.srcId  like 'PR99%';

select  *  from   Sync_ProductInfo  a where Release_Name='iMC V700R018';

--PT000279 技术战略
select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PT000279';

select  *  from   specMS_SpecDataIDSet  a  where  a.srcPID='PT000279';

--iMC V700R015 (在研)  PR003426
--iMC V700R018 (在研)  PR003454
--20201201R (在研)	   PR99990044
select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR003426';
select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR003454';


select  
t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge
from  specMS_SpecDataIDSet  t1
LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
where t1.IDLevel=1   and   t4.isSync=0  and (t4.flag=1 or t4.flag is null) and t1.show=1 and t2.show=1 and t3.show=1 and (t4.show=1 or t4.show  is null)   and
t3.srcID='PR003426'  or  t3.srcID='PR003454'  or t3.srcID='PR99990044'  and 
 (t4.VerType=1  or t4.verType=0   ) and 
t3.Status is not null order by PROCode,PDTCode,PRCode,PBCode ;


select  *  from  specMs_ModuleChangeRecord  a;

select  *  from  specMS_SpecModule   a;

select  *  from  specMS_SpecModuleBLRel   a;

select  COUNT(smID)  from  specMS_SpecModuleBLRel   a 
group  by  a.blID;

--iMC ESM V900R005
select  *  from  Sync_ProductInfo  a  where  a.Release_Name='iMC V700R018';

select  *  from  Sync_ProductInfo  a  where  a.Release_Name='iMC V700R015';

select  *  from  Sync_ProductInfo  a  where  a.Release_Name='iMC V900R003';

select  *  from  Sync_ProductInfo  a  where  a.Release_Name='iMC ESM V900R005';

select  *  from  specMS_SpecDataIDSet  a  
where  a.srcID  not in(select  a.Release_Code  from Sync_ProductInfo  a);

--truncate  table  specms_CustomerSearch

select  *  from   specms_CustomerSearch  a;

select   *  from   specMS_SpecModule  a  where a.verTreeCode='PR003407';

select   *  from  specMs_SpecModuleHistory  a;
--truncate  table   specMs_SpecModuleHistory;

with temp  as
(
	select  *  from  specMS_SpecModule  where smID  in (select smID from specMS_SpecModuleBLRel where blID=17244)
	union  all
	select  a.*  from  specMS_SpecModule  a  inner join  temp  b  on  a.smID=b.smPID
)

select  *  from  temp;


with temp1  as
(
	select  *  from  specMS_SpecDataIDSet  where  srcID='PR003025'
	union  all
	select  a.*  from  specMS_SpecDataIDSet  a  inner join  temp1  b  on  a.srcPID=b.srcID
)

select  *  from  temp1  a;


with temp1  as
                                                            (
	                                                            select  *  from  specMS_SpecDataIDSet  where  srcID='PB001142'
	                                                            union  all
	                                                            select  a.*  from  specMS_SpecDataIDSet  a  inner join  temp1  b  on  a.srcID=b.srcPID
                                                            )
                                                            select  *  from  temp1  a  where idLevel>2;

--S10500 V700R015   测试R版本

--OPT V500R002
--update  specMS_SpecDataIDSet   set   srcName='S10500 V700R015'  where srcID='PR99990045';


select  *  from  Sync_Employee  a where a.ChnNamePY='chenmin'  and  a.Code='ys2689'

select  *  from  specMS_SpecModuleBLRel  a;

select  *  from  specMS_SpecDataIDSet  a  where  srcPID='PR003494'  ;

--update  specMS_SpecDataIDSet  set  isMerge=0,blNumber=0  where srcID='PR003494';

--PB001532
select  *  from  specMS_SpecDataIDSet  a  where srcID='PB001532'  or srcPID='PR003494'  ;
--PL000025
select  *  from  specMS_SpecDataIDSet  a  where srcID='PR99990048' ;
	
select  *  from  specMS_SpecList  a  where  a.verTreeCode='PB990102';

--update  specMS_SpecList  set  verTreeCode='PB003521'  where verTreeCode='PB990101';

select  *  from   specMS_SpecBaseLine a  where a.blID in(17277,17281);

select  *  from   specMS_SpecDataIDSet  order by dataSetID desc;

--PR99990050		PR003637

select  *  from   specMS_SpecDataIDSet  a  where a.srcID='PR003404' or srcPID='PR003404';

--PR99990051		PR003359
select  *  from   specMS_SpecDataIDSet  a  where a.srcID='PR99990017';

select  *  from   specMS_SpecDataIDSet  a  where a.srcID='PB003853';

select  *  from   specMS_SpecDataIDSet  a  where a.srcID='PR990007';

select  top  1000  * from  Log  a order  by  a.LogTime desc;

select *  from  specMS_SpecBaseLine  a  order  by a.blID  desc;

select  *  from  specMS_TemplateSpecBLRel  a;

select  lTitle,verTreeCode  from   specMS_SpecList a 
inner  join  specMS_SpecBaseLine  b  on a.blID=b.blID
group  by  b.lTitle,a.verTreeCode  having (COUNT(lTitle)>1)

--PB003853
select  *  from   specMS_SpecList a 
inner  join  specMS_SpecBaseLine  b  on a.blID=b.blID
--where  b.deleteflag=1
 where a.verTreeCode='PB003853';

select  *  from   specMS_SpecBaseLineLabel  a  where a.blID in (17225);

select  *  from   specMS_SpecModule  a  where a.verTreeCode='PR99990041';

--update specMS_SpecDataIDSet   set

select  *  from   specMS_SpecDataIDSet  a where  IDLevel=3 and flag=-1;

select  *  from  specMS_SpecDataIDSet a  where a.srcPID='PR003734';

select  *  from   specMS_SpecDataIDSet  a  where   a.srcName='UNIS SNA Center V100R001';

select  *  from   specMS_SpecBaseLine  a ;

select  *  from   Sync_ProductInfo  a  where  a.Release_Code='PR99990055';

select  *  from  RDMDS_V_PDT_TMP  a   where  a.Code='PT000227';

select distinct  b.srcName,b.orderNo  from  specMS_SpecPermission  a
inner  join  specMS_SpecDataIDSet  b  on a.dataSetID=b.dataSetID
where  a.rCode=9  and  a.userName='00739'  and  b.IDLevel=3 and b.flag=1  and b.Status=1
order by  b.orderNo desc;

select  *  from  specMS_TabRefBaseLine   a;

select  *  from  specMS_TabRefBaseLine  a  where  listblID=17441;

select  *  from  specMS_SpecBLEntryRel  a where   blID=17431;

select  *  from  specMS_SpecList   a  where  a.listID=8343;

select  *  from  specMS_SpecList   a  where  a.blID=17442;

select  *  from  specMS_SpecListExtCol  a  where  a.listID=8343;

select  *  from  specMS_SpecListExtColData  a  where  a.blID=17430;

select  *  from  specMS_SpecDataIDSet  a   where  a.IDLevel=2;

--主基线idblId  17439    子基线id  17440

select  b.*  from  specMS_SpecBLEntryRel  a 
inner  join  specMS_SpecEntry  b  on a.entryID=b.entryID
where   blID=17440;

select  a.*,b.*  from  specMS_SpecBLEntryRel  a 
inner  join  specMS_SpecEntryContent  b  on a.entryID=b.entryID
where   blID=17440;

select  *  from  specMS_SpecEntryChangeRel  a  where blID=17442;

select  *  from  specMS_SpecEntryContent   a  where  a.entryID='3325268';

select  *  from  specMS_TabRefBaseLine  a  where  a.listblID=17441;

select  *  from  specMS_SpecEntryChangeRel   a   where   a.entryID  in
(
	select  c.entryID  from  specms_TabRefBaseLine  b   
	inner join  specMS_SpecBLEntryRel  c  on  b.BlId=c.BlId   
	where  b.listblID=17441  and  
	c.refID=105206  and  
	b.status=2  
) 

select  *  from  specMS_SpecEntryChangeRel   a   where   a.entryID  in
(
	select  c.entryID  from  specms_TabRefBaseLine  b   
	inner join  specMS_SpecBLEntryRel  c  on  b.BlId=c.BlId   
	where  b.listblID=17441  and  
	c.refID=105206  and  
	b.status=2  
) 

--3325265  3325264
select  *  from  specMS_SpecEntryContent  a  where  a.entryID='3325264';
select  *  from  specMS_SpecEntryContent  a  where  a.entryID='3325265';

select  *  from  specMS_TabRefBaseLine  a  where  a.listID=8349  and  a.status=2;

select  *  
from  specms_SpecEntryChangeRel  a    
inner join  specms_TabRefBaseLine  b   on  a.BlId=b.BlId  
inner join  specms_SpecBaseLine  c  on  b.BlId=c.BlId   
where  b.listId=8349  and  
--b.TabId=105206  and  
b.status=2  and 
c.status<>1;   

select  *  
from  specms_SpecEntryChangeRel  a    
where entryID  in
(
select  c.entryID  from  specms_TabRefBaseLine  b   
inner join  specMS_SpecBLEntryRel  c  on  b.BlId=c.BlId   
where  b.listId=8349  and  
c.refID=105206  and  
b.status=2  
)

select  *  from  specMS_SpecBaseLine a where  a.blID=17440;

select  *  from  specms_SpecEntryChangeRel  a    where  a.blID=17442;

select  *  from  specMS_TabRefBaseLine a  where a.listID=8349;

select  *  from  specMS_SpecBLEntryRel a  where a.blID=17440;

select  *  from   specMS_SpecListExtColData  a  where  a.blID=17441;

select  *  from   specMS_SpecList   a   where   a.blID=17441;

select  *  from   specMS_SpecListTab   a   where   a.listID=8350;

select  *    from specMS_SpecListExtColData where 
--status=-1 and 
blID=17441 and  blEntryId  in( select   blEntryId  from   specMS_SpecBLEntryRel  a  where  a.refId=105281);

select  *    from   specMs_SpecEntryChangeRel    where blID=17442  and  entryId  in 
                                                       ( 
                                                            select   a.entryID  from  specMS_SpecBLEntryRel  a
	                                                        where  a.blId=17442  and  a.refID=105281
                                                       ) ;


select  *  from   RDMDS_V_PDT_TMP  a  where  a.code='PT000207';

exec sp_executesql N' select  *  from   RDMDS_V_PDT_TMP   a  where  a.Code=@p0  and  PDT_Manager=@p1 ',N'@p0 nvarchar(4000),@p1 nvarchar(4000)',@p0=N'PT000207',@p1=N'wangxin kf7785';

exec sp_executesql N' select  *  from   RDMDS_V_PDT_TMP   a  where  a.Code=@p0  and  PDT_Manager=@p1 ',N'@p0 nvarchar(4000),@p1 nvarchar(4000)',@p0=N'PT000207',@p1=N'wangxin kf7785'


select  *  from  specMS_SpecBaseLine a where  a.blID=17441;

select  *  from  specMS_SpecBaseLine a where  a.blID=17442;

select  *  from  specMS_SpecDataIDSet  a   where  a.srcID='PR002925';

select  *  from  specMS_SpecDataIDSet   a  where  a.srcName='8042 V300R003 硬件';

--update  specMS_SpecDataIDSet  set Status=3 where srcID='PB001028'

select  *  from  specMS_SpecBaseLine a  where  a.lTitle='8042 V300R003 硬件';

--8042 V800R015
8042 V800R015
select  *  from  ProductBaselineTemp  a  where  a.BASELINE='S9500V100R002B02';

select  *  from  ProductBaselineTemp  a  where  a.RELEASENo='8042 V800R015';

select A.blID,a.lTitle,b.verTreeCode from specMS_SpecBaseLine A
INNER JOIN specMS_SpecList B ON A.blID=B.blID
WHERE B.listType=1 AND A.status=1 order by A.blid desc;
--PR99990047

select   *  from  specMS_SpecDataIDSet  a  where  a.srcPID='PR99990047';

select   *  from  specMS_SpecDataIDSet  a  where  a.srcID='PR003407';

select  *  from  specMS_SpecList  a  where  a.verTreeCode='PR003407';

--7153780
--7153783
select  * from  specMS_SpecListExtColData  a  where  a.blID=17441  and  blEntryID='7153780';

select  * from  specMS_SpecListExtColData  a  where  a.blID=17690  and  blEntryID='8376596';

--3855139,3855142

exec [P_UpdateParentEntryWhenDelete] @parentEntryIdStr=N'3855132',@subBlid=N'17691',@tabId=N'101080';

select  *  from  specMS_SpecBLEntryRel  a   where  a.entryPID='3855132';


select  * 
			from   specMS_SpecBLEntryRel  rel 
			inner join specMS_SpecListExtColData  extColData  on   extColData.blEntryID=rel.blEntryID  
			--where  rel.isLeaf=0  and rel.blID=17691   and  extColData.blID=17690  
			where not  exists
			(
				select 1  from  specMS_SpecBLEntryRel  a  where  a.entryPID=3855132
			)  and rel.blID=17691   and  extColData.blID=17690 
			and  (extColData.status=-1  or extColData.status=0) and extColData.implCase=3 and rel.entryID=3855132 ;

select  *  from  specMS_SpecDataIDSet
where not  exists(select 1 from  specMS_SpecBaseLine);

--3855155,3855155
--3855133  3855138

select *  from  specMS_SpecBLEntryRel  a  where  a.entryPID=3855155;

select *  from  specMS_SpecBLEntryRel  a  where  a.entryID=3855205;
select *  from  specMS_SpecBLEntryRel  a  where  a.entryPID=3855205;

select  *  from  specMS_SpecEntryContent   a  where  a.entryID=3855205;

select  *  from  specMS_SpecEntry   a  where  a.entryID='3344235';
select  *  from  specMS_SpecEntry   a  where  a.entryID='3344236';

--新增
--3855156,3855156

--17690
select  *  from  specMS_SpecBLEntryRel   a  where  a.blID=17691; 

select  *  from  specMS_SpecListTab   a  where  a.tabID=100553;

select  *  from  specMS_SpecModule   a  where  a.verTreeCode='PR003407';

select  top 100 *  from  SysLogInfo  order by OptTime desc;

select  *  from  specMS_SpecDataIDSet  a   where  a.srcName='1108B版本';

select  *  from  specMS_SpecList a  where  a.verTreeCode='PB003584';

select  *  from  specMS_SpecBaseLine  a  where  a.blID=16626;
--smid 11429  

select  *  from  specMS_SpecDataIDSet  a  where  a.srcName='iMC V700R020B01';

select  *  from  specMS_SpecDataIDSet   a  where  a.srcID='PB003584';

select  *  from  specMS_SpecDataIDSet   a  where  a.IDLevel=4  and show=-1;

--update  specMS_SpecDataIDSet  set show=1 where IDLevel=4  and show=-1;
--where t1.PBName='1108B版本'

--PT000188
select  *  from  specMS_SpecDataIDSet   a  where  a.srcPID='PT000188'  and flag=1  and show=1 and  Status=1;

select  c.*  from  specMS_SpecList     a   
inner join  specMS_SpecBaseLine  b  on  a.blID=b.blID
inner join  specMS_SpecDataIDSet   c   on   a.verTreeCode=c.srcID
where b.status!=1   and  c.status=1 and  c.flag=1  and  c.show=1 and c.srcPID='PT000188';

--PR003313	Comware-chinaloc 自筹 科技部 地球观测与导航专项项目 (在研 -- 平台)

select  *  from  specMS_SpecModule  a   where   a.verTreeCode='PR003313';

select  *  from  specms_CustomerSearch   a  where   a.ReleaseCode='PR003527';

select  top  100  *  from  SysLogInfo   a  order by  a.OptTime  desc;

select  *  from  specMS_SpecList  a  where  a.verTreeCode='PR003527';

select  *  from  specMS_SpecList  a  where  a.blID=17530;

select  *  from  specMS_SpecBaseLine  a  where  a.blID=17530;

select  *  from  specMS_SpecModule  a  where a.verTreeCode='PR003527';

--delete  specms_CustomerSearch  where  UserName='00428';

--truncate table specms_CustomerSearch

select  *  from  Sol_Permission  ;

select  *  from  BusinessNode  a;
select  *  from  EmailTemplate  a;

select  *  from  EmailTemplate  a  where  a.Buss_Id='44017CAE-10E1-4574-BEEA-49F6B6FA774E'

---编辑草稿
select  *  from  specMS_RESOURCE  a  where  RES_CODE='203003';

select  *  from  specMS_RESOURCE  a  where  RES_CODE='228005';

select  *  from  Sol_BaseLine  a  where  a.BlID=146;

--update Sol_BaseLine  set  CurEditStatus=0,CurEditor='',Ip=''  where BlID=124
select  *  from  Sol_PageConfig  a   where  a.BlID=129;

select  *  from  Sol_DataIDSet  a where  a.DataSetID=15;

select  *  from  Sol_Permission   a;

select  *  from  Sol_Features;

select  *  from  Sol_ProductInfo  a;

select  *  from  Sol_EntryColName;

select  *  from  Sol_EntryColName  a  where  a.ColID=421;

select  *  from  Sol_PartProductAttribute  a  where  a.ColID=421;

select  LEN('P5G V200R001 自筹 科技部 科技冬奥课题三项目B06D001');

select  *    from   [iSplan].[JSZL].dbo.[View_SolutionProductLineInfo]  where   b_name='连锁酒店敏捷管理方案'

--PL000032		PL000033		PL000034		PL000036		
with temp  as
(
	select  *  from specMS_SpecDataIDSet  a where SrcID='PL000033'
	union all
	select  a.*  from  specMS_SpecDataIDSet  a inner join temp  b  on  a.SrcPID=b.SrcID
)
select  *  from  temp;

select  top  0  *  into   Sol_DataIDSetTemp  from  Sol_DataIDSet;

select  top  0  *  into   Sol_ProductInfoTemp  from Sol_ProductInfo;

select  top  0  *  into   Sol_PermissionTemp  from Sol_Permission;
--truncate  table  Sol_DataIDSetTemp;
--truncate table  Sol_PermissionTemp
--truncate table  Sol_ProductInfoTemp
--drop table  Sol_DataIDSetTemp
--drop  table Sol_ProductInfoTemp;
--drop table  Bversiontemp

select  *  from  Sol_Permission  order by CreateTime desc;
--delete Sol_Permission  where  CreateTime>'2020-12-28 14:28:07';

select  *  from  Sol_BaseLine  a;

select  *  from  Sol_DataIDSet  a;

select  *  from  Sol_DataIDSetTemp  a order  by  a.datasetid;

select  *  from  Sol_ProductInfoTemp  a ;
--PL000021

select  *  from  Sol_ProductInfoTemp  a  where  a.ProductLine_Code='PL000021';

--update  Sol_ProductInfoTemp  set  ProductLine_Code='PL000022'  where ProductLine_Code='PL000021'

select  *  from  Sol_PermissionTemp  a;

select  *  from  Sol_ProductInfo;

select  *  from  Sol_ProductInfoTemp;

select  *  from  Sol_Permission;

select  *  from  specMS_ROLE  a  where  a.RL_CODE=30;

select  *  from  specMS_RESOURCE  a   where  a.RES_CODE='201005';

select  *  from  specMS_RESOURCE_Lang  a;

select  *  from  BusinessNode  a  where  a.Pid='44017CAE-10E1-4574-BEEA-49F6B6FA774E';

select  *  from  BusinessNode  a  where  a.id='B2349926-19D3-4C9E-BFB1-DEDDF0E21754';
--STR阶段通知
select  *  from  EmailTemplate  a where a.Buss_Id='77160701-4C91-4CFF-8FF1-ACDCA582CBC8';
--批量通知产品确认
select  *  from  EmailTemplate  a where a.Buss_Id='627782DB-F181-4C95-9D7A-5E3D11474CA1';

select  * from   specMS_Dict   a  order  by  a.dictId desc;

select  *    from   [iSplan].[JSZL].dbo.[View_SolutionProductLineInfo];

select  *    from  specms_Resource  a  where  full_name='创建草稿';

select  *   from  specMS_ROLE_RESOURCE_RELATION  a  where  a.RL_ID=55

select  *  from  specMS_SpecDataIDSet  a  where  a.IdLevel=1  and  SrcPID=0  and  Flag=1  and  Show=1;


select  a.*,b.RL_CODE,c.RES_CONTENT,c.RES_CODE  from  specMS_ROLE_RESOURCE_RELATION  a
inner join  specMS_ROLE   b  on  a.RL_ID=b.RL_ID
inner join  specMS_RESOURCE  c  on  a.RES_ID=c.RES_ID
where  b.RL_CODE=1001;

select * from  Sol_Entry  a   where  a.BlID=2;

select  *  from  Sol_PartProductAttribute  

select  *  from   Sol_Entry  a 
inner join  Sol_EntryRelation  b  on  a.EntryID=b.EntryID
inner join  Sol_PartProductAttribute  c  on  b.RelID=c.RelID
where a.EntryID=42;

select  * from Sol_DataIDSet  a where a.IDLevel=1;

select  * from Sol_ProductInfoTemp
--truncate table Sol_ProductInfo;

--truncate table Sol_DataIDSet;
select  top  0  *  into  Sol_ProductInfoTemp  from  Sol_ProductInfo ;

select  *  from  Sol_DataIDSet;

select  *  from  Sol_BaseLine   a  where  a.BlID=3;

select  *  from  Sol_BaseLine   a  where  a.BlID=12;

select  *  from  Sol_Features  a   where  a.BlID=3;

select  *  from  Sol_Features  a   where  a.BlID=12;

select  *  from  Sol_PartProductAttribute  a where  a.BlID=12;

--Col 46  47
--TabId 13 14
--Relid 21 22 23 24

--update Sol_BaseLine  set Status=0  where BlID=12

--VB20200316171007756
--VB20200316171007756

select  *  from   specms_CustomerSearch  a  where  a.releaseCode='PR003346'
--delete  specms_CustomerSearch  where releaseCode='PR003527'

select  *  from   Sol_Permission  a;

select  *  from   Sol_Entry  a;

select  *  from   Sol_DataIDSet a  where  a.srcName='AD-WAN广域网解决方案'

select  *  from   Sol_DataIDSet a  where  a.srcName='AD-WAN 广域网解决方案'

select  *  from  specMS_EntryParam  a  where a.blID=17720  and  a.entryID='3128942';

select  *  from   specMS_SpecListExtColData  a  where a.blID=17720  and  blEntryID='6758728'

select  *  from   specMS_SpecBLEntryRel  a  where  a.blEntryID='6758728'

select  *  from   specMS_SpecListExtColData  a  where a.blEntryID='7190177';

--7190171
select  *  from   specMS_SpecListExtColData  a  where a.blEntryID='7190183';

--blID 17533 

select  *  from   specMS_SpecListExtColData  a  where  a.blID=17533  and  tecID=24352;

exec [P_UpdateParentEntryWhenDelete] @parentEntryIdStr=N'3375869',@subBlid=N'17648',@tabId=N'107570';

select IsNull((select  listBlId from specMS_TabRefBaseLine  where blID=17648   and  status=2),0);

select *  from  specMS_SpecBLEntryRel  a  where  a.entryPID=3375869	and a.flag=0;

select  * 
			from  specMS_SpecEntry   temp
			inner join specMS_SpecBLEntryRel  rel on  temp.entryId=rel.entryID 
			inner join specMS_SpecListExtColData  extColData  on   extColData.blEntryID=rel.blEntryID  
			--where rel.blID=17650
			--where  rel.isLeaf=0  and rel.blID=@subBlId   and  extColData.blID=@blId 
			where not exists
			(
				select 1  from  specMS_SpecBLEntryRel  a  where  a.entryPID=temp.entryId and a.blID=17650	and a.flag=0
			)  and rel.blID=17650   and  extColData.blID=17649
			and temp.entryID='3375869'  and (extColData.status=-1  or extColData.status=0) 
			and extColData.implCase=3  and rel.flag=0;

--PR003119
--PB004039		OPN V100R001B07
select  *  from  specMS_SpecDataIDSet a  where  a.srcName='OPN V100R001B07';

select  *  from  specMS_SpecDataIDSet a  where  a.srcID='PR002781';

select  *  from  Sync_ProductInfo  a where  a.Release_Code='OPN V100R001';

select  *  from  specMS_SpecBLEntryRel  a where  a.entryID='2316886';

select  *  from  specMS_SpecBaseLine  a where a.blID=6320;

select  *  from  specMS_SpecList  a  where  a.blID=6320;

select  *  from  specMS_SpecEntryContent a  where  a.remark like '%逐流情况下，由于硬件无法识别MPLS报文，不会提取五元组，所以HASH Key值为0，只会上送到一个vcpu处理%'

select  *  from  specMS_SpecDataIDSet a  where  a.srcName='1108020';

select  *  from  specMS_SpecEntryContent    a  where  a.entryID=3375955;

select  *  from  specMS_SpecEntryContent    a  where  a.entryID=3375955  and   a.remark  like '%\n%';

select  *  from  Sol_BaseLine  a  where  a.BlID=18;

select  *  from  Sol_ProductInfo  a;

select  *  from  Sol_TabConfig 

select  *  from  specMS_SpecDataIDSet  a  where  a.IDLevel=4

--update  Sol_BaseLine    set   Status=0 where  BlID=129;  

select  *  from   specMs_CustomerSearch  a;

--delete   specMs_CustomerSearch   where ReleaseCode='PR003527'

select  COUNT(*)  from   SpecBaseLineEntryView   where IsQueryResult=0;

select  *  from  specMS_RESOURCE  a where  a.RES_CODE='202001';

select  *  from  specMS_SpecBaseLine  a where a.blID=12718;

select  *  from  specMS_RESOURCE_Lang  a;

--update  specMS_RESOURCE_Lang  set  lang='zh-CN'  where lang='zh-US'