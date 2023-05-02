--部门授权表
select   *   from   GiveRight_Dept   a;


--产品授权表
select   *   from   GiveRight_Pro     a;

Select DeptCode,DeptName From Department  t where 
							    Exists(
							    select 1 from UserInfo u 
							    inner join User_Role_Relation ur on u.Uid=ur.Uid
							    inner join RoleInfo r on r.Rid=ur.Rid
							    where u.Code='03806' and (r.Code='sys_SAP' or r.Code='sys_admin' or r.Code='busi_admin')
							    )
                                And DeptName like '%%' and DeleteFlag =0 

select  *   from   Department  a  where  a.DeleteFlag=0 ;

select  *   from   Department   a where  a.DeptCode  in (select  a.DeptCode   from   GiveRight_Dept    a    where   a.UserId='liucaixuan 03806'   and  a.DeleteFlag=0);

select  *   from   User_Role_Relation   a;


select  *   from   Department  a  where  a.DeleteFlag=0   and   a.DeptName  not  like '%Comware开发部系统部（合肥）%'


