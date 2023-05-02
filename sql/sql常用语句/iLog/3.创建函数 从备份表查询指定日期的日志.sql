USE [PersonalInput]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetUserDayPercents]    Script Date: 2019/12/5 16:54:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-------------------------------------分割线-------------------------------------------------------------------------------------


--Create By:chenmin cys2689	
--Deacription:查询指定日期的日志信息   如果是2个月内，查询正式表  超出两个月  查询备份表
--Date:2019.12.05
Alter FUNCTION [dbo].[F_GetUserDayPercentsHistory]
    (
      @user NVARCHAR(200) ,
      @date DATETIME
    ) 
RETURNS @dt TABLE(ID int,HMain_ID int,ProID uniqueidentifier,Date datetime,DayOfWeek int,Percents float,FillState int,IsWorkingDay int,IsLeave int,Creator nvarchar(200),CreateTime Datetime,
Modifier nvarchar(200),ModifyTime datetime,DeleteFlag int,FirstProName nvarchar(200),ProName nvarchar(200),ProCode nvarchar(200),Remark nvarchar(max),SuspendTime datetime,ProDeleteFlag int,ChildCount int,
IsTdms int,TdmsTime datetime)
AS
begin
    DECLARE @tmpDate nvarchar(30)
	if  DATEDIFF(month,@date,GETDATE())<2
		begin
			SELECT top 1 @tmpDate=f.Date
				FROM     ( SELECT    c.Date ,
									ISNULL(b.IsLeave,
										0) IsLeave
							FROM      dbo.DateSetting c
									LEFT JOIN ( SELECT distinct
										e.Creator ,
										e.Date ,
										e.IsLeave ,
										e.DeleteFlag
										FROM
										dbo.V_HourInfo_New e
										WHERE
										e.Creator = @user
										AND e.DeleteFlag = 0
										AND e.Date < @date
										) b ON c.Date = b.Date
							WHERE     c.IsWorkingDay = 0
									AND c.Date < @date
						) f
				WHERE    f.IsLeave != 1
				ORDER BY f.Date DESC


			insert into @dt
			SELECT    op.ID ,
						op.HMain_ID ,
						op.ProID ,
						op.Date ,
						op.DayOfWeek ,
						op.Percents ,
						op.FillState ,
						op.IsWorkingDay ,
						op.IsLeave ,
						op.Creator ,
						op.CreateTime ,
						op.Modifier ,
						op.ModifyTime ,
						op.DeleteFlag ,
						ISNULL(op.FirstProName, '') FirstProName ,
						ISNULL(op.ProName, '') ProName ,
						ISNULL(op.ProCode, '') ProCode ,
						ISNULL(op.Remark, '') Remark ,
						op.SuspendTime ,
						op.ProDeleteFlag ,
						op.ChildCount,
						op.IsTdms ,
						op.TdmsTime
			  FROM      ( SELECT --DISTINCT
									a.Id ,
									a.HMain_ID ,
									a.ProID ,
									a.Date ,
									a.DayOfWeek ,
									a.Percents ,
									a.FillState ,
									a.IsWorkingDay ,
									a.IsLeave ,
									a.Creator ,
									a.CreateTime ,
									a.Modifier ,
									a.ModifyTime ,
									a.DeleteFlag ,
								--	ISNULL(c.FirstProName, '') FirstProName ,
									ISNULL(a.FirstProName,'') FirstProName,
									ISNULL(a.ProName, '') ProName ,
									ISNULL(a.ProCode, '') ProCode ,
									ISNULL(a.Remark, '') Remark ,
									a.SuspendTime ,
									a.ProDeleteFlag,
									(select count(*) from ProductInfo where ParentCode=b.ProCode And DeleteFlag<>1) as ChildCount,--ys2338 新增该字段暂用作查看是否有子集 0 无子集 >0有子集
									a.IsTdms ,
									a.TdmsTime
						  FROM      dbo.V_HourInfo_New a
									INNER JOIN dbo.ProductInfo b ON a.ProID = b.ProID
								--    LEFT JOIN dbo.ProductInfo b ON a.ProID = b.ProID
								--    LEFT JOIN dbo.ProductInfo_Display c ON c.Current_ProId=a.ProID
						  WHERE     a.Date = @date
									AND a.Creator = @user
								--    AND a.DeleteFlag = 0
						  UNION ALL
						  SELECT  --DISTINCT
									a.Id ,
									a.HMain_ID ,
									a.ProID ,
									a.Date ,
									a.DayOfWeek ,
									a.Percents ,
									a.FillState ,
									a.IsWorkingDay ,
									a.IsLeave ,
									a.Creator ,
									a.CreateTime ,
									a.Modifier ,
									a.ModifyTime ,
									a.DeleteFlag ,
								--	ISNULL(c.FirstProName, '') FirstProName ,
									ISNULL(a.FirstProName,'') FirstProName,
									ISNULL(a.ProName, '') ProName ,
									ISNULL(a.ProCode, '') ProCode ,
									ISNULL(a.Remark, '') Remark ,
									a.SuspendTime ,
									a.ProDeleteFlag ,
									(select count(*) from ProductInfo where ParentCode=b.ProCode And DeleteFlag<>1) as ChildCount,--ys2338 新增该字段暂用作查看是否有子集 0 无子集 >0有子集
									a.IsTdms ,
									a.TdmsTime
						  FROM      dbo.V_HourInfo_New a
									INNER JOIN dbo.ProductInfo b ON a.ProID = b.ProID --OR a.ProID = '00000000-0000-0000-0000-000000000000'
								--	LEFT JOIN dbo.ProductInfo_Display c ON c.Current_ProId=a.ProID
						  WHERE     
							  a.Date = @tmpDate
									--a.Date = ( SELECT TOP 1
			   --                                         f.Date
			   --                                FROM     ( SELECT    c.Date ,
			   --                                                     ISNULL(b.IsLeave,
			   --                                                       0) IsLeave
			   --                                           FROM      dbo.DateSetting c
			   --                                                     LEFT JOIN ( SELECT
			   --                                                       e.Creator ,
			   --                                                       e.Date ,
			   --                                                       e.IsLeave ,
			   --                                                       e.DeleteFlag
			   --                                                       FROM
			   --                                                       dbo.V_HourInfo_New e
			   --                                                       WHERE
			   --                                                       e.Creator = @user
			   --                                                       AND e.DeleteFlag = 0
			   --                                                       AND e.Date < @date
			   --                                                       ) b ON c.Date = b.Date
			   --                                           WHERE     c.IsWorkingDay = 0
			   --                                                     AND c.Date < @date
			   --                                         ) f
			   --                                WHERE    f.IsLeave != 1
			   --                                ORDER BY f.Date DESC
			   --                              )
									AND a.Creator = @user
							   --     AND a.DeleteFlag = 0
									AND ( ( ( b.DeleteFlag = 0
											  AND ( b.invalidType IS NULL
													OR b.invalidType = ''
													OR b.invalidType = '2'
												  )
											)
											OR ( b.DeleteFlag = 0
												 AND b.invalidType = 1
												 AND b.ActualSuspendTime IS NOT NULL
												 AND CONVERT(NVARCHAR(200), b.ActualSuspendTime, 23) >= @date
											   )
										  )
										  OR ( b.DeleteFlag = 1
											   AND a.SuspendTime BETWEEN DATEADD(dd,
																	  -DAY(@date) + 1,
																	  @date)
																 AND  DATEADD(MONTH, 1,
																	  DATEADD(dd,
																	  -DAY(@date) + 1,
																	  @date))
											 )
										   OR b.DeleteFlag=2 --ys2338 挂起状态直接使用
										)
						) op
			end
	else 
		begin
		SELECT top 1 @tmpDate=f.Date
		FROM     ( SELECT    c.Date ,
							ISNULL(b.IsLeave,
								0) IsLeave
					FROM      dbo.DateSetting c
							LEFT JOIN ( SELECT distinct
								e.Creator ,
								e.Date ,
								e.IsLeave ,
								e.DeleteFlag
								FROM
								dbo.V_HourInfoDetailHistory e
								WHERE
								e.Creator = @user
								AND e.DeleteFlag = 0
								AND e.Date < @date
								) b ON c.Date = b.Date
					WHERE     c.IsWorkingDay = 0
							AND c.Date < @date
				) f
		WHERE    f.IsLeave != 1
		ORDER BY f.Date DESC


	insert into @dt
	SELECT    op.ID ,
                op.HMain_ID ,
                op.ProID ,
                op.Date ,
                op.DayOfWeek ,
                op.Percents ,
                op.FillState ,
                op.IsWorkingDay ,
                op.IsLeave ,
                op.Creator ,
                op.CreateTime ,
                op.Modifier ,
                op.ModifyTime ,
                op.DeleteFlag ,
				ISNULL(op.FirstProName, '') FirstProName ,
                ISNULL(op.ProName, '') ProName ,
                ISNULL(op.ProCode, '') ProCode ,
                ISNULL(op.Remark, '') Remark ,
                op.SuspendTime ,
                op.ProDeleteFlag ,
				op.ChildCount,
				op.IsTdms ,
				op.TdmsTime
      FROM      ( SELECT --DISTINCT
                            a.Id ,
                            a.HMain_ID ,
                            a.ProID ,
                            a.Date ,
                            a.DayOfWeek ,
                            a.Percents ,
                            a.FillState ,
                            a.IsWorkingDay ,
                            a.IsLeave ,
                            a.Creator ,
                            a.CreateTime ,
                            a.Modifier ,
                            a.ModifyTime ,
                            a.DeleteFlag ,
						--	ISNULL(c.FirstProName, '') FirstProName ,
							ISNULL(a.FirstProName,'') FirstProName,
                            ISNULL(a.ProName, '') ProName ,
                            ISNULL(a.ProCode, '') ProCode ,
                            ISNULL(a.Remark, '') Remark ,
                            a.SuspendTime ,
                            a.ProDeleteFlag,
							(select count(*) from ProductInfo where ParentCode=b.ProCode And DeleteFlag<>1) as ChildCount,--ys2338 新增该字段暂用作查看是否有子集 0 无子集 >0有子集
							a.IsTdms ,
							a.TdmsTime
                  FROM      dbo.V_HourInfoDetailHistory a
							INNER JOIN dbo.ProductInfo b ON a.ProID = b.ProID
                        --    LEFT JOIN dbo.ProductInfo b ON a.ProID = b.ProID
                        --    LEFT JOIN dbo.ProductInfo_Display c ON c.Current_ProId=a.ProID
                  WHERE     a.Date = @date
                            AND a.Creator = @user
                        --    AND a.DeleteFlag = 0
                  UNION ALL
                  SELECT  --DISTINCT
                            a.Id ,
                            a.HMain_ID ,
                            a.ProID ,
                            a.Date ,
                            a.DayOfWeek ,
                            a.Percents ,
                            a.FillState ,
                            a.IsWorkingDay ,
                            a.IsLeave ,
                            a.Creator ,
                            a.CreateTime ,
                            a.Modifier ,
                            a.ModifyTime ,
                            a.DeleteFlag ,
						--	ISNULL(c.FirstProName, '') FirstProName ,
							ISNULL(a.FirstProName,'') FirstProName,
                            ISNULL(a.ProName, '') ProName ,
                            ISNULL(a.ProCode, '') ProCode ,
                            ISNULL(a.Remark, '') Remark ,
                            a.SuspendTime ,
                            a.ProDeleteFlag ,
							(select count(*) from ProductInfo where ParentCode=b.ProCode And DeleteFlag<>1) as ChildCount,--ys2338 新增该字段暂用作查看是否有子集 0 无子集 >0有子集
							a.IsTdms ,
							a.TdmsTime
                  FROM      dbo.V_HourInfoDetailHistory a
                            INNER JOIN dbo.ProductInfo b ON a.ProID = b.ProID --OR a.ProID = '00000000-0000-0000-0000-000000000000'
						--	LEFT JOIN dbo.ProductInfo_Display c ON c.Current_ProId=a.ProID
                  WHERE     
				      a.Date = @tmpDate
							--a.Date = ( SELECT TOP 1
       --                                         f.Date
       --                                FROM     ( SELECT    c.Date ,
       --                                                     ISNULL(b.IsLeave,
       --                                                       0) IsLeave
       --                                           FROM      dbo.DateSetting c
       --                                                     LEFT JOIN ( SELECT
       --                                                       e.Creator ,
       --                                                       e.Date ,
       --                                                       e.IsLeave ,
       --                                                       e.DeleteFlag
       --                                                       FROM
       --                                                       dbo.V_HourInfo_New e
       --                                                       WHERE
       --                                                       e.Creator = @user
       --                                                       AND e.DeleteFlag = 0
       --                                                       AND e.Date < @date
       --                                                       ) b ON c.Date = b.Date
       --                                           WHERE     c.IsWorkingDay = 0
       --                                                     AND c.Date < @date
       --                                         ) f
       --                                WHERE    f.IsLeave != 1
       --                                ORDER BY f.Date DESC
       --                              )
                            AND a.Creator = @user
                       --     AND a.DeleteFlag = 0
                            AND ( ( ( b.DeleteFlag = 0
                                      AND ( b.invalidType IS NULL
                                            OR b.invalidType = ''
                                            OR b.invalidType = '2'
                                          )
                                    )
                                    OR ( b.DeleteFlag = 0
                                         AND b.invalidType = 1
                                         AND b.ActualSuspendTime IS NOT NULL
                                         AND CONVERT(NVARCHAR(200), b.ActualSuspendTime, 23) >= @date
                                       )
                                  )
                                  OR ( b.DeleteFlag = 1
                                       AND a.SuspendTime BETWEEN DATEADD(dd,
                                                              -DAY(@date) + 1,
                                                              @date)
                                                         AND  DATEADD(MONTH, 1,
                                                              DATEADD(dd,
                                                              -DAY(@date) + 1,
                                                              @date))
                                     )
								   OR b.DeleteFlag=2 --ys2338 挂起状态直接使用
                                )
                ) op
		end
	return
end
GO


