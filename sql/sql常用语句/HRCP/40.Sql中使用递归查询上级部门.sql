
--部门编码50014560   上级部门编码   ParentDeptCode   50009351
select  *  from   PrjectPersonRDODC  a  where  a.DeleteFlag=0;
--要拿到各级部门的名称      去掉编码   
select  *  from   Department  a   where  a.Code='500042991'  ;

--给的子节点  查找父节点
with  temp   as
(
	select   Name,Code,ParentDeptCode  from  Department   where Code='500042991'
	union    all
	select   a.Name,a.Code,a.ParentDeptCode  from  Department  a  inner  join   temp   on  temp.ParentDeptCode=a.Code
)

select   *   from  temp;

--目的：给定一个部门     同时求出其对应的上级部门   最高从一级到四级
--示例部门编码   500042991  

select   name  from   syscolumns   where id=(select id  from  sysobjects  a  where  a.xtype='u' and  a.name='PrjectPersonRDODC')

select   a.CName,a.DeleteFlag,a.Dept1Code,a.Dept2Code,a.Dept3Code,a.Dept4Code,a.ID,a.OnJob,a.PersonID,a.PinYin  from  PrjectPersonRDODC   a;

