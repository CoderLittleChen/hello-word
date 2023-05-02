--系统常量表specms_Dict 插入解决方案规格优先级
--select  *  from  specMS_Dict  a;
use iSEDB;
--插入父级
insert  into  specMS_Dict  
select  107000,1,1,'解决方案规格优先级',null,1,null,'cys2689',null,GETDATE(),null;

--插入子级
insert  into  specMS_Dict  
select  107001,107000,1,'高',null,1,null,'cys2689',null,GETDATE(),null
union
select  107002,107000,2,'中',null,2,null,'cys2689',null,GETDATE(),null
union
select  107003,107000,3,'低',null,3,null,'cys2689',null,GETDATE(),null;