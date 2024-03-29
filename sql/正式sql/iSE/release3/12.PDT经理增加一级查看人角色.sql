USE [iSEDB]
GO
/****** Object:  StoredProcedure [dbo].[SyncProjManager]    Script Date: 2020-11-27 9:44:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		陈聪
-- Create date: <Create Date,,>
-- Description:	同步责任人

-- =============================================
ALTER PROCEDURE [dbo].[SyncProjManager] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	    declare  @userType int
	    declare @userName nvarchar(1000)
	    declare @dataSetID int 
	    declare @rCode nvarchar(50)
	    
		IF OBJECT_ID(N'dbo.#tempSpecTable', N'U') IS NOT NULL  
		BEGIN  
		  DROP TABLE #tempSpecTable  
		END 
	--备份不需要同步的数据 
	create table #tempSpecTable(userType  int,userName nvarchar(1000),dataset int,rcode nvarchar(50),createBy nvarchar(50),createTime datetime,flag int);
	
	insert into #tempSpecTable
	select  userType,userName,dataSetID,rCode,createBy,createTime,flag=0
    from specMS_SpecPermission 
    where rCode in ('1001','1','2','3','4','5','6','7','8','9','10','11','37','38','14','15','16','17','18','19');
    --
    
    insert into #tempSpecTable
    --1: 插入项目规格责任人
    select distinct userType,userName,dataSetID,rCode,createBy,GETDATE() as createTime,flag from
    ( 
    select '1' as userType,PDT_SE_ID as userName,dataSetID,'1' as rCode,'' as createBy,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  
    where s.srcID=p.ReleaseCode
    and PDT_SE_ID is not null and PDT_SE_ID<>'' and s.dataSetID not in 
    (select distinct dataSetID from specMS_SpecPermission p where p.rCode='1')
    
    union all
    select '1' as userType,System_Mnger as userName,dataSetID,'1' as rCode,'' as createBy,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and System_Mnger is not null and System_Mnger<>'' and s.dataSetID not in 
    (select distinct dataSetID from specMS_SpecPermission p where p.rCode='1')) a
    union all
    --同步PDT SE
    select '1' as userType, PDT_SE_ID as userName,dataSetID,'20' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and PDT_SE_ID is not null and PDT_SE_ID<>'' 
     union all
    --同步项目 SE
    select '1' as userType, System_Mnger as userName,dataSetID,'29' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and System_Mnger is not null and System_Mnger<>'' 
    union all
    --同步研发产品线总监
    select '1' as userType,PilotProduction_Mnger as userName,dataSetID,'21' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and PilotProduction_Mnger is not null and PilotProduction_Mnger<>''
    --开发代表
    union all
    select '1' as userType,RNDPDT_ID as userName,dataSetID,'13' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and RNDPDT_ID is not null and RNDPDT_ID<>''
     --市场代表
    union all
    select '1' as userType,Sales_Mnger as userName,dataSetID,'31' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Sales_Mnger is not null and Sales_Mnger<>''
    union all
    --财务代表
    select '1' as userType,PDT_FINPDT_ID as userName,dataSetID,'23' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and PDT_FINPDT_ID is not null and PDT_FINPDT_ID<>''
     union all
    --采购代表
    select '1' as userType,Purchase_Mnger as userName,dataSetID,'32' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Purchase_Mnger is not null and Purchase_Mnger<>''
    union all
    --产品工程代表
    select '1' as userType,PPPDT_ID as userName,dataSetID,'24' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and PPPDT_ID is not null and PPPDT_ID<>''
    union all
    --交付代表
    select '1' as userType,Manufacture_Mnger as userName,dataSetID,'33' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Manufacture_Mnger is not null and Manufacture_Mnger<>''
    union all
    --技术支援代表
    select '1' as userType,TechSupport_Mnger as userName,dataSetID,'25' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and TechSupport_Mnger is not null and TechSupport_Mnger<>''
     union all
    --R级项目经理
    select '1' as userType,Product_Mnger as userName,dataSetID,'26' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Product_Mnger is not null and Product_Mnger<>''
    union all
    --PQA
    select '1' as userType,Quality_Mnger as userName,dataSetID,'34' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Quality_Mnger is not null and Quality_Mnger<>''
    union all
    --POP
    select '1' as userType,POP_ID as userName,dataSetID,'35' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and POP_ID is not null and POP_ID<>''
    union all
    --测试经理
    select '1' as userType,Testing_Mnger as userName,dataSetID,'27' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Testing_Mnger is not null and Testing_Mnger<>''
    union all
    ---Documents_Mnger
    select '1' as userType,Documents_Mnger as userName,dataSetID,'28' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and Documents_Mnger is not null and Documents_Mnger<>''
     union all
    --PDT经理
    select '1' as userType,PDT_LPDT_ID as userName,dataSetID,'30' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and PDT_LPDT_ID is not null and PDT_LPDT_ID<>''
    union all
    --CMO
    select '1' as userType,CMO_ID as userName,dataSetID,'12' as rCode,'' as createBy,GETDATE() as createTime,flag=1
    from Sync_Self_Project p,specMS_SpecDataIDSet s  where s.srcID=p.ReleaseCode
    and CMO_ID is not null and CMO_ID<>''
	union all
	--PDT经理对应一级查看人 角色编码 9
	select distinct 1 as userType,SUBSTRING(b.PDT_Manager,CHARINDEX(' ',b.PDT_Manager)+1,10) as userName,c.dataSetID,'9' as rCode,'' as createBy,GETDATE() as createTime,flag=1
	from  specMS_SpecDataIDSet  a   
	left  join specMS_SpecDataIDSet  c  on  a.srcID=c.srcPID
	inner join  RDMDS_V_PDT_TMP  b  on  a.srcID=b.Code
	where  c.srcName!='' and  c.dataSetID is  not null
	union
	select  distinct  1 as userType,SUBSTRING(b.PDT_Manager,CHARINDEX(' ',b.PDT_Manager)+1,10) as userName,d.dataSetID,'9' as rCode,'' as createBy,GETDATE() as createTime,flag=1
	from  specMS_SpecDataIDSet  a   
	left  join specMS_SpecDataIDSet  c  on  a.srcID=c.srcPID
	left  join specMS_SpecDataIDSet  d  on  c.srcID=d.srcPID
	inner join  RDMDS_V_PDT_TMP  b  on  a.srcID=b.Code
	where  d.srcName!='' and  d.dataSetID is  not null;

    declare @index_sys int
    ---分离userName 里面带,的 
    declare DataCur  CURSOR FAST_FORWARD FOR
    SELECT userType,userName,dataset,rCode from #tempSpecTable where CHARINDEX(',',userName) >0 and flag=1;
    open DataCur
    fetch next from DataCur into @userType,@userName,@dataSetID,@rCode
    while @@fetch_status=0
    begin 
			set @index_sys =CHARINDEX(',',@userName,0);
			while @index_sys>0
			begin
				declare @temp3 varchar(100) = substring(@userName,1,@index_sys-1);
				declare @sysmnger varchar(max) = substring(@userName,@index_sys+1,len(@userName)-@index_sys);
				set @userName =@sysmnger;
				insert into #tempSpecTable(userType,userName,dataset,rCode,createBy,createTime)
				values(1,@temp3,@dataSetID,@rCode,'',GETDATE());
				set @index_sys = CHARINDEX(',',@sysmnger,0);
			end
					
	fetch next from DataCur into @userType,@userName,@dataSetID,@rCode
	end
	
close DataCur
deallocate DataCur
   --删除带，号
   delete  from #tempSpecTable where flag=1 and CHARINDEX(',',userName) >0;
   update   #tempSpecTable set userName=SUBSTRING(userName,PATINDEX('% %',userName)+1,LEN(userName)-PATINDEX('% %',userName)) where userType=1;
  
   --清空表数据 
   TRUNCATE  table  specMS_SpecPermission;
   
   --插入表数据 
   insert into specMS_SpecPermission(userType,userName,dataSetID,rCode,createBy,createTime)
   SELECT userType,userName,dataset,rcode,createBy,createTime from #tempSpecTable ;
	  
END

--