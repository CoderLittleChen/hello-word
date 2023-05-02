--CREATE  TABLE [StudentScores]
--(
--   [UserName]         NVARCHAR(20),        --学生姓名
--    [Subject]          NVARCHAR(30),        --科目
--    [Score]            FLOAT,               --成绩
--)
--INSERT INTO [StudentScores] SELECT 'Nick', '语文', 80
--INSERT INTO [StudentScores] SELECT 'Nick', '数学', 90
--INSERT INTO [StudentScores] SELECT 'Nick', '英语', 70
--INSERT INTO [StudentScores] SELECT 'Nick', '生物', 85
--INSERT INTO [StudentScores] SELECT 'Kent', '语文', 80
--INSERT INTO [StudentScores] SELECT 'Kent', '数学', 90
--INSERT INTO [StudentScores] SELECT 'Kent', '英语', 70
--INSERT INTO [StudentScores] SELECT 'Kent', '生物', 85

select  *  from  StudentScores a;

SELECT * FROM [StudentScores] /*数据源*/
AS P
PIVOT 
(
    SUM(Score/*行转列后 列的值*/) FOR 
    p.Subject/*需要行转列的列*/ IN ([语文],[数学],[英语],[生物]/*列的值*/)
) AS T