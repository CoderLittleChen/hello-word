USE [iSEDB]
GO
/****** Object:  StoredProcedure [dbo].[Sync_DataFromMDS]    Script Date: 2020-11-27 9:38:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================  
-- Author:  liufeng 
-- Create date: 2016-12-28
-- Description: 同步IPlan决议  
-- =============================================  
ALTER PROCEDURE [dbo].[Sync_DataFromMDS]  
  
AS  
BEGIN  

 SET NOCOUNT ON;  
  Begin Try 
	Begin Transaction
	DECLARE @GroupCount int;
    DECLARE @GroupEmployeeRelationCount int;
    DECLARE @PI_PL_PT_PV_PRCount int;
    DECLARE @Self_ProjectCount int;
	DECLARE @PDTCount int;

    --修改人员数据[Sync_Employee]
    update [dbo].[Sync_Employee] set 
       [DeptCode]=t.[DeptCode_Code]
      ,[DeptCode_Name]=t.[DeptCode_Name]
      ,[ManpowerType]=t.[ManpowerType]
      ,[RegionAccount]=t.[RegionAccount]
      ,[NotesAccount]=t.[NotesAccount]
      ,[Email]=t.[Email]
      ,[EmployeeRemark]=t.[EmployeeRemark]
      ,[EnterDateTime]=t.[EnterDateTime]
      ,[EnterUserName]=t.[EnterUserName]
      ,[EnterVersionNumber]=t.[EnterVersionNumber]
      ,[LastChgDateTime]=t.[LastChgDateTime]
      ,[LastChgUserName]=t.[LastChgUserName]
      ,[LastChgVersionNumber]=t.[LastChgVersionNumber]
      ,[ValidationStatus]=t.[ValidationStatus]
      ,EngName=t.[EngName]
      ,NotesEmail = t.[NotesEmail]
      ,ChnNamePY = t.[ChnNamePY]
      from [RDMDSDB].[RD_MDS].[mdm].[V_Employee] t
       where  [dbo].[Sync_Employee].code = t.NotesAccount

    
    --失效人员数据[Sync_Employee]
    update [dbo].[Sync_Employee] set 
       ChnNamePY = null, 
       EngName = null, 
       NotesAccount = null,
       RegionAccount = null
      from [RDMDSDB].[RD_MDS].[mdm].[V_Employee] t
      where not exists (select * from [RDMDSDB].[RD_MDS].[mdm].[V_Employee] t1 where t1.NotesAccount = [dbo].[Sync_Employee].code)


    
    --新增人员数据[Sync_Employee]
    insert into [dbo].[Sync_Employee]([VersionName],[VersionNumber],[VersionFlag],[Name],[Code],[DeptCode]
      ,[DeptCode_Name],[ManpowerType],[ChnNamePY],[EngName],[RegionAccount],[NotesAccount],[NotesEmail]
      ,[Email],[EmployeeRemark],[EnterDateTime],[EnterUserName],[EnterVersionNumber],[LastChgDateTime]
      ,[LastChgUserName],[LastChgVersionNumber],[ValidationStatus])
      select a.[VersionName],a.[VersionNumber],a.[VersionFlag],a.[Name],a.[NotesAccount],a.[DeptCode_Code]
            ,a.[DeptCode_Name],a.[ManpowerType],a.[ChnNamePY],a.[EngName],a.[RegionAccount],a.[NotesAccount]
            ,a.[NotesEmail],a.[Email],a.[EmployeeRemark],a.[EnterDateTime],a.[EnterUserName],a.[EnterVersionNumber]
            ,a.[LastChgDateTime],a.[LastChgUserName],a.[LastChgVersionNumber],a.[ValidationStatus]
        from [RDMDSDB].[RD_MDS].[mdm].[V_Employee] a
        where not exists (select * from [dbo].[Sync_Employee] where [dbo].[Sync_Employee].code = a.NotesAccount)

    --同步群组信息[Sync_Group]
    select @GroupCount = count(*) from [RDMDSDB].[RD_MDS].[mdm].[V_Group]
    if(@GroupCount!=0)
    begin
        TRUNCATE TABLE [dbo].[Sync_Group]

        insert into [dbo].[Sync_Group]([VersionName],[VersionNumber],[VersionFlag],[Name],[Code],[GroupRemark]
        ,[CreateUser],[CreateDate],[ModifyUser],[ModifyDate],[GroupDel],[EnterDateTime],[EnterUserName],[EnterVersionNumber]
            ,[LastChgDateTime],[LastChgUserName],[LastChgVersionNumber],[ValidationStatus])
        select [VersionName],[VersionNumber],[VersionFlag],[Name],[Code],[GroupRemark],[CreateUser],[CreateDate]
            ,[ModifyUser] ,[ModifyDate],[GroupDel],[EnterDateTime],[EnterUserName],[EnterVersionNumber]
            ,[LastChgDateTime],[LastChgUserName] ,[LastChgVersionNumber],[ValidationStatus]
            from [RDMDSDB].[RD_MDS].[mdm].[V_Group]
    end

    --同步群组人员关系信息[Sync_GroupEmployeeRelation]
    select @GroupEmployeeRelationCount=count(*) from  [RDMDSDB].[RD_MDS].[mdm].[V_GroupEmployeeRelation]
    if(@GroupEmployeeRelationCount!=0)
    begin
        TRUNCATE TABLE [dbo].[Sync_GroupEmployeeRelation]

        insert into [dbo].[Sync_GroupEmployeeRelation]([VersionName],[VersionNumber],[VersionFlag],[Name],[Code]
            ,[GroupCode],[RegionAccount],[EnterDateTime],[EnterUserName],[EnterVersionNumber],[LastChgDateTime]
            ,[LastChgUserName],[LastChgVersionNumber],[ValidationStatus])
        select [VersionName],[VersionNumber],[VersionFlag],[Name],[Code],[GroupCode],[RegionAccount],[EnterDateTime]
        ,[EnterUserName],[EnterVersionNumber],[LastChgDateTime],[LastChgUserName],[LastChgVersionNumber],[ValidationStatus]
            from [RDMDSDB].[RD_MDS].[mdm].[V_GroupEmployeeRelation]
    end

    --同步产品线、PDT、R版本 [dbo].[Sync_Self_PI_PL_PT_PV_PR]
    select @PI_PL_PT_PV_PRCount=count(*) from  [RDMDSDB].[RD_MDS].[mdm].[V_Self_PI_PL_PT_PV_PR] 
    if(@PI_PL_PT_PV_PRCount !=0)
    begin
        TRUNCATE TABLE [dbo].[Sync_Self_PI_PL_PT_PV_PR]

        insert into [dbo].[Sync_Self_PI_PL_PT_PV_PR]([VersionName],[VersionNumber],[VersionFlag],[ROOT],[IPMTCode_Code]
          ,[IPMTCode_Name],[ProductLineCode_Code],[ProductLineCode_Name],[PDTCode_Code],[PDTCode_Name],[VersionCode_Code]
              ,[VersionCode_Name],[Release_Code],[Release_Name])
        select [VersionName],[VersionNumber],[VersionFlag],[ROOT],[IPMT_Code],[IPMT_Name],[ProductLine_Code],[ProductLine_Name]
              ,[PDT_Code],[PDT_Name],[Version_Code],[Version_Name],[Release_Code],[Release_Name] 
              from [RDMDSDB].[RD_MDS].[mdm].[V_Self_PI_PL_PT_PV_PR] 
    end

    --R版本人员配置信息同步[dbo].[Sync_Self_Project]
    select @Self_ProjectCount=count(*) from  [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL]
    if(@Self_ProjectCount!=0)
    begin
        TRUNCATE TABLE [dbo].[Sync_Self_Project]

        insert into [dbo].[Sync_Self_Project]([VersionName],[VersionNumber],[VersionFlag],[Name],[Code],[engProject],[ReleaseCode]
            ,[ReleaseCode_Name],[ProjectType],[ProjectStatus],[ProjectJX],[ProjectJFJ],[ProjectDH],[ProjectRemark],[POP_ID]
                ,[Product_Mnger],[RNDPDT_ID],[Sales_Mnger],[FINPDT_ID],[Purchase_Mnger],[Manufacture_Mnger],[PPPDT_ID]
              ,[TechSupport_Mnger],[Quality_Mnger],[System_Mnger],[softmg],[hardmg],[Documents_Mnger],[Equipment_Mnger]
            ,[SQA],[HQA],[TQA],[fldPDE],[CMO_ID],[Testing_Mnger],[HardwareTM],[MarketMnger],[SoftPlatformJKR],[OMC_Mnger]
            ,[OMC_SE],[FF_ID],[PilotProduction_Mnger],[CreateUser],[CreateDate],[ModifyUser],[ModifyDate],[Del],[EnterDateTime]
            ,[EnterUserName],[EnterVersionNumber],[LastChgDateTime],[LastChgUserName],[LastChgVersionNumber],[ValidationStatus]
            ,[PDT_POP_ID],[PDT_LPDT_ID],[PDT_RNDPDT_ID],[PDT_MKTPDT_ID],[PDT_FINPDT_ID],[PDT_PROPDT_ID],[PDT_PPPDT_ID]
            ,[PDT_MFGPDT_ID],[PDT_TSPDT_ID],[PDT_PQA_ID],[PDT_TE_ID],[PDT_TD_ID],[PDT_SE_ID],[PDT_CMO_ID],[PDT_NMJKR_ID])
        select [VersionName],[VersionNumber],[VersionFlag],[Name],[Code],[engProject],[ReleaseCode],[ReleaseCode_Name]
           ,[ProjectType],[ProjectStatus],[ProjectJX],[ProjectJFJ],[ProjectDH],[ProjectRemark],[POP_ID],[Product_Mnger]
           ,[RNDPDT_ID],[Sales_Mnger],[FINPDT_ID],[Purchase_Mnger],[Manufacture_Mnger],[PPPDT_ID],[TechSupport_Mnger]
           ,[Quality_Mnger],[System_Mnger],[softmg],[hardmg],[Documents_Mnger],[Equipment_Mnger],[SQA],[HQA],[TQA],[fldPDE]
               ,[CMO_ID],[Testing_Mnger],[HardwareTM],[MarketMnger],[SoftPlatformJKR],[OMC_Mnger],[OMC_SE],[FF_ID]
           ,[PilotProduction_Mnger],[CreateUser],[CreateDate],[ModifyUser],[ModifyDate],[Del],[EnterDateTime],[EnterUserName]
               ,[EnterVersionNumber],[LastChgDateTime],[LastChgUserName],[LastChgVersionNumber],[ValidationStatus]
           ,[PDT_POP_ID],[PDT_LPDT_ID],[PDT_RNDPDT_ID],[PDT_MKTPDT_ID],[PDT_FINPDT_ID],[PDT_PROPDT_ID],[PDT_PPPDT_ID]
           ,[PDT_MFGPDT_ID],[PDT_TSPDT_ID],[PDT_PQA_ID],[PDT_TE_ID],[PDT_TD_ID],[PDT_SE_ID],[PDT_CMO_ID],[PDT_NMJKR_ID] 
               from [RDMDSDB].[RD_MDS].[mdm].[V_Self_Project_ALL]
	end

	 --PDT角色信息[dbo].[Sync_RDMDS_V_PDT_TMP]	[RDMDSDB].[RD_MDS].[mdm].[V_PDT];
    select @PDTCount=count(*) from  [RDMDSDB].[RD_MDS].[mdm].[V_PDT]
    if(@PDTCount!=0)
    begin
        TRUNCATE TABLE [dbo].[Sync_RDMDS_V_PDT_TMP]

		insert into [dbo].[RDMDS_V_PDT_TMP]
	(
	   [Member_ID]
      ,[VersionName]
      ,[VersionNumber]
      ,[VersionFlag]
      ,[Name]
      ,[Code]
      ,[ChangeTrackingMask]
      ,[engPDT]
      ,[PDTOld]
      ,[sStatus]
      ,[ProductLineCode_Code]
      ,[ProductLineCode_Name]
      ,[ProductLineCode_ID]
      ,[PDT_Manager]
      ,[CMJKR_ID]
      ,[SCJKR_ID]
      ,[HCJKR_ID]
      ,[AbroadJKR_ID]
      ,[IPJKR_ID]
      ,[OrderDecom]
      ,[Quality_Mnger_ID]
      ,[PDT_Group]
      ,[PND_Group]
      ,[Remark]
      ,[CreateUser]
      ,[CreateDate]
      ,[ModifyUser]
      ,[ModifyDate]
      ,[Del]
      ,[EnterDateTime]
      ,[EnterUserName]
      ,[EnterVersionNumber]
      ,[LastChgDateTime]
      ,[LastChgUserName]
      ,[LastChgVersionNumber]
      ,[ValidationStatus]
	 )
	select 
		[Member_ID]
      ,[VersionName]
      ,[VersionNumber]
      ,[VersionFlag]
      ,[Name]
      ,[Code]
      ,[ChangeTrackingMask]
      ,[engPDT]
      ,[PDTOld]
      ,[sStatus]
      ,[ProductLineCode_Code]
      ,[ProductLineCode_Name]
      ,[ProductLineCode_ID]
      ,[PDT_Manager]
      ,[CMJKR_ID]
      ,[SCJKR_ID]
      ,[HCJKR_ID]
      ,[AbroadJKR_ID]
      ,[IPJKR_ID]
      ,[OrderDecom]
      ,[Quality_Mnger_ID]
      ,[PDT_Group]
      ,[PND_Group]
      ,[Remark]
      ,[CreateUser]
      ,[CreateDate]
      ,[ModifyUser]
      ,[ModifyDate]
      ,[Del]
      ,[EnterDateTime]
      ,[EnterUserName]
      ,[EnterVersionNumber]
      ,[LastChgDateTime]
      ,[LastChgUserName]
      ,[LastChgVersionNumber]
      ,[ValidationStatus]
	from [RDMDSDB].[RD_MDS].[mdm].[V_PDT];
	end



	Commit Transaction 
End Try 
Begin Catch 
	Rollback Transaction 
	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT 
	@ErrorMessage = ERROR_MESSAGE(),
	@ErrorSeverity = ERROR_SEVERITY(),
	@ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage,  -- Message text.
	@ErrorSeverity, -- Severity.
	@ErrorState     -- State.
	);
End Catch

    
END  


