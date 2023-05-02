use iSEDB;
---开启事务
begin tran
--错误扑捉机制，可以嵌套。
begin try
--新增角色
insert  into  specMS_ROLE
select '产品接口人',52,0,GETDATE(),0,GETDATE(),0,'',62,0
union
select '解决方案可查看人',53,0,GETDATE(),0,GETDATE(),0,'',63,0
union
select '解决方案可导出人',54,0,GETDATE(),0,GETDATE(),0,'',64,0
union
select 'SDT经理',55,0,GETDATE(),0,GETDATE(),0,'',65,0
union
select 'SDT架构师',56,0,GETDATE(),0,GETDATE(),0,'',66,0
union
select '解决方案二级部门主管',57,0,GETDATE(),0,GETDATE(),0,'',67,0
union
select '解决方案三级部门主管',58,0,GETDATE(),0,GETDATE(),0,'',68,0

--新增资源
insert   into  specMS_RESOURCE
select   0,1,'解决方案资源','',229000,'解决方案资源',0,GETDATE(),0,NULL,1,'',0,1,0,0

insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'组网图','',228000,'组网图',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'部件产品','',226000,'部件产品',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'每期版本号','',227000,'每期版本号',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'STR4通知产品确认','',203010,'STR4通知产品确认',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'STR5通知产品确认','',203011,'STR5通知产品确认',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'STR5基线化','',203012,'STR5基线化',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'功能-性能页面','',230000,'功能-性能页面',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'批量通知产品确认','',230008,'批量通知产品确认',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'导出本系统最新模板','',230630,'导出本系统最新模板',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'本系统最新模板导入','',230830,'本系统最新模板导入',0,GETDATE(),0,NULL,1,'',0,1,0,0

--组网图
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='228000'),1,'上传组网图','',228001,'上传组网图',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a where a.RES_CODE='228000'),1,'下载组网图','',228002,'下载组网图',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='228000'),1,'删除组网图','',228003,'删除组网图',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='228000'),1,'覆盖组网图','',228004,'覆盖组网图',0,GETDATE(),0,NULL,1,'',0,1,0,0

--部件产品
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'新增部件产品','',226001,'新增部件产品',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'修改部件产品','',226002,'修改部件产品',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'删除部件产品','',226003,'删除部件产品',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'批量部件产品支持情况','',226004,'批量部件产品支持情况',0,GETDATE(),0,NULL,1,'',0,1,0,0


--每期版本号
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'新增版本号','',227001,'新增版本号',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'修改版本号','',227002,'修改版本号',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'删除版本号','',227003,'删除版本号',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'批量每期版本支持情况','',227004,'批量每期版本支持情况',0,GETDATE(),0,NULL,1,'',0,1,0,0


--功能-性能页面
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'保存','',230001,'保存',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'查看未保存的内容','',230006,'查看未保存的内容',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'撤销全部修改','',230007,'撤销全部修改',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'批量确认','',230009,'批量确认',0,GETDATE(),0,NULL,1,'',0,1,0,0


----导出
--insert   into  specMS_RESOURCE
--select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230002'),1,'页面数据导出','',230001,'页面数据导出',0,GETDATE(),0,NULL,1,'',0,1,0,0
--union all
--select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230002'),1,'下载导入模板','',230002,'下载导入模板',0,GETDATE(),0,NULL,1,'',0,1,0,0
--union all
--select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230002'),1,'按可覆盖导入格式导出','',230006,'按可覆盖导入格式导出',0,GETDATE(),0,NULL,1,'',0,1,0,0


--specms_ResourceLang表插入数据
insert  into  specMS_RESOURCE_Lang
select    
	a.RES_ID,1,a.FULL_NAME,'','en-US',1
from specMS_RESOURCE  a  where a.RES_ID>=(select  b.RES_ID from  specMS_RESOURCE  b  where b.RES_CODE='229000')
union all
select    
	a.RES_ID,1,a.FULL_NAME,'','zh-US',1
from specMS_RESOURCE  a  where a.RES_ID>=(select  b.RES_ID from  specMS_RESOURCE  b  where b.RES_CODE='229000')


--specMS_ROLE_RESOURCE_RELATION表插入数据


--应用管理员
insert  into  specMS_ROLE_RESOURCE_RELATION

select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='229000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203010'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203011'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203012'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230007'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230008'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230630'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230830'),'',''
--规格责任人
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203010'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203011'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203012'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230007'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230008'),'',''
--union
--select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='229000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230630'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230830'),'',''
--PDT经理
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='30'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='30'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203003'),'',''
union
--产品接口人
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
-----解决方案可查看人
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
------解决方案可导出人
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
-------SDT经理
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
--------SDT架构师
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
-------解决方案二级部门主管
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
-------解决方案三级部门主管
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''

end try
begin catch
   select Error_number() as ErrorNumber,  --错误代码
          Error_severity() as ErrorSeverity,  --错误严重级别，级别小于10 try catch 捕获不到
          Error_state() as ErrorState ,  --错误状态码
          Error_Procedure() as ErrorProcedure , --出现错误的存储过程或触发器的名称。
          Error_line() as ErrorLine,  --发生错误的行号
          Error_message() as ErrorMessage  --错误的具体信息
   if(@@trancount>0) --全局变量@@trancount，事务开启此值+1，他用来判断是有开启事务
      rollback tran  ---由于出错，这里回滚到开始，第一条语句也没有插入成功。
end catch
if(@@trancount>0)
commit tran  --


