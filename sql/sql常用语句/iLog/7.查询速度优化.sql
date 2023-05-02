exec sp_executesql N'
                           with  tempDept  as
                                (
                                    SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
		                            FROM dbo.Department
		                            WHERE DeptCode IN
                                    (
			                            SELECT g.DeptCode FROM dbo.GiveRight_Dept g INNER JOIN Department d on g.DeptCode=d.DeptCode WHERE g.UserId=@UserId and g.DeleteFlag =0  
                                        UNION ALL 
						                Select DeptCode From Department  t where 
						                Exists
                                        (
							                select 1 from UserInfo u 
							                inner join User_Role_Relation ur on u.Uid=ur.Uid
							                inner join RoleInfo r on r.Rid=ur.Rid
							                where u.Code=@userCode and (r.Code=@sys_SAP or r.Code=@sys_admin or r.Code=@busi_admin)
						                )   
                                    ) and DeleteFlag =0
                                ),
                         
                              ChildDept   as
                                (
                                    SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
		                            FROM tempDept
                                    UNION ALL
                                    SELECT dep.DepartmentID,dep.DeptLevel,dep.DeptCode,dep.DeptName,CASE WHEN dep.DeptLevel = 1 THEN NULL ELSE dep.ParentDeptCode END ParentDeptCode,
				                    dep.DeptCOACode,dep.DeptManager,dep.CreateTime,dep.Creator,dep.Modifier,dep.ModifyTime,dep.DeleteFlag,dep.DeptSecretary,dep.SecondDeptCode,dep.SecondDeptName
		                            FROM ChildDept AS c JOIN dbo.Department AS dep ON c.DeptCode =dep.ParentDeptCode
		                            where dep.DeleteFlag =0
                                ),
                        
                              ParentDept   as
                                (
                                    SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
		                            FROM tempDept
                                    UNION ALL
                                    SELECT dep.DepartmentID,dep.DeptLevel,dep.DeptCode,dep.DeptName,CASE WHEN dep.DeptLevel = 1 THEN NULL ELSE dep.ParentDeptCode END ParentDeptCode,
				                    dep.DeptCOACode,dep.DeptManager,dep.CreateTime,dep.Creator,dep.Modifier,dep.ModifyTime,dep.DeleteFlag,dep.DeptSecretary,dep.SecondDeptCode,dep.SecondDeptName
		                            FROM ParentDept AS p JOIN dbo.Department AS dep ON p.ParentDeptCode =dep.DeptCode
		                            where dep.DeleteFlag =0
                                )
                        
                            SELECT DISTINCT *
                            FROM 
                                (
                                    SELECT * FROM ChildDept
                                    UNION ALL 
                                    SELECT * FROM ParentDept
                                ) main  
                    ',N'@DeptManager nvarchar(16),@DeptSecretary nvarchar(16),@UserId nvarchar(16),@userCode nvarchar(5),@sys_SAP nvarchar(7),@sys_admin nvarchar(9),@busi_admin nvarchar(10),@deptName nvarchar(2)',@DeptManager=N'liucaixuan 03806',@DeptSecretary=N'liucaixuan 03806',@UserId=N'liucaixuan 03806',@userCode=N'03806',@sys_SAP=N'sys_SAP',@sys_admin=N'sys_admin',@busi_admin=N'busi_admin',@deptName=N'%%'