USE [PersonalInput]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetDayLog]    Script Date: 2019/12/7 11:37:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[F_GetDayLog]
    (
      @user NVARCHAR(200) ,
      @date DATETIME	
    )
RETURNS TABLE
AS 
RETURN
    ( SELECT    b.* ,
                ( SELECT    value = ( STUFF(( SELECT    ',' + d.ProCode + ' '
                                                        + d.ProName
                                              FROM      dbo.ProductInfo d
                                              WHERE     CHARINDEX(CAST(d.ProID AS NVARCHAR(40)),
                                                              b.ProID) != 0
                                            FOR
                                              XML PATH('')
                                            ), 1, 1, '') )
                ) ProName
      FROM      ( SELECT    c.*
                  FROM      BackRecord c
                  WHERE     EXISTS ( SELECT *
                                     FROM   dbo.HourInfoMain a
                                     WHERE  a.Creator = @user
                                            AND a.DeleteFlag = 0
                                            AND a.id = c.Back_ID
                                            AND a.CreateTime BETWEEN CONVERT(NVARCHAR(10), DATEADD(wk,
                                                              DATEDIFF(wk, 0,
                                                              DATEADD(dd, -1,
                                                              @date)),
                                                              0), 121)
                                                             AND
                                                              CONVERT(NVARCHAR(10), DATEADD(wk,
                                                              DATEDIFF(wk, 0,
                                                              DATEADD(dd, -1,
                                                              @date)),
                                                              6), 121) --SELECT 1
      --                               FROM   dbo.V_HourInfo_New a
      --                               WHERE  a.Date = @date
      --                                      AND a.Creator = @user
      --                                      AND a.DeleteFlag = 0
      --                                      AND a.HMain_ID = c.Back_ID
											 )
                            AND c.Back_Date = @date
                            AND ( IsBack = 0
                                  OR IsBack = 1
                                )
                ) b
    );


GO


