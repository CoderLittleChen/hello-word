USE [PersonalInput]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetDayLog_New]    Script Date: 2020/1/15 9:00:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






create FUNCTION [dbo].[F_GetDayLog]
    (
      @user NVARCHAR(200) ,
      @date DATETIME	
    )
RETURNS  @dt TABLE(ID  int,Back_Id int,Back_ParentID int,Back_Date datetime,Opinion nvarchar(max),Creator nvarchar(200),CreateTime datetime,ProID nvarchar(1000),IsBack int,Operation nvarchar(100),ProName nvarchar(500))
AS 
begin
	DECLARE @firstDayOfMonth date
	DECLARE @monday nvarchar(20)
	set @firstDayOfMonth= CONVERT(datetime,convert(nvarchar(7),DATEADD(month,-1,getdate()),120)+'-01',20)
	set @monday=dbo.GetMondayByDate(@firstDayOfMonth)
if	@date>=@monday
	begin
			insert  into  @dt
						SELECT    b.* ,
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
												 WHERE  --a.Creator = @user
														a.UserCode = @user
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
		end
else 
		begin
		insert  into  @dt
						SELECT    b.* ,
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
							  FROM      BackRecordHistory  c
							  WHERE     EXISTS ( SELECT *
												 FROM   dbo.HourInfoMainHistory a
												 WHERE  --a.Creator = @user
														a.UserCode = @user
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
			end
return
end





GO


