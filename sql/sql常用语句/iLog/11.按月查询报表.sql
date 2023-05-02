SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:  按月报表 
-- =============================================
CREATE PROCEDURE [dbo].[P_WorkHourMonthView_New]
    @startDate DATETIME ,            --时间区间开始
    @endDate DATETIME ,              --时间区间结束
    @ProjectLevel VARCHAR(50) ,      --项目层级
    @IsPDT VARCHAR(50) ,         --5 PDT人力 6周边人力 7外包人力
    @UserId VARCHAR(50) ,            --用户 如：liucaixuan 03806
    @SysRole INT,                    --0管理员 1非管理员
    @projectCode VARCHAR(MAX),
    @proTreeNode VARCHAR(MAX),
    @SelRowID varchar(max)
AS
    BEGIN

    --权限项目1：为项目经理和POP的项目+被授权的项目  
    --权限项目2：递归查询权限项目1所有下级项目
    --权限项目跟明细表关联查询，根据六个项目等级分别进行关联最后合并（判断没有某个等级可少个union）
    --再union （为部门主管和部门秘书时能看到部门下人员所有反馈的项目，部门下人员直接跟明细表关联查询）

    
    DECLARE @Condition NVARCHAR(MAX);
    set @Condition='SELECT * INTO #DetailTable_temp FROM WorkHourDetail  where 1=1 ';
    declare @RowID varchar(max);
    declare @sql nvarchar(max);
    set @RowID='';

    --输入项目编码
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
    
        END
    --选择产品
    if(@proTreeNode<>'')  
        begin           
            set @Condition=@Condition+' and (ProCode in ('+@proTreeNode+')) ';      --拼接好的字符串
        end

    CREATE TABLE #DetailTable_temp
    (
        [ID] [int] NOT NULL IDENTITY(1, 1),
        [ProCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [ProName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [ProductLineCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [ProductLineName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [PDTCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [PDTName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [BVersionCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [BVersionName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [SecondProCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [SecondProName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [ThirdProCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [ThirdProName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [FourthProCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [FourthProName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [UserCode] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,
        [UserName] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL,
        [YearMonth] [int] NULL,
        [Percents] [float] NULL,
        [WorkingDay] [tinyint] NULL,
        [DeptCode] [varchar] (10) COLLATE Chinese_PRC_CI_AS NULL,
        [DeptName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [SecondDeptCode] [varchar] (10) COLLATE Chinese_PRC_CI_AS NULL,
        [SecondDeptName] [nvarchar] (100) COLLATE Chinese_PRC_CI_AS NULL,
        [StationCategoryCode] [varchar] (10) COLLATE Chinese_PRC_CI_AS NULL,
        [StationCategoryName] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL,
        [IsPDT] [bit] NULL,
        [IsVendor] [bit] NULL
    ) 
    Exec Sp_ExecuteSql @Condition  --条件过来后的明细表数据存入临时表 #DetailTable_temp
    
    

    CREATE TABLE #ManagerAllProcuct  --所有直接权限项目及对应所有以下等级项目存入临时表 #ManagerAllProcuct
        (
          ProCode VARCHAR(100) ,
          ProLevel INT
        );
        CREATE TABLE #ManagerAllDeptUser  --
        (
          UserId VARCHAR(100)
        );
    --管理员或非管理员，查询权限内项目
    IF ( @SysRole = 0 )  
        BEGIN
            --SELECT  ProCode ,
            --        ProLevel
            --INTO    #ManagerAllProcuct
            --FROM    dbo.ProductInfo
            --WHERE   DeleteFlag = 0;   
            SELECT * #DetailTableRight_temp FROM WorkHourDetail
        END;
    ELSE 
        BEGIN

            SELECT  *
            INTO    #ManagerProcuct  --所有直接权限的项目插入临时表 #ManagerProcuct
            FROM    ( SELECT    ProCode ,
                                ProLevel ,
                                ParentCode
                      FROM      ProductInfo AS a
                                JOIN GiveRight_Pro AS b ON b.ProCodeId = a.ProCode
                                                           AND b.UserId = @UserId
                                                           AND b.DeleteFlag = 0
                      WHERE     a.DeleteFlag = 0
                      UNION
                      SELECT    ProCode ,
                                ProLevel ,
                                ParentCode
                      FROM      ProductInfo
                      WHERE     ( Manager = @UserId
                                  OR CC = @UserId
                                )
                    ) T;
            --所有直接权限项目及对应所有以下等级项目插入临时表 #ManagerAllProcuct
            WITH    pro
                      AS ( SELECT   ProCode ,
                                    ProLevel ,
                                    ParentCode
                           FROM     #ManagerProcuct
                           UNION  ALL
                           SELECT   a.ProCode ,
                                    a.ProLevel ,
                                    a.ParentCode
                           FROM     ProductInfo a
                                    INNER JOIN pro b ON a.ParentCode = b.ProCode
                           WHERE    a.DeleteFlag = 0
                         )
                INSERT  INTO #ManagerAllProcuct
                        SELECT  ProCode ,
                                ProLevel
                        FROM    pro; 


            SELECT  *
            INTO    #ManagerDept  --所有直接权限的部门插入临时表 #ManagerDept
            FROM    ( SELECT    a.DeptCode ,
                                a.DeptLevel ,
                                a.ParentDeptCode
                      FROM      Department AS a
                                JOIN GiveRight_Dept AS b ON b.DeptCode = a.DeptCode
                                                           AND b.UserId = @UserId
                                                           AND b.DeleteFlag = 0
                      WHERE     a.DeleteFlag = 0
                      UNION
                      SELECT    DeptCode ,
                                DeptLevel ,
                                ParentDeptCode
                      FROM      Department
                      WHERE     ( DeptManager = @UserId
                                  OR DeptSecretary = @UserId
                                )
                    ) T;

            --所有权限部门下人员插入临时表 #ManagerAllDeptUser
            WITH    dep
                      AS ( SELECT  DeptCode ,
                                   DeptLevel ,
                                   ParentDeptCode
                           FROM     #ManagerDept
                           UNION  ALL
                           SELECT   a.DeptCode ,
                                    a.DeptLevel ,
                                    a.ParentDeptCode
                           FROM     dbo.Department a
                                    INNER JOIN dep b ON a.ParentDeptCode = b.DeptCode
                           WHERE    a.DeleteFlag = 0
                         )
                INSERT  INTO #ManagerAllDeptUser
                        SELECT  b.Code
                        FROM    dep AS a 
                        JOIN dbo.UserInfo AS b ON a.DeptCode=b.DeptCode

       

--从初步筛选过的明细表 查询有权限的数据
DECLARE @sql_DetailTable_temp VARCHAR(1000);
SET @sql_DetailTable_temp = 'select * into #DetailTableRight_temp from (SELECT * FROM  #DetailTable_temp  where 1=0 ';
IF ( EXISTS ( SELECT   1
               FROM     #ManagerAllProcuct
               WHERE    ProLevel = 1 ) )
    BEGIN
        SET @sql_DetailTable_temp = @sql_DetailTable_temp + 'union
        SELECT a.* FROM  #DetailTable_temp AS a 
        JOIN #ManagerAllProcuct AS b ON a.ProductLineCode=b.ProCode AND b.ProLevel=1';
    END;
IF ( EXISTS ( SELECT   1
               FROM     #ManagerAllProcuct
               WHERE    ProLevel = 2 ) )
    BEGIN
        SET @sql_DetailTable_temp = @sql_DetailTable_temp + 'union
        SELECT a.* FROM  #DetailTable_temp AS a 
        JOIN #ManagerAllProcuct AS b ON a.PDTCode=b.ProCode AND b.ProLevel=2';
    END;
IF ( EXISTS ( SELECT   1
               FROM     #ManagerAllProcuct
               WHERE    ProLevel = 3 ) )
    BEGIN
        SET @sql_DetailTable_temp = @sql_DetailTable_temp + 'union
        SELECT a.* FROM  #DetailTable_temp AS a 
        JOIN #ManagerAllProcuct AS b ON a.BVersionCode=b.ProCode AND b.ProLevel=3';
    END;
IF ( EXISTS ( SELECT   1
               FROM     #ManagerAllProcuct
               WHERE    ProLevel = 4 ) )
    BEGIN
        SET @sql_DetailTable_temp = @sql_DetailTable_temp + 'union
        SELECT a.* FROM  #DetailTable_temp AS a 
        JOIN #ManagerAllProcuct AS b ON a.SecondProCode=b.ProCode AND b.ProLevel=4';
    END;
IF ( EXISTS ( SELECT   1
               FROM     #ManagerAllProcuct
               WHERE    ProLevel = 5 ) )
    BEGIN
        SET @sql_DetailTable_temp = @sql_DetailTable_temp + 'union
        SELECT a.* FROM  #DetailTable_temp AS a 
        JOIN #ManagerAllProcuct AS b ON a.ThirdProCode=b.ProCode AND b.ProLevel=5';
    END;
IF ( EXISTS ( SELECT   1
               FROM     #ManagerAllProcuct
               WHERE    ProLevel = 6 ) )
    BEGIN
        SET @sql_DetailTable_temp = @sql_DetailTable_temp + 'union
        SELECT a.* FROM  #DetailTable_temp AS a 
        JOIN #ManagerAllProcuct AS b ON a.FourthProCode=b.ProCode AND b.ProLevel=6';
    END;
    SET @sql_DetailTable_temp = @sql_DetailTable_temp + ')m'
    Exec Sp_ExecuteSql @sql_DetailTable_temp

      END;

--为部门主管和部门秘书时能看到部门下人员所有反馈的项目，部门下人员直接跟明细表关联查询


            --INSERT  INTO #temp_table
   --         ( Row_ID ,SecondDeptName ,DName ,UserName ,UserCode ,mon_date ,ProductLineName ,PDTName ,PDTCode ,FirstProCode ,FirstProName ,
   --             SecondProCode ,SecondProName ,Station ,StationName,sumPer ,sumMon ,ispdt,DeptCode , SecondDeptCode,ProductLineCode ,ThirdProName ,ThirdProCode ,
   --             FourthProName ,FourthProCode,PCodeShare,FirstProCodeShare,SecondProCodeShare,ThirdProCodeShare,FourthProCodeShare,StationNameShow,SumAll,Counts
   --         )
   --         EXEC [dbo].[P_WorkHourDetailView] 0,0, @startDate, @endDate, @ProjectLevel, @IsPDT, @UserId, @SysRole,'','',@projectCode,@station,@proTreeNode,@deptTreeNode,@RowID,'false',@ProductLineCode,@PDTCode,@FirstProCode,@SecondProCode ,@ThirdProCode ,@FourthProCode ,'','';

--select * from #temp_table
            --rowID选中 应用于导出勾选
    declare @contion varchar(max);
    if(@SelRowID<>'')
    begin
    DECLARE @Split_RowID NVARCHAR(MAX);
        if(CHARINDEX(',',@SelRowID)>0)
    begin
    set @Split_RowID='select tableColumn from F_SplitStrToTable('''+@SelRowID+''')';
    end
    else
    begin
    set @Split_RowID=''''+isnull(@SelRowID,'')+'''';
    end
    set @contion='where RowID  in ('+@Split_RowID+')';
    end

    set @sql='';
    set @sql=@sql+'SELECT ISNULL( ROW_NUMBER() OVER(ORDER BY PDTCode,FirstProCode,SecondProCode,ThirdProCode,FourthProCode),0) rowID,
                mon_date,ProductLineName ,ProductLineCode,PDTName,PDTCode,FirstProName,FirstProCode,SecondProName,
                SecondProCode,ThirdProName,ThirdProCode,FourthProName,FourthProCode,SUM(sumPer/sumMon) SAP into #SelectAllPro FROM #temp_table
        GROUP BY mon_date,ProductLineName ,ProductLineCode,PDTName,PDTCode,FirstProName,FirstProCode,SecondProName,
                SecondProCode,ThirdProName,ThirdProCode,FourthProName,FourthProCode;

        select mon_date,sum(SAP) as SumAll into #SelectAllPer from #SelectAllPro group by mon_date;

        select a.*,b.SumAll from #SelectAllPro a inner join #SelectAllPer b on a.mon_date=b.mon_date '+isnull(@contion,'');  

        
    --  select @sql;
        Exec Sp_ExecuteSql @SQL
    
        DROP TABLE #temp_table;

    END;


GO



