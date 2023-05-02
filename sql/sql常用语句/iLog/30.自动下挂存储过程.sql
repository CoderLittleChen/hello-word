USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_Sync_PL_PT_PR_Detail]    Script Date: 2020/2/20 10:07:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		wangweidong
-- =============================================
ALTER PROCEDURE [dbo].[P_Sync_PL_PT_PR_Detail]
AS
    DECLARE @sql NVARCHAR(4000);
    DECLARE @RoleCode NVARCHAR(100);
    DECLARE @ProCode VARCHAR(50); 
	DECLARE @pop VARCHAR(50);
	DECLARE @ProName VARCHAR(100);
    DECLARE @SuspendType VARCHAR(50); 
    DECLARE @invalidType VARCHAR(50);
    DECLARE @SuspendTime DATETIME; 
    DECLARE @ActualSuspendTime DATETIME;
    BEGIN
	--开始事物   
        BEGIN TRY 
            BEGIN TRANSACTION;
	-----------------------------------------存储项目类型表-----------------------------------------

            INSERT  INTO [dbo].[FailureTimeConfiguration]
                    SELECT DISTINCT
                            SuspendBRproject.ipdProjectTypeName ,
                            SuspendBRproject.ipdProjectTypeCode ,
                            SuspendBRproject.ipdProjectSubTypeName ,
                            SuspendBRproject.ipdProjectSubTypeCode ,
                            1
                    FROM    [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
                    WHERE   NOT EXISTS ( SELECT 1
                                         FROM   FailureTimeConfiguration
                                         WHERE  ProjectParentCode = SuspendBRproject.ipdProjectTypeCode
                                                AND ProjectChildCode = SuspendBRproject.ipdProjectSubTypeCode );

	-----------------------------------------更新9编码项目-----------------------------------------
		--产品线、PDT数据
            SELECT DISTINCT
                    PL.Name  ProductLine_Name ,
                    PL.Code ProductLine_Code ,
                    PT.Name PDT_Name ,
                    PT.Code PDT_Code ,
                    PR.Name Release_Name ,
                    PR.Code Release_Code
            INTO    #ProductLine
            FROM    [RDMDSDB].[RD_MDS].[mdm].[V_ProductLine] PL
					INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_PDT] PT ON PL.Code=PT.ProductLineCode_Code
					INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_Release] PR ON PT.Code = PR.PDTCode_Code
            WHERE   PR.Code IS NOT NULL AND PR.sStatus=1;

		--9编码数据
            SELECT DISTINCT
                    a.ProjectCode ,
                    a.NewProjectName
            INTO    #ProductTemp
            FROM    ( SELECT    ProjectCode ,
                                ProjectName ,
                                CASE WHEN SUBSTRING(ProjectName,
                                                    LEN(ProjectName) - 2, 1) = 'B'
                                     THEN reverse(
												SUBSTRING(reverse(ProjectName), 
														  charindex('B',reverse(ProjectName))+1,
														LEN(ProjectName)-charindex('B',reverse(ProjectName))))
                                     ELSE ProjectName
                                END NewProjectName
                      FROM      dbo.ProductTemp
                    ) AS a;

		--ProductInfo 表的 PL、PT、9 编码的数据 
            SELECT  #ProductLine.* ,
                    #ProductTemp.* ,
                    ProductTemp.ProjectName ,
                    REPLACE(REPLACE(REPLACE(ProductTemp.ProjectMgr, 'CN=', ''),
                                    '/h3c', ''), '/O=h3c', '') Manager ,
                    MDSPOP.POP_ID
            INTO    #NewProductInfo
            FROM    #ProductLine
                    INNER JOIN #ProductTemp ON #ProductLine.Release_Name = #ProductTemp.NewProjectName
                    INNER JOIN ProductTemp ON #ProductTemp.ProjectCode = ProductTemp.ProjectCode
                    LEFT JOIN [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] MDSPOP ON #ProductLine.Release_Code = MDSPOP.Code
            WHERE   POP_ID IS NOT NULL

			--SELECT * FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 

		--根据9编码修改 项目信息
            UPDATE  ProductInfo
            SET     ProName = #NewProductInfo.ProjectName ,
                    ParentCode = #NewProductInfo.PDT_Code ,
                    ParentId = #NewProductInfo.PDT_Code ,
                    Manager = #NewProductInfo.Manager ,
                    CC = #NewProductInfo.POP_ID ,
                    ModifyTime = GETDATE()
            FROM    #NewProductInfo
            WHERE   ProductInfo.ProLevel = 3
                    AND #NewProductInfo.ProjectCode = ProductInfo.ProCode;

		--新项目
			 SELECT NewPro.ProjectName , NewPro.ProjectCode , NewPro.POP_ID INTO #NewProduct
					FROM    ( SELECT DISTINCT * FROM #NewProductInfo) NewPro
                    LEFT JOIN ProductInfo P ON P.ProCode = NewPro.ProjectCode
					WHERE   P.ProCode IS NULL; 

		
		--插入不存在的9编码的数据
            INSERT  INTO ProductInfo
                    ( ProID ,
                      ProLevel ,
                      ProName ,
                      ProCode ,
                      ParentCode ,
                      Manager ,
                      CC ,
                      CreateTime ,
                      ModifyTime ,
                      DeleteFlag ,
                      Id ,
                      ParentId ,
                      RestartFlag
                    )
                    SELECT  NEWID() ,
                            3 ,
                            NewPro.ProjectName ,
                            NewPro.ProjectCode ,
                            NewPro.PDT_Code ,
                            NewPro.Manager ,
                            NewPro.POP_ID ,
                            GETDATE() ,
                            GETDATE() ,
                            0 ,
                            NewPro.ProjectCode ,
                            NewPro.PDT_Code ,
                            0
                    FROM    ( SELECT DISTINCT
                                        *
                              FROM      #NewProductInfo
                            ) NewPro
                            LEFT JOIN ProductInfo P ON P.ProCode = NewPro.ProjectCode
                    WHERE   P.ProCode IS NULL; 

		--自动下挂产品测试以及子项
			DECLARE @OldACode NVARCHAR(50);
			DECLARE @NewACode NVARCHAR(50);
			DECLARE @OldBCode NVARCHAR(50);
			DECLARE @NewBCode NVARCHAR(50);
			DECLARE @NewCCode NVARCHAR(50);
			DECLARE @CountNum INT;
			DECLARE @RDPDT NVARCHAR(50);			--开发代表
			DECLARE @RDPDTManual NVARCHAR(50);		--指定开发代表
			DECLARE @HardManager NVARCHAR(50);		--硬件经理
			DECLARE @TestManager nvarchar(50);		--测试经理
			DECLARE @Documents_Mnger nvarchar(50);	--资料经理
			DECLARE @PPPDT_ID nvarchar(50);			--产品工程代表
			DECLARE @Index int;

			BEGIN  
                DECLARE Update_cursora CURSOR LOCAL 
                FOR
                    SELECT * FROM #NewProduct
                OPEN Update_cursora;
                FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
                WHILE @@FETCH_STATUS = 0
                    BEGIN

						SET @CountNum= (SELECT COUNT(0) FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE  ISNULL(bigTypeName,'') NOT IN ('解决方案项目','预研/技术开发项目')AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)
						--SET @RDPDT= (SELECT RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
						--		WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)
						SET @RDPDT= (SELECT RDPDT FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE  ISNULL(bigTypeName,'') NOT IN ('解决方案项目','预研/技术开发项目')AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)

						IF(@CountNum >0)
						BEGIN
								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
								
								-----产品测试 start -----
							    --A
								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'产品测试',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)

						        --B
								SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'测试计划与策略',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)

								--C start
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试计划与策略制定及修改',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								--C end

								--B
								SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'测试分析设计',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
							
							    --C start
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试需求与规格分析',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试SOW制定',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试方案设计',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试点设计',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试用例设计',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'自动化测试编码',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'自动化测试移植与优化',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								--C end
							
								--B 
							    set @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'测试执行',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)

								--C start
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试执行准备',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'手工测试执行',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'自动化测试执行',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'开发定位配合',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'CMM问题单回归',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'CMM问题单复现',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'重大问题同步',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'资料测试',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'网上问题处理',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'实验局/技术支持',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'对外测试',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'拷机测试',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								--C end

								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'测试评估',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
							
								--C start
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'缺陷分析',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试报告/总结',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								--C end

								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'鉴定测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)

								--C start
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'鉴定测试准备与分析',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'鉴定测试执行',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'鉴定测试重现定位',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'鉴定测试总结与报告',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								--C end

								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'公共活动',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
						
								--C start
								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'项目管理以及流程处理',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试流程引导/审计/优化',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'技术积累与贡献',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'指导和培训类工作',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'公共测试环境维护',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'测试工具开发',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'请假',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)

								SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),6,'其他测试公共活动',@NewCCode,@NewBCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								--C end

								-----产品测试 end -----

								--SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								--INSERT INTO dbo.ProductInfo
								--		( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								--VALUES(NEWID(),5,'评审和检视工作',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
						
								--SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								--INSERT INTO dbo.ProductInfo
								--		( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								--VALUES(NEWID(),5,'测试工具开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
						
								--SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								--INSERT INTO dbo.ProductInfo
								--		( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								--VALUES(NEWID(),5,'技术支持－海外支持部',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)

								-----公共(原产品开发) start-----
								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'公共',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								-----公共(原产品开发) end-----

								-----质量管理 start-----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02373'

								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'质量管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)

								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'TR评审',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)

								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'软件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'硬件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)

								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'质量&过程改进',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								-----质量管理 end-----
						END

						FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
					END;
                CLOSE Update_cursora;
                DEALLOCATE Update_cursora;
            END;

			------------------------------------------------------------------------------------------------------------
			BEGIN  
                DECLARE Update_cursora CURSOR LOCAL 
                FOR
                    SELECT * FROM #NewProduct
                OPEN Update_cursora;
                FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
                WHILE @@FETCH_STATUS = 0
                    BEGIN

						SET @CountNum= (SELECT COUNT(0) FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE ISNULL(bigTypeName,'') NOT IN ('解决方案项目','预研/技术开发项目')
								AND ISNULL(smallTypeName,'')<>'纯软件项目' AND ISNULL(smallTypeName,'')<>'综合产品软件项目' And ISNULL(smallTypeName,'')<>'Devops项目'
								AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)
						
						SET @HardManager =	(select hardmg FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

						SET @RDPDT =	(select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

						IF(@CountNum >0)
						BEGIN
								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
							--A#
								-----硬件开发 start-----
								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'硬件开发',@NewACode,@ProCode,@HardManager,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								-----硬件开发 end-----

								-----驱动开发 start-----
								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'驱动开发',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								-----驱动开发 end-----

								-----硬件鉴定 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02355'

								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'硬件鉴定',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								-----硬件鉴定 end -----

								-----工程开发 start-----
								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'工程开发',@NewACode,@ProCode,@HardManager,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'结构开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'电源开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'整机试装',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'装备开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'准入认证',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'热设计',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'产品数据',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'单板工艺',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'互连单板开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'产品可靠性',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'EMC',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'专业试验',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'器件分析',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'工程代表专项',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'安规（含节能环保）',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'互连仿真测试开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'逻辑开发',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								--B
								SET @NewBCode =[dbo].[F_DistributionProductCode](5,@NewACode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),5,'硬件公共',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								-----工程开发 end-----	
						END

						FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
					END;
                CLOSE Update_cursora;
                DEALLOCATE Update_cursora;
            END;
			------------------------------------------------------------------------------------------------------------

			BEGIN  
                DECLARE Update_cursora CURSOR LOCAL 
                FOR
                    SELECT * FROM #NewProduct
                OPEN Update_cursora;
                FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
                WHILE @@FETCH_STATUS = 0
                    BEGIN

						SET @CountNum= (SELECT COUNT(0) FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE ISNULL(bigTypeName,'') IN ('IPD产品开发项目')
								AND (ISNULL(smallTypeName,'')='纯软件项目' OR ISNULL(smallTypeName,'')='综合产品软件项目' OR ISNULL(smallTypeName,'')='Devops项目')
								AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)

						SET @RDPDT =	(select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

						IF(@CountNum >0)
						BEGIN
								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
								-----特性开发 start-----
								SET @NewACode =	[dbo].[F_DistributionProductCode](4,@ProCode);
								INSERT INTO dbo.ProductInfo
										( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
								VALUES(NEWID(),4,'特性开发',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								-----特性开发 end-----
								
						END

						FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
					END;
                CLOSE Update_cursora;
                DEALLOCATE Update_cursora;
            END;
			------------------------------------------------------------------------------------------------------------
			-----------------------------------------更新生命周期需求开发项目新增项下挂 start-------------------------------------------------------------------
			BEGIN  
				DECLARE Update_cursora CURSOR LOCAL 
				FOR
				   SELECT * FROM #NewProduct
                   --SELECT ProName,ProCode,CC FROM dbo.ProductInfo WHERE ProLevel=3 AND ProName LIKE('%生命周期需求开发项目%') --And DeleteFlag=0-- AND DeleteFlag in(1,2) --注意没有“产品两字”
				OPEN Update_cursora;
				FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
				WHILE @@FETCH_STATUS = 0
                    BEGIN
						   SELECT @Index=CHARINDEX('生命周期需求开发项目',@ProName,0)
						   IF(@Index>0)
						   BEGIN
							   SELECT @TestManager=Testing_Mnger,
									  @PPPDT_ID=PPPDT_ID,
									--  @Documents_Mnger=PDT_TD_ID,
									  @Documents_Mnger=Documents_Mnger,
									  @RDPDT=RNDPDT_ID 
									  FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] where ReleaseCode_Name = @ProName

								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
								-----产品测试 start -----
								--A
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'产品测试',@NewACode,@ProCode,@TestManager,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试计划与策略',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试计划与策略制定及修改',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试分析设计',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试需求与规格分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试SOW制定',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试测试方案设计制定' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试SOW测试方案设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试测试方案设计制定' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试点设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试用例设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试编码',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试移植与优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试执行',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试执行准备',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'手工测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'开发定位配合',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'CMM问题单回归',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'CMM问题单复现',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='重大问题同步' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'重大问题同步',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='重大问题同步' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'资料测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='网上问题处理' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'网上问题处理',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='网上问题处理' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='实验局/技术支持' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'实验局/技术支持',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='实验局/技术支持' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='对外测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'对外测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='对外测试' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'拷机测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试评估',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'缺陷分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试报告/总结',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='鉴定测试' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'鉴定测试',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='鉴定测试' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试准备与分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'鉴定测试准备与分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试准备与分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'鉴定测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试重现定位' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'鉴定测试重现定位',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试重现定位' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试总结与报告' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'鉴定测试总结与报告',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试总结与报告' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='公共活动' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'公共活动',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='公共活动' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='项目管理以及流程处理' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'项目管理以及流程处理',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='项目管理以及流程处理' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试流程引导/审计/优化' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试流程引导/审计/优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试流程引导/审计/优化' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='技术积累与贡献' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'技术积累与贡献',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='技术积累与贡献' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='指导和培训类工作' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'指导和培训类工作',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='指导和培训类工作' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='公共测试环境维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'公共测试环境维护',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='公共测试环境维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试工具开发' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试工具开发',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试工具开发' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='请假' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'请假',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='请假' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='其他测试公共活动' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'其他测试公共活动',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='其他测试公共活动' AND ProLevel=6  )
								END
								-----产品测试 end -----
								-------------------------------------------------------------------------------------
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00595' --焦旭坡
								-----基础软件 start -----
								--A
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'基础软件',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4  )
								END 
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02102' --辛海宁
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'OM',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'BootWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'dWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'License开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'可信计算开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'MUI',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'代码扫描＆安全漏洞',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6  )
								END

								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02217' --余斌
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'操作系统',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V5）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V7）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V9）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'服务器OS开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'S1020V开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6  )
								END

								-----基础软件 end -----
								-----------------------------------------------------------------------------------------------------------------
								-----Comware平台 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00526' --张弢
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='Comware平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'Comware平台',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='Comware平台' AND ProLevel=4  )
								END 

								-----Comware平台 end -----
								-----------------------------------------------------------------------------------------------------------------
								-----硬件平台 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'硬件平台',@NewACode,@ProCode,@PPPDT_ID,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
								END 
								-----硬件平台 end-----
								-----------------------------------------------------------------------------------------------------------------
								-----资料工作（资料开发、翻译和视觉设计） start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'资料工作（资料开发、翻译和视觉设计）',@NewACode,@ProCode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4  )
								END 

								-----资料工作（资料开发、翻译和视觉设计） end -----
								-----项目管理 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00681' --李亮
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'项目管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4  )
								END 
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='01540' --王建军01540
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'PLCCB运作',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'生命周期管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'项目计划管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'产品运营分析',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5  )
								END 
								-----项目管理 end -----
								--------------------------------------------------------------------------------------------------------------
								-----质量管理 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02373' --李欣然
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4 AND DeleteFlag=0)
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'质量管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4  AND DeleteFlag=0)
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'软件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'硬件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'质量回溯',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'数据分析与度量',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'质量&过程改进',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5  )
								END 
								-----质量管理 end -----
								------------------------------------------------------------------------------------------------------------------

								-----产品维护 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品维护' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'产品维护',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品维护' AND ProLevel=4 )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件维护和测试' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'硬件维护和测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件维护和测试' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件维护和测试' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'软件维护和测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件维护和测试' AND ProLevel=5  )
								END 
								-----产品维护 end-----
								------------------------------------------------------------------------------------------------------------------
								-----集采测试 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='集采测试' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'集采测试',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='集采测试' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='运营商集采测试' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'运营商集采测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='运营商集采测试' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='非运营商对外测试' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'非运营商对外测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='非运营商对外测试' AND ProLevel=5  )
								END 
								-----集采测试 end-----
								------------------------------------------------------------------------------------------------------------------
								-----市场支持 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='市场支持' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'市场支持',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='市场支持' AND ProLevel=4  )
								END 
								-----市场支持 end -----
								------------------------------------------------------------------------------------------------------------------
								-----测试平台 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'测试平台',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'自动化测试平台建设',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试分析，设计和评估',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5  )
								END 
								-----测试平台 end -----
								------------------------------------------------------------------------------------------------------------------
								-----技术研究 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
												   SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
												   INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
												   VALUES(NEWID(),4,'技术研究',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										 SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究' AND ProLevel=4 )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='早期技术研究' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'早期技术研究',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='早期技术研究' AND ProLevel=5  )
								END 
								-----技术研究 end-----
								------------------------------------------------------------------------------------------------------------------
								-----团队管理 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'团队管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4  )
								END 
								-----团队管理 end -----
								------------------------------------------------------------------------------------------------------------------
								-----需求管理 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'需求管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4  )
								END 
								-----需求管理 end -----
							END
                           FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
                   END;
					CLOSE Update_cursora;
					DEALLOCATE Update_cursora;
			END
			------------------------------------------------------------------------------------------------------------
			-----------------------------------------更新生命周期需求开发项目新增项下挂 end-------------------------------------------------------------------

			-----------------------------------------更新小特性开发项目新增项下挂 start-------------------------------------------------------------------
			BEGIN  
				DECLARE Update_cursora CURSOR LOCAL 
				FOR
				   SELECT * FROM #NewProduct
				OPEN Update_cursora;
				FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
				WHILE @@FETCH_STATUS = 0
                    BEGIN
						   SELECT @Index=CHARINDEX('小特性开发',@ProName,0)
						   IF(@Index>0)
						   BEGIN
							   SELECT @TestManager=Testing_Mnger,
									  @PPPDT_ID=PPPDT_ID,
									--  @Documents_Mnger=PDT_TD_ID,
									  @Documents_Mnger=Documents_Mnger,
									  @RDPDT=RNDPDT_ID 
									  FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] where ReleaseCode_Name = @ProName

								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
								-----产品测试 start -----
								--A
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'产品测试',@NewACode,@ProCode,@TestManager,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试计划与策略',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试计划与策略制定及修改',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试分析设计',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试需求与规格分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试SOW制定',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试方案设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试方案设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试方案设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试点设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试用例设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试编码',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试移植与优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试执行',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试执行准备',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'手工测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'开发定位配合',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'CMM问题单回归',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'CMM问题单复现',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'资料测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'拷机测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试评估',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'缺陷分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试报告/总结',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6  )
								END
								-----产品测试 end -----
								-------------------------------------------------------------------------------------
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00595' --焦旭坡
								-----基础软件 start -----
								--A
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'基础软件',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4  )
								END 
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02102' --辛海宁
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'OM',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'BootWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'dWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'License开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'可信计算开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'MUI',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'代码扫描＆安全漏洞',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6  )
								END

								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02217' --余斌 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'操作系统',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V5）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V7）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V9）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'服务器OS开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'S1020V开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6  )
								END

								-----基础软件 end -----
								-----------------------------------------------------------------------------------------------------------------
								-----硬件平台 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'硬件平台',@NewACode,@ProCode,@PPPDT_ID,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
								END 
								-----硬件平台 end-----
								-----------------------------------------------------------------------------------------------------------------
								-----资料工作（资料开发、翻译和视觉设计） start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'资料工作（资料开发、翻译和视觉设计）',@NewACode,@ProCode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='版本配套资料工作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'版本配套资料工作',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='版本配套资料工作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='重大项目资料支持' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'重大项目资料支持',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='重大项目资料支持' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='扩展交付&图说图解&视频&查询工具' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'扩展交付&图说图解&视频&查询工具',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='扩展交付&图说图解&视频&查询工具' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='评审工作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'评审工作',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='评审工作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='翻译和翻译支持' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'翻译和翻译支持',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='翻译和翻译支持' AND ProLevel=5  )
								END 
								-----资料工作（资料开发、翻译和视觉设计） end -----
								-----项目管理 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00681' --李亮
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'项目管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4  )
								END 
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='01540' --王建军01540
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'PLCCB运作',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'生命周期管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'项目计划管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'产品运营分析',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5  )
								END 
								-----项目管理 end -----
								--------------------------------------------------------------------------------------------------------------
								-----质量管理 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02373' --李欣然
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'质量管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'软件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'硬件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'质量回溯',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'数据分析与度量',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'质量&过程改进',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5  )
								END 
								-----质量管理 end -----
								------------------------------------------------------------------------------------------------------------------
								-----测试平台 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'测试平台',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'自动化测试平台建设',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试分析，设计和评估',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5  )
								END 
								-----测试平台 end -----
								------------------------------------------------------------------------------------------------------------------
								-----技术研究 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究（含立项前准备等）' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
												   SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
												   INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
												   VALUES(NEWID(),4,'技术研究（含立项前准备等）',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										 SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究（含立项前准备等）' AND ProLevel=4 )
								END 
								-----技术研究 end-----
								------------------------------------------------------------------------------------------------------------------
								-----团队管理 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'团队管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4  )
								END 
								-----团队管理 end -----
								------------------------------------------------------------------------------------------------------------------
								-----需求管理 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'需求管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4  )
								END 
								-----需求管理 end -----
							END
                           FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
                   END;
					CLOSE Update_cursora;
					DEALLOCATE Update_cursora;
			END
			------------------------------------------------------------------------------------------------------------
			-----------------------------------------更新小特性开发项目新增项下挂 end-------------------------------------------------------------------

			-----------------------------------------更新维护开发项目新增项下挂 start-------------------------------------------------------------------
			BEGIN  
				DECLARE Update_cursora CURSOR LOCAL 
				FOR
				   SELECT * FROM #NewProduct
				OPEN Update_cursora;
				FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
				WHILE @@FETCH_STATUS = 0
                    BEGIN
						   SELECT @Index=CHARINDEX('维护开发',@ProName,0)
						   IF(@Index>0)
						   BEGIN
							   SELECT @TestManager=Testing_Mnger,
									  @PPPDT_ID=PPPDT_ID,
									--  @Documents_Mnger=PDT_TD_ID,
									  @Documents_Mnger=Documents_Mnger,
									  @RDPDT=RNDPDT_ID 
									  FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] where ReleaseCode_Name = @ProName

								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
								-----产品测试 start -----
								--A
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'产品测试',@NewACode,@ProCode,@TestManager,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试计划与策略',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试计划与策略制定及修改',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试分析设计',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试需求与规格分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试SOW制定',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试方案设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试方案设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试方案设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试点设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试用例设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试编码',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试移植与优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试执行',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试执行准备',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'手工测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'自动化测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'开发定位配合',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'CMM问题单回归',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'CMM问题单复现',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'资料测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'拷机测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6  )
								END
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试评估',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'缺陷分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'测试报告/总结',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6  )
								END
								-----产品测试 end -----
								-------------------------------------------------------------------------------------
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00595' --焦旭坡
								-----基础软件 start -----
								--A
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'基础软件',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4  )
								END 
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02102' --辛海宁
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'OM',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'BootWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'dWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'License开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'可信计算开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'MUI',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'代码扫描＆安全漏洞',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6  )
								END

								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02217' --余斌
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'操作系统',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5  )
								END 
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V5）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V7）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'嵌入式OS开发维护（V9）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'服务器OS开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6  )
								END
								--C
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),6,'S1020V开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewCCode,@NewBCode)
								END
								ELSE
								BEGIN
										SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6  )
								END

								-----基础软件 end -----
								-----------------------------------------------------------------------------------------------------------------
								-----Comware平台 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00526' --张弢
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='Comware平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'Comware平台',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='Comware平台' AND ProLevel=4  )
								END 

								-----Comware平台 end -----
								-----------------------------------------------------------------------------------------------------------------
								-----硬件平台 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'硬件平台',@NewACode,@ProCode,@PPPDT_ID,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
								END 
								-----硬件平台 end-----
								-----------------------------------------------------------------------------------------------------------------
								-----资料工作（资料开发、翻译和视觉设计） start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'资料工作（资料开发、翻译和视觉设计）',@NewACode,@ProCode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='版本配套资料工作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'版本配套资料工作',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='版本配套资料工作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='重大项目资料支持' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'重大项目资料支持',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='重大项目资料支持' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='扩展交付&图说图解&视频&查询工具' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'扩展交付&图说图解&视频&查询工具',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='扩展交付&图说图解&视频&查询工具' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='评审工作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'评审工作',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='评审工作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='翻译和翻译支持' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'翻译和翻译支持',@NewBCode,@NewACode,@Documents_Mnger,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='翻译和翻译支持' AND ProLevel=5  )
								END 
								-----资料工作（资料开发、翻译和视觉设计） end -----
								-----项目管理 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00681' --李亮
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'项目管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4  )
								END 
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='01540' --王建军01540
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'PLCCB运作',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'生命周期管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'项目计划管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'产品运营分析',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5  )
								END 
								-----项目管理 end -----
								--------------------------------------------------------------------------------------------------------------
								-----质量管理 start -----
								SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02373' --李欣然
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'质量管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4 )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'软件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'硬件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'质量回溯',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'数据分析与度量',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'质量&过程改进',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5  )
								END 
								-----质量管理 end -----
								------------------------------------------------------------------------------------------------------------------
								-----测试平台 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'测试平台',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'自动化测试平台建设',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5  )
								END 
								--B
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
										INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),5,'测试分析，设计和评估',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',0,@NewBCode,@NewACode)
								END
								ELSE
								BEGIN
										SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5  )
								END 
								-----测试平台 end -----
								------------------------------------------------------------------------------------------------------------------
								-----技术研究 start-----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究（含立项前准备等）' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
												   SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
												   INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
												   VALUES(NEWID(),4,'技术研究（含立项前准备等）',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										 SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究（含立项前准备等）' AND ProLevel=4 )
								END 
								-----技术研究 end-----
								------------------------------------------------------------------------------------------------------------------
								-----团队管理 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'团队管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4  )
								END 
								-----团队管理 end -----
								------------------------------------------------------------------------------------------------------------------
								-----需求管理 start -----
								SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4 )
								IF(@CountNum <1)
								BEGIN 
										SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
										INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
										VALUES(NEWID(),4,'需求管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',0,@NewACode,@ProCode)
								END
								ELSE
								BEGIN
										SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4  )
								END 
								-----需求管理 end -----
							END
                           FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
                   END;
					CLOSE Update_cursora;
					DEALLOCATE Update_cursora;
			END
			------------------------------------------------------------------------------------------------------------
			-----------------------------------------更新维护开发项目新增项下挂 end-------------------------------------------------------------------
			INSERT INTO dbo.ProductShare
			        ( PSID ,ProCode ,ParentCode ,SharePercents ,CreateTime ,Creator ,DeleteFlag ,ProductId)
			SELECT NEWID(),ProCode,ParentCode,100,GETDATE(),'admin',0, ProCode FROM dbo.ProductInfo
			WHERE ProCode NOT IN(SELECT ProCode FROM dbo.ProductShare) AND ProLevel>2
		
	-----------------------------------------更新PDT-----------------------------------------

		--更新PDT数据
            UPDATE  ProductInfo
            SET     ProName = PT.Name ,
                    Manager = REPLACE(PT.PDT_Manager, '/h3c', '') ,
                    ParentCode = PT.ProductLineCode_Code ,
                    ModifyTime = GETDATE()
            FROM    [RDMDSDB].[RD_MDS].[mdm].[V_PDT] PT
            WHERE   ProductInfo.ProCode = PT.Code
                    AND ProductInfo.ProLevel = 2;

		--插入不存在的PDT
            INSERT  INTO ProductInfo
                    ( ProID ,
                      ProLevel ,
                      ProName ,
                      ProCode ,
                      ParentCode ,
                      Manager ,
                      CreateTime ,
                      ModifyTime ,
                      DeleteFlag ,
                      Id ,
                      ParentId ,
                      RestartFlag
                    )
                    SELECT  NEWID() ,
                            2 ,
                            PT.Name ,
                            PT.Code ,
                            PT.ProductLineCode_Code ,
                            REPLACE(PT.PDT_Manager, '/h3c', '') ,
                            GETDATE() ,
                            GETDATE() ,
                            0 ,
                            PT.Code ,
                            PT.ProductLineCode_Code ,
                            0
                    FROM    [RDMDSDB].[RD_MDS].[mdm].[V_PDT] PT
                            LEFT JOIN ProductInfo P ON P.ProCode = PT.Code
                    WHERE   P.ProCode IS NULL
                            AND PT.Code IN ( SELECT DISTINCT
                                                    PDT_Code
                                             FROM   #NewProductInfo );

	-----------------------------------------更新ProductLine-----------------------------------------

		--更新产品线数据
            UPDATE  ProductInfo
            SET     ProName = PL.Name ,
                    Manager = REPLACE(PL.fldcpxzj, '/h3c', '') ,
                    ModifyTime = GETDATE()
            FROM    [RDMDSDB].[RD_MDS].[mdm].[V_ProductLine] PL
            WHERE   ProductInfo.ProCode = PL.Code
                    AND ProductInfo.ProLevel = 1;

		--插入不存在的产品线
            INSERT  INTO ProductInfo
                    ( ProID ,
                      ProLevel ,
                      ProName ,
                      ProCode ,
                      Manager ,
                      CreateTime ,
                      ModifyTime ,
                      DeleteFlag ,
                      Id ,
                      RestartFlag
                    )
                    SELECT  NEWID() ,
                            1 ,
                            PL.Name ,
                            PL.Code ,
                            REPLACE(PL.fldcpxzj, '/h3c', '') ,
                            GETDATE() ,
                            GETDATE() ,
                            0 ,
                            PL.Code ,
                            0
                    FROM    [RDMDSDB].[RD_MDS].[mdm].[V_ProductLine] PL
                            LEFT JOIN ProductInfo P ON P.ProCode = PL.Code
                    WHERE   P.ProCode IS NULL
                            AND PL.Code IN ( SELECT DISTINCT
                                                    ProductLine_Code
                                             FROM   #NewProductInfo );
			
		--生成 Product_display 
		EXEC [dbo].[P_UpdateProductInfoDisplay]

	-----------------------------------------给人员添加项目经理和pop角色的-----------------------------------------

		--给相关人员加项目经理权限
            SELECT  @RoleCode = Rid
            FROM    dbo.RoleInfo
            WHERE   Code = 'sys_04';

			---ys2338 新增对有逗号分隔的人员处理start--- 
			declare @userName nvarchar(100)
			declare @userFullText nvarchar(max)
			set @userName=''
			set @userFullText=''
			DECLARE User_Cursor CURSOR LOCAL static read_only forward_only
			FOR
					   SELECT distinct  Manager FROM ProductInfo where Manager IS NOT NULL And Manager <> ''
			OPEN User_Cursor;
			FETCH NEXT FROM User_Cursor INTO @userName
			WHILE @@FETCH_STATUS = 0
					   BEGIN
							set @userFullText=@userFullText+ @userName+','
							FETCH NEXT FROM User_Cursor INTO @userName;
					   END;
			CLOSE User_Cursor;
			DEALLOCATE User_Cursor;
			---ys2338 新增对有逗号分隔的人员处理end---

            INSERT  INTO dbo.User_Role_Relation
                    ( Id ,
                      Uid ,
                      Rid ,
                      CreateTime ,
                      Creator ,
                      Modifier ,
                      ModifyTime ,
                      DeleteFlag
                    )
                    SELECT  NEWID() ,
                            UserInfoUid ,
                            RoleinfoRid ,
                            GETDATE() ,
                            NULL ,
                            NULL ,
                            NULL ,
                            0
                    FROM    ( SELECT    UserInfo.Uid UserInfoUid ,
                                        @RoleCode RoleinfoRid ,
                                        User_Role_Relation.*
                              FROM      UserInfo
							  --ys2338 原有备份 start
                                        --INNER JOIN ( SELECT DISTINCT
                                        --                    SUBSTRING(Manager,
                                        --                      ( CHARINDEX(' ',
                                        --                      Manager) + 1 ),
                                        --                      ( LEN(Manager)
                                        --                      - CHARINDEX(' ',
                                        --                      Manager) + 1 )) ManagerCode
                                        --             FROM   dbo.ProductInfo
                                        --             WHERE  ( Manager IS NOT NULL
                                        --                      OR Manager <> ''
                                        --                    )
                                        --           ) Managers ON UserInfo.NotesAccount = Managers.ManagerCode
												   --ys2338 原有备份 end
												    --ys2338 新增优化 start
							   INNER JOIN ( SELECT DISTINCT
                                                            SUBSTRING(tableColumn,
                                                              ( CHARINDEX(' ',
                                                              tableColumn) + 1 ),
                                                              ( LEN(tableColumn)
                                                              - CHARINDEX(' ',
                                                              tableColumn) + 1 )) ManagerCode
                                                     FROM  F_SplitStrToTable(@userFullText)
                                                   ) Managers ON UserInfo.NotesAccount = Managers.ManagerCode
								--ys2338 新增优化 end
                                        LEFT JOIN ( SELECT  *
                                                    FROM    User_Role_Relation
                                                    WHERE   User_Role_Relation.Rid = @RoleCode
                                                  ) User_Role_Relation ON UserInfo.Uid = User_Role_Relation.Uid
                            ) New_U_R_info
                    WHERE   New_U_R_info.Uid IS NULL;

		--给相关人员加pop权限
            SELECT  @RoleCode = Rid
            FROM    dbo.RoleInfo
            WHERE   Code = 'sys_POP';

			---ys2338 新增对有逗号分隔的人员处理start--- 
			set @userName=''
			set @userFullText=''
			DECLARE User_Cursor CURSOR LOCAL static read_only forward_only
			FOR
					   SELECT distinct  CC FROM ProductInfo where CC IS NOT NULL And CC <> ''
			OPEN User_Cursor;
			FETCH NEXT FROM User_Cursor INTO @userName
			WHILE @@FETCH_STATUS = 0
					   BEGIN
							set @userFullText=@userFullText+ @userName+','
							FETCH NEXT FROM User_Cursor INTO @userName;
					   END;
			CLOSE User_Cursor;
			DEALLOCATE User_Cursor;
			---ys2338 新增对有逗号分隔的人员处理end---

            INSERT  INTO dbo.User_Role_Relation
                    ( Id ,
                      Uid ,
                      Rid ,
                      CreateTime ,
                      Creator ,
                      Modifier ,
                      ModifyTime ,
                      DeleteFlag
                    )
                    SELECT  NEWID() ,
                            UserInfoUid ,
                            RoleinfoRid ,
                            GETDATE() ,
                            NULL ,
                            NULL ,
                            NULL ,
                            0
                    FROM    ( SELECT    UserInfo.Uid UserInfoUid ,
                                        @RoleCode RoleinfoRid ,
                                        User_Role_Relation.*
                              FROM      UserInfo
							  --ys2338 原有备份 start
                                        --INNER JOIN ( SELECT DISTINCT
                                        --                    SUBSTRING(CC,
                                        --                      ( CHARINDEX(' ',
                                        --                      CC) + 1 ),
                                        --                      ( LEN(CC)
                                        --                      - CHARINDEX(' ',
                                        --                      CC) + 1 )) ManagerCode
                                        --             FROM   dbo.ProductInfo
                                        --             WHERE  ( CC IS NOT NULL
                                        --                      OR CC <> ''
                                        --                    )
                                        --           ) Managers ON UserInfo.NotesAccount = Managers.ManagerCode
								--ys2338 原有备份 start
								--ys2338 优化逻辑 start
								INNER JOIN ( SELECT DISTINCT
                                                            SUBSTRING(tableColumn,
                                                              ( CHARINDEX(' ',
                                                              tableColumn) + 1 ),
                                                              ( LEN(tableColumn)
                                                              - CHARINDEX(' ',
                                                              tableColumn) + 1 )) ManagerCode
                                                     FROM      F_SplitStrToTable(@userFullText)
                                                   ) Managers ON UserInfo.NotesAccount = Managers.ManagerCode
								--ys2338 优化逻辑 end
                                        LEFT JOIN ( SELECT  *
                                                    FROM    User_Role_Relation
                                                    WHERE   User_Role_Relation.Rid = @RoleCode
                                                  ) User_Role_Relation ON UserInfo.Uid = User_Role_Relation.Uid
                            ) New_U_R_info
                    WHERE   New_U_R_info.Uid IS NULL;

	-----------------------------------------更新分摊比例-----------------------------------------

		--修改分摊比例
            UPDATE  ProductShare
            SET     SharePercents = ( Temp.sharePercents) ,
                    ModifyTime = GETDATE()
            FROM    ( SELECT DISTINCT
                                Pdt ,
                                ProjectCode ,
                                ProInfo.Code ParentCode ,
                                ( SELECT    SUM(CostScale) * 100
                                  FROM      ProductTemp
                                  WHERE     ProjectCode = Temp1.ProjectCode
                                            AND Pdt = Temp1.Pdt
                                ) sharePercents
                      FROM      dbo.ProductTemp Temp1
                                INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_PDT] ProInfo ON ProInfo.Name = Temp1.Pdt
                      WHERE     Temp1.CostScale IS NOT NULL
                    ) Temp
            WHERE   ProductShare.ProCode = Temp.ProjectCode
                    AND ProductShare.ParentCode = Temp.ParentCode;

		--插入分摊比例
		--原有逻辑注释 ys2338 start
		/*
            INSERT  INTO dbo.ProductShare
                    ( PSID ,
                      ProCode ,
                      ParentCode ,
                      SharePercents ,
                      CreateTime ,
                      Creator ,
                      Modifier ,
                      ModifyTime ,
                      DeleteFlag ,
                      ProductId
                    )
                    SELECT  NEWID() ,
                            Temp.ProjectCode ,
                            Temp.ParentCode ,
                            ( SELECT    SUM(CostScale) * 100
                              FROM      ProductTemp
                              WHERE     ProjectCode = Temp.ProjectCode
                                        AND Pdt = Temp.Pdt
                            ) sharePercents ,
                            GETDATE() ,
                            NULL ,
                            NULL ,
                            GETDATE() ,
                            0 ,
                            Temp.ProjectCode
                    FROM    ( SELECT DISTINCT
                                        Pdt ,
                                        ProjectCode ,
                                        ProInfo.Code ParentCode ,
                                        ( SELECT    SUM(CostScale) * 100
                                          FROM      ProductTemp
                                          WHERE     ProjectCode = Temp1.ProjectCode
                                                    AND Pdt = Temp1.Pdt
                                        ) sharePercents
                              FROM      ( SELECT DISTINCT
                                                    *
                                          FROM      dbo.ProductTemp
                                        ) Temp1
                                        INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_PDT] ProInfo ON ProInfo.Name = Temp1.Pdt
                              WHERE     Temp1.CostScale IS NOT NULL
                                        AND Temp1.Pdt <> 'SDN'
                              UNION
                              SELECT DISTINCT
                                        Pdt ,
                                        ProjectCode ,
                                        ProInfo.Code ParentCode ,
                                        ( SELECT    SUM(CostScale) * 100
                                          FROM      ProductTemp
                                          WHERE     ProjectCode = Temp1.ProjectCode
                                                    AND Pdt = Temp1.Pdt
                                        ) sharePercents
                              FROM      ( SELECT DISTINCT
                                                    *
                                          FROM      dbo.ProductTemp
                                        ) Temp1
                                        INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_PDT] ProInfo ON ProInfo.Name = Temp1.Pdt
                              WHERE     Temp1.Pdt = 'SDN'
                                        AND Temp1.CostScale IS NOT NULL
                                        AND CHARINDEX(Temp1.ProductLine,
                                                      ProInfo.ProductLineCode_Name) > 0
                            ) Temp
                    WHERE   NOT EXISTS ( SELECT 1
                                         FROM   dbo.ProductShare ProShare
                                         WHERE  ProShare.ProCode = Temp.ProjectCode 
										 --ys2338 注释 还是需要该代码
										 AND ProShare.ParentCode = Temp.ParentCode
										 )
					--AND	 NOT EXISTS ( SELECT 1  --ys2338增加条件
      --                                   FROM   dbo.ProductShare ProShare
      --                                   WHERE  ProShare.ProCode = Temp.ProjectCode And ProShare.DeleteFlag=0
						--				 group by ProShare.ProCode
						--				 HAVING SUM(ProShare.SharePercents)=100
						--				 )
						*/
						--原有逻辑注释 ys2338 end

			-- ys2338 调整插入分摊逻辑 start
			--待调整分摊插入临时表
					 SELECT  NEWID() GUID,
                            Temp.ProjectCode ,
                            Temp.ParentCode ,
                            ( SELECT    SUM(CostScale) * 100
                              FROM      ProductTemp
                              WHERE     ProjectCode = Temp.ProjectCode
                                        AND Pdt = Temp.Pdt
                            ) sharePercents ,
                            GETDATE() CreateTime,
                            NULL Creator,
                            NULL Modifier,
                            GETDATE() ModifyTime,
                            0 DeleteFlag,
                            Temp.ProjectCode ProductId
					INTO	#ShareTable
                    FROM    ( SELECT DISTINCT
                                        Pdt ,
                                        ProjectCode ,
                                        ProInfo.Code ParentCode ,
                                        ( SELECT    SUM(CostScale) * 100
                                          FROM      ProductTemp
                                          WHERE     ProjectCode = Temp1.ProjectCode
                                                    AND Pdt = Temp1.Pdt
                                        ) sharePercents
                              FROM      ( SELECT DISTINCT
                                                    *
                                          FROM      dbo.ProductTemp
                                        ) Temp1
                                        INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_PDT] ProInfo ON ProInfo.Name = Temp1.Pdt
                              WHERE     Temp1.CostScale IS NOT NULL
                                        AND Temp1.Pdt <> 'SDN'
                              UNION
                              SELECT DISTINCT
                                        Pdt ,
                                        ProjectCode ,
                                        ProInfo.Code ParentCode ,
                                        ( SELECT    SUM(CostScale) * 100
                                          FROM      ProductTemp
                                          WHERE     ProjectCode = Temp1.ProjectCode
                                                    AND Pdt = Temp1.Pdt
                                        ) sharePercents
                              FROM      ( SELECT DISTINCT
                                                    *
                                          FROM      dbo.ProductTemp
                                        ) Temp1
                                        INNER JOIN [RDMDSDB].[RD_MDS].[mdm].[V_PDT] ProInfo ON ProInfo.Name = Temp1.Pdt
                              WHERE     Temp1.Pdt = 'SDN'
                                        AND Temp1.CostScale IS NOT NULL
                                        AND CHARINDEX(Temp1.ProductLine,
                                                      ProInfo.ProductLineCode_Name) > 0
                            ) Temp
                    WHERE   NOT EXISTS ( SELECT 1
                                         FROM   dbo.ProductShare ProShare
                                         WHERE  ProShare.ProCode = Temp.ProjectCode 
										 --ys2338 注释 还是需要该代码
										 AND ProShare.ParentCode = Temp.ParentCode
										 )
					----------------------------------------------------------------
					IF (SELECT COUNT(*) FROM #ShareTable)>0
					BEGIN
						--对于现有分摊为100%的 删除该分摊，然后插入新分摊
						SELECT * INTO #DeleteShareTable
						FROM #ShareTable
						WHERE ProjectCode IN(
						select ProCode from ProductShare 
						where ProCode in(SELECT ProjectCode FROM #ShareTable)
						And DeleteFlag=0
						group by ProCode
						HAVING SUM(SharePercents)=100
						)
						DELETE FROM ProductShare where ProCode IN(SELECT ProjectCode From #DeleteShareTable)
						INSERT  INTO dbo.ProductShare
						( PSID ,
							ProCode ,
							ParentCode ,
							SharePercents ,
							CreateTime ,
							Creator ,
							Modifier ,
							ModifyTime ,
							DeleteFlag ,
							ProductId
						)
						select * from #DeleteShareTable

						--对于现有分摊不为100%的 直接插入新分摊 因为前面的逻辑会调整其他分摊数值
						INSERT  INTO dbo.ProductShare
						( PSID ,
							ProCode ,
							ParentCode ,
							SharePercents ,
							CreateTime ,
							Creator ,
							Modifier ,
							ModifyTime ,
							DeleteFlag ,
							ProductId
						)
						SELECT * FROM #ShareTable 
						WHERE ProjectCode IN(
							select ProCode from ProductShare 
							where ProCode in(SELECT ProjectCode FROM #ShareTable)
							And DeleteFlag=0
							group by ProCode
							HAVING SUM(SharePercents)<100
						)
						DROP TABLE #DeleteShareTable;
					END
					DROP TABLE #ShareTable;
		-- ys2338 调整插入分摊逻辑 end
	-----------------------------------------失效处理-----------------------------------------

	---------根据Notes的数据判断失效
	
		--标记9编码项目失效信息，目前暂不失效
            UPDATE  ProductInfo
            SET     SuspendType = '' ,
                    SuspendTime = ( SELECT  CONVERT(CHAR(10), DATEADD(m, 1,
                                                              DATEADD(dd,
                                                              -DAY(GETDATE())
                                                              + 2, GETDATE())), 120)
                                  ) ,
                    ActualSuspendTime = GETDATE() ,
                    invalidType = '2'
            WHERE   ProLevel = 3
					AND DeleteFlag<>2
                    AND ( invalidType = ''
                          OR invalidType IS NULL
                        )
                    AND NOT EXISTS ( SELECT 1
                                     FROM   dbo.ProductTemp
                                     WHERE  ProjectCode = ProCode );

		--标记子集编码项目失效信息，目前暂不失效
            BEGIN  
                DECLARE Update_cursor1 CURSOR LOCAL 
                FOR
                    ( SELECT    ProCode ,
                                SuspendType ,
                                SuspendTime ,
                                ActualSuspendTime ,
                                invalidType
                      FROM      dbo.ProductInfo
                      WHERE     NOT EXISTS ( SELECT 1
                                             FROM   dbo.ProductTemp
                                             WHERE  ProjectCode = ProCode )
								AND ProductInfo.ProLevel = 3
								AND dbo.ProductInfo.DeleteFlag<>1
                    );
                OPEN Update_cursor1;
                FETCH NEXT FROM Update_cursor1 INTO @ProCode, @SuspendType,
                     @SuspendTime, @ActualSuspendTime,@invalidType;
                WHILE @@FETCH_STATUS = 0
                    BEGIN            
                        EXEC P_SyncUpdateInvalidProductInfo @ProCode, @SuspendType,
                            @SuspendTime, @ActualSuspendTime, @invalidType;
						FETCH NEXT FROM Update_cursor1 INTO @ProCode, @SuspendType,
							 @SuspendTime, @ActualSuspendTime,@invalidType;
					END;
                CLOSE Update_cursor1;
                DEALLOCATE Update_cursor1;
            END;

	-------根据Iplan的数据判断失效
		PRINT 2;
		--标记9编码项目失效信息，目前暂不失效
		--ys2338 原有备份 start
     --       UPDATE  ProductInfo
     --       SET     SuspendType = SuspendBRproject.SuspendType ,
     --               ActualSuspendTime = SuspendBRproject.SuspendTime ,
     --               invalidType = '2' ,
     --               SuspendTime = ( CASE WHEN 6 = ( SELECT  FailureTime
     --                                               FROM    FailureTimeConfiguration
     --                                               WHERE   ProjectParentCode = ipdProjectTypeCode
     --                                                       AND ProjectChildCode = ipdProjectSubTypeCode
     --                                             )
     --                                    THEN ( SELECT  CONVERT(CHAR(10), DATEADD(m,
     --                                                         6,
     --                                                         DATEADD(dd,
     --                                                         -DAY(SuspendBRproject.SuspendTime)
     --                                                         + 2, SuspendBRproject.SuspendTime)), 120)
     --                                         )
     --                                    ELSE ( SELECT  CONVERT(CHAR(10), DATEADD(m,
     --                                                         1,
     --                                                         DATEADD(dd,
     --                                                         -DAY(SuspendBRproject.SuspendTime)
     --                                                         + 2, SuspendBRproject.SuspendTime)), 120)
     --                                         )
     --                               END )
     --       FROM    [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
     --       WHERE   ( SuspendBRproject.ReleaseName + SuspendBRproject.BVersion ) = ProductInfo.ProName
     --               AND ProductInfo.ProLevel = 3
					--AND ProductInfo.DeleteFlag<>2
     --               AND ( ProductInfo.invalidType = ''
     --                     OR ProductInfo.invalidType IS NULL
     --                     OR ProductInfo.SuspendType = 'Suspend_VersionHung'
     --                   );
						--ys2338 原有备份 end
						--ys2338 修改 start
			UPDATE  ProductInfo
            SET     SuspendType = SuspendBRproject.SuspendType ,
                    ActualSuspendTime = SuspendBRproject.SuspendTime ,
                    invalidType = '2' ,
                    SuspendTime = ( CASE WHEN 6 = ( SELECT  FailureTime
                                                    FROM    FailureTimeConfiguration
                                                    WHERE   ProjectParentCode = ipdProjectTypeCode
                                                            AND ProjectChildCode = ipdProjectSubTypeCode
                                                  )
                                         THEN ( SELECT  CONVERT(CHAR(10), DATEADD(m,
                                                              6,
                                                              DATEADD(dd,
                                                              -DAY(SuspendBRproject.SuspendTime)
                                                              + 2, SuspendBRproject.SuspendTime)), 120)
                                              )
										 WHEN 007 = ( SELECT  ProjectParentCode
                                                    FROM    FailureTimeConfiguration
                                                    WHERE   ProjectParentCode = ipdProjectTypeCode
                                                            AND ProjectChildCode = ipdProjectSubTypeCode
                                                  )
                                         THEN ( SELECT  CONVERT(CHAR(10), DATEADD(m,
                                                              6,
                                                              DATEADD(dd,
                                                              -DAY(SuspendBRproject.SuspendTime)
                                                              + 2, SuspendBRproject.SuspendTime)), 120)
                                              )
                                         ELSE ( SELECT  CONVERT(CHAR(10), DATEADD(m,
                                                              1,
                                                              DATEADD(dd,
                                                              -DAY(SuspendBRproject.SuspendTime)
                                                              + 2, SuspendBRproject.SuspendTime)), 120)
                                              )
                                    END )
            FROM    [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
            WHERE   ( SuspendBRproject.ReleaseName + SuspendBRproject.BVersion ) = ProductInfo.ProName
                    AND ProductInfo.ProLevel = 3
					AND ProductInfo.DeleteFlag<>2
                    AND ( ProductInfo.invalidType = ''
                          OR ProductInfo.invalidType IS NULL
                        )
						--ys2338 注释
					--AND ProductInfo.SuspendType <> 'Suspend_VersionHung'
					--ys2338 修改
					--AND SuspendBRproject.SuspendType <> 'Suspend_VersionHung'
					AND SuspendBRproject.SuspendType = 'Suspend_Normal'
			----------------------------------------------------------------------------------------------------
			UPDATE  ProductInfo   -- 如果状态不为Suspend_Normal 则可能为Suspend_Abnormal或Suspend_VersionHung都是下月失效
            SET     SuspendType = SuspendBRproject.SuspendType ,
					ActualSuspendTime = SuspendBRproject.SuspendTime ,
                    invalidType = '2' ,
					SuspendTime =  ( SELECT  CONVERT(CHAR(10), DATEADD(m,
                                                              1,
                                                              DATEADD(dd,
                                                              -DAY(SuspendBRproject.SuspendTime)
                                                              + 2, SuspendBRproject.SuspendTime)), 120)
                                              )
            FROM    [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
            WHERE   ( SuspendBRproject.ReleaseName + SuspendBRproject.BVersion ) = ProductInfo.ProName
                    AND ProductInfo.ProLevel = 3
					AND ProductInfo.DeleteFlag<>2
					--ys2338 注释
					--AND ProductInfo.SuspendType = 'Suspend_VersionHung'
					--ys2338 修改
					--AND SuspendBRproject.SuspendType = 'Suspend_VersionHung'
					AND SuspendBRproject.SuspendType <> 'Suspend_Normal'
			--ys2338 修改 end
		--标记子集编码项目失效信息，目前暂不失效
            BEGIN 
                DECLARE Update_cursor2 CURSOR LOCAL 
                FOR
                    ( SELECT    ProductInfo.ProCode ,
                                ProductInfo.SuspendType ,
                                ProductInfo.invalidType ,
                                ProductInfo.SuspendTime ,
                                ProductInfo.ActualSuspendTime
                      FROM      dbo.ProductInfo
                                INNER JOIN [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject ON ( SuspendBRproject.ReleaseName
                                                              + SuspendBRproject.BVersion ) = ProductInfo.ProName
                      WHERE     ProductInfo.ProLevel = 3
                    );
                OPEN Update_cursor2;
                FETCH NEXT FROM Update_cursor2 INTO @ProCode, @SuspendType,
                    @invalidType, @SuspendTime, @ActualSuspendTime;
                WHILE @@FETCH_STATUS = 0
                    BEGIN            
                        EXEC P_SyncUpdateInvalidProductInfo @ProCode, @SuspendType,
                            @SuspendTime, @ActualSuspendTime, @invalidType;
                        FETCH NEXT FROM Update_cursor2 INTO @ProCode,
                            @SuspendType, @invalidType, @SuspendTime,
                            @ActualSuspendTime;   
                    END;    
                CLOSE Update_cursor2; 
                DEALLOCATE Update_cursor2; 
            END;
	
	-----------------------------------------重启处理(仅限于IPLAN)-----------------------------------------

		--9编码重启同时重启子级项目（非手工失效）
            BEGIN 
                DECLARE Update_cursor3 CURSOR LOCAL 
                FOR
                    (SELECT    ProductInfo.ProCode
								 FROM ProductInfo
									WHERE   ProductInfo.ProLevel = 3
											AND NOT EXISTS ( SELECT 1
															 FROM   [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
															 WHERE  ( SuspendBRproject.ReleaseName
																	  + SuspendBRproject.BVersion ) = ProductInfo.ProName )
											AND ProductInfo.SuspendType = 'Suspend_VersionHung'
                    );
                OPEN Update_cursor3;
                FETCH NEXT FROM Update_cursor3 INTO @ProCode;
                WHILE @@FETCH_STATUS = 0
                    BEGIN            
                        EXEC P_SyncUpdateRestartProductInfo @ProCode;
                        FETCH NEXT FROM Update_cursor3 INTO @ProCode;
                    END;    
                CLOSE Update_cursor3; 
                DEALLOCATE Update_cursor3; 
            END;

			----重启9编码项目
            UPDATE  ProductInfo
            SET     SuspendType = NULL ,
                    ActualSuspendTime = NULL ,
                    invalidType = NULL ,
                    SuspendTime = NULL,
					DeleteFlag=0
            WHERE   ProductInfo.ProLevel = 3
                    AND NOT EXISTS ( SELECT 1
                                     FROM   [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
                                     WHERE  ( SuspendBRproject.ReleaseName
                                              + SuspendBRproject.BVersion ) = ProductInfo.ProName )
                    AND ProductInfo.SuspendType = 'Suspend_VersionHung';

			----重启9编码项目分摊
			UPDATE ProductShare
			SET DeleteFlag=0 ,
				ModifyTime=GETDATE()
			FROM ProductShare ps
			WHERE ProCode in(
					SELECT ProCode
					FROM ProductInfo 
					WHERE 
                    NOT EXISTS ( SELECT 1
                                     FROM   [10.63.18.239].[IPMP].[dbo].[V_GetAllSuspendBRproject] SuspendBRproject
                                     WHERE  ( SuspendBRproject.ReleaseName
                                              + SuspendBRproject.BVersion ) = ProductInfo.ProName )
					AND NOT EXISTS (select 1 from ProductShare where ProCode=ps.Procode and DeleteFlag=0) -- 重启不能存在还有deleteflag=0的分摊记录 否则肯定有数据问题
					AND NOT EXISTS (select 1 from ProductShare where ProCode=ps.Procode and DeleteFlag=1 group by ProCode having(sum(SharePercents)<>100)) --重启的数据和必须为100%才对
					AND ProLevel=3
					AND DeleteFlag=0
					)
					and SharePercents<>0

	-----------------------------------------需要记录的数据（发邮件）-----------------------------------------
		
		----未匹配到的数据(财务参考信息推送过来的9编码数据)
  --      SELECT  *
  --      FROM    dbo.ProductTemp
  --      WHERE   NOT EXISTS ( SELECT 1
  --                           FROM   dbo.ProductInfo
  --                           WHERE  ProCode = ProjectCode );

		----失效项目删除分摊比例  数据记录发邮件

  --      SELECT  ProCode ,
  --              SUM(SharePercents)
  --      FROM    dbo.ProductShare
  --      GROUP BY ProCode
  --      HAVING  SUM(SharePercents) <> 100;

			--ys2338 添加 start
			--------------------------------------------产品开发和生命周期下的产品测试及项目细分经理，更新为测试经理start---------------------------------------
				DECLARE @ProCodeTmp nvarchar(50);
				DECLARE @A_ProCodeTmp nvarchar(50);
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.Testing_Mnger from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='产品测试' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@TestManager
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='产品测试' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @TestManager<>''
												Begin

												update productinfo set Manager=@TestManager where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager=@TestManager where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
												(
												select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												)
												End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@TestManager
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;


				--------------------------------------------产品开发和生命周期下的产品测试及项目细分经理，更新为测试经理end---------------------------------------

				--------------------------------------------工程开发，更新为硬件经理start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.hardmg from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='工程开发' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@HardManager
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='工程开发' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @TestManager<>''
												Begin

												update productinfo set Manager=@HardManager where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager=@HardManager where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
												End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@TestManager
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------工程开发，更新为硬件经理end---------------------------------------
					--------------------------------------------硬件鉴定，更新为徐涛start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='硬件鉴定' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='硬件鉴定' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
												update productinfo set Manager='xutao 02355' where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												--update productinfo set Manager=@HardManager where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------硬件鉴定，更新为徐涛end---------------------------------------
				--------------------------------------------质量管理(产品开发和生命周期)，更新为李欣然start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='质量管理' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='质量管理' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
												update productinfo set Manager='lixinran 02373' where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager='lixinran 02373' where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------质量管理(产品开发和生命周期)，更新为李欣然start---------------------------------------
				--------------------------------------------驱动开发，更新为开发代表 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='驱动开发' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RDPDT
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='驱动开发' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RDPDT<>''
												Begin
												update productinfo set Manager=@RDPDT where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												--update productinfo set Manager='lixinran 02373' where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
												END
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RDPDT
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------驱动开发，更新为开发代表end---------------------------------------
				--------------------------------------------硬件开发(产品开发)，更新为硬件经理 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.hardmg from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='硬件开发' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@HardManager
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='硬件开发' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @HardManager<>''
												Begin
												update productinfo set Manager=@HardManager where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												--update productinfo set Manager='lixinran 02373' where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
												END
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@HardManager
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------硬件开发(产品开发)，更新为硬件经理end---------------------------------------
				--------------------------------------------资料工作（资料开发、翻译和视觉设计）(只生命周期项目下的才更新)，为资料经理 start---------------------------------------
				
				--DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
				--	select a.ProCode,c.Documents_Mnger from
				--	(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
				--			           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
				--					   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
				--					   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
				--				       else ProName
				--	                   end ProName
				--	from productinfo t 
				--	where t.ProLevel=3 
				--	) a
				--	inner join productinfo b on b.ParentCode=a.ProCode
				--	inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
				--	where b.ProName='资料工作（资料开发、翻译和视觉设计）' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin'
				--	-------------------------------
				--OPEN Cursor_CCUser;
				--FETCH NEXT FROM Cursor_CCUser
				--INTO @ProCodeTmp,@Documents_Mnger
				--WHILE @@FETCH_STATUS=0
				--	Begin
				--			    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
				--					select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='资料工作（资料开发、翻译和视觉设计）' And ProLevel=4  --A
				--					OPEN Cursor_ACode;
				--					FETCH NEXT FROM Cursor_ACode
				--					INTO @A_ProCodeTmp
				--					WHILE @@FETCH_STATUS=0
				--						Begin
				--							IF @Documents_Mnger<>''
				--								Begin

				--								update productinfo set Manager=@Documents_Mnger where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

				--								--update productinfo set Manager=@Documents_Mnger where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

				--								--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
				--								--(
				--								--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
				--								--)
				--								End
				--					FETCH NEXT FROM Cursor_ACode
				--					INTO @A_ProCodeTmp
				--					END
				--				CLOSE Cursor_ACode;
				--				DEALLOCATE Cursor_ACode;
				--	FETCH NEXT FROM Cursor_CCUser
				--	INTO @ProCodeTmp,@Documents_Mnger
				--	END
				--CLOSE Cursor_CCUser;
				--DEALLOCATE Cursor_CCUser;


				--------------------------------------------资料工作（资料开发、翻译和视觉设计）(只生命周期项目下的才更新)，为资料经理 end---------------------------------------

				--------------------------------------------以下为公共 的项目经理，为开发代表 start---------------------------------------
				DECLARE @RNDPDT_ID nvarchar(50);
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='公共' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RNDPDT_ID
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='公共' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RNDPDT_ID<>''
												Begin

												update productinfo set Manager=@RNDPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RNDPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;


				--------------------------------------------以下为以下为公共 的项目经理，为开发代表 end---------------------------------------

				--------------------------------------------以下为特性开发 的项目经理，为开发代表 start---------------------------------------

				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='特性开发' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 
					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RNDPDT_ID
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='特性开发' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RNDPDT_ID<>''
												Begin

												update productinfo set Manager=@RNDPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RNDPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;


				--------------------------------------------以下为以下为特性开发 的项目经理，为开发代表 end---------------------------------------

				--------------------------------------------生命周期需求项目下的产品测试同步更新项目经理 start---------------------------------------
	
				----生命周期需求开发项目 产品测试及子项更新
				--DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
				--	select a.ProCode,c.Testing_Mnger from  
				--	(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
				--			           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
				--					   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
				--					   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
				--				       else ProName
				--	                   end ProName
				--	from productinfo t 
				--	where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
				--	) a
				--	inner join productinfo b on b.ParentCode=a.ProCode
				--	inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
				--	where b.ProName='产品测试' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

				--	-------------------------------
				--OPEN Cursor_CCUser;
				--FETCH NEXT FROM Cursor_CCUser
				--INTO @ProCodeTmp,@TestManager
				--WHILE @@FETCH_STATUS=0
				--	Begin
				--			    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
				--					select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='产品测试' And ProLevel=4  --A
				--					OPEN Cursor_ACode;
				--					FETCH NEXT FROM Cursor_ACode
				--					INTO @A_ProCodeTmp
				--					WHILE @@FETCH_STATUS=0
				--						Begin
				--							IF @TestManager<>''
				--								Begin

				--								update productinfo set Manager=@TestManager where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

				--								update productinfo set Manager=@TestManager where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

				--								update productinfo set Manager=@TestManager where ProLevel=6 And ParentCode In   --update C
				--								(
				--								select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
				--								)
				--							    End
				--					FETCH NEXT FROM Cursor_ACode
				--					INTO @A_ProCodeTmp
				--					END
				--				CLOSE Cursor_ACode;
				--				DEALLOCATE Cursor_ACode;
				--	FETCH NEXT FROM Cursor_CCUser
				--	INTO @ProCodeTmp,@TestManager
				--	END
				--CLOSE Cursor_CCUser;
				--DEALLOCATE Cursor_CCUser;

				--------------------------------------------生命周期需求项目下的产品测试同步更新项目经理 end---------------------------------------

				--------------------------------------------生命周期需求项目下的资料工作（资料开发、翻译和视觉设计）同步更新项目经理 start---------------------------------------
				--生命周期需求开发项目 资料工作（资料开发、翻译和视觉设计）及子项更新
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.Documents_Mnger from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='资料工作（资料开发、翻译和视觉设计）' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@Documents_Mnger
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='资料工作（资料开发、翻译和视觉设计）' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @Documents_Mnger<>''
												Begin

												update productinfo set Manager=@Documents_Mnger where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												--update productinfo set Manager=@Documents_Mnger where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@Documents_Mnger
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下的资料工作（资料开发、翻译和视觉设计）同步更新项目经理 end---------------------------------------
				--------------------------------------------小特性开发和维护开发下的资料工作（资料开发、翻译和视觉设计）同步更新项目经理 start---------------------------------------
				--生命周期需求开发项目 资料工作（资料开发、翻译和视觉设计）及子项更新
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.Documents_Mnger from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and (ProName like '%小特性开发%' or ProName like '%维护开发%')
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='资料工作（资料开发、翻译和视觉设计）' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@Documents_Mnger
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='资料工作（资料开发、翻译和视觉设计）' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @Documents_Mnger<>''
												Begin

												update productinfo set Manager=@Documents_Mnger where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager=@Documents_Mnger where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@Documents_Mnger
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------小特性开发和维护开发下的资料工作（资料开发、翻译和视觉设计）同步更新项目经理 end---------------------------------------
				--------------------------------------------生命周期需求项目下的硬件平台同步更新为产品工程代表 start---------------------------------------
				--生命周期需求开发项目 硬件平台及子项更新
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.PPPDT_ID from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='硬件平台' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@PPPDT_ID
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='硬件平台' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @PPPDT_ID<>''
												Begin

												update productinfo set Manager=@PPPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												--update productinfo set Manager=@Documents_Mnger where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@PPPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下的硬件平台同步更新为产品工程代表 end---------------------------------------
				--------------------------------------------小特性开发和维护开发下的硬件平台同步更新为产品工程代表 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.PPPDT_ID from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and (ProName like '%小特性开发%' OR ProName like '%维护开发%')
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='硬件平台' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@PPPDT_ID
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='硬件平台' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @PPPDT_ID<>''
												Begin

												update productinfo set Manager=@PPPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												--update productinfo set Manager=@Documents_Mnger where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@PPPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------小特性开发和维护开发下的硬件平台同步更新为产品工程代表 end---------------------------------------
				--------------------------------------------生命周期需求项目下基础软件 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='基础软件' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='基础软件' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
												update productinfo set Manager='jiaoxupo 00595' where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager='xinhaining 02102' where ParentCode=@A_ProCodeTmp And ProName='OM' And ProLevel=5 --update B

												update productinfo set Manager='yubin 02217' where ParentCode=@A_ProCodeTmp And ProName='操作系统' And ProLevel=5 --update B

												update productinfo set Manager='xinhaining 02102' where ProLevel=6 And ParentCode In   --update C
												(
												select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5 And ProName='OM'
												)

												update productinfo set Manager='yubin 02217' where ProLevel=6 And ParentCode In   --update C
												(
												select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5 And ProName='操作系统'
												)

									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下基础软件 end---------------------------------------
				--------------------------------------------小特性开发和维护开发下基础软件 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and (ProName like '%小特性开发%' OR ProName like '%维护开发%')
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='基础软件' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='基础软件' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
												update productinfo set Manager='jiaoxupo 00595' where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager='xinhaining 02102' where ParentCode=@A_ProCodeTmp And ProName='OM' And ProLevel=5 --update B

												update productinfo set Manager='yubin 02217' where ParentCode=@A_ProCodeTmp And ProName='操作系统' And ProLevel=5 --update B

												update productinfo set Manager='xinhaining 02102' where ProLevel=6 And ParentCode In   --update C
												(
												select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5 And ProName='OM'
												)

												update productinfo set Manager='yubin 02217' where ProLevel=6 And ParentCode In   --update C
												(
												select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5 And ProName='操作系统'
												)

									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------小特性开发和维护开发下基础软件 end---------------------------------------
				--------------------------------------------生命周期需求项目下的Comware平台 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='Comware平台' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='Comware平台' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
												update productinfo set Manager='zhangtao 00526' where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下的Comware平台 end---------------------------------------
				--------------------------------------------生命周期需求项目下项目管理 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='项目管理' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='项目管理' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
												update productinfo set Manager='liliang 00681' where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager='wangjianjun 01540' where ParentCode=@A_ProCodeTmp And (ProName='PLCCB运作' OR ProName='生命周期管理' OR ProName='项目计划管理' OR ProName='产品运营分析') And ProLevel=5 --update B
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下项目管理 end---------------------------------------
				--------------------------------------------生命周期需求项目下 市场支持、团队管理、需求管理 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where (b.ProName='市场支持'  OR b.ProName='团队管理' OR b.ProName='需求管理') and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RNDPDT_ID 
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And (ProName='市场支持'  OR ProName='团队管理' OR ProName='需求管理') And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RNDPDT_ID<>''
												Begin

												update productinfo set Manager=@RNDPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RNDPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下 市场支持、团队管理、需求管理 end---------------------------------------
				--------------------------------------------小特性开发和维护开发下技术研究（含立项前准备等）、团队管理、需求管理 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and (ProName like '%小特性开发%' OR ProName like '%维护开发%')
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where (b.ProName='技术研究（含立项前准备等）'  OR b.ProName='团队管理' OR b.ProName='需求管理') and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RNDPDT_ID 
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And (ProName='技术研究（含立项前准备等）'  OR ProName='团队管理' OR ProName='需求管理') And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RNDPDT_ID<>''
												Begin

												update productinfo set Manager=@RNDPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RNDPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------小特性开发和维护开发下技术研究（含立项前准备等）、团队管理、需求管理 end---------------------------------------
				--------------------------------------------生命周期需求项目下 产品维护、集采测试、测试平台、技术研究 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and ProName like '%生命周期需求开发项目%'
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where (b.ProName='产品维护' OR b.ProName='集采测试' OR b.ProName='测试平台' OR b.ProName='技术研究') and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RNDPDT_ID 
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And (ProName='产品维护' OR ProName='集采测试' OR ProName='测试平台' OR ProName='技术研究') And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RNDPDT_ID<>''
												Begin

												update productinfo set Manager=@RNDPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager=@RNDPDT_ID where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RNDPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------生命周期需求项目下 产品维护、集采测试、测试平台、技术研究 end---------------------------------------
				--------------------------------------------小特性开发和维护开发下测试平台 start---------------------------------------
				DECLARE Cursor_CCUser CURSOR local static read_only forward_only FOR
					select a.ProCode,c.RNDPDT_ID from  
					(select t.ProCode, case  when CHARINDEX('B',REVERSE(ProName))=3 
							           And  ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-1,1))=1 
									   And ISNUMERIC(SUBSTRING(REVERSE(ProName),CHARINDEX('B',REVERSE(ProName))-2,1))=1
									   then SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName))))
								       else ProName
					                   end ProName
					from productinfo t 
					where t.ProLevel=3 and (ProName like '%小特性开发%' OR ProName like '%维护开发%')
					) a
					inner join productinfo b on b.ParentCode=a.ProCode
					inner join [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] c on c.Name=a.ProName
					where b.ProName='测试平台' and b.ProLevel=4 --and b.DeleteFlag=0 --And Creator='admin' 

					-------------------------------
				OPEN Cursor_CCUser;
				FETCH NEXT FROM Cursor_CCUser
				INTO @ProCodeTmp,@RNDPDT_ID 
				WHILE @@FETCH_STATUS=0
					Begin
							    DECLARE Cursor_ACode CURSOR local static read_only forward_only FOR
									select ProCode from productinfo where ParentCode=@ProCodeTmp And ProName='测试平台' And ProLevel=4  --A
									OPEN Cursor_ACode;
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									WHILE @@FETCH_STATUS=0
										Begin
											IF @RNDPDT_ID<>''
												Begin

												update productinfo set Manager=@RNDPDT_ID where ProCode=@A_ProCodeTmp And ProLevel=4 --update A

												update productinfo set Manager=@RNDPDT_ID where ParentCode=@A_ProCodeTmp And ProLevel=5 --update B

												--update productinfo set Manager=@Documents_Mnger where ProLevel=6 And ParentCode In   --update C
												--(
												--select ProCode from productinfo where ParentCode=@A_ProCodeTmp And ProLevel=5
												--)
											    End
									FETCH NEXT FROM Cursor_ACode
									INTO @A_ProCodeTmp
									END
								CLOSE Cursor_ACode;
								DEALLOCATE Cursor_ACode;
					FETCH NEXT FROM Cursor_CCUser
					INTO @ProCodeTmp,@RNDPDT_ID
					END
				CLOSE Cursor_CCUser;
				DEALLOCATE Cursor_CCUser;
				--------------------------------------------小特性开发和维护开发下测试平台 end---------------------------------------
			--ys2338 添加 end



			--------------------------------------------对现有数据的开发代表赋予项目经理权限 start---------------------------------------
			/*
 DECLARE @OldACode NVARCHAR(50);
			DECLARE @NewACode NVARCHAR(50);
			DECLARE @OldBCode NVARCHAR(50);
			DECLARE @NewBCode NVARCHAR(50);
			DECLARE @NewCCode NVARCHAR(50);
			DECLARE @CountNum INT;
			DECLARE @RDPDT NVARCHAR(50);			--开发代表
			DECLARE @RDPDTManual NVARCHAR(50);		--指定开发代表
			DECLARE @HardManager NVARCHAR(50);		--硬件经理
			DECLARE @TestManager nvarchar(50);		--测试经理
			DECLARE @Documents_Mnger nvarchar(50);	--资料经理
			DECLARE @PPPDT_ID nvarchar(50);			--产品工程代表
			DECLARE @Index int;
			DECLARE @ProName NVARCHAR(200);
			DECLARE @ProCode NVARCHAR(200);
			DECLARE @pop NVARCHAR(200);
 DECLARE Update_cursora CURSOR LOCAL 
                FOR
                    SELECT ProName,ProCode,CC FROM ProductInfo where ProLevel=3 and DeleteFlag=0
                OPEN Update_cursora;
                FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop
                WHILE @@FETCH_STATUS = 0
                    BEGIN

						SET @CountNum= (SELECT COUNT(0) FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE bigTypeName NOT IN ('解决方案项目','预研/技术开发项目')AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)
						SET @RDPDT= (SELECT top 1 RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
								WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

						IF(@CountNum >0)
						BEGIN
								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END

						END
						-------------------------------------------------------------------------------------------------------------------
						SET @CountNum= (SELECT COUNT(0) FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE bigTypeName NOT IN ('解决方案项目','预研/技术开发项目')
								AND smallTypeName<>'纯软件项目' AND smallTypeName<>'综合产品软件项目' And smallTypeName<>'Devops项目'
								AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)
						
						SET @RDPDT =	(select top 1 RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

						IF(@CountNum >0)
						BEGIN
								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
						END
						----------------------------------------------------------------------------------------------------------------
						SET @CountNum= (SELECT COUNT(0) FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
								WHERE bigTypeName IN ('IPD产品开发项目')
								AND (smallTypeName='纯软件项目' OR smallTypeName='综合产品软件项目' OR smallTypeName='Devops项目')
								AND SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseName)

						SET @RDPDT =	(select top 1 RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

						IF(@CountNum >0)
						BEGIN
								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
						END
						------------------------------------------------------------------------------------------------------------
						SELECT @Index=CHARINDEX('生命周期需求开发项目',@ProName,0)
						   IF(@Index>0)
						   BEGIN
							   SELECT top 1 @TestManager=Testing_Mnger,
									  @PPPDT_ID=PPPDT_ID,
									  @Documents_Mnger=PDT_TD_ID,
									  @RDPDT=RNDPDT_ID 
									  FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] where ReleaseCode_Name = @ProName

								IF @RDPDT<>'' --开发代表不为空，赋给开发代表项目权限
								BEGIN
									INSERT INTO GiveRight_Pro SELECT NEWID(),NUll,@ProCode,@RDPDT,0,GETDATE(),'admin',NULL,NULL
									WHERE not exists(select 1 from GiveRight_Pro where UserId=@RDPDT and ProCodeId=@ProCode and DeleteFlag=0)
								END
							END

						FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
					END;
                CLOSE Update_cursora;
                DEALLOCATE Update_cursora;
				*/
			--------------------------------------------对现有数据的开发代表赋予项目经理权限 end---------------------------------------

			/* --对现有项目缺失下挂的更新脚本
			-----------------------------------------更新IPD产品开发项目缺失下挂 start-------------------------------------------------------------------
DECLARE @ProName NVARCHAR(50);
DECLARE @ProCode NVARCHAR(50);
DECLARE @pop NVARCHAR(50);
DECLARE @NewACode NVARCHAR(50);
DECLARE @NewBCode NVARCHAR(50);
DECLARE @NewCCode NVARCHAR(50);
DECLARE @CountNum INT;
DECLARE @RDPDT NVARCHAR(50);			--开发代表
DECLARE @RDPDTManual nvarchar(50);		--开发代表手工配置
DECLARE @PPPDT_ID NVARCHAR(50);			--产品工程代表
DECLARE @PDT_TD_ID NVARCHAR(50);		--资料经理
DECLARE @RNDPDT_ID NVARCHAR(50);		--开发代表(暂不用)
DECLARE @TestManager nvarchar(50);		--测试经理
DECLARE @HardManager NVARCHAR(50);		--硬件经理
DECLARE @DeleteFlag INT;  --删除标识0未删除 
	SELECT DISTINCT * INTO #product_temp FROM (
                            SELECT ProName,ProCode,CC,DeleteFlag  FROM dbo.ProductInfo  WHERE ProLevel=3 --AND DeleteFlag =0-- in(1,2)
                                               AND EXISTS(
                                                        SELECT 0 FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
                                                                 WHERE  bigTypeName NOT IN ('解决方案项目','预研/技术开发项目','公共项目除') 
                                                                 AND SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName)))) = ReleaseName
                                                        )
                            UNION ALL
                            SELECT ProName,ProCode,CC,DeleteFlag  FROM dbo.ProductInfo WHERE ProLevel=3 --AND DeleteFlag =0-- in(1,2)
                                               AND EXISTS(
                                                        SELECT 0 FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
                                                                 WHERE bigTypeName NOT IN ('解决方案项目','预研/技术开发项目','公共项目除')
                                                                 AND ProName = ReleaseName
                                                        )
                                                        ) amin

BEGIN  
         DECLARE Update_cursora CURSOR LOCAL 
         FOR
                   SELECT ProName,ProCode,CC,DeleteFlag FROM #product_temp
         OPEN Update_cursora;
         FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag
         WHILE @@FETCH_STATUS = 0
                   BEGIN
                            IF (CHARINDEX('B',REVERSE(@ProName))=3 And ISNUMERIC(SUBSTRING(REVERSE(@ProName),CHARINDEX('B',REVERSE(@ProName))-1,1))=1 And ISNUMERIC(SUBSTRING(REVERSE(@ProName),CHARINDEX('B',REVERSE(@ProName))-2,1))=1)
                            BEGIN
                                    SET @RDPDT= (select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)
									SET	@TestManager=(select Testing_Mnger FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
														WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

                            END
                            ELSE
							BEGIN
                                    SET @RDPDT= (select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
									SET @TestManager= (select Testing_Mnger FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
                            END 

							-----产品测试 start-----
                            --A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'产品测试',@NewACode,@ProCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试计划与策略',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试计划与策略制定及修改',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试分析设计',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试需求与规格分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试SOW制定',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试测试方案设计制定' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试SOW测试方案设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试测试方案设计制定' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试点设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试用例设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'自动化测试编码',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'自动化测试移植与优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试执行',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试执行准备',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'手工测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'自动化测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'开发定位配合',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'CMM问题单回归',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'CMM问题单复现',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='重大问题同步' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'重大问题同步',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='重大问题同步' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'资料测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='网上问题处理' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'网上问题处理',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='网上问题处理' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='实验局/技术支持' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'实验局/技术支持',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='实验局/技术支持' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='对外测试' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'对外测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='对外测试' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'拷机测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试评估',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'缺陷分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试报告/总结',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='鉴定测试' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'鉴定测试',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='鉴定测试' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试准备与分析' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试准备与分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试准备与分析' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试执行' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试执行' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试重现定位' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试重现定位',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试重现定位' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试总结与报告' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试总结与报告',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试总结与报告' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='公共活动' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'公共活动',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='公共活动' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='项目管理以及流程处理' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'项目管理以及流程处理',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='项目管理以及流程处理' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试流程引导/审计/优化' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试流程引导/审计/优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试流程引导/审计/优化' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='技术积累与贡献' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'技术积累与贡献',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='技术积累与贡献' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='指导和培训类工作' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'指导和培训类工作',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='指导和培训类工作' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='公共测试环境维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'公共测试环境维护',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='公共测试环境维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试工具开发' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试工具开发',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试工具开发' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='请假' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'请假',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='请假' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='其他测试公共活动' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'其他测试公共活动',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='其他测试公共活动' AND ProLevel=6  )
                            END
							-----产品测试 end-----
							-----质量管理 Start-----
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02373' --李欣然
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'质量管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='TR评审' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'TR评审',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='TR评审' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'软件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'硬件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'质量&过程改进',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5  )
                            END 
							-----质量管理 End-----
							-----公共 Start-----
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='公共' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'公共',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='公共' AND ProLevel=4  )
                            END 
							-----公共 End-----

                            FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag;
                   END;
        CLOSE Update_cursora;
        DEALLOCATE Update_cursora;
END
drop table #product_temp
-----------------------------------------------------------------------------------------------------------------------------------------------------


SELECT DISTINCT * INTO #product_temp1 FROM (
                            SELECT ProName,ProCode,CC,DeleteFlag  FROM dbo.ProductInfo  WHERE ProLevel=3 --AND DeleteFlag =0-- in(1,2)
                                               AND EXISTS(
                                                        SELECT 0 FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
                                                                 WHERE  bigTypeName NOT IN ('解决方案项目','预研/技术开发项目','公共项目除') AND smallTypeName<>'纯软件项目' AND smallTypeName<>'综合产品软件项目' And smallTypeName<>'Devops项目'
                                                                 AND SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName)))) = ReleaseName
                                                        )
                            UNION ALL
                            SELECT ProName,ProCode,CC,DeleteFlag  FROM dbo.ProductInfo WHERE ProLevel=3 --AND DeleteFlag =0-- in(1,2)
                                               AND EXISTS(
                                                        SELECT 0 FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
                                                                 WHERE bigTypeName NOT IN ('解决方案项目','预研/技术开发项目','公共项目除') AND smallTypeName<>'纯软件项目' AND smallTypeName<>'综合产品软件项目' And smallTypeName<>'Devops项目'
                                                                 AND ProName = ReleaseName
                                                        )
                                                        ) amin;

BEGIN  
         DECLARE Update_cursora CURSOR LOCAL 
         FOR
                   SELECT ProName,ProCode,CC,DeleteFlag FROM #product_temp1
         OPEN Update_cursora;
         FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag
         WHILE @@FETCH_STATUS = 0
                   BEGIN
                            IF (CHARINDEX('B',REVERSE(@ProName))=3 And ISNUMERIC(SUBSTRING(REVERSE(@ProName),CHARINDEX('B',REVERSE(@ProName))-1,1))=1 And ISNUMERIC(SUBSTRING(REVERSE(@ProName),CHARINDEX('B',REVERSE(@ProName))-2,1))=1)
                            BEGIN
                                    SET @RDPDT= (select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)
									SET	@HardManager=(select hardmg FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
														WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)
									SET @PPPDT_ID=(select PPPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
														WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

                            END
                            ELSE
							BEGIN
                                    SET @RDPDT= (select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
									SET @HardManager= (select hardmg FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
									SET @PPPDT_ID= (select PPPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
                            END 

							-----工程开发 start-----
                            --A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='工程开发' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'工程开发',@NewACode,@ProCode,@HardManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='工程开发' AND ProLevel=4  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='结构开发' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'结构开发',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='结构开发' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='电源开发' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'电源开发',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='电源开发' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='整机试装' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'整机试装',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='整机试装' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='装备开发' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'装备开发',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='装备开发' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='准入认证' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'准入认证',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='准入认证' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='热设计' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'热设计',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='热设计' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品数据' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'产品数据',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品数据' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='单板工艺' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'单板工艺',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='单板工艺' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='互连单板开发' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'互连单板开发',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='互连单板开发' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品可靠性' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'产品可靠性',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品可靠性' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='EMC' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'EMC',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='EMC' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='专业试验' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'专业试验',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='专业试验' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='器件分析' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'器件分析',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='器件分析' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='工程代表专项' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'工程代表专项',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='工程代表专项' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='安规（含节能环保）' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'安规（含节能环保）',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='安规（含节能环保）' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='互连仿真测试开发' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'互连仿真测试开发',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='互连仿真测试开发' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='逻辑开发' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'逻辑开发',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='逻辑开发' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件公共' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'硬件公共',@NewBCode,@NewACode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件公共' AND ProLevel=5  )
                            END 
							-----工程开发 end-----
							-----硬件鉴定 Start-----
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02355' --徐涛
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件鉴定' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'硬件鉴定',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件鉴定' AND ProLevel=4  )
                            END 
							
							-----硬件鉴定 End-----
							-----驱动开发 Start-----
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='驱动开发' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'驱动开发',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='驱动开发' AND ProLevel=4  )
                            END 
							-----驱动开发 End-----
							-----硬件开发 Start-----
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件开发' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'硬件开发',@NewACode,@ProCode,@HardManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件开发' AND ProLevel=4  )
                            END 
							-----硬件开发 End-----


                            FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag;
                   END;
        CLOSE Update_cursora;
        DEALLOCATE Update_cursora;
END

drop table #product_temp1
-----------------------------------------------------------------------------------------------------------------------------------------------------


SELECT DISTINCT * INTO #product_temp2 FROM (
                            SELECT ProName,ProCode,CC,DeleteFlag  FROM dbo.ProductInfo  WHERE ProLevel=3 --AND DeleteFlag =0-- in(1,2)
                                               AND EXISTS(
                                                        SELECT 0 FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
                                                                 WHERE  bigTypeName IN ('IPD产品开发项目') AND smallTypeName='纯软件项目' AND smallTypeName='综合产品软件项目' And smallTypeName='Devops项目'
                                                                 AND SUBSTRING(ProName,1,(len(ProName)- CHARINDEX('B',REVERSE(ProName)))) = ReleaseName
                                                        )
                            UNION ALL
                            SELECT ProName,ProCode,CC,DeleteFlag  FROM dbo.ProductInfo WHERE ProLevel=3 --AND DeleteFlag =0-- in(1,2)
                                               AND EXISTS(
                                                        SELECT 0 FROM [10.63.18.239].[IPMP].[dbo].[V_GetAllRprojectProjectType] 
                                                                 WHERE bigTypeName NOT IN ('IPD产品开发项目') AND smallTypeName='纯软件项目' AND smallTypeName='综合产品软件项目' And smallTypeName='Devops项目'
                                                                 AND ProName = ReleaseName
                                                        )
                                                        ) amin;

BEGIN  
         DECLARE Update_cursora CURSOR LOCAL 
         FOR
                   SELECT ProName,ProCode,CC,@DeleteFlag FROM #product_temp2
         OPEN Update_cursora;
         FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag
         WHILE @@FETCH_STATUS = 0
                   BEGIN
                            IF (CHARINDEX('B',REVERSE(@ProName))=3 And ISNUMERIC(SUBSTRING(REVERSE(@ProName),CHARINDEX('B',REVERSE(@ProName))-1,1))=1 And ISNUMERIC(SUBSTRING(REVERSE(@ProName),CHARINDEX('B',REVERSE(@ProName))-2,1))=1)
                            BEGIN
                                    SET @RDPDT= (select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)
									SET	@HardManager=(select hardmg FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
														WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)
									SET @PPPDT_ID=(select PPPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
														WHERE SUBSTRING(@ProName,1,(len(@ProName)- CHARINDEX('B',REVERSE(@ProName)))) = ReleaseCode_Name)

                            END
                            ELSE
							BEGIN
                                    SET @RDPDT= (select RNDPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
									SET @HardManager= (select hardmg FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
									SET @PPPDT_ID= (select PPPDT_ID FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] 
                                                        WHERE @ProName = ReleaseCode_Name)
                            END 

							
							-----特性开发 Start-----
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='特性开发' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'特性开发',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='特性开发' AND ProLevel=4  )
                            END 
							-----特性开发 End-----


                            FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag;
                   END;
        CLOSE Update_cursora;
        DEALLOCATE Update_cursora;
END

drop table #product_temp2
			-----------------------------------------更新IPD产品开发项目缺失下挂 end-------------------------------------------------------------------
			*/

			/* --对现有项目缺失下挂的更新脚本
			-----------------------------------------更新生命周期需求开发项目缺失下挂 start-------------------------------------------------------------------
			DECLARE @OldACode NVARCHAR(50);
			DECLARE @NewACode NVARCHAR(50);
			DECLARE @OldBCode NVARCHAR(50);
			DECLARE @NewBCode NVARCHAR(50);
			DECLARE @NewCCode NVARCHAR(50);
			DECLARE @CountNum INT;
			DECLARE @RDPDT NVARCHAR(50);			--开发代表
			DECLARE @RDPDTManual NVARCHAR(50);		--指定开发代表
			DECLARE @HardManager NVARCHAR(50);		--硬件经理
			DECLARE @TestManager nvarchar(50);		--测试经理
			DECLARE @Documents_Mnger nvarchar(50);	--资料经理
			DECLARE @PPPDT_ID nvarchar(50);			--产品工程代表
			DECLARE @Index int;
			DECLARE @ProCode VARCHAR(50); 
			DECLARE @pop VARCHAR(50);
			DECLARE @ProName VARCHAR(100);

			BEGIN  
				DECLARE Update_cursora CURSOR LOCAL 
				FOR
                   SELECT ProName,ProCode,CC,DeleteFlag FROM dbo.ProductInfo WHERE ProLevel=3 AND ProName LIKE('%生命周期需求开发项目%') --And DeleteFlag=0-- AND DeleteFlag in(1,2) --注意没有“产品两字”
				OPEN Update_cursora;
				FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop,@DeleteFlag
				WHILE @@FETCH_STATUS = 0
                   BEGIN
						   select @TestManager=Testing_Mnger,
								  @PPPDT_ID=PPPDT_ID,
								  @Documents_Mnger=PDT_TD_ID,
								  @RDPDT=RNDPDT_ID 
								  FROM [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL] where ReleaseCode_Name = @ProName

							-----产品测试 start -----
							--A
                            SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'产品测试',@NewACode,@ProCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品测试' AND ProLevel=4  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试计划与策略',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试计划与策略' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试计划与策略制定及修改',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试计划与策略制定及修改' AND ProLevel=6  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试分析设计',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析设计' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试需求与规格分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试需求与规格分析' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试SOW制定',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试SOW制定' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试测试方案设计制定' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试SOW测试方案设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试测试方案设计制定' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试点设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试点设计' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试用例设计',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试用例设计' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'自动化测试编码',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试编码' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'自动化测试移植与优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试移植与优化' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试执行',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试执行' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试执行准备',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试执行准备' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'手工测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='手工测试执行' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'自动化测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='自动化测试执行' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'开发定位配合',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='开发定位配合' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'CMM问题单回归',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单回归' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'CMM问题单复现',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='CMM问题单复现' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='重大问题同步' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'重大问题同步',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='重大问题同步' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'资料测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='资料测试' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='网上问题处理' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'网上问题处理',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='网上问题处理' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='实验局/技术支持' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'实验局/技术支持',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='实验局/技术支持' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='对外测试' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'对外测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='对外测试' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'拷机测试',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='拷机测试' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试评估',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试评估' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'缺陷分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='缺陷分析' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试报告/总结',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试报告/总结' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='鉴定测试' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'鉴定测试',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='鉴定测试' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试准备与分析' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试准备与分析',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试准备与分析' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试执行' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试执行',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试执行' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试重现定位' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试重现定位',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试重现定位' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试总结与报告' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'鉴定测试总结与报告',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='鉴定测试总结与报告' AND ProLevel=6  )
                            END
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='公共活动' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'公共活动',@NewBCode,@NewACode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='公共活动' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='项目管理以及流程处理' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'项目管理以及流程处理',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='项目管理以及流程处理' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试流程引导/审计/优化' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试流程引导/审计/优化',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试流程引导/审计/优化' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='技术积累与贡献' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'技术积累与贡献',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='技术积累与贡献' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='指导和培训类工作' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'指导和培训类工作',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='指导和培训类工作' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='公共测试环境维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'公共测试环境维护',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='公共测试环境维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试工具开发' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'测试工具开发',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='测试工具开发' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='请假' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'请假',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='请假' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='其他测试公共活动' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'其他测试公共活动',@NewCCode,@NewBCode,@TestManager,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='其他测试公共活动' AND ProLevel=6  )
                            END
							-----产品测试 end -----
							-------------------------------------------------------------------------------------
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00595' --焦旭坡
                            -----基础软件 start -----
							--A
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'基础软件',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='基础软件' AND ProLevel=4  )
                            END 
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02102' --辛海宁
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'OM',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='OM' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'BootWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='BootWare开发维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'dWare开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='dWare开发维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'License开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='License开发维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'可信计算开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='可信计算开发维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'MUI',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='MUI' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'代码扫描＆安全漏洞',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='代码扫描＆安全漏洞' AND ProLevel=6  )
                            END

							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02217' --余斌
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'操作系统',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='操作系统' AND ProLevel=5  )
                            END 
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'嵌入式OS开发维护（V5）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V5）' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'嵌入式OS开发维护（V7）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V7）' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'嵌入式OS开发维护（V9）',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='嵌入式OS开发维护（V9）' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'服务器OS开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='服务器OS开发维护' AND ProLevel=6  )
                            END
							--C
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewCCode = [dbo].[F_DistributionProductCode](6,@NewBCode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),6,'S1020V开发维护',@NewCCode,@NewBCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewCCode,@NewBCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewCCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewBCode AND ProName='S1020V开发维护' AND ProLevel=6  )
                            END

							-----基础软件 end -----
							-----------------------------------------------------------------------------------------------------------------
							-----Comware平台 start -----
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00526' --张弢
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='Comware平台' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'Comware平台',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='Comware平台' AND ProLevel=4  )
                            END 

							-----Comware平台 end -----
							-----------------------------------------------------------------------------------------------------------------
							-----硬件平台 start-----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'硬件平台',@NewACode,@ProCode,@PPPDT_ID,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='硬件平台' AND ProLevel=4 )
                            END 
							-----硬件平台 end-----
							-----------------------------------------------------------------------------------------------------------------
							-----资料工作（资料开发、翻译和视觉设计） start -----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'资料工作（资料开发、翻译和视觉设计）',@NewACode,@ProCode,@Documents_Mnger,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='资料工作（资料开发、翻译和视觉设计）' AND ProLevel=4  )
                            END 

							-----资料工作（资料开发、翻译和视觉设计） end -----
							-----项目管理 start -----
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='00681' --李亮
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'项目管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='项目管理' AND ProLevel=4  )
                            END 
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='01540' --王建军01540
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'PLCCB运作',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='PLCCB运作' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'生命周期管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='生命周期管理' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'项目计划管理',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='项目计划管理' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'产品运营分析',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='产品运营分析' AND ProLevel=5  )
                            END 
							-----项目管理 end -----
							--------------------------------------------------------------------------------------------------------------
							-----质量管理 start -----
							SELECT @RDPDTManual= ChnNamePY+' '+Code FROM ManagerTemp where Code='02373' --李欣然
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4 AND DeleteFlag=0)
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'质量管理',@NewACode,@ProCode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='质量管理' AND ProLevel=4  AND DeleteFlag=0)
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'软件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件项目引导' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'硬件项目引导',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件项目引导' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'质量回溯',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量回溯' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'数据分析与度量',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='数据分析与度量' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'质量&过程改进',@NewBCode,@NewACode,@RDPDTManual,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='质量&过程改进' AND ProLevel=5  )
                            END 
							-----质量管理 end -----
							------------------------------------------------------------------------------------------------------------------

							-----产品维护 start-----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品维护' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'产品维护',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='产品维护' AND ProLevel=4 )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件维护和测试' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'硬件维护和测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='硬件维护和测试' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件维护和测试' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'软件维护和测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='软件维护和测试' AND ProLevel=5  )
                            END 
							-----产品维护 end-----
							------------------------------------------------------------------------------------------------------------------
							-----集采测试 start-----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='集采测试' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'集采测试',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='集采测试' AND ProLevel=4  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='运营商集采测试' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'运营商集采测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='运营商集采测试' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='非运营商对外测试' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'非运营商对外测试',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='非运营商对外测试' AND ProLevel=5  )
                            END 
							-----集采测试 end-----
							------------------------------------------------------------------------------------------------------------------
							-----市场支持 start -----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='市场支持' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'市场支持',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='市场支持' AND ProLevel=4  )
                            END 
							-----市场支持 end -----
							------------------------------------------------------------------------------------------------------------------
							-----测试平台 start -----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'测试平台',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='测试平台' AND ProLevel=4 )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'自动化测试平台建设',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='自动化测试平台建设' AND ProLevel=5  )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'测试分析，设计和评估',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='测试分析，设计和评估' AND ProLevel=5  )
                            END 
							-----测试平台 end -----
							------------------------------------------------------------------------------------------------------------------
							-----技术研究 start-----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                               SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                               INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                               VALUES(NEWID(),4,'技术研究',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                     SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='技术研究' AND ProLevel=4 )
                            END 
							--B
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='早期技术研究' AND ProLevel=5 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewBCode = [dbo].[F_DistributionProductCode](5,@NewACode);
									INSERT INTO dbo.ProductInfo ( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),5,'早期技术研究',@NewBCode,@NewACode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewBCode,@NewACode)
                            END
                            ELSE
							BEGIN
                                    SET @NewBCode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@NewACode AND ProName='早期技术研究' AND ProLevel=5  )
                            END 
							-----技术研究 end-----
							------------------------------------------------------------------------------------------------------------------
							-----团队管理 start -----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'团队管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='团队管理' AND ProLevel=4  )
                            END 
							-----团队管理 end -----
							------------------------------------------------------------------------------------------------------------------
							-----需求管理 start -----
							SET @CountNum=(SELECT COUNT(0) FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4 )
                            IF(@CountNum <1)
                            BEGIN 
                                    SET @NewACode = [dbo].[F_DistributionProductCode](4,@ProCode);
                                    INSERT INTO dbo.ProductInfo( ProID ,ProLevel ,ProName ,ProCode ,ParentCode ,Manager ,CC ,CreateTime ,Creator ,DeleteFlag ,Id ,ParentId)
                                    VALUES(NEWID(),4,'需求管理',@NewACode,@ProCode,@RDPDT,@pop,GETDATE(),'admin',@DeleteFlag,@NewACode,@ProCode)
                            END
                            ELSE
							BEGIN
                                    SET @NewACode=(SELECT TOP 1 ProCode FROM dbo.ProductInfo WHERE ParentCode=@ProCode AND ProName='需求管理' AND ProLevel=4  )
                            END 
							-----需求管理 end -----
                            FETCH NEXT FROM Update_cursora INTO @ProName,@ProCode,@pop;
                   END;
					CLOSE Update_cursora;
					DEALLOCATE Update_cursora;
			END
			------------------------------------------------------------------------------------------------------------
			-----------------------------------------更新生命周期需求开发项目缺失下挂 end-------------------------------------------------------------------
			*/

            DROP TABLE #ProductLine; 
            DROP TABLE #ProductTemp;
            DROP TABLE #NewProductInfo;
            COMMIT TRANSACTION; 

        END TRY 
        BEGIN CATCH 
            ROLLBACK TRANSACTION; 
            DECLARE @ErrorMessage NVARCHAR(4000);
            DECLARE @ErrorSeverity INT;
            DECLARE @ErrorState INT;

            SELECT  @ErrorMessage = ERROR_MESSAGE() ,
                    @ErrorSeverity = ERROR_SEVERITY() ,
                    @ErrorState = ERROR_STATE();

            RAISERROR (@ErrorMessage,  -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState     -- State.
				   );
        END CATCH; 
    END;



GO


