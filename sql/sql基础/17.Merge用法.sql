--对SqlServer中merge的使用
--merge  into [目标表]
--using [源表]
--on 条件(这里的条件一般指的是对目标表的限制,想对源表进行限制 在using中进行子查询和条件)
--when matched then
--如果有匹配的数据  可以对匹配数据更新  或者 删除匹配的数据
--when not matched then 

CREATE PROCEDURE [dbo].[SP_SolutionSync_Test]
AS
BEGIN
	--导入产品线
    MERGE Sol_DataIDSet  AS T
        USING (SELECT pro.ProductLine_Code,pro.ProductLine_Name FROM Sol_ProductInfo pro GROUP BY pro.ProductLine_Code,pro.ProductLine_Name)  AS S
		ON T.SrcID=S.ProductLine_Code
	WHEN MATCHED THEN 
		UPDATE SET T.SrcName=S.ProductLine_Name
	WHEN NOT MATCHED THEN 
		INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
		VALUES(S.ProductLine_Code,0,S.ProductLine_Name,1,'','',0,1);
  
	--导入PDT
	MERGE Sol_DataIDSet  AS T
        USING (SELECT pro.PDT_Code,pro.PDT_Name,pro.ProductLine_Code FROM Sol_ProductInfo pro GROUP BY pro.PDT_Code,pro.PDT_Name,pro.ProductLine_Code)  AS S
		ON T.SrcID=S.PDT_Code
	WHEN MATCHED THEN 
		UPDATE SET T.SrcName=S.PDT_Name,T.SrcPID=S.ProductLine_Code
	WHEN NOT MATCHED THEN 
		INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
		VALUES(S.PDT_Code,S.ProductLine_Code,S.PDT_Name,2,'','',0,1);

	--导入R版本
	MERGE Sol_DataIDSet  AS T
        USING (SELECT pro.Release_Code,pro.Release_Name,pro.PDT_Code FROM Sol_ProductInfo pro GROUP BY pro.Release_Code,pro.Release_Name,pro.PDT_Code)  AS S
		ON T.SrcID=S.Release_Code
	WHEN MATCHED THEN 
		UPDATE SET T.SrcName=S.Release_Name,T.SrcPID=S.PDT_Code
	WHEN NOT MATCHED THEN 
		INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
		VALUES(S.Release_Code,S.PDT_Code,S.Release_Name,3,'','',0,1);

	--导入B版本
	MERGE Sol_DataIDSet  AS T
        USING (SELECT pro.B_Code,pro.B_Name,pro.Release_Code FROM Sol_ProductInfo pro GROUP BY pro.B_Code,pro.B_Name,pro.Release_Code)  AS S
		ON T.SrcID=S.B_Code
	WHEN MATCHED THEN 
		UPDATE SET T.SrcName=S.B_Name,T.SrcPID=S.Release_Code
	WHEN NOT MATCHED THEN 
		INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
		VALUES(S.B_Code,S.Release_Code,S.B_Name,4,'','',0,1);

	--导入D版本
	MERGE Sol_DataIDSet  AS T
        USING (SELECT pro.D_Code,pro.D_Name,pro.B_Code FROM Sol_ProductInfo pro GROUP BY pro.D_Code,pro.D_Name,pro.B_Code)  AS S
		ON T.SrcID=S.D_Code
	WHEN MATCHED THEN 
		UPDATE SET T.SrcName=S.D_Name,T.SrcPID=S.B_Code
	WHEN NOT MATCHED THEN 
		INSERT ([SrcID],[SrcPID],[SrcName],[IDLevel],[OrderNo],[Status],[DeleteFlag],[Show]) 
		VALUES(S.D_Code,S.B_Code,S.D_Name,5,'','',0,1);
END
