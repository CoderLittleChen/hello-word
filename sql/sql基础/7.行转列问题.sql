--CREATE  TABLE [StudentScores]
--(
--   [UserName]         NVARCHAR(20),        --ѧ������
--    [Subject]          NVARCHAR(30),        --��Ŀ
--    [Score]            FLOAT,               --�ɼ�
--)
--INSERT INTO [StudentScores] SELECT 'Nick', '����', 80
--INSERT INTO [StudentScores] SELECT 'Nick', '��ѧ', 90
--INSERT INTO [StudentScores] SELECT 'Nick', 'Ӣ��', 70
--INSERT INTO [StudentScores] SELECT 'Nick', '����', 85
--INSERT INTO [StudentScores] SELECT 'Kent', '����', 80
--INSERT INTO [StudentScores] SELECT 'Kent', '��ѧ', 90
--INSERT INTO [StudentScores] SELECT 'Kent', 'Ӣ��', 70
--INSERT INTO [StudentScores] SELECT 'Kent', '����', 85

select  *  from  StudentScores a;

SELECT * FROM [StudentScores] /*����Դ*/
AS P
PIVOT 
(
    SUM(Score/*��ת�к� �е�ֵ*/) FOR 
    p.Subject/*��Ҫ��ת�е���*/ IN ([����],[��ѧ],[Ӣ��],[����]/*�е�ֵ*/)
) AS T