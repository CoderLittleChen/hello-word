select * from specMS_TabRefBaseLine where dataSrc!=2 and listblID=17094;

select  *  from  specMS_SpecListTab   a  where  a.tabID='101322';

select  *  from  specMS_SpecListTab   a  where  a.tabID='101320';

select  *  from   specMS_SpecBLEntryRel   a  where  a.blID=17095;



--specMS_SpecBLEntryRel    各字段含义
--blEntryId    主键
--refID  当前规格所在TabId
--refBlId  
--entryId   规格id
--entryPid  规格父级id
--blId  基线id
--lvl  规格级别
--isLeaf  是否为叶子节点


--specMS_TabRefBaseLine
--TabId  当前所在TabId
--dataSrc  引用时候  1产品  3模块
--

--specms_SpecList								blId	主基线id
--specms_SpecBlEntryRel						blId	子基线id
--specms_SpecTabRefBaseLine				blId	子基线id		listBlId	主基线id
--specms_SpecListExtColData				blId	主基线id
															
