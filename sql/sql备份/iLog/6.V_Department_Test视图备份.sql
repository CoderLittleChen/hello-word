USE [PersonalInput]
GO

/****** Object:  View [dbo].[V_Department_Test]    Script Date: 2019/12/11 14:44:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-------------------------------------·Ö¸îÏß-------------------------------------------------------------------------------------


ALTER VIEW [dbo].[V_Department_Test]
AS
    WITH    cte_rd
              AS ( SELECT   DepartmentID ,DeptLevel , DeptCode , DeptName , ParentDeptCode ,
                            DeptCOACode , DeptManager , CreateTime , Creator , Modifier , ModifyTime , DeleteFlag , DeptSecretary
                   FROM     Department
                   WHERE    
							--( 
							--	DeptCode IN ( '50040858', '50040892', '50041012','50041227' )
							--	OR ParentDeptCode IN ( '50040248', '50041266','50042382','50042383','50042384','50042385' )
							--  )
                            DeptLevel=1	AND DeleteFlag = 0
                   UNION ALL
                   SELECT   dept.DepartmentID ,dept.DeptLevel ,dept.DeptCode ,dept.DeptName ,
							dept.ParentDeptCode ,
                            dept.DeptCOACode , dept.DeptManager , dept.CreateTime ,dept.Creator ,dept.Modifier , dept.ModifyTime ,
                            dept.DeleteFlag , dept.DeptSecretary
                   FROM     Department dept JOIN cte_rd ON dept.ParentDeptCode = cte_rd.DeptCode AND dept.DeleteFlag = 0
                 ),
	cte_pd AS (
		SELECT   DepartmentID ,DeptLevel , DeptCode , DeptName , ParentDeptCode ,
                            DeptCOACode , DeptManager , CreateTime , Creator , Modifier , ModifyTime , DeleteFlag , DeptSecretary
                   FROM     Department
                   WHERE    
							--( 
							--	DeptCode IN ( '50040858', '50040892', '50041012','50041227' )
							--	OR ParentDeptCode IN ( '50040248', '50041266','50042382','50042383','50042384','50042385' )
							--  )
                             DeptLevel=1	AND DeleteFlag = 0
                   UNION ALL
                   SELECT   dept.DepartmentID ,dept.DeptLevel ,dept.DeptCode ,dept.DeptName ,
							CAST(NULL AS NVARCHAR(200)) AS ParentDeptCode ,
                            dept.DeptCOACode , dept.DeptManager , dept.CreateTime ,dept.Creator ,dept.Modifier , dept.ModifyTime ,
                            dept.DeleteFlag , dept.DeptSecretary
                   FROM     Department dept JOIN cte_pd ON cte_pd.ParentDeptCode = dept.DeptCode AND dept.DeleteFlag = 0
				   WHERE dept.DeptLevel<>0
	)
	
	SELECT DepartmentID , DeptLevel , DeptCode , DeptName ,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode ,DeptCOACode , DeptManager ,
            CreateTime , Creator , Modifier , ModifyTime , DeleteFlag , DeptSecretary FROM dbo.Department WHERE DepartmentID IN (	
    SELECT DISTINCT DepartmentID
    FROM    ( SELECT    *
              FROM      cte_rd
              UNION ALL
              SELECT    *
              FROM      cte_pd
            ) main) ;










GO


