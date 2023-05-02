--SELECT DepartmentID,DeptLevel,DeptCode,DeptName,CASE WHEN DeptLevel = 1 THEN NULL ELSE ParentDeptCode END ParentDeptCode,DeptCOACode,DeptManager,CreateTime,Creator,Modifier,ModifyTime,DeleteFlag,DeptSecretary,SecondDeptCode,SecondDeptName
--FROM tempDept
--UNION ALL
--SELECT dep.DepartmentID,dep.DeptLevel,dep.DeptCode,dep.DeptName,CASE WHEN dep.DeptLevel = 1 THEN NULL ELSE dep.ParentDeptCode END ParentDeptCode,
--dep.DeptCOACode,dep.DeptManager,dep.CreateTime,dep.Creator,dep.Modifier,dep.ModifyTime,dep.DeleteFlag,dep.DeptSecretary,dep.SecondDeptCode,dep.SecondDeptName
--FROM ChildDept AS c JOIN dbo.Department AS dep ON c.DeptCode =dep.ParentDeptCode
--where dep.DeleteFlag =0


with ChildDept  as
(
SELECT * FROM IPDProjectTemp
UNION ALL
SELECT  dep.*  FROM ChildDept AS c JOIN dbo.IPDProjectTemp AS dep ON c.IPDProjectTypeID =dep.IPDProjectParentTypeID
where dep.DeleteFlag =0
),
ParentDept as
(
SELECT * FROM IPDProjectTemp
UNION ALL
SELECT  dep.*  FROM ChildDept AS c JOIN dbo.IPDProjectTemp AS dep ON c.IPDProjectParentTypeID =dep.IPDProjectTypeID
where dep.DeleteFlag =0
)

SELECT *
FROM 
(
SELECT * FROM ChildDept
UNION 
SELECT * FROM ParentDept
) main  order by  main.IPDProjectParentTypeID

