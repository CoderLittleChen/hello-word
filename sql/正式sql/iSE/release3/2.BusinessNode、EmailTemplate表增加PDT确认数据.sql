use iSEDB;
--BusinessNode  增加  PDT确认环节
insert into  BusinessNode 
select  NEWID(),'00000000-0000-0000-0000-000000000000'as pid,'应用管理员新增版本','00000000-0000-0000-0000-000000000000','',1

--EmailTemplate  增加模板数据

insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='应用管理员新增版本')
	,''
	,''
	,'[?规格责任人?]'
	,'[?应用管理员?]'
	,''
	,'iSE系统[?PDT?]下有手动新增版本：[?版本名称?],请知悉。'
	,'<p>系统名称：H3C规格管理系统（iSE）</p><p>相关链接：[?链接?]</p>','','ys2689',GETDATE(),'','',1,null;



		
