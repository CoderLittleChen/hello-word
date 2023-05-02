use iSEDB;
--BusinessNode  

--规格责任人确认规格
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='解决方案') as Pid,'规格责任人确认规格','00000000-0000-0000-0000-000000000000','',1;

--PDT确认
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='解决方案') as Pid,'PDT确认','00000000-0000-0000-0000-000000000000','',1;

--批量通知产品确认
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='解决方案') as Pid,'批量通知产品确认','00000000-0000-0000-0000-000000000000','',1;

--STR阶段通知产品确认
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='解决方案') as Pid,'STR阶段通知产品确认','00000000-0000-0000-0000-000000000000','',1;

--EmailTemplate  增加模板数据

--规格责任人确认规格
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='规格责任人确认规格')
	,''
	,''
	,'[?规格责任人?]'
	,''
	,''
	,'产品责任人都已配置完毕，请确认解决方案规格'
	,'<p>系统名称：H3C规格管理系统（iSE）</p>

<p>功能模块：解决方案规格</p>

<p>当前状态：[?状态?]</p>

<p>相关链接：[?链接?]</p>','','ys2689',GETDATE(),'','',1,null;

----PDT确认
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='PDT确认')
	,''
	,''
	,'[?PDT经理?]'
	,''
	,''
	,'请设置iSE解决方案模块：[?PDT?]中的产品接口人'
	,'<p>系统名称：H3C规格管理系统（iSE）</p>

	<p>功能模块：解决方案规格</p>

	<p>当前状态：[?状态?]</p>

	<p>相关链接：[?链接?]</p>

	<p>&nbsp;</p>','','ys2689',GETDATE(),'','',1,null;

--批量通知产品确认
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='批量通知产品确认')
	,''
	,''
	,'[?产品接口人?]'
	,'[?规格责任人?][?SDT经理?]'
	,''
	,'请确认iSE解决方案版本：【[?D版本?]】 中的基线： 【[?基线?]】STR4规格'
	,'<p>系统名称：H3C规格管理系统（iSE）</p>

<p>功能模块：解决方案规格</p>

<p>当前状态：[?状态?]</p>

<p>内&nbsp; &nbsp; &nbsp; 容：请确认如下规格以及其子规格：[?规格名称?]</p>

<p>相关链接：[?链接?]</p>

<p>&nbsp;</p>','','ys2689',GETDATE(),'','',1,null;

--STR阶段通知产品确认
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='STR阶段通知产品确认')
	,''
	,''
	,'[?产品接口人?]'
	,'[?规格责任人?][?SDT经理?]'
	,''
	,'请确认iSE解决方案版本：【[?D版本?]】 中的基线： 【[?基线?]】STR4规格'
	,'<p>系统名称：H3C规格管理系统（iSE）</p>

<p>功能模块：解决方案规格</p>

<p>当前状态：[?状态?]</p>

<p>相关链接：[?链接?]</p>

<p>&nbsp;</p>
','','ys2689',GETDATE(),'','',1,null;




		
