--1、先搞清楚目前模块的表结构
--如果模块下已经存在基线化的基线   对模块进行升降级   规格的所属模块信息会发生变化  
--确认所属模块信息是怎么查的？  


--Comware V9开发   PR003407
select  *  from  specMS_SpecBaseLine  a   where   a.blID=17231;

select  *  from  specMS_SpecModule  a  where  a.smID=11539;

select  *  from  specMS_SpecModuleBLRel  a  where a.blID=17185;

select  *  from  specMS_SpecModule  a   where   a.verTreeCode='PR003407' and type=0;

--insert  into   specms_ModuleChangeRecord
--select  11539,11259,'测试模块4',GETDATE()
--union
--select  11259,11258,'测试1.1',GETDATE()
--union
--select  11258,0,'测试1',GETDATE()

select  *   from   specms_ModuleChangeRecord  a;

select   *  from  specMS_SpecModule  a 
left  join  specms_ModuleChangeRecord  b  on a.smID=b.smOldId
where  smOldId is not null;

select  *  from  Sync_Employee  a  where a.ChnNamePY='zhengyanhui';

