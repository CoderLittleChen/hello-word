USE [PersonalInput]
GO

/****** Object:  StoredProcedure [dbo].[P_PersonalMonthView]    Script Date: 2020/1/15 9:04:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER PROC [dbo].[P_PersonalMonthView]
    @code NVARCHAR(200) , --员工code
    @month NVARCHAR(200) ,  --yyyy-MM	
    @ProjectLevel VARCHAR(50) ,--项目级别
    @conditionFlag VARCHAR(10) ,--筛选条件   
    @date VARCHAR(100) ,--指定查询某一天   
    @projectCode VARCHAR(100) ,--项目Code  
    @proTreeNode NVARCHAR(MAX) --产品树选中数据    
AS
    BEGIN 
	--创建临时表	
	create table   #AllData  
	(
		ProductLineID uniqueidentifier ,
        ProductLineCode nvarchar(100),
        ProductLineName nvarchar(100),
        PDTID uniqueidentifier,
        PDTCode nvarchar(100),
        PDTName nvarchar(100),
        FirstProID uniqueidentifier,
        FirstProCode nvarchar(100),
        FirstProName nvarchar(100),
        SecondProID uniqueidentifier,
        SecondProCode nvarchar(100),
        SecondProName nvarchar(100),
        ThirdProID uniqueidentifier,
        ThirdProCode nvarchar(100),
        ThirdProName nvarchar(100),
        FourthProID uniqueidentifier,
        FourthProCode nvarchar(100),
        FourthProName nvarchar(100),
        BillNo nvarchar(100),
        CreateTime datetime,
        UserCode nvarchar(100),
        UserName nvarchar(100),
        IsFrozen int,
        HMain_ID int,
        ProID uniqueidentifier,
        Date datetime,
        Percents DECIMAL(18, 2),
        DayOfWeek int,
        FillState nvarchar(100),
        IsLeave int,
        Remark nvarchar(1000),
        isReView int,
        IsWorkingDay int,
        DeptCode nvarchar(100),
        DeptName nvarchar(100),
        SecondDeptCode nvarchar(100),
        SecondDeptName nvarchar(100),
        StationName nvarchar(100),
        Station nvarchar(100)
	)
		--进行条件判断
		DECLARE @firstDayOfCurrentMonth datetime;
		DECLARE @firstDayOfCheckedMonth datetime;
		DECLARE @monday nvarchar(20);
		DECLARE @monthDiff int;
		set @firstDayOfCurrentMonth= CONVERT(datetime,convert(nvarchar(7),DATEADD(month,-1,getdate()),120)+'-01',20);
		set @monday=dbo.GetMondayByDate(@firstDayOfCurrentMonth)
		set @firstDayOfCheckedMonth=CONVERT(datetime,@month+'-01',20)
		set @monthDiff=DATEDIFF(month,@firstDayOfCheckedMonth,GETDATE());


		if @monthDiff<2
			begin
				--只查正式表
				insert into      #AllData
        SELECT  ISNULL(b.ProductLineID, '00000000-0000-0000-0000-000000000000') ProductLineID ,
                ISNULL(b.ProductLineCode, '') ProductLineCode ,
                ISNULL(b.ProductLineName, '') ProductLineName ,
                ISNULL(b.PDTID, '00000000-0000-0000-0000-000000000000') PDTID ,
                ISNULL(b.PDTCode, '') PDTCode ,
                ISNULL(b.PDTName, '') PDTName ,
                ISNULL(b.FirstProID, '00000000-0000-0000-0000-000000000000') FirstProID ,
                ISNULL(b.FirstProCode, '') FirstProCode ,
                ISNULL(b.FirstProName, '') FirstProName ,
                ISNULL(b.SecondProID, '00000000-0000-0000-0000-000000000000') SecondProID ,
                ISNULL(b.SecondProCode, '') SecondProCode ,
                ISNULL(b.SecondProName, '') SecondProName ,
                ISNULL(b.ThirdProID, '00000000-0000-0000-0000-000000000000') ThirdProID ,
                ISNULL(b.ThirdProCode, '') ThirdProCode ,
                ISNULL(b.ThirdProName, '') ThirdProName ,
                ISNULL(b.FourthProID, '00000000-0000-0000-0000-000000000000') FourthProID ,
                ISNULL(b.FourthProCode, '') FourthProCode ,
                ISNULL(b.FourthProName, '') FourthProName ,
                b.BillNo ,
                b.CreateTime ,
                ISNULL(b.UserCode, c.Code) UserCode ,
                ISNULL(b.UserName, c.Name) UserName ,
                b.IsFrozen ,
                b.HMain_ID ,
                ISNULL(b.ProID, '00000000-0000-0000-0000-000000000000') ProID ,
                a.Date ,
                CAST(ISNULL(b.Percents, 0) AS DECIMAL(18, 2)) / 100 Percents ,
                b.DayOfWeek ,
                CASE ISNULL(b.FillState, 2)
                  WHEN 2 THEN '未填写'
                  WHEN 0 THEN '已填写'
                  WHEN 1 THEN '返回修改'
                END FillState ,
                b.IsLeave ,
                b.Remark ,
                ISNULL(b.IsReview, 0) isReView ,
                a.IsWorkingDay ,
                d.DeptCode ,
                d.DeptName ,
                d.SecondDeptCode ,
                d.SecondDeptName ,
                f.Name StationName ,
                c.Station
        FROM    dbo.DateSetting a
                LEFT JOIN ( SELECT  hm.BillNo ,
                                    hm.CreateTime ,
                                    hm.UserCode ,
                                    hm.UserName ,
                                    hm.IsFrozen ,
                                    hi.HMain_ID ,
                                    hi.ProID ,
                                    hi.Date ,
                                    hi.Percents ,
                                    hi.DayOfWeek ,
                                    hi.FillState ,
                                    hi.IsLeave ,
                                    hi.Remark ,
                                    hi.IsReview ,
                                    p.ProductLineID ,
                                    p.ProductLineCode ,
                                    p.ProductLineName ,
                                    p.PDTID ,
                                    p.PDTCode ,
                                    p.PDTName ,
                                    p.FirstProID ,
                                    p.FirstProCode ,
                                    p.FirstProName ,
                                    p.SecondProID ,
                                    p.SecondProCode ,
                                    p.SecondProName ,
                                    p.ThirdProID ,
                                    p.ThirdProCode ,
                                    p.ThirdProName ,
                                    p.FourthProID ,
                                    p.FourthProCode ,
                                    p.FourthProName
                            FROM    dbo.HourInfoMain hm
                                    INNER JOIN dbo.HourInfo_New hi ON hi.HMain_ID = hm.id
                                    LEFT JOIN ProductInfo_Display p ON  p.Current_ProId=hi.ProID
                            WHERE   hm.UserCode = @code
                                    AND SUBSTRING(CONVERT(NVARCHAR(200), hi.Date, 23),
                                                  0, 8) = @month
                                    AND hi.DeleteFlag = 0
                          ) b ON a.Date = b.Date
                LEFT JOIN ( SELECT  *
                            FROM    dbo.UserInfo
                            WHERE   Code = @code
                          ) c ON 1 = 1
                LEFT JOIN dbo.Department d ON c.DeptCode = d.DeptCode
                LEFT JOIN dbo.StationCategory f ON c.Station = f.Code
        WHERE   SUBSTRING(CONVERT(NVARCHAR(200), a.Date, 23), 0, 8) = @month
				AND a.Date>=c.HireDate
				AND a.Date<=GETDATE()  AND (a.IsWorkingDay=0 OR (a.IsWorkingDay!=0 AND b.FillState IS NOT NULL));
			end
        else if @monthDiff=2
			begin
				--查询备份表和正式表
				insert into      #AllData
        SELECT  ISNULL(b.ProductLineID, '00000000-0000-0000-0000-000000000000') ProductLineID ,
                ISNULL(b.ProductLineCode, '') ProductLineCode ,
                ISNULL(b.ProductLineName, '') ProductLineName ,
                ISNULL(b.PDTID, '00000000-0000-0000-0000-000000000000') PDTID ,
                ISNULL(b.PDTCode, '') PDTCode ,
                ISNULL(b.PDTName, '') PDTName ,
                ISNULL(b.FirstProID, '00000000-0000-0000-0000-000000000000') FirstProID ,
                ISNULL(b.FirstProCode, '') FirstProCode ,
                ISNULL(b.FirstProName, '') FirstProName ,
                ISNULL(b.SecondProID, '00000000-0000-0000-0000-000000000000') SecondProID ,
                ISNULL(b.SecondProCode, '') SecondProCode ,
                ISNULL(b.SecondProName, '') SecondProName ,
                ISNULL(b.ThirdProID, '00000000-0000-0000-0000-000000000000') ThirdProID ,
                ISNULL(b.ThirdProCode, '') ThirdProCode ,
                ISNULL(b.ThirdProName, '') ThirdProName ,
                ISNULL(b.FourthProID, '00000000-0000-0000-0000-000000000000') FourthProID ,
                ISNULL(b.FourthProCode, '') FourthProCode ,
                ISNULL(b.FourthProName, '') FourthProName ,
                b.BillNo ,
                b.CreateTime ,
                ISNULL(b.UserCode, c.Code) UserCode ,
                ISNULL(b.UserName, c.Name) UserName ,
                b.IsFrozen ,
                b.HMain_ID ,
                ISNULL(b.ProID, '00000000-0000-0000-0000-000000000000') ProID ,
                a.Date ,
                CAST(ISNULL(b.Percents, 0) AS DECIMAL(18, 2)) / 100 Percents ,
                b.DayOfWeek ,
                CASE ISNULL(b.FillState, 2)
                  WHEN 2 THEN '未填写'
                  WHEN 0 THEN '已填写'
                  WHEN 1 THEN '返回修改'
                END FillState ,
                b.IsLeave ,
                b.Remark ,
                ISNULL(b.IsReview, 0) isReView ,
                a.IsWorkingDay ,
                d.DeptCode ,
                d.DeptName ,
                d.SecondDeptCode ,
                d.SecondDeptName ,
                f.Name StationName ,
                c.Station
        FROM    dbo.DateSetting a  
                LEFT JOIN ( SELECT  hm.BillNo ,
                                    hm.CreateTime ,
                                    hm.UserCode ,
                                    hm.UserName ,
                                    hm.IsFrozen ,
                                    hi.HMain_ID ,
                                    hi.ProID ,
                                    hi.Date ,
                                    hi.Percents ,
                                    hi.DayOfWeek ,
                                    hi.FillState ,
                                    hi.IsLeave ,
                                    hi.Remark ,
                                    hi.IsReview ,
                                    p.ProductLineID ,
                                    p.ProductLineCode ,
                                    p.ProductLineName ,
                                    p.PDTID ,
                                    p.PDTCode ,
                                    p.PDTName ,
                                    p.FirstProID ,
                                    p.FirstProCode ,
                                    p.FirstProName ,
                                    p.SecondProID ,
                                    p.SecondProCode ,
                                    p.SecondProName ,
                                    p.ThirdProID ,
                                    p.ThirdProCode ,
                                    p.ThirdProName ,
                                    p.FourthProID ,
                                    p.FourthProCode ,
                                    p.FourthProName
                            FROM    dbo.HourInfoMain hm
                                    INNER JOIN dbo.HourInfo_New hi ON hi.HMain_ID = hm.id
                                    LEFT JOIN ProductInfo_Display p ON  p.Current_ProId=hi.ProID
                            WHERE   hm.UserCode = @code
                                    AND SUBSTRING(CONVERT(NVARCHAR(200), hi.Date, 23),
                                                  0, 8) = @month
                                    AND hi.DeleteFlag = 0
                          ) b ON a.Date = b.Date
                LEFT JOIN ( SELECT  *
                            FROM    dbo.UserInfo
                            WHERE   Code = @code
                          ) c ON 1 = 1
                LEFT JOIN dbo.Department d ON c.DeptCode = d.DeptCode
                LEFT JOIN dbo.StationCategory f ON c.Station = f.Code
        WHERE   SUBSTRING(CONVERT(NVARCHAR(200), a.Date, 23), 0, 8) = @month
				AND a.Date>=c.HireDate
				AND a.Date<=GETDATE()  AND (a.IsWorkingDay=0 OR (a.IsWorkingDay!=0 AND b.FillState IS NOT NULL))
				and  a.Date>=@monday -- And  DATEDIFF(MONTH,a.Date,@firstDayOfCheckedMonth)=0  
		union   all
	SELECT  ISNULL(b.ProductLineID, '00000000-0000-0000-0000-000000000000') ProductLineID ,
                ISNULL(b.ProductLineCode, '') ProductLineCode ,
                ISNULL(b.ProductLineName, '') ProductLineName ,
                ISNULL(b.PDTID, '00000000-0000-0000-0000-000000000000') PDTID ,
                ISNULL(b.PDTCode, '') PDTCode ,
                ISNULL(b.PDTName, '') PDTName ,
                ISNULL(b.FirstProID, '00000000-0000-0000-0000-000000000000') FirstProID ,
                ISNULL(b.FirstProCode, '') FirstProCode ,
                ISNULL(b.FirstProName, '') FirstProName ,
                ISNULL(b.SecondProID, '00000000-0000-0000-0000-000000000000') SecondProID ,
                ISNULL(b.SecondProCode, '') SecondProCode ,
                ISNULL(b.SecondProName, '') SecondProName ,
                ISNULL(b.ThirdProID, '00000000-0000-0000-0000-000000000000') ThirdProID ,
                ISNULL(b.ThirdProCode, '') ThirdProCode ,
                ISNULL(b.ThirdProName, '') ThirdProName ,
                ISNULL(b.FourthProID, '00000000-0000-0000-0000-000000000000') FourthProID ,
                ISNULL(b.FourthProCode, '') FourthProCode ,
                ISNULL(b.FourthProName, '') FourthProName ,
                b.BillNo ,
                b.CreateTime ,
                ISNULL(b.UserCode, c.Code) UserCode ,
                ISNULL(b.UserName, c.Name) UserName ,
                b.IsFrozen ,
                b.HMain_ID ,
                ISNULL(b.ProID, '00000000-0000-0000-0000-000000000000') ProID ,
                a.Date ,
                CAST(ISNULL(b.Percents, 0) AS DECIMAL(18, 2)) / 100 Percents ,
                b.DayOfWeek ,
                CASE ISNULL(b.FillState, 2)
                  WHEN 2 THEN '未填写'
                  WHEN 0 THEN '已填写'
                  WHEN 1 THEN '返回修改'
                END FillState ,
                b.IsLeave ,
                b.Remark ,
                ISNULL(b.IsReview, 0) isReView ,
                a.IsWorkingDay ,
                d.DeptCode ,
                d.DeptName ,
                d.SecondDeptCode ,
                d.SecondDeptName ,
                f.Name StationName ,
                c.Station
        FROM    dbo.DateSetting a
                LEFT JOIN ( SELECT  hm.BillNo ,
                                    hm.CreateTime ,
                                    hm.UserCode ,
                                    hm.UserName ,
                                    hm.IsFrozen ,
                                    hi.HMain_ID ,
                                    hi.ProID ,
                                    hi.Date ,
                                    hi.Percents ,
                                    hi.DayOfWeek ,
                                    hi.FillState ,
                                    hi.IsLeave ,
                                    hi.Remark ,
                                    hi.IsReview ,
                                    p.ProductLineID ,
                                    p.ProductLineCode ,
                                    p.ProductLineName ,
                                    p.PDTID ,
                                    p.PDTCode ,
                                    p.PDTName ,
                                    p.FirstProID ,
                                    p.FirstProCode ,
                                    p.FirstProName ,
                                    p.SecondProID ,
                                    p.SecondProCode ,
                                    p.SecondProName ,
                                    p.ThirdProID ,
                                    p.ThirdProCode ,
                                    p.ThirdProName ,
                                    p.FourthProID ,
                                    p.FourthProCode ,
                                    p.FourthProName
                            FROM    dbo.HourInfoMainHistory hm
                                    INNER JOIN dbo.HourInfoDetailHistory hi ON hi.HMain_ID = hm.id
                                    LEFT JOIN ProductInfo_Display p ON p.Current_ProId=hi.ProID
                            WHERE   hm.UserCode = @code
                                    AND SUBSTRING(CONVERT(NVARCHAR(200), hi.Date, 23),
                                                  0, 8) = @month
                                    AND hi.DeleteFlag = 0
                          ) b ON a.Date = b.Date
                LEFT JOIN ( SELECT  *
                            FROM    dbo.UserInfo
                            WHERE   Code = @code
                          ) c ON 1 = 1
                LEFT JOIN dbo.Department d ON c.DeptCode = d.DeptCode
                LEFT JOIN dbo.StationCategory f ON c.Station = f.Code
        WHERE   SUBSTRING(CONVERT(NVARCHAR(200), a.Date, 23), 0, 8) = @month
				AND a.Date>=c.HireDate
				AND a.Date<=GETDATE()  AND (a.IsWorkingDay=0 OR (a.IsWorkingDay!=0 AND b.FillState IS NOT NULL))
				and a.Date<@monday  --AND DATEDIFF(MONTH,a.Date,@firstDayOfCheckedMonth)=0  ;
			end
		else 
			begin
				--查询备份表
				insert into      #AllData
        SELECT  ISNULL(b.ProductLineID, '00000000-0000-0000-0000-000000000000') ProductLineID ,
                ISNULL(b.ProductLineCode, '') ProductLineCode ,
                ISNULL(b.ProductLineName, '') ProductLineName ,
                ISNULL(b.PDTID, '00000000-0000-0000-0000-000000000000') PDTID ,
                ISNULL(b.PDTCode, '') PDTCode ,
                ISNULL(b.PDTName, '') PDTName ,
                ISNULL(b.FirstProID, '00000000-0000-0000-0000-000000000000') FirstProID ,
                ISNULL(b.FirstProCode, '') FirstProCode ,
                ISNULL(b.FirstProName, '') FirstProName ,
                ISNULL(b.SecondProID, '00000000-0000-0000-0000-000000000000') SecondProID ,
                ISNULL(b.SecondProCode, '') SecondProCode ,
                ISNULL(b.SecondProName, '') SecondProName ,
                ISNULL(b.ThirdProID, '00000000-0000-0000-0000-000000000000') ThirdProID ,
                ISNULL(b.ThirdProCode, '') ThirdProCode ,
                ISNULL(b.ThirdProName, '') ThirdProName ,
                ISNULL(b.FourthProID, '00000000-0000-0000-0000-000000000000') FourthProID ,
                ISNULL(b.FourthProCode, '') FourthProCode ,
                ISNULL(b.FourthProName, '') FourthProName ,
                b.BillNo ,
                b.CreateTime ,
                ISNULL(b.UserCode, c.Code) UserCode ,
                ISNULL(b.UserName, c.Name) UserName ,
                b.IsFrozen ,
                b.HMain_ID ,
                ISNULL(b.ProID, '00000000-0000-0000-0000-000000000000') ProID ,
                a.Date ,
                CAST(ISNULL(b.Percents, 0) AS DECIMAL(18, 2)) / 100 Percents ,
                b.DayOfWeek ,
                CASE ISNULL(b.FillState, 2)
                  WHEN 2 THEN '未填写'
                  WHEN 0 THEN '已填写'
                  WHEN 1 THEN '返回修改'
                END FillState ,
                b.IsLeave ,
                b.Remark ,
                ISNULL(b.IsReview, 0) isReView ,
                a.IsWorkingDay ,
                d.DeptCode ,
                d.DeptName ,
                d.SecondDeptCode ,
                d.SecondDeptName ,
                f.Name StationName ,
                c.Station
        FROM    dbo.DateSetting a
                LEFT JOIN ( SELECT  hm.BillNo ,
                                    hm.CreateTime ,
                                    hm.UserCode ,
                                    hm.UserName ,
                                    hm.IsFrozen ,
                                    hi.HMain_ID ,
                                    hi.ProID ,
                                    hi.Date ,
                                    hi.Percents ,
                                    hi.DayOfWeek ,
                                    hi.FillState ,
                                    hi.IsLeave ,
                                    hi.Remark ,
                                    hi.IsReview ,
                                    p.ProductLineID ,
                                    p.ProductLineCode ,
                                    p.ProductLineName ,
                                    p.PDTID ,
                                    p.PDTCode ,
                                    p.PDTName ,
                                    p.FirstProID ,
                                    p.FirstProCode ,
                                    p.FirstProName ,
                                    p.SecondProID ,
                                    p.SecondProCode ,
                                    p.SecondProName ,
                                    p.ThirdProID ,
                                    p.ThirdProCode ,
                                    p.ThirdProName ,
                                    p.FourthProID ,
                                    p.FourthProCode ,
                                    p.FourthProName
                            FROM    dbo.HourInfoMainHistory hm
                                    INNER JOIN dbo.HourInfoDetailHistory hi ON hi.HMain_ID = hm.id
                                    LEFT JOIN ProductInfo_Display p ON  p.Current_ProId=hi.ProID
                            WHERE   hm.UserCode = @code
                                    AND SUBSTRING(CONVERT(NVARCHAR(200), hi.Date, 23),
                                                  0, 8) = @month
                                    AND hi.DeleteFlag = 0
                          ) b ON a.Date = b.Date
                LEFT JOIN ( SELECT  *
                            FROM    dbo.UserInfo
                            WHERE   Code = @code
                          ) c ON 1 = 1
                LEFT JOIN dbo.Department d ON c.DeptCode = d.DeptCode
                LEFT JOIN dbo.StationCategory f ON c.Station = f.Code
        WHERE   SUBSTRING(CONVERT(NVARCHAR(200), a.Date, 23), 0, 8) = @month
				AND a.Date>=c.HireDate
				AND a.Date<=GETDATE()  AND (a.IsWorkingDay=0 OR (a.IsWorkingDay!=0 AND b.FillState IS NOT NULL));
			end
        DECLARE @SQL NVARCHAR(MAX);
        DECLARE @conWhere NVARCHAR(MAX);

        SET @conWhere = '';
		
        IF ( CHARINDEX('5', @conditionFlag) > 0 )
            BEGIN
                SET @conWhere = ' Where (FillState=''未填写''  or FillState=''返回修改''   ';
            END; 

        

        IF ( CHARINDEX('6', @conditionFlag) > 0 )
            BEGIN
                IF @conWhere = ''
                    BEGIN
                        SET @conWhere = ' Where (FillState=''返回修改'' ';
                    END; 
                ELSE
                    BEGIN
                        SET @conWhere = @conWhere + ' OR FillState=''返回修改'' ';
                    END; 
            END; 

        

        IF @conWhere != ''
            BEGIN 
                SET @conWhere = @conWhere + ' )';
            END; 



        --IF ( CHARINDEX('5,6,7,8', @conditionFlag) > 0 )
        --    BEGIN
        --        SET @conWhere = '';
        --    END;

        --IF ( CHARINDEX('5,6,7', @conditionFlag) > 0
        --     AND CHARINDEX('8', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        SET @conWhere = ' where (isReView=0 and FillState=''返回修改'') or (isReView=0 and FillState=''返回修改'') ';
        --    END;

        --IF ( CHARINDEX('5,6', @conditionFlag) > 0
        --     AND CHARINDEX('8', @conditionFlag) > 0
        --     AND CHARINDEX('7', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        SET @conWhere = ' where (isReView=0 and FillState=''已填写'') or (isReView=1 and FillState=''已填写'') ';
        --    END;

        --IF ( CHARINDEX('5', @conditionFlag) > 0
        --     AND CHARINDEX('7,8', @conditionFlag) > 0
        --     AND CHARINDEX('6', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        SET @conWhere = ' where (isReView=0 and FillState=''返回修改'') or (isReView=0 and FillState=''已填写'') ';
        --    END;

        --IF ( CHARINDEX('6,7,8', @conditionFlag) > 0
        --     AND CHARINDEX('5', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        SET @conWhere = ' where (isReView=1 and FillState=''已填写'') or (isReView=1 and FillState=''返回修改'') ';
        --    END;

        --IF ( CHARINDEX('5', @conditionFlag) > 0
        --     AND CHARINDEX('8', @conditionFlag) > 0
        --     AND CHARINDEX('6,7', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or (isReView=0 and FillState=''已填写'') ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' where (isReView=0 and FillState=''已填写'') ';
        --            END;
        --    END;

        --IF ( CHARINDEX('6', @conditionFlag) > 0
        --     AND CHARINDEX('8', @conditionFlag) > 0
        --     AND CHARINDEX('5', @conditionFlag) < 1
        --     AND CHARINDEX('7', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
						
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or (isReView=1 and FillState=''已填写'') ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' where isReView=1 and FillState=''已填写'' ';
        --            END;
        --    END;

        --IF ( CHARINDEX('5', @conditionFlag) > 0
        --     AND CHARINDEX('7', @conditionFlag) > 0
        --     AND CHARINDEX('6', @conditionFlag) < 1
        --     AND CHARINDEX('8', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN

        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or (isReView=0 and FillState=''返回修改'') ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' where isReView=0 and FillState=''返回修改'' ';
        --            END;
        --    END;

        --IF ( CHARINDEX('5,6', @conditionFlag) > 0
        --     AND CHARINDEX('7,8', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN

        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or (isReView=0 or isReView=1) ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' where isReView=0 or isReView=1 ';
        --            END;
        --    END;

        --IF ( CHARINDEX('5,6', @conditionFlag) < 1
        --     AND CHARINDEX('7,8', @conditionFlag) > 0
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN

        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or (FillState=0 or FillState=''返回修改'' )';

        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' where FillState=0 or FillState=''返回修改'' ';

        --            END;
        --    END;

        --IF ( CHARINDEX('6,7', @conditionFlag) > 0
        --     AND CHARINDEX('5', @conditionFlag) < 1
        --     AND CHARINDEX('8', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or (isReView=1 and FillState=''返回修改'') ';
        --            END;
        --        ELSE
        --            BEGIN

        --                SET @conWhere = ' where isReView=1 and FillState=''返回修改'' ';
        --            END;
        --    END;

        --IF ( CHARINDEX('5', @conditionFlag) > 0
        --     AND CHARINDEX('7', @conditionFlag) < 1
        --     AND CHARINDEX('8', @conditionFlag) < 1
        --     AND CHARINDEX('6', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + 'or isReView=0 ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = 'where isReView=0 ';
        --            END;
        --    END;

        --IF ( CHARINDEX('6', @conditionFlag) > 0
        --     AND CHARINDEX('7', @conditionFlag) < 1
        --     AND CHARINDEX('8', @conditionFlag) < 1
        --     AND CHARINDEX('5', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or  isReView=1 ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' where isReView=1  ';
        --            END;

        --    END;

        --IF ( CHARINDEX('7', @conditionFlag) > 0
        --     AND CHARINDEX('5', @conditionFlag) < 1
        --     AND CHARINDEX('8', @conditionFlag) < 1
        --     AND CHARINDEX('6', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or FillState=''返回修改'' ';
        --            END;
        --        ELSE
        --            BEGIN

        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' where FillState=''返回修改'' ';
        --            END;

        --    END;

        --IF ( CHARINDEX('8', @conditionFlag) > 0
        --     AND CHARINDEX('5', @conditionFlag) < 1
        --     AND CHARINDEX('7', @conditionFlag) < 1
        --     AND CHARINDEX('6', @conditionFlag) < 1
        --   )
        --    BEGIN
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' or FillState=''已填写'' ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' where FillState=''已填写'' ';
        --            END;
        --    END;

        IF ( @date <> '' )
            BEGIN
                IF ( @conWhere <> '' )
                    BEGIN
                        SET @conWhere = ISNULL(@conWhere, '')
                            + ' AND  YEAR(''' + @date
                            + ''') = YEAR(Date) AND MONTH(''' + @date
                            + ''') = MONTH(Date) AND DAY(''' + @date
                            + ''') = DAY(Date)';
                    END;
                ELSE
                    BEGIN
                        SET @conWhere = ' WHERE  YEAR(''' + @date
                            + ''') = YEAR(Date) AND MONTH(''' + @date
                            + ''') = MONTH(Date)  AND DAY(''' + @date
                            + ''') = DAY(Date)';
                    END;
            END;

	
        IF ( @projectCode <> '' )
            BEGIN
                IF ( @conWhere <> '' )
                    BEGIN
                        SET @conWhere = ISNULL(@conWhere, '')
                            + ' and (FirstProCode=''' + @projectCode
                            + ''' OR SecondProCode=''' + @projectCode
                            + ''' OR ThirdProCode=''' + @projectCode
                            + ''' OR FourthProCode=''' + @projectCode + ''')';
                    END;
                ELSE
                    BEGIN
                        SET @conWhere = ' WHERE FirstProCode='''
                            + @projectCode + ''' OR SecondProCode='''
                            + @projectCode + ''' OR ThirdProCode='''
                            + @projectCode + ''' OR FourthProCode='''
                            + @projectCode + '''';
                    END;
            END; 

	    --ys2338 注释原有 start
        --IF ( @proTreeNode <> '' )
        --    BEGIN	
        --        IF ( @conWhere <> '' )
        --            BEGIN
        --                SET @conWhere = ISNULL(@conWhere, '')
        --                    + ' and (charindex(FirstProCode,''' + @proTreeNode
        --                    + ''')>0 ' + ' OR charindex(SecondProCode,'''
        --                    + @proTreeNode + ''')>0 '
        --                    + ' OR charindex(ThirdProCode,''' + @proTreeNode
        --                    + ''')>0' + ' OR charindex(FourthProCode,'''
        --                    + @proTreeNode + ''')>0) ';
        --            END;
        --        ELSE
        --            BEGIN
        --                SET @conWhere = ' WHERE charindex(FirstProCode,'''
        --                    + @proTreeNode + ''')>0 '
        --                    + ' OR charindex(SecondProCode,''' + @proTreeNode
        --                    + ''')>0 ' + ' OR charindex(ThirdProCode,'''
        --                    + @proTreeNode + ''')>0'
        --                    + ' OR charindex(FourthProCode,''' + @proTreeNode
        --                    + ''')>0 ';
        --            END;
        --    END;
			--ys2338 注释原有 end

			--ys2338 目前改为拼接好的字符串 start
				DECLARE @Split_proTreeNode NVARCHAR(MAX);
				if(@proTreeNode<>'' )
					begin
					set @Split_proTreeNode=@proTreeNode;
					end
				--else
				--	begin
				--	set @Split_proTreeNode=''''+isnull(@proTreeNode,'')+'''';
				--	end
				
				IF @Split_proTreeNode<>''
				BEGIN
						IF ( @conWhere <> '' )
							BEGIN
								SET @conWhere = ISNULL(@conWhere, '')
									+ ' and (ProCode in ('+@Split_proTreeNode+'))' 
									;
							END;
						ELSE
							BEGIN
								SET @conWhere = ' WHERE (ProCode in ('+@Split_proTreeNode+')) '
									;
							END;
				END
			--ys2338 目前改为拼接好的字符串 end
	   
										
        IF ( @ProjectLevel = '2' )
            BEGIN
                SET @SQL = 'SELECT ROW_NUMBER() OVER( ORDER BY Date,HMain_ID) RowID, SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID ,SUM(Percents) Percents,IsLeave,StationName,ReMark,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,SecondProID ,SecondProCode  , 
                                        SecondProName  ,Convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000'') ThirdProID,'''' ThirdProName ,
										'''' ThirdProCode ,Convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000'') FourthProID,'''' FourthProName,'''' FourthProCode,  
                                        DeptCode,SecondDeptCode,ProductLineCode,Station FROM  #AllData  '
                    + @conWhere
                    + '  GROUP BY SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID ,IsLeave,StationName,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,SecondProID ,SecondProCode  , 
                                        SecondProName  , 
                                        DeptCode,SecondDeptCode,ProductLineCode,Station,ReMark;';
		
            END;	
        ELSE
            IF ( @ProjectLevel = '3' )
                BEGIN
                    SET @SQL = 'SELECT ROW_NUMBER() OVER( ORDER BY Date,HMain_ID) RowID, SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID ,SUM(Percents) Percents,IsLeave,StationName,ReMark,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,SecondProID ,SecondProCode  , 
                                        SecondProName ,ThirdProID, ThirdProName ,ThirdProCode,Convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000'') FourthProID,
										'''' FourthProName,'''' FourthProCode,  
                                        DeptCode,SecondDeptCode,ProductLineCode,Station FROM  #AllData  '
                        + @conWhere
                        + '  GROUP BY SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID ,IsLeave,StationName,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,SecondProID ,SecondProCode  , 
                                        SecondProName  , ThirdProID, ThirdProName ,ThirdProCode,
                                        DeptCode,SecondDeptCode,ProductLineCode,Station,ReMark;';                    
                END;	
            ELSE
                IF ( @ProjectLevel = '4' )
                    BEGIN
                        SET @SQL = 'SELECT ROW_NUMBER() OVER( ORDER BY Date,HMain_ID) RowID, SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID , Percents,IsLeave,StationName,Remark,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,SecondProID ,SecondProCode  , 
                                        SecondProName ,ThirdProID, ThirdProName ,ThirdProCode,FourthProID, FourthProName,FourthProCode,  
                                        DeptCode,SecondDeptCode,ProductLineCode,Station FROM  #AllData  '
                            + @conWhere
                            --+ '  GROUP BY SecondDeptName , DeptName,UserName,UserCode,
                            --            Date,FillState,isReview,BillNo,HMain_ID ,Percents,IsLeave,
                            --            ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,SecondProID ,SecondProCode  , 
                            --            SecondProName , ThirdProID, ThirdProName ,ThirdProCode,FourthProID, FourthProName,FourthProCode,  
                            --            DeptCode,SecondDeptCode,ProductLineCode,Station;';                          
                    END;	
                ELSE
                    BEGIN
                        SET @SQL = 'SELECT ROW_NUMBER() OVER( ORDER BY Date,HMain_ID) RowID, SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID , SUM(Percents) Percents,IsLeave,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName ,
										Convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000'') SecondProID,'''' SecondProCode  , 
                                        '''' SecondProName ,Station,  StationName  ,ReMark,
                                        DeptCode,SecondDeptCode,ProductLineCode,Convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000'') ThirdProID,
										'''' ThirdProName ,'''' ThirdProCode ,Convert(uniqueidentifier,''00000000-0000-0000-0000-000000000000'') FourthProID,
										'''' FourthProName,'''' FourthProCode,  
                                        DeptCode,SecondDeptCode,ProductLineCode,Station FROM  #AllData  '
                            + @conWhere
                            + '  GROUP BY SecondDeptName , DeptName,UserName,UserCode,
                                        Date,FillState,IsReview,BillNo,HMain_ID ,IsLeave, StationName,
                                        ProductLineName , PDTName , PDTCode,FirstProID, FirstProCode  ,FirstProName, 
                                        DeptCode,SecondDeptCode,ProductLineCode,Station,ReMark;'; 
                       
                    END;	
		 			
        EXEC sp_executesql @SQL;
		drop   table  #AllData;
	 --   select @SQL;
    END; 







GO


