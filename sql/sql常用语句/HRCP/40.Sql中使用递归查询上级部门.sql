
--���ű���50014560   �ϼ����ű���   ParentDeptCode   50009351
select  *  from   PrjectPersonRDODC  a  where  a.DeleteFlag=0;
--Ҫ�õ��������ŵ�����      ȥ������   
select  *  from   Department  a   where  a.Code='500042991'  ;

--�����ӽڵ�  ���Ҹ��ڵ�
with  temp   as
(
	select   Name,Code,ParentDeptCode  from  Department   where Code='500042991'
	union    all
	select   a.Name,a.Code,a.ParentDeptCode  from  Department  a  inner  join   temp   on  temp.ParentDeptCode=a.Code
)

select   *   from  temp;

--Ŀ�ģ�����һ������     ͬʱ������Ӧ���ϼ�����   ��ߴ�һ�����ļ�
--ʾ�����ű���   500042991  

select   name  from   syscolumns   where id=(select id  from  sysobjects  a  where  a.xtype='u' and  a.name='PrjectPersonRDODC')

select   a.CName,a.DeleteFlag,a.Dept1Code,a.Dept2Code,a.Dept3Code,a.Dept4Code,a.ID,a.OnJob,a.PersonID,a.PinYin  from  PrjectPersonRDODC   a;

