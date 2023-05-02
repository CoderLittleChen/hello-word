USE [PersonalInput]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetWeekLog]    Script Date: 2019/12/14 17:51:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [dbo].[F_GetWeekLog] ( @HMain_ID INT )
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
      FROM      ( SELECT    *
                  FROM      BackRecord c
                  WHERE     c.Back_ID = @HMain_ID
                            AND c.IsBack = 2
                  UNION ALL
                  SELECT    *
                  FROM      BackRecord c
                  WHERE     c.Back_ID = @HMain_ID
                            AND c.IsBack = 0
                  UNION ALL
                  SELECT    *
                  FROM      BackRecord c
                  WHERE     c.Back_ID = @HMain_ID
                            AND c.IsBack = 3
                ) b
    );




GO


