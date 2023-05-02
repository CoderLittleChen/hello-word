declare @DeptManager  varchar(100)  set  @DeptManager='liucaixuan 03806'
declare @DeptSecretary  varchar(100)  set  @DeptSecretary='liucaixuan 03806'
declare @UserId  varchar(100)  set  @UserId='liucaixuan 03806'
declare @userCode  varchar(100)  set  @userCode='03806'
declare @sys_SAP  varchar(100)  set  @sys_SAP='sys_SAP'
declare @sys_admin  varchar(100)  set  @sys_admin='sys_admin'
declare @busi_admin  varchar(100)  set  @busi_admin='busi_admin';

WITH ChildDept AS
                    (
		                SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
                        FROM dbo.Department
                        WHERE DeptCode IN(
               
                                SELECT DeptCode FROM dbo.Department WHERE  DeptManager=@DeptManager or DeptSecretary=@DeptSecretary and DeleteFlag =0
                                UNION ALL
			                    SELECT g.DeptCode FROM dbo.GiveRight_Dept g INNER JOIN Department d on g.DeptCode=d.DeptCode WHERE g.UserId=@UserId and g.DeleteFlag=0
                                Union All 
							    Select DeptCode From Department  t where DeptLevel=1
							    And Exists(
							    select 1 from UserInfo u 
							    inner join User_Role_Relation ur on u.Uid=ur.Uid
							    inner join RoleInfo r on r.Rid=ur.Rid
							    where u.Code=@userCode and (r.Code=@sys_SAP or r.Code=@sys_admin or r.Code=@busi_admin)
							    )
			                    ) and DeleteFlag =0
			                
                        UNION ALL
                        SELECT c.DepartmentID,c.DeptLevel,c.DeptCode,c.DeptName,CASE WHEN c.DeptLevel = 1 THEN NULL ELSE c.ParentDeptCode END ParentDeptCode,
                                c.DeptCOACode,c.DeptManager,c.CreateTime,c.Creator,c.Modifier,c.ModifyTime,c.DeleteFlag,c.DeptSecretary,c.SecondDeptCode,c.SecondDeptName
                        FROM ChildDept AS P JOIN dbo.Department AS C ON C.ParentDeptCode =P.DeptCode
                        where C.DeleteFlag =0
                    ),
	                ParentDept AS
	                (

		                SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
		                FROM dbo.Department
		                WHERE DeptCode IN(
                                SELECT DeptCode FROM dbo.Department WHERE  DeptManager=@DeptManager or DeptSecretary=@DeptSecretary and DeleteFlag =0
                                UNION ALL
			                    SELECT g.DeptCode FROM dbo.GiveRight_Dept g INNER JOIN Department d on g.DeptCode=d.DeptCode WHERE g.UserId=@UserId and g.DeleteFlag =0
                                Union All 
							    Select DeptCode From Department  t where DeptLevel=1
							    And Exists(
							    select 1 from UserInfo u 
							    inner join User_Role_Relation ur on u.Uid=ur.Uid
							    inner join RoleInfo r on r.Rid=ur.Rid
							    where u.Code=@userCode and (r.Code=@sys_SAP or r.Code=@sys_admin  or r.Code=@busi_admin)
							    )
			                    ) and DeleteFlag =0
                       
		                UNION ALL
		                SELECT c.DepartmentID,c.DeptLevel,c.DeptCode,c.DeptName,CASE WHEN c.DeptLevel = 1 THEN NULL ELSE c.ParentDeptCode END ParentDeptCode,
				                c.DeptCOACode,c.DeptManager,c.CreateTime,c.Creator,c.Modifier,c.ModifyTime,c.DeleteFlag,c.DeptSecretary,c.SecondDeptCode,c.SecondDeptName
		                FROM ParentDept AS P JOIN dbo.Department AS C ON P.ParentDeptCode =C.DeptCode
		                where C.DeleteFlag =0
	                )
                SELECT DISTINCT * FROM (
                SELECT * FROM ChildDept
                UNION ALL 
                SELECT * FROM ParentDept) main ;
                    