USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[Sync_RDMDS_V_Release_TMP]    Script Date: 2020-11-12 10:26:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  chenmin
-- Create date: 2020-11-12
-- Description: 同步RDMDS_V_PDT_TMP
-- =============================================  
Create PROCEDURE [dbo].[Sync_RDMDS_V_PDT_TMP]  
  
AS  
BEGIN  

 SET NOCOUNT ON;  
 Begin Try 
	Begin Transaction

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

	-- 一级可查看人  角色编码 9
	insert  into   specMS_SpecPermission(
       [userType]
      ,[userName]
      ,[dataSetID]
      ,[rCode]
      ,[createBy]
      ,[createTime])

	  select distinct 1,SUBSTRING(b.PDT_Manager,CHARINDEX(' ',b.PDT_Manager)+1,10),c.dataSetID,9,'',GETDATE()  from  specMS_SpecDataIDSet  a   
	  left  join specMS_SpecDataIDSet  c  on  a.srcID=c.srcPID
	  inner join  RDMDS_V_PDT_TMP  b  on  a.srcID=b.Code
	  where  c.srcName!='' and  c.dataSetID is  not null
	  union
	  select  distinct  1,SUBSTRING(b.PDT_Manager,CHARINDEX(' ',b.PDT_Manager)+1,10),d.dataSetID,9,'',GETDATE()  from  specMS_SpecDataIDSet  a   
	  left  join specMS_SpecDataIDSet  c  on  a.srcID=c.srcPID
	  left  join specMS_SpecDataIDSet  d  on  c.srcID=d.srcPID
	  inner join  RDMDS_V_PDT_TMP  b  on  a.srcID=b.Code
	  where  d.srcName!='' and  d.dataSetID is  not null


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
GO


