--1���ȸ����Ŀǰģ��ı�ṹ
--���ģ�����Ѿ����ڻ��߻��Ļ���   ��ģ�����������   ��������ģ����Ϣ�ᷢ���仯  
--ȷ������ģ����Ϣ����ô��ģ�  


--Comware V9����   PR003407
select  *  from  specMS_SpecBaseLine  a   where   a.blID=17231;

select  *  from  specMS_SpecModule  a  where  a.smID=11539;

select  *  from  specMS_SpecModuleBLRel  a  where a.blID=17185;

select  *  from  specMS_SpecModule  a   where   a.verTreeCode='PR003407' and type=0;

--insert  into   specms_ModuleChangeRecord
--select  11539,11259,'����ģ��4',GETDATE()
--union
--select  11259,11258,'����1.1',GETDATE()
--union
--select  11258,0,'����1',GETDATE()

select  *   from   specms_ModuleChangeRecord  a;

select   *  from  specMS_SpecModule  a 
left  join  specms_ModuleChangeRecord  b  on a.smID=b.smOldId
where  smOldId is not null;

select  *  from  Sync_Employee  a  where a.ChnNamePY='zhengyanhui';

