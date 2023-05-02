USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_WorkHourDetailView]    Script Date: 2019/12/23 11:03:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[P_WorkHourDetailView]  
@PageIndex INT,--当前页
@Rows INT,--条数
@startDate DATETIME,--时间区间开始
@endDate DATETIME,--时间区间结束
@ProjectLevel VARCHAR(50),
@conditionFlag VARCHAR(50),
@ManagerUser VARCHAR(50),
@Sys_Role INT,
@userCode VARCHAR(50),
@userName VARCHAR(50),
@projectCode VARCHAR(max),
@station VARCHAR(50),
@proTreeNode VARCHAR(max),
@deptTreeNode VARCHAR(max),
@RowID varchar(max), --rowID选中 应用于导出勾选

--跳转链接带过来的条件
--本身项目
@IsLinkType varchar(100),
@ProductLineCode varchar(MAX), --暂时用作集成多个条件查询
@PDTCode varchar(1000),
@FirstProCode varchar(1000),
@SecondProCode varchar(1000),
@ThirdProCode varchar(1000),
@FourthProCode varchar(1000),
@Mon_date varchar(100),
@SecondDeptName varchar(100)

AS
DECLARE @SQL NVARCHAR(MAX);
DECLARE @Condition NVARCHAR(MAX);


    BEGIN

	set @Condition='';

	if(@userCode<>'')
		begin
		set @Condition=' and UserCode ='''+@userCode+'''';
		end
	if(@userName<>'')
		begin
		set @Condition=@Condition+' and UserName ='''+@userName+'''';
		end
	if(@ProductLineCode<>'' and @IsLinkType<>'true')
	begin
	set @Condition=@Condition+' and ('+@ProductLineCode+')';
	end

	if(@projectCode<>'')
		begin
			DECLARE @Split_projectCode NVARCHAR(MAX);
			if(CHARINDEX(',',@projectCode)>0)
				begin
				set @Split_projectCode='select tableColumn from F_SplitStrToTable('''+@projectCode+''')';
				end
			else
				begin
				set @Split_projectCode=''''+isnull(@projectCode,'')+'''';
				end
			set @Condition=@Condition+' and (ProductLineCode in ('+@Split_projectCode+') or PDTCode in ('+@Split_projectCode+') or FirstProCode in ('+@Split_projectCode+') or SecondProCode in ('+@Split_projectCode+') or ThirdProCode in ('+@Split_projectCode+') or FourthProCode in ('+@Split_projectCode+'))';
	
		end
	if(@station<>'')
		begin
		DECLARE @Split_station NVARCHAR(MAX);
		if(CHARINDEX(',',@station)>0)
			begin
			set @Split_station='select tableColumn from F_SplitStrToTable('''+@station+''')';
			end
		else
			begin
			set @Split_station=''''+isnull(@station,'')+'''';
			end
		set @Condition=@Condition+' and Station in ('+@Split_station+')';

		end
	if(@proTreeNode<>'')
		begin
			--ys2338 原有备份 start
			--DECLARE @Split_proTreeNode NVARCHAR(MAX);
			--if(CHARINDEX(',',@proTreeNode)>0)
			--	begin
			--	set @Split_proTreeNode='select tableColumn from F_SplitStrToTable('''+@proTreeNode+''')';
			--	end
			--else
			--	begin
			--	set @Split_proTreeNode=''''+isnull(@proTreeNode,'')+'''';
			--	end
			--set @Condition=@Condition+' and (ProductLineCode in ('+@Split_proTreeNode+') or PDTCode in ('+@Split_proTreeNode+') or FirstProCode in ('+@Split_proTreeNode+') or SecondProCode in ('+@Split_proTreeNode+') or ThirdProCode in ('+@Split_proTreeNode+') or FourthProCode in ('+@Split_proTreeNode+'))';
			
			--ys2338 原有备份 end
		---------------------------------------------
			--ys2338 目前改为拼接好的字符串 start
			DECLARE @Split_proTreeNode NVARCHAR(MAX);
			if(@proTreeNode<>'' )
				begin
				set @Split_proTreeNode=@proTreeNode;
				end
			else
				begin
				set @Split_proTreeNode=''''+isnull(@proTreeNode,'')+'''';
				end
				
			IF @Split_proTreeNode<>''
				set @Condition=@Condition+' and (ProCode in ('+@Split_proTreeNode+')) ';

			--ys2338 目前改为拼接好的字符串 end
		end
	if(@deptTreeNode<>'')
		begin
			DECLARE @Split_deptTreeNode NVARCHAR(MAX);
			--新增授权的部门
			DECLARE @Split_authorizedDeptTreeNode NVARCHAR(MAX);
			if(CHARINDEX(',',@deptTreeNode)>0)
				begin
				set @Split_deptTreeNode='select tableColumn from F_SplitStrToTable('''+@deptTreeNode+''')';
				set @Split_authorizedDeptTreeNode='select tableColumn from F_GetAuthorizedDeptCode('''+@ManagerUser+''','''+@deptTreeNode+''')';
				end
			else
				begin
				set @Split_deptTreeNode=''''+isnull(@deptTreeNode,'')+'''';
				set @Split_authorizedDeptTreeNode=''''+isnull(@deptTreeNode,'')+'''';
				end

			if @Sys_Role = 1
				begin
					set @Condition=@Condition+' and (DeptCode  in ('+@Split_authorizedDeptTreeNode+') or SecondDeptCode in ('+@Split_deptTreeNode+'))';
				end
			else
				begin
					set @Condition=@Condition+' and (DeptCode  in ('+@Split_deptTreeNode+') or SecondDeptCode in ('+@Split_deptTreeNode+'))';
				end
		end

	

			 SELECT  distinct b.Date,a.UserCode into #LeaveDate
			 FROM    dbo.HourInfoMain a 
            LEFT JOIN dbo.HourInfo_New b ON b.HMain_ID = a.id AND a.DeleteFlag = 0 AND b.DeleteFlag = 0
			where IsLeave=1 and IsWorkingDay=0; --and Month(Date)='12' and year(Date)='2018'


		--SELECT ProCode,ProLevel INTO #procuctManager FROM dbo.ProductInfo WHERE Manager=@ManagerUser or CC=@ManagerUser
		IF(@Sys_Role = 1)
		BEGIN

		create table #procuctManager(
   ProCode varchar(100)
);
		  WITH    pro
          AS ( SELECT ProCode,ProLevel,ParentCode
               FROM     ProductInfo
               WHERE    (Manager=@ManagerUser or CC=@ManagerUser) and DeleteFlag<>1
			   UNION ALL
			   SELECT a.ProCode,a.ProLevel,a.ParentCode  FROM ProductInfo a INNER JOIN pro b ON  a.ParentCode=b.ProCode where a.DeleteFlag<>1
             )
	    insert INTO #procuctManager
        SELECT ProCode  FROM pro; 
		insert into #procuctManager
		SELECT ProCodeId FROM GiveRight_Pro WHERE DeleteFlag=0 AND UserId=@ManagerUser
	
	---增加部门层级
	create table #deptManager(
   Dept_Code varchar(100)
);
WITH    dept
          AS ( SELECT DeptCode,DeptLevel,ParentDeptCode
               FROM     Department
               WHERE    (DeptManager=@ManagerUser or DeptSecretary=@ManagerUser) and DeleteFlag<>1
			   UNION ALL
			   SELECT a.DeptCode,a.DeptLevel,a.ParentDeptCode  FROM Department a INNER JOIN dept b ON  a.ParentDeptCode=b.DeptCode where a.DeleteFlag<>1
             )
	    insert INTO #deptManager
        SELECT DeptCode  FROM dept; 
		insert into #deptManager
		SELECT DeptCode FROM GiveRight_Dept WHERE DeleteFlag=0 AND UserId=@ManagerUser

	 END

	 	create table #temp_table(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 

     --    CREATE INDEX IX_temp ON #temp_table(SecondProCode, UserName, DeptCode)
		
		--isPDT 目前为0 才是PDT 为1 是周边

		--Drop Table #FUnfreezen Drop Table #Ffreeze Drop Table #AUnfreezen Drop Table #Afreezen Drop Table #BUnfreezen Drop Table #Bfreezen Drop Table #CUnfreezen Drop Table #Cfreezen

		--declare @conditionFlag nvarchar(50) set @conditionFlag='5,6' 
		--declare @startDate nvarchar(50) set @startDate='2019-10-1'
		--declare @endDate nvarchar(50) set @startDate='2019-11-1'

		create table #FUnfreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #Ffreeze(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #AUnfreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #Afreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #BUnfreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #Bfreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #CUnfreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 
		create table #Cfreezen(
				  PDTCodeShare varchar(100),
				  FirstCodeShare varchar(100),
				  SecondCodeShare varchar(100),
				  ThirdCodeShare varchar(100),
				  FourthCodeShare varchar(100),
				  MonDate datetime,
				  ProductLineName varchar(100),
				  PDTName varchar(100),
				  PDTCode varchar(100),
				  FirstProCode varchar(100), 
				  FirstProName varchar(100),
				  UserCode varchar(100),
				  UserName varchar(100),
				  DeptName varchar(100),
				  SecondDeptCode varchar(100),
				  SecondDeptName varchar(100),
				  Station varchar(100),
				  DeptCode varchar(100),
				  ProductLineCode varchar(100),
				  Percents float,
				  SecondProName varchar(100),
				  SecondProCode varchar(100),
			      ThirdProName varchar(100),
				  ThirdProCode varchar(100),
				  FourthProName varchar(100),
				  FourthProCode varchar(100),
				  ispdt int,
				  ProCode varchar(36)
                              ) 

		IF(CHARINDEX('5',@conditionFlag)>0 AND CHARINDEX('6',@conditionFlag)=0 AND CHARINDEX('7',@conditionFlag)=0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
				FROM [First_WorkHourUnfreezen]
                WHERE First_IsPDT =0
				AND (CHARINDEX('KF',First_UserCode)=0 and CHARINDEX('YS',First_UserCode)=0 and CHARINDEX('WX',First_UserCode)=0 and CHARINDEX('FW',First_UserCode)=0)
				AND CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
				
			INSERT INTO	#Ffreeze			
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourfreeze]
                WHERE First_IsPDT =0
				AND (CHARINDEX('KF',First_UserCode)=0 and CHARINDEX('YS',First_UserCode)=0 and CHARINDEX('WX',First_UserCode)=0 and CHARINDEX('FW',First_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

			INSERT INTO	#AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE A_IsPDT =0
				AND (CHARINDEX('KF',A_UserCode)=0 and CHARINDEX('YS',A_UserCode)=0 and CHARINDEX('WX',A_UserCode)=0 and CHARINDEX('FW',A_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                    
			INSERT INTO #Afreezen      
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourfreeze]
                WHERE A_IsPDT =0
				AND (CHARINDEX('KF',A_UserCode)=0 and CHARINDEX('YS',A_UserCode)=0 and CHARINDEX('WX',A_UserCode)=0 and CHARINDEX('FW',A_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE B_IsPDT =0
				AND (CHARINDEX('KF',B_UserCode)=0 and CHARINDEX('YS',B_UserCode)=0 and CHARINDEX('WX',B_UserCode)=0 and CHARINDEX('FW',B_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourfreeze]
                WHERE B_IsPDT =0
				AND (CHARINDEX('KF',B_UserCode)=0 and CHARINDEX('YS',B_UserCode)=0 and CHARINDEX('WX',B_UserCode)=0 and CHARINDEX('FW',B_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE C_IsPDT =0
				AND (CHARINDEX('KF',C_UserCode)=0 and CHARINDEX('YS',C_UserCode)=0 and CHARINDEX('WX',C_UserCode)=0 and CHARINDEX('FW',C_UserCode)=0)
				AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE C_IsPDT =0
				AND (CHARINDEX('KF',C_UserCode)=0 and CHARINDEX('YS',C_UserCode)=0 and CHARINDEX('WX',C_UserCode)=0 and CHARINDEX('FW',C_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
		ELSE IF(CHARINDEX('5',@conditionFlag)=0 AND CHARINDEX('6',@conditionFlag)>0 AND CHARINDEX('7',@conditionFlag)=0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourUnfreezen]
                WHERE First_IsPDT =1
				AND (CHARINDEX('KF',First_UserCode)=0 and CHARINDEX('YS',First_UserCode)=0 and CHARINDEX('WX',First_UserCode)=0 and CHARINDEX('FW',First_UserCode)=0)
				AND CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
				
			INSERT INTO	#Ffreeze	
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourfreeze]
                WHERE First_IsPDT =1
				AND (CHARINDEX('KF',First_UserCode)=0 and CHARINDEX('YS',First_UserCode)=0 and CHARINDEX('WX',First_UserCode)=0 and CHARINDEX('FW',First_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

			INSERT INTO #AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE A_IsPDT =1
				AND (CHARINDEX('KF',A_UserCode)=0 and CHARINDEX('YS',A_UserCode)=0 and CHARINDEX('WX',A_UserCode)=0 and CHARINDEX('FW',A_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                  
			INSERT INTO #Afreezen        
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourfreeze]
                WHERE A_IsPDT =1
				AND (CHARINDEX('KF',A_UserCode)=0 and CHARINDEX('YS',A_UserCode)=0 and CHARINDEX('WX',A_UserCode)=0 and CHARINDEX('FW',A_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE B_IsPDT =1
				AND (CHARINDEX('KF',B_UserCode)=0 and CHARINDEX('YS',B_UserCode)=0 and CHARINDEX('WX',B_UserCode)=0 and CHARINDEX('FW',B_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourfreeze]
                WHERE B_IsPDT =1
				AND (CHARINDEX('KF',B_UserCode)=0 and CHARINDEX('YS',B_UserCode)=0 and CHARINDEX('WX',B_UserCode)=0 and CHARINDEX('FW',B_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE C_IsPDT =1
				AND (CHARINDEX('KF',C_UserCode)=0 and CHARINDEX('YS',C_UserCode)=0 and CHARINDEX('WX',C_UserCode)=0 and CHARINDEX('FW',C_UserCode)=0)
				AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE C_IsPDT =1
				AND (CHARINDEX('KF',C_UserCode)=0 and CHARINDEX('YS',C_UserCode)=0 and CHARINDEX('WX',C_UserCode)=0 and CHARINDEX('FW',C_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
		ELSE IF(CHARINDEX('5',@conditionFlag)=0 AND CHARINDEX('6',@conditionFlag)=0 AND CHARINDEX('7',@conditionFlag)>0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',First_UserCode)>0 OR CHARINDEX('YS',First_UserCode)>0 OR CHARINDEX('WX',First_UserCode)>0 OR CHARINDEX('FW',First_UserCode)>0)
				AND CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
					
			INSERT INTO	#Ffreeze	
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourfreeze]
                WHERE (CHARINDEX('KF',First_UserCode)>0 OR CHARINDEX('YS',First_UserCode)>0 OR CHARINDEX('WX',First_UserCode)>0 OR CHARINDEX('FW',First_UserCode)>0)
				AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

			INSERT INTO #AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',A_UserCode)>0 OR CHARINDEX('YS',A_UserCode)>0 OR CHARINDEX('WX',A_UserCode)>0 OR CHARINDEX('FW',A_UserCode)>0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                  
			INSERT INTO #Afreezen        
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourfreeze]
                WHERE (CHARINDEX('KF',A_UserCode)>0 OR CHARINDEX('YS',A_UserCode)>0 OR CHARINDEX('WX',A_UserCode)>0 OR CHARINDEX('FW',A_UserCode)>0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',B_UserCode)>0 OR CHARINDEX('YS',B_UserCode)>0 OR CHARINDEX('WX',B_UserCode)>0 OR CHARINDEX('FW',B_UserCode)>0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode  
                FROM [B_WorkHourfreeze]
                WHERE (CHARINDEX('KF',B_UserCode)>0 OR CHARINDEX('YS',B_UserCode)>0 OR CHARINDEX('WX',B_UserCode)>0 OR CHARINDEX('FW',B_UserCode)>0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',C_UserCode)>0 OR CHARINDEX('YS',C_UserCode)>0 OR CHARINDEX('WX',C_UserCode)>0 OR CHARINDEX('FW',C_UserCode)>0)
				AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE C_IsPDT =0
				AND (CHARINDEX('KF',C_UserCode)>0 OR CHARINDEX('YS',C_UserCode)>0 OR CHARINDEX('WX',C_UserCode)>0 OR CHARINDEX('FW',C_UserCode)>0)
				AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
		ELSE IF(CHARINDEX('5',@conditionFlag)>0 AND CHARINDEX('6',@conditionFlag)>0 AND CHARINDEX('7',@conditionFlag)=0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode  
                FROM [First_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',First_UserCode)=0 and CHARINDEX('YS',First_UserCode)=0 and CHARINDEX('WX',First_UserCode)=0 and CHARINDEX('FW',First_UserCode)=0)
				AND CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
						
			INSERT INTO	#Ffreeze
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourfreeze]
                WHERE (CHARINDEX('KF',First_UserCode)=0 and CHARINDEX('YS',First_UserCode)=0 and CHARINDEX('WX',First_UserCode)=0 and CHARINDEX('FW',First_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

		    INSERT INTO #AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',A_UserCode)=0 and CHARINDEX('YS',A_UserCode)=0 and CHARINDEX('WX',A_UserCode)=0 and CHARINDEX('FW',A_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                     
			INSERT INTO #Afreezen       
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourfreeze]
                WHERE (CHARINDEX('KF',A_UserCode)=0 and CHARINDEX('YS',A_UserCode)=0 and CHARINDEX('WX',A_UserCode)=0 and CHARINDEX('FW',A_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',B_UserCode)=0 and CHARINDEX('YS',B_UserCode)=0 and CHARINDEX('WX',B_UserCode)=0 and CHARINDEX('FW',B_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourfreeze]
                WHERE (CHARINDEX('KF',B_UserCode)=0 and CHARINDEX('YS',B_UserCode)=0 and CHARINDEX('WX',B_UserCode)=0 and CHARINDEX('FW',B_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE (CHARINDEX('KF',C_UserCode)=0 and CHARINDEX('YS',C_UserCode)=0 and CHARINDEX('WX',C_UserCode)=0 and CHARINDEX('FW',C_UserCode)=0)
				AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE (CHARINDEX('KF',C_UserCode)=0 and CHARINDEX('YS',C_UserCode)=0 and CHARINDEX('WX',C_UserCode)=0 and CHARINDEX('FW',C_UserCode)=0)
				AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
		ELSE IF(CHARINDEX('5',@conditionFlag)>0 AND CHARINDEX('6',@conditionFlag)=0 AND CHARINDEX('7',@conditionFlag)>0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourUnfreezen]
                WHERE (First_IsPDT=0 OR (CHARINDEX('KF',First_UserCode)>0 OR CHARINDEX('YS',First_UserCode)>0 OR CHARINDEX('WX',First_UserCode)>0 OR CHARINDEX('FW',First_UserCode)>0))
				AND CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
							
			INSERT INTO #Ffreeze
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourfreeze]
                WHERE (First_IsPDT=0 OR (CHARINDEX('KF',First_UserCode)>0 OR CHARINDEX('YS',First_UserCode)>0 OR CHARINDEX('WX',First_UserCode)>0 OR CHARINDEX('FW',First_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

			INSERT INTO #AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE (A_IsPDT=0 OR (CHARINDEX('KF',A_UserCode)>0 OR CHARINDEX('YS',A_UserCode)>0 OR CHARINDEX('WX',A_UserCode)>0 OR CHARINDEX('FW',A_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                        
			INSERT INTO #Afreezen   
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourfreeze]
                WHERE (A_IsPDT=0 OR (CHARINDEX('KF',A_UserCode)>0 OR CHARINDEX('YS',A_UserCode)>0 OR CHARINDEX('WX',A_UserCode)>0 OR CHARINDEX('FW',A_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE (B_IsPDT=0 OR (CHARINDEX('KF',B_UserCode)>0 OR CHARINDEX('YS',B_UserCode)>0 OR CHARINDEX('WX',B_UserCode)>0 OR CHARINDEX('FW',B_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourfreeze]
                WHERE (B_IsPDT=0 OR (CHARINDEX('KF',B_UserCode)>0 OR CHARINDEX('YS',B_UserCode)>0 OR CHARINDEX('WX',B_UserCode)>0 OR CHARINDEX('FW',B_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE (C_IsPDT=0 OR (CHARINDEX('KF',C_UserCode)>0 OR CHARINDEX('YS',C_UserCode)>0 OR CHARINDEX('WX',C_UserCode)>0 OR CHARINDEX('FW',C_UserCode)>0))
				AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE (C_IsPDT=0 OR (CHARINDEX('KF',C_UserCode)>0 OR CHARINDEX('YS',C_UserCode)>0 OR CHARINDEX('WX',C_UserCode)>0 OR CHARINDEX('FW',C_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
		ELSE IF(CHARINDEX('5',@conditionFlag)=0 AND CHARINDEX('6',@conditionFlag)>0 AND CHARINDEX('7',@conditionFlag)>0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourUnfreezen]
                WHERE (First_IsPDT=1 OR (CHARINDEX('KF',First_UserCode)>0 OR CHARINDEX('YS',First_UserCode)>0 OR CHARINDEX('WX',First_UserCode)>0 OR CHARINDEX('FW',First_UserCode)>0))
				AND CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
					
			INSERT INTO	#Ffreeze	
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode  
                FROM [First_WorkHourfreeze]
                WHERE (First_IsPDT=1 OR (CHARINDEX('KF',First_UserCode)>0 OR CHARINDEX('YS',First_UserCode)>0 OR CHARINDEX('WX',First_UserCode)>0 OR CHARINDEX('FW',First_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

			INSERT INTO #AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE (A_IsPDT=1 OR (CHARINDEX('KF',A_UserCode)>0 OR CHARINDEX('YS',A_UserCode)>0 OR CHARINDEX('WX',A_UserCode)>0 OR CHARINDEX('FW',A_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                       
			INSERT INTO #Afreezen    
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourfreeze]
                WHERE (A_IsPDT=1 OR (CHARINDEX('KF',A_UserCode)>0 OR CHARINDEX('YS',A_UserCode)>0 OR CHARINDEX('WX',A_UserCode)>0 OR CHARINDEX('FW',A_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE (B_IsPDT=1 OR (CHARINDEX('KF',B_UserCode)>0 OR CHARINDEX('YS',B_UserCode)>0 OR CHARINDEX('WX',B_UserCode)>0 OR CHARINDEX('FW',B_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourfreeze]
                WHERE (B_IsPDT=1 OR (CHARINDEX('KF',B_UserCode)>0 OR CHARINDEX('YS',B_UserCode)>0 OR CHARINDEX('WX',B_UserCode)>0 OR CHARINDEX('FW',B_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE (C_IsPDT=1 OR (CHARINDEX('KF',C_UserCode)>0 OR CHARINDEX('YS',C_UserCode)>0 OR CHARINDEX('WX',C_UserCode)>0 OR CHARINDEX('FW',C_UserCode)>0))
				AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE (C_IsPDT=1 OR (CHARINDEX('KF',C_UserCode)>0 OR CHARINDEX('YS',C_UserCode)>0 OR CHARINDEX('WX',C_UserCode)>0 OR CHARINDEX('FW',C_UserCode)>0))
				AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
		ELSE IF(CHARINDEX('5',@conditionFlag)>0 AND CHARINDEX('6',@conditionFlag)>0 AND CHARINDEX('7',@conditionFlag)>0)
		BEGIN
			INSERT INTO #FUnfreezen
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
				First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourUnfreezen]
                WHERE CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
				and First_Percents<>0;
						
			INSERT INTO	#Ffreeze
			SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
                First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
                First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
                '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
                FROM [First_WorkHourfreeze]
                WHERE Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
				and First_Percents<>0;

			INSERT INTO #AUnfreezen
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
                FROM [A_WorkHourUnfreezen]
                WHERE Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;
                     
			INSERT INTO #Afreezen      
			SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
				A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
                A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
                A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
                A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode  
                FROM [A_WorkHourfreeze]
                WHERE Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and A_Percents<>0;

			INSERT INTO #BUnfreezen
			SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
				B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourUnfreezen]
                WHERE Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;
               
			INSERT INTO #Bfreezen
			SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
                B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
                B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
                B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
                FROM [B_WorkHourfreeze]
                WHERE Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and B_Percents<>0;    

			INSERT INTO #CUnfreezen
			SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourUnfreezen]
                WHERE CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
    
			INSERT INTO #Cfreezen
			SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
				C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
                C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
                C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
                C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
                FROM [C_WorkHourfreeze]
                WHERE Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
				and C_Percents<>0;
		END
	
	--------------------------------
	--ys2338 原有注释
   --      SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			--	First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
   --             First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
   --             First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
   --             '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
			--	INTO #FUnfreezen
   --             FROM [First_WorkHourUnfreezen]
   --             WHERE First_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--	AND 
			--	CONVERT(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between @startDate and @endDate
			--	and First_Percents<>0;
							
   --      SELECT First_PDTCodeShare PDTCodeShare,First_Code FirstCodeShare,'' SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,First_MonDate MonDate,
			--    First_ProductLineName ProductLineName,First_PDTName PDTName, First_PDTCode PDTCode, 
   --             First_Code FirstProCode, First_Name FirstProName, First_UserCode UserCode, First_UserName UserName, First_DeptName DeptName,
   --             First_SecondDeptCode SecondDeptCode,First_SecondDeptName SecondDeptName, First_Station Station,First_DeptCode DeptCode,First_ProductLineCode ProductLineCode,First_Percents Percents,
   --             '' SecondProName,'' SecondProCode,'' ThirdProName,'' ThirdProCode,'' FourthProName,'' FourthProCode,First_IsPDT IsPDT,First_Code ProCode 
			--	INTO #Ffreeze
   --             FROM [First_WorkHourfreeze]
   --             WHERE First_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--	AND Convert(Datetime,(( CAST(YEAR(First_MonDate) AS VARCHAR) + '-' + CAST(MONTH(First_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate                
			--	and First_Percents<>0;



		 --SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
			--	A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
   --             A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
   --             A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
   --             A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
			--	INTO #AUnfreezen
   --             FROM [A_WorkHourUnfreezen]
   --             WHERE A_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--		AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
			--		and A_Percents<>0;
                            
   --      SELECT A_PDTCodeShare PDTCodeShare,A_FirstProCodeShare FirstCodeShare,A_Code SecondCodeShare,'' ThirdCodeShare ,'' FourthCodeShare,A_MonDate MonDate,
			--	A_ProductLineName ProductLineName,A_PDTName PDTName, A_PDTCode PDTCode, 
   --             A_FirstProCode FirstProCode, A_FirstProName FirstProName, A_UserCode UserCode, A_UserName UserName, A_DeptName DeptName,
   --             A_SecondDeptCode SecondDeptCode,A_SecondDeptName SecondDeptName, A_Station Station,A_DeptCode DeptCode,A_ProductLineCode ProductLineCode,A_Percents Percents,
   --             A_Name SecondProName,A_Code SecondProCode,'' ThirdProName ,'' ThirdProCode ,'' FourthProName,'' FourthProCode,A_IsPDT IsPDT,A_Code ProCode 
			--	INTO #Afreezen
   --             FROM [A_WorkHourfreeze]
   --             WHERE A_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--		AND Convert(Datetime,(( CAST(YEAR(A_MonDate) AS VARCHAR) + '-' + CAST(MONTH(A_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
			--		and A_Percents<>0;


   --      SELECT B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			--	B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
   --             B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
   --             B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
   --             B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
			--	INTO #BUnfreezen
   --             FROM [B_WorkHourUnfreezen]
   --             WHERE B_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--		AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
			--		and B_Percents<>0;

                                
   --     SELECT  B_PDTCodeShare PDTCodeShare,B_FirstProCodeShare FirstCodeShare,B_SecondProCodeShare SecondCodeShare,B_Code ThirdCodeShare ,'' FourthCodeShare,B_MonDate MonDate,
			--    B_ProductLineName ProductLineName,B_PDTName PDTName, B_PDTCode PDTCode, 
   --             B_FirstProCode FirstProCode, B_FirstProName FirstProName, B_UserCode UserCode, B_UserName UserName, B_DeptName DeptName,
   --             B_SecondDeptCode SecondDeptCode,B_SecondDeptName SecondDeptName, B_Station Station,B_DeptCode DeptCode,B_ProductLineCode ProductLineCode,B_Percents Percents,
   --             B_SecondProName SecondProName,B_SecondProCode SecondProCode,B_Name ThirdProName ,B_Code ThirdProCode,'' FourthProName,'' FourthProCode,B_IsPDT IsPDT,B_Code ProCode 
			--	INTO #Bfreezen
   --             FROM [B_WorkHourfreeze]
   --             WHERE B_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--		AND Convert(Datetime,(( CAST(YEAR(B_MonDate) AS VARCHAR) + '-' + CAST(MONTH(B_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
			--		and B_Percents<>0;    

   --     SELECT  C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
			--	C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
   --             C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
   --             C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
   --             C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
			--	INTO #CUnfreezen
   --             FROM [C_WorkHourUnfreezen]
   --             WHERE C_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--		AND CONVERT(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
			--		and C_Percents<>0;

                                
   --      SELECT C_PDTCodeShare PDTCodeShare,C_FirstProCodeShare FirstCodeShare,C_SecondProCodeShare SecondCodeShare,C_ThirdProCodeShare ThirdCodeShare ,C_Code FourthCodeShare,C_MonDate MonDate,
			--	C_ProductLineName ProductLineName,C_PDTName PDTName, C_PDTCode PDTCode, 
   --             C_FirstProCode FirstProCode, C_FirstProName FirstProName, C_UserCode UserCode, C_UserName UserName, C_DeptName DeptName,
   --             C_SecondDeptCode SecondDeptCode,C_SecondDeptName SecondDeptName, C_Station Station,C_DeptCode DeptCode,C_ProductLineCode ProductLineCode,C_Percents Percents,
   --             C_SecondProName SecondProName,C_SecondProCode SecondProCode,C_ThirdProName ThirdProName,C_ThirdProCode ThirdProCode,C_Name FourthProName,C_Code FourthProCode,C_IsPDT IsPDT,C_Code ProCode 
			--	INTO #Cfreezen
   --             FROM [C_WorkHourfreeze]
   --             WHERE C_IsPDT <> (CASE WHEN CHARINDEX('5,6', @conditionFlag) > 0 THEN 5 --5是为了判断查全部用的,在这个IsPDT 字段中没有意义
			--						WHEN CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 THEN 0
			--						WHEN CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 THEN 1
			--		ELSE 5 END) 
			--		AND Convert(Datetime,(( CAST(YEAR(C_MonDate) AS VARCHAR) + '-' + CAST(MONTH(C_MonDate) AS VARCHAR) ) +'-01'),101) between  @startDate and @endDate
			--		and C_Percents<>0;

             
        IF ( @ProjectLevel = '2' )--二级项目
            BEGIN
                IF ( @startDate < ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                              GETDATE()), 120)
                                    + '-1' ) )--区间开始时间在上个月一号以前的
                    BEGIN
                        IF ( @endDate < ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                              GETDATE()), 120)
                                          + '-1' ) )--区间结束时间在上个月一号以前的
                            BEGIN
							--优化union all==>#temp_table
							insert into #temp_table
							SELECT * FROM #Afreezen; 
							insert into #temp_table
							SELECT * FROM #Bfreezen;
							insert into #temp_table
							SELECT * FROM #Cfreezen;
							insert into #temp_table
							SELECT * FROM #Ffreeze;

							--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), SecondProCode, UserName, DeptCode ),0) rowID_wrong ,
                                SET @SQL ='SELECT 
                                
                                        SecondDeptName , DeptName DName ,UserName UserName ,UserCode UserCode ,
                                        ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                        ProductLineName ProductLineName , PDTName PName , PDTCode PCode, FirstProCode FirstProCode ,FirstProName FirstProName ,SecondProCode SecondProCode , 
                                        SecondProName SecondProName , Station Station,'''' StationName, SUM(Percents) sumPer ,
                                        CONVERT(FLOAT, ( SELECT  COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                              IsWorkingDay = 0  AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate)    AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                       )
                                                ) sumMon,IsPDT,
                                        DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,'''' ThirdProName ,'''' ThirdProCode ,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                from('
								IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
											    left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate )'+@Condition+' 
											    GROUP BY YEAR(MonDate) ,MONTH(MonDate) ,SecondProCode ,SecondProName , ProductLineName ,PDTName , PDTCode , FirstProCode , FirstProName , UserCode , UserName ,
                                        DeptName ,SecondDeptName , Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode ,PDTCodeShare,FirstCodeShare,SecondCodeShare';

                            END;
                        IF ( @endDate >= ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                              GETDATE()), 120)
                                          + '-1' ) )--区间结束时间在上个月一号以后的
                            BEGIN
							--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), SecondProCode, UserName, DeptCode ),0) rowID_wrong ,
                                SET @SQL ='SELECT 
                                
                                        SecondDeptName , DeptName DName ,UserName UserName ,UserCode UserCode ,
                                        ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                        ProductLineName ProductLineName , PDTName PName , PDTCode PCode, FirstProCode FirstProCode ,FirstProName FirstProName ,SecondProCode SecondProCode , 
                                        SecondProName SecondProName , Station Station,'''' StationName, SUM(Percents) sumPer ,
                                        CONVERT(FLOAT, ( SELECT  COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                              IsWorkingDay = 0  AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate)  AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                       )
                                                ) sumMon,IsPDT,
                                        DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,'''' ThirdProName ,'''' ThirdProCode ,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                from('
								IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) ,MONTH(MonDate) ,SecondProCode ,SecondProName , ProductLineName ,PDTName , PDTCode , FirstProCode , FirstProName , UserCode , UserName ,
                                        DeptName ,SecondDeptName , Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode ,PDTCodeShare,FirstCodeShare,SecondCodeShare';


                            END;
                    END;
                IF ( @startDate >= ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                              GETDATE()), 120)
                                    + '-1' ) )--区间开始时间在上个月一号以后的
                    BEGIN
					--优化union all==>#temp_table
								
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), SecondProCode, UserName, DeptCode ),0) rowID_wrong ,
                        SET @SQL ='SELECT 
                                
                                        SecondDeptName , DeptName DName ,UserName UserName ,UserCode UserCode ,
                                        ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                        ProductLineName ProductLineName , PDTName PName , PDTCode PCode, FirstProCode FirstProCode ,FirstProName FirstProName ,SecondProCode SecondProCode , 
                                        SecondProName SecondProName , Station Station,'''' StationName, SUM(Percents) sumPer ,
                                        CONVERT(FLOAT, ( SELECT  COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                              IsWorkingDay = 0  AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate)  AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                       )
                                                ) sumMon,IsPDT,
                                        DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,'''' ThirdProName ,'''' ThirdProCode ,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                from('
								IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) ,MONTH(MonDate) ,SecondProCode ,SecondProName , ProductLineName ,PDTName , PDTCode , FirstProCode , FirstProName , UserCode , UserName ,
                                        DeptName ,SecondDeptName , Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode ,PDTCodeShare,FirstCodeShare,SecondCodeShare';

                    END;
            END;
        ELSE
            IF ( @ProjectLevel = '3' )--三级项目
                BEGIN
                    IF ( @startDate < ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                              GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以前的
                        BEGIN
                            IF ( @endDate < ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                              -1, GETDATE()), 120)
                                              + '-1' ) )--区间结束时间在上个月一号以前的
                                BEGIN
								--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), ThirdProCode, UserCode, DeptCode ),0) rowID_wrong ,
                                     SET @SQL ='SELECT 
                                            SecondDeptName SecondDeptName ,DeptName DName , UserName UserName , UserCode UserCode ,
                                            ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,ProductLineName ProductLineName ,
                                            PDTName PName , PDTCode PCode,FirstProCode FirstProCode ,FirstProName FirstProName ,SecondProCode SecondProCode ,
                                            SecondProName SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date)FROM DateSetting b WHERE IsWorkingDay = 0
                                                          AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                            DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,ThirdProName ThirdProName,ThirdProCode ThirdProCode ,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,'''' FourthCodeShare
                                    FROM ('
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) ,MONTH(MonDate) ,SecondDeptName ,DeptName ,UserName ,UserCode ,ProductLineName ,PDTName ,PDTCode,FirstProCode ,
														FirstProName ,SecondProCode ,SecondProName ,ThirdProCode ,ThirdProName ,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare ';


                                END;
                            IF ( @endDate >= ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                              -1, GETDATE()), 120)
                                              + '-1' ) )--区间结束时间在上个月一号以后的
                                BEGIN
								--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), ThirdProCode, UserCode, DeptCode ),0) rowID_wrong ,
                                    SET @SQL ='SELECT 
                                            SecondDeptName SecondDeptName ,DeptName DName , UserName UserName , UserCode UserCode ,
                                            ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,ProductLineName ProductLineName ,
                                            PDTName PName , PDTCode PCode,FirstProCode FirstProCode ,FirstProName FirstProName ,SecondProCode SecondProCode ,
                                            SecondProName SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date)FROM DateSetting b WHERE IsWorkingDay = 0
                                                          AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                            DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,ThirdProName ThirdProName ,ThirdProCode ThirdProCode ,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,'''' FourthCodeShare
                                    FROM ('
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) ,MONTH(MonDate) ,SecondDeptName ,DeptName ,UserName ,UserCode ,ProductLineName ,PDTName ,PDTCode,FirstProCode ,
														FirstProName ,SecondProCode ,SecondProName ,ThirdProCode ,ThirdProName ,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare ';
									  
                                END;
                        END;
                    IF ( @startDate >= ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                              GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以后的
                        BEGIN
						--优化union all==>#temp_table
								
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), ThirdProCode, UserCode, DeptCode ),0) rowID_wrong ,
                           SET @SQL ='SELECT 
                                            SecondDeptName SecondDeptName ,DeptName DName , UserName UserName , UserCode UserCode ,
                                            ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,ProductLineName ProductLineName ,
                                            PDTName PName , PDTCode PCode,FirstProCode FirstProCode ,FirstProName FirstProName ,SecondProCode SecondProCode ,
                                            SecondProName SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date)FROM DateSetting b WHERE IsWorkingDay = 0
                                                          AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                            DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,ThirdProName ThirdProName ,ThirdProCode ThirdProCode ,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,'''' FourthCodeShare
                                    FROM ('
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) ,MONTH(MonDate) ,SecondDeptName ,DeptName ,UserName ,UserCode ,ProductLineName ,PDTName ,PDTCode,FirstProCode ,
														FirstProName ,SecondProCode ,SecondProName ,ThirdProCode ,ThirdProName ,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare ';

									  
                        END;

                END;
        ELSE
            IF ( @ProjectLevel = '4' )--四级项目
                BEGIN
                    IF ( @startDate < ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                            GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以前的
                        BEGIN
                            IF ( @endDate < ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                            -1, GETDATE()), 120)
                                                + '-1' ) )--区间结束时间在上个月一号以前的
                                BEGIN
								--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), FourthProCode, UserCode, DeptCode ),0) rowID_wrong ,
                                    SET @SQL ='SELECT 
                                    SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                    ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                    ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,FirstProCode FirstProCode ,FirstProName FirstProName ,
                                    SecondProCode SecondProCode ,SecondProName SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer , CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                            IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                                    DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,ThirdProName ThirdProName ,
									ThirdProCode ThirdProCode ,
                                    FourthProName FourthProName ,FourthProCode FourthProCode ,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,FourthCodeShare
                                    FROM    ('
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) , MONTH(MonDate) ,SecondDeptName ,DeptName ,UserName ,UserCode ,PDTCode,ProductLineName ,PDTName ,FirstProCode ,FirstProName ,
																SecondProCode ,SecondProName ,ThirdProCode ,ThirdProName ,FourthProCode ,FourthProName ,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,FourthCodeShare ';
                          
                                END;
                            IF ( @endDate >= ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                            -1, GETDATE()), 120)
                                                + '-1' ) )--区间结束时间在上个月一号以后的
                                BEGIN

								--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), FourthProCode, UserCode, DeptCode ),0) rowID_wrong ,
                                    SET @SQL ='SELECT  
                                    SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                    ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                    ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,FirstProCode FirstProCode ,FirstProName FirstProName ,
                                    SecondProCode SecondProCode ,SecondProName SecondProName  ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                            IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                                    DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,ThirdProName ThirdProName,ThirdProCode ThirdProCode ,
                                    FourthProName FourthProName,FourthProCode FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdProCode  ThirdCodeShare,FourthCodeShare
                                    FROM    ('
										 	IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) , MONTH(MonDate) ,SecondDeptName ,DeptName ,UserName ,UserCode ,PDTCode,ProductLineName ,PDTName ,FirstProCode ,FirstProName ,
																SecondProCode ,SecondProName ,ThirdProCode ,ThirdProName ,FourthProCode ,FourthProName ,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,FourthCodeShare ';
 
                                END;
                        END;
                    IF ( @startDate >= ( CONVERT(VARCHAR(7), DATEADD(mm, -1,
                                                            GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以后的
                        BEGIN
						--优化union all==>#temp_table
								
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), FourthProCode, UserCode, DeptCode ),0) rowID_wrong ,
                           SET @SQL ='SELECT  
                                    SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                    ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                    ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,FirstProCode FirstProCode ,FirstProName FirstProName ,
                                    SecondProCode SecondProCode ,SecondProName SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                            IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                                    DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode,ThirdProName ThirdProName,ThirdProCode ThirdProCode,
                                    FourthProName FourthProName,FourthProCode FourthProCode,PDTCodeShare,FirstCodeShare,SecondCodeShare, ThirdCodeShare,FourthCodeShare
                                    FROM    ( '
									 	IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY YEAR(MonDate) , MONTH(MonDate) ,SecondDeptName ,DeptName ,UserName ,UserCode ,PDTCode,ProductLineName ,PDTName ,FirstProCode ,FirstProName ,
																SecondProCode ,SecondProName ,ThirdProCode ,ThirdProName ,FourthProCode ,FourthProName ,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare,SecondCodeShare,ThirdCodeShare,FourthCodeShare ';

                        END;
                END;
        ELSE
            IF ( @ProjectLevel = '' )--PDT级
                BEGIN
                    IF ( @startDate < ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以前的
                        BEGIN
						--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								
                            IF ( @endDate < ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                                + '-1' ) )--区间结束时间在上个月一号以前的
                                BEGIN--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), PDTCode, UserCode, DeptCode ),0) rowID_wrong ,
                                   SET @SQL = 'SELECT 
                                    SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                    ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                    ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,'''' FirstProCode ,'''' FirstProName ,
                                    '''' SecondProCode ,'''' SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                            IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                                    DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode ,'''' ThirdProName,'''' ThirdProCode ,
                                    '''' FourthProName ,'''' FourthProCode,PDTCodeShare,''''  FirstCodeShare,'''' SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
										FROM ('
										IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY SecondDeptName , DeptName , UserName , UserCode , YEAR(MonDate) , MONTH(MonDate) ,ProductLineName ,PDTName ,PDTCode, 
										Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare ';
										
                                END;
                                
                            IF ( @endDate >= ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                                + '-1' ) )--区间结束时间在上个月一号以后的
                                BEGIN
								--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), PDTCode, UserCode, DeptCode ),0) rowID_wrong ,
                                   SET @SQL = 'SELECT 
                                    SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                    ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                    ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,'''' FirstProCode ,'''' FirstProName ,
                                    '''' SecondProCode ,'''' SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                            IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                                    DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode ,'''' ThirdProName,'''' ThirdProCode ,
                                    '''' FourthProName ,'''' FourthProCode,PDTCodeShare,'''' FirstCodeShare,'''' SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                    FROM ('
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate )'+@Condition+' 
											    GROUP BY SecondDeptName , DeptName , UserName , UserCode , YEAR(MonDate) , MONTH(MonDate) ,ProductLineName ,PDTName ,PDTCode, 
										Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare ';
										

                                END;
                        END;
                    IF ( @startDate >= ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以后的
                        BEGIN
						--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), PDTCode, UserCode, DeptCode ),0) rowID_wrong ,
                             SET @SQL = 'SELECT 
                                    SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                    ( CAST(YEAR(MonDate) AS VARCHAR) +''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                    ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,'''' FirstProCode ,'''' FirstProName ,
                                    '''' SecondProCode ,'''' SecondProName ,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                            IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                            )
                                                    ) sumMon,IsPDT,
                                                    DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode ,'''' ThirdProName,'''' ThirdProCode ,
                                    '''' FourthProName ,'''' FourthProCode,PDTCodeShare,'''' FirstCodeShare,'''' SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                    FROM ( '
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY SecondDeptName , DeptName , UserName , UserCode , YEAR(MonDate) , MONTH(MonDate) ,ProductLineName ,PDTName ,PDTCode, 
										Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare ';

                        END;
                END;
        ELSE--默认视图9#级
        BEGIN
            IF ( @startDate < ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以前的
                        BEGIN
                            IF ( @endDate < ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                                + '-1' ) )--区间结束时间在上个月一号以前的
                                BEGIN
								insert into #temp_table
							SELECT * FROM #Afreezen; 
							insert into #temp_table
							SELECT * FROM #Bfreezen;
							insert into #temp_table
							SELECT * FROM #Cfreezen;
							insert into #temp_table
							SELECT * FROM #Ffreeze;
							--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), FirstProCode, UserName ,DeptCode ),0) rowID_wrong ,
                                   SET @SQL=' SELECT 
                                            SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                            ( CAST(YEAR(MonDate) AS VARCHAR)+''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                            ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,FirstProCode FirstProCode ,
                                            FirstProName FirstProName ,'''' SecondProCode,'''' SecondProName,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                        IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                        )
                                                    ) sumMon,IsPDT,
                                            DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode
                                            ,'''' ThirdProName,'''' ThirdProCode,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,'''' SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                        FROM ( '
										IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY SecondDeptName , DeptName , UserName , UserCode ,FirstProCode,FirstProName,  YEAR(MonDate) ,
                                                MONTH(MonDate) , ProductLineName ,PDTName , PDTCode,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare  ';
                                        
                                END;
                                
                            IF ( @endDate >= ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                                + '-1' ) )--区间结束时间在上个月一号以后的
                                BEGIN
								--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #Afreezen; 
								insert into #temp_table
								SELECT * FROM #Bfreezen;
								insert into #temp_table
								SELECT * FROM #Cfreezen;
								insert into #temp_table
								SELECT * FROM #Ffreeze;
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), FirstProCode, UserName ,DeptCode ),0) rowID_wrong ,
                                    SET @SQL=' SELECT 
                                            SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                            ( CAST(YEAR(MonDate) AS VARCHAR)+''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                            ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,FirstProCode FirstProCode ,
                                            FirstProName FirstProName ,'''' SecondProCode,'''' SecondProName,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                        IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                        )
                                                    ) sumMon,IsPDT,
                                            DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode
                                            ,'''' ThirdProName,'''' ThirdProCode,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,'''' SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                        FROM ( '
										IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate )'+@Condition+' 
											    GROUP BY SecondDeptName , DeptName , UserName , UserCode ,FirstProCode,FirstProName,  YEAR(MonDate) ,
                                                MONTH(MonDate) , ProductLineName ,PDTName , PDTCode,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare  ';
                                END;
                        END;
                    IF ( @startDate >= ( CONVERT(VARCHAR(7), DATEADD(mm,
                                                        -1, GETDATE()), 120)
                                        + '-1' ) )--区间开始时间在上个月一号以后的
                        BEGIN
						--优化union all==>#temp_table
								insert into #temp_table
								SELECT * FROM #AUnfreezen; 
								insert into #temp_table
								SELECT * FROM #BUnfreezen;
								insert into #temp_table
								SELECT * FROM #CUnfreezen;
								insert into #temp_table
								SELECT * FROM #FUnfreezen;--SELECT ISNULL(ROW_NUMBER() OVER ( ORDER BY MONTH(MonDate), YEAR(MonDate), SUM(Percents), FirstProCode, UserName ,DeptCode ),0) rowID ,
                                      SET @SQL=' SELECT 
                                            SecondDeptName SecondDeptName ,DeptName DName ,UserName UserName ,UserCode UserCode ,
                                            ( CAST(YEAR(MonDate) AS VARCHAR)+''-''+ CAST(MONTH(MonDate) AS VARCHAR) ) AS mon_date ,
                                            ProductLineName ProductLineName ,PDTName PName ,PDTCode PCode,FirstProCode FirstProCode ,
                                            FirstProName FirstProName ,'''' SecondProCode,'''' SecondProName,Station Station ,'''' StationName,SUM(Percents) sumPer ,
                                            CONVERT(FLOAT, ( SELECT COUNT(DISTINCT Date) FROM DateSetting b WHERE
                                                        IsWorkingDay = 0 AND YEAR(b.Date) = YEAR(MonDate) AND MONTH(b.Date) = MONTH(MonDate) AND  not exists (
															  select Date from #LeaveDate where UserCode=main.UserCode and Date=b.Date
															  )
															  and not exists (select HireDate from UserInfo where b.Date<HireDate and Code=main.UserCode )
                                                        )
                                                    ) sumMon,IsPDT,
                                            DeptCode DCode,SecondDeptCode,ProductLineCode ProductLineCode
                                            ,'''' ThirdProName,'''' ThirdProCode,'''' FourthProName,'''' FourthProCode,PDTCodeShare,FirstCodeShare,'''' SecondCodeShare,'''' ThirdCodeShare,'''' FourthCodeShare
                                    FROM (   ';
									IF(@Sys_Role = 1)--1不是sap或者应用管理员的账户，0是sap或者应用管理员的账户
									BEGIN
										SET @SQL = @SQL + '
										    select * from #temp_table where deptcode in(select * from #deptManager)
											union
									        select * from #temp_table where FirstCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FirstProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where PDTCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where SecondProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where ThirdProCode in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthCodeShare in(SELECT * FROM #procuctManager)
											union 
											select * from #temp_table where FourthProCode in(SELECT * FROM #procuctManager)'

									END
									ELSE
									BEGIN
											SET @SQL = @SQL + 'select  * from #temp_table';
									END
									
										SET @SQL = @SQL + '	 ) main
										        left join DateSetting ds on main.MonDate=ds.Date
										        where 1=1 And ds.IsWorkingDay=0 And Exists(select 1 from userinfo where main.UserCode=Code And HireDate<=MonDate ) '+@Condition+' 
											    GROUP BY SecondDeptName , DeptName , UserName , UserCode ,FirstProCode,FirstProName,  YEAR(MonDate) ,
                                                MONTH(MonDate) , ProductLineName ,PDTName , PDTCode,Station,IsPDT,DeptCode,SecondDeptCode,ProductLineCode,PDTCodeShare,FirstCodeShare  ';
										
                        END;
        END
		--用完删除
		--select * from #temp_table -- where UserCode ='02293' order by MonDate
	
		--@conditionFlag 值为5、6、7    5为PDT人力、6为周边投入、7为外包人力
		--ys2338 暂时注释 在基础表里筛选出来了 start
		--IF(@conditionFlag <> '' AND CHARINDEX('5,6,7', @conditionFlag) = 0 )
		--BEGIN
		--	IF(CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) > 0 AND CHARINDEX('7', @conditionFlag) = 0)
		--	BEGIN
		--		SET @SQL = 'SELECT * FROM ('+@SQL+') a 
		--		WHERE CHARINDEX(''KF'',UserCode) = 0 AND CHARINDEX(''YS'',UserCode) = 0 AND CHARINDEX(''GW'',UserCode) = 0 AND CHARINDEX(''WX'',UserCode) = 0 AND CHARINDEX(''FW'',UserCode) = 0';
		--	END
		--	ELSE IF(CHARINDEX('5', @conditionFlag) > 0 AND CHARINDEX('6', @conditionFlag) = 0 AND CHARINDEX('7', @conditionFlag) > 0)
		--	BEGIN
		--		SET @SQL = 'SELECT * FROM ('+@SQL+') a ';
				
		--	END
		--	ELSE IF(CHARINDEX('5', @conditionFlag) = 0 AND CHARINDEX('6', @conditionFlag) > 0 AND CHARINDEX('7', @conditionFlag) > 0)
		--	BEGIN
		--		SET @SQL = 'SELECT * FROM ('+@SQL+') a ';
		--	END
		--	ELSE
  --          BEGIN
		--		IF(CHARINDEX('7', @conditionFlag) > 0)
		--		BEGIN
		--			SET @SQL = 'SELECT * FROM ('+@SQL+') a WHERE CHARINDEX(''KF'',UserCode) > 0 
		--			union all SELECT * FROM ('+@SQL+') a WHERE CHARINDEX(''YS'',UserCode) > 0 
		--			union all SELECT * FROM ('+@SQL+') a WHERE CHARINDEX(''GW'',UserCode) > 0 
		--			union all SELECT * FROM ('+@SQL+') a WHERE CHARINDEX(''WX'',UserCode) > 0 
		--			union all SELECT * FROM ('+@SQL+') a WHERE CHARINDEX(''FW'',UserCode) > 0
		--			';
  --              END
		--		ELSE IF(CHARINDEX('5', @conditionFlag) > 0)
		--		BEGIN
		--			SET @SQL = 'SELECT * FROM ('+@SQL+') a 
		--			WHERE CHARINDEX(''KF'',UserCode) = 0 AND CHARINDEX(''YS'',UserCode) = 0 AND CHARINDEX(''GW'',UserCode) = 0 AND CHARINDEX(''WX'',UserCode) = 0 AND CHARINDEX(''FW'',UserCode) = 0';
		--		END
		--		ELSE IF(CHARINDEX('6', @conditionFlag) > 0 )
		--		BEGIN
		--			SET @SQL = 'SELECT * FROM ('+@SQL+') a 
		--			WHERE CHARINDEX(''KF'',UserCode) = 0 AND CHARINDEX(''YS'',UserCode) = 0 AND CHARINDEX(''GW'',UserCode) = 0 AND CHARINDEX(''WX'',UserCode) = 0 AND CHARINDEX(''FW'',UserCode) = 0';
		--		END
		--	END
		--END
		--ys2338 暂时注释 在基础表里筛选出来了 end

--rowID选中 应用于导出勾选
	--if(@RowID<>'')
	--begin
	--DECLARE @Split_RowID NVARCHAR(MAX);
	--	if(CHARINDEX(',',@RowID)>0)
	--begin
	--set @Split_RowID='select tableColumn from F_SplitStrToTable('''+@RowID+''')';
	--end
	--else
	--begin
	--set @Split_RowID=''''+isnull(@RowID,'')+'''';
	--end
	--set @SQL='select * from ('+@SQL+') a where RowID  in ('+@Split_RowID+')';
	--end

	--新增跳转链接条件
	declare @ConditionLink NVARCHAR(MAX);
	set @ConditionLink=' where 1=1 ';
	if(@IsLinkType='true')
		begin
		if(@ProjectLevel='2')
			begin
			if(@SecondProCode<>'')
				begin
				set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' and SecondProCode='''+@SecondProCode+'''   ';
				end
			else if(@FirstProCode<>'')
				begin
				set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+'''   ';
				end
				else
				begin
				set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +'''';
				end
			end
		else if(@ProjectLevel='3')
			begin
				if(@ThirdProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' and SecondProCode='''+@SecondProCode+''' and ThirdProCode='''+@ThirdProCode+''' 
					';
					end
				else if(@SecondProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' and SecondProCode='''+@SecondProCode+''' 
					';
					end
				else if(@FirstProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' 
					';
					end
					else
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +'''';
					end
			end
		else if(@ProjectLevel='4')
			begin
				if(@FourthProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' and SecondProCode='''+@SecondProCode+''' and ThirdProCode='''+@ThirdProCode+''' and FourthProCode='''+@FourthProCode+''' 
					';
					end
				else if(@ThirdProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' and SecondProCode='''+@SecondProCode+''' and ThirdProCode='''+@ThirdProCode+'''
					';
					end
				else if(@SecondProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+''' and SecondProCode='''+@SecondProCode+'''
					';
					end
				else if(@FirstProCode<>'')
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+'''
					';
					end
					else
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +'''';
					end
			end
		else if(@ProjectLevel<>'')
		    begin
			if(@FirstProCode<>'')
				begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +''' and FirstProCode='''+@FirstProCode+'''
					';
				end
				else
					begin
					set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +'''';
					end
			end
		else
			begin
			set @ConditionLink=@ConditionLink+'  and  PCode='''+@PDTCode +'''
			';
			end

		end

	if(@Mon_date<>'')
		begin
		set @ConditionLink=@ConditionLink+' and  mon_date= '''+@Mon_date+''' ';
		end

	if(@SecondDeptName<>'')
		begin
		set @ConditionLink=@ConditionLink+' and SecondDeptName ='''+@SecondDeptName+'''';
		end

		--bak--SELECT @SumNum=sum(sumPer/sumMon) FROM #SelectAllPro '+@ConditionLink+'
	--关联岗位表
	set @SQL='DECLARE @SumNum INT;DECLARE @SumAll float; select a.*,b.Name as StationNameShow into #SelectAllPro from ('+@SQL+') a left join StationCategory b on a.Station=b.Code 
	SELECT @SumAll=sum(sumPer/sumMon) FROM #SelectAllPro '+@ConditionLink

	set @SQL=@SQL+ ' SELECT @SumNum=COUNT(0) FROM #SelectAllPro '+@ConditionLink


		if(@RowID<>'')
	begin
		DECLARE @Split_RowID NVARCHAR(MAX);
		if(CHARINDEX(',',@RowID)>0)
			begin
			set @Split_RowID='select tableColumn from F_SplitStrToTable('''+@RowID+''')';
			--bak set @SQL=@SQL+' select * from (select top 100 PERCENT  ROW_NUMBER() over (order by mon_date ) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode) tt where RowID in ('+@Split_RowID+') '; --CREATE CLUSTERED INDEX IDX_#tables_NAME ON #order(rowID1);
			 set @SQL=@SQL+' select ROW_NUMBER() over (order by mon_date,SecondDeptName,DName,UserCode) rowID, *,@SumNum Counts,@SumAll SumAll into #SelectAllProOrder from #SelectAllPro  '+@ConditionLink+' ;select * from #SelectAllProOrder where RowID in ('+@Split_RowID+') order by mon_date,SecondDeptName,DName,UserCode';
			--set @SQL=@SQL+' select ROW_NUMBER() over (order by mon_date,SecondDeptName,DName,UserCode) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' And RowID in ('+@Split_RowID+') order by mon_date,SecondDeptName,DName,UserCode';
			end
		else
			begin
				set @Split_RowID=''''+isnull(@RowID,'')+'''';
				
			end
		--set @SQL='select * from ('+@SQL+') a where RowID  in ('+@Split_RowID+')';
	end
	else
	begin
		--bak  set @SQL=@SQL+' select ROW_NUMBER() over (order by mon_date ) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode';
		 set @SQL=@SQL+'select  ROW_NUMBER() over (order by mon_date,SecondDeptName,DName,UserCode) rowID, *,@SumNum Counts,@SumAll SumAll into #SelectAllProOrder from #SelectAllPro   '+@ConditionLink+' ; select * from #SelectAllProOrder order by mon_date,SecondDeptName,DName,UserCode';
		--set @SQL=@SQL+'select  ROW_NUMBER() over (order by mon_date,SecondDeptName,DName,UserCode) rowID, *,@SumNum SumAll from #SelectAllPro   '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode';
	end

	IF @PageIndex <>0
					BEGIN
					SET @SQL=@SQL+' offset '+ CAST(( ( @PageIndex * @Rows ) - @Rows ) AS VARCHAR(10))
							+ ' rows fetch next ' + CAST(@Rows AS VARCHAR(10))+ ' rows only' ;
					END

	--暂时注释--select  *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode';

	---SELECT @SumNum=sum(sumPer/sumMon) FROM #SelectAllPro '+@ConditionLink+'; --没用
		
		--if(@RowID<>'')
	--begin
	--	DECLARE @Split_RowID NVARCHAR(MAX);
	--	if(CHARINDEX(',',@RowID)>0)
	--		begin
	--		set @Split_RowID='select tableColumn from F_SplitStrToTable('''+@RowID+''')';
	--		--bak set @SQL=@SQL+' select * from (select top 100 PERCENT  ROW_NUMBER() over (order by mon_date ) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode) tt where RowID in ('+@Split_RowID+') ';
	--		set @SQL=@SQL+'   select  * from (select top 100 PERCENT ROW_NUMBER() over (order by mon_date ) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode) tt where RowID in ('+@Split_RowID+')';
	--		end
	--	else
	--		begin
	--			set @Split_RowID=''''+isnull(@RowID,'')+'''';
				
	--		end
	--	--set @SQL='select * from ('+@SQL+') a where RowID  in ('+@Split_RowID+')';
	--end
	--else
	--begin
	--	--bak  set @SQL=@SQL+' select ROW_NUMBER() over (order by mon_date ) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+' order by mon_date,SecondDeptName,DName,UserCode';
	--	set @SQL=@SQL+' select* from (select top 100 PERCENT  ROW_NUMBER() over (order by mon_date ) rowID, *,@SumNum SumAll from #SelectAllPro  '+@ConditionLink+'order by mon_date,SecondDeptName,DName,UserCode ) t';
	--end

	Exec Sp_ExecuteSql @SQL
	--SELECT @SQL;
		DROP TABLE #Afreezen;
		DROP TABLE #AUnfreezen;
		DROP TABLE #Bfreezen;
		DROP TABLE #BUnfreezen;
		DROP TABLE #Cfreezen;
		DROP TABLE #CUnfreezen;
		DROP TABLE #Ffreeze;
		DROP TABLE #FUnfreezen;
		if object_id(N'#procuctManager',N'U') is not null
		begin
		DROP TABLE #procuctManager;
		end
		if object_id(N'#LeaveDate',N'U') is not null
		begin
		drop table #LeaveDate;
		end
		if object_id(N'#temp_table',N'U') is not null
		begin
		drop table #temp_table;
		end
		if object_id(N'#deptManager',N'U') is not null
		begin
		DROP TABLE #deptManager;
		end
		
    END;




GO


