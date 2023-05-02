--userType 1用户 2群组
select  *  from  specMS_SpecPermission a  where a.userName='ys2338';
select  *  from  specMS_SpecDataIDSet  a where a.dataSetID=2605;

--角色表
select  *  from  specMS_ROLE  a;
--资源表
--resourceType  0菜单  1数据功能权限
select  *  from  specMS_RESOURCE  a  where  a.ResourceType=0;
--语言包
select  *  from  specMS_RESOURCE_Lang  a;
--角色和资源关系表
select  *  from  specMS_ROLE_RESOURCE_RELATION   a;


