--cte递归查询  需要两部分组成
--1、普通查询  设置查询条件
--2、递归查询  


declare @DeptManager  varchar(100)  set  @DeptManager='liucaixuan 03806'
declare @DeptSecretary  varchar(100)  set  @DeptSecretary='liucaixuan 03806'
declare @UserId  varchar(100)  set  @UserId='liucaixuan 03806'
declare @userCode  varchar(100)  set  @userCode='03806'
declare @sys_SAP  varchar(100)  set  @sys_SAP='sys_SAP'
declare @sys_admin  varchar(100)  set  @sys_admin='sys_admin'
declare @busi_admin  varchar(100)  set  @busi_admin='busi_admin';
declare @deptName  varchar(100)  set  @deptName='安全研发部';

 with  ParentDept AS
	                (
		         --       SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
		         --       FROM dbo.Department
		         --       WHERE DeptCode IN(
           --                     SELECT DeptCode FROM dbo.Department WHERE  DeptManager=@DeptManager or DeptSecretary=@DeptSecretary and DeleteFlag =0
           --                     UNION ALL
			        --            SELECT g.DeptCode FROM dbo.GiveRight_Dept g INNER JOIN Department d on g.DeptCode=d.DeptCode WHERE g.UserId=@UserId and g.DeleteFlag =0
           --                     Union All 
							    --Select DeptCode From Department  t where DeptLevel=1
							    --And Exists(
							    --select 1 from UserInfo u 
							    --inner join User_Role_Relation ur on u.Uid=ur.Uid
							    --inner join RoleInfo r on r.Rid=ur.Rid
							    --where u.Code=@userCode and (r.Code=@sys_SAP or r.Code=@sys_admin  or r.Code=@busi_admin)
							    --)
			        --            ) and DeleteFlag =0
                       
		         --       UNION ALL
							
						--select  DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
						--from  Department  a  where  a.DeleteFlag=0 and  a.DeptCode='50042704'
						--union all
		    --            SELECT c.DepartmentID,c.DeptLevel,c.DeptCode,c.DeptName,CASE WHEN c.DeptLevel = 1 THEN NULL ELSE c.ParentDeptCode END ParentDeptCode,
				  --              c.DeptCOACode,c.DeptManager,c.CreateTime,c.Creator,c.Modifier,c.ModifyTime,c.DeleteFlag,c.DeptSecretary,c.SecondDeptCode,c.SecondDeptName
		    --            FROM ParentDept AS P JOIN dbo.Department AS C ON P.ParentDeptCode =C.DeptCode
		    --            where C.DeleteFlag =0  


						 SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
		                            FROM dbo.Department  dept
		                            WHERE DeptCode IN
                                    (
			                            SELECT g.DeptCode FROM dbo.GiveRight_Dept g INNER JOIN Department d on g.DeptCode=d.DeptCode WHERE g.UserId=@UserId and g.DeleteFlag =0  And d.DeptName like '%'+@deptName+'%'
                                        and (select   DeptName  from  Department  a  where  a.DeptCode=dept.ParentDeptCode)  not like '%'+@deptName+'%'
                                        UNION ALL 
						                Select DeptCode From Department  t where 
						                Exists
                                        (
							                select 1 from UserInfo u 
							                inner join User_Role_Relation ur on u.Uid=ur.Uid
							                inner join RoleInfo r on r.Rid=ur.Rid
							                where u.Code=@userCode and (r.Code=@sys_SAP or r.Code=@sys_admin or r.Code=@busi_admin)
						                )   And DeptName like '%'+@deptName+'%'  and (select   DeptName  from  Department  a  where  a.DeptCode=dept.ParentDeptCode)  not like '%'+@deptName+'%'
                                    ) and DeleteFlag =0
	                )
select *   from   ParentDept