USE [PersonalInput]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetWeekLog_New]    Script Date: 2020/1/15 9:01:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create FUNCTION [dbo].[F_GetWeekLog] ( @HMain_ID INT,@createTime datetime)

RETURNS  @dt TABLE(ID  int,Back_Id int,Back_ParentID int,Back_Date datetime,Opinion nvarchar(max),Creator nvarchar(200),CreateTime datetime,ProID nvarchar(1000),IsBack int,Operation nvarchar(100),ProName nvarchar(500))
AS 
begin
	DECLARE  @startDayOfWeek  datetime;
	DECLARE @firstDayOfMonth date
	DECLARE @monday nvarchar(20)
	set @firstDayOfMonth= CONVERT(datetime,convert(nvarchar(7),DATEADD(month,-1,getdate()),120)+'-01',20)
	set @monday=dbo.GetMondayByDate(@firstDayOfMonth)
	select @startDayOfWeek= @createTime
	if	@startDayOfWeek>=@monday
	begin
			insert  into   @dt
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
	end
else
	begin
		insert  into   @dt
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
		  FROM      ( SELECT    *
					  FROM      BackRecordHistory c
					  WHERE     c.Back_ID = @HMain_ID
								AND c.IsBack = 2
					  UNION ALL
					  SELECT    *
					  FROM      BackRecordHistory c
					  WHERE     c.Back_ID = @HMain_ID
								AND c.IsBack = 0
					  UNION ALL
					  SELECT    *
					  FROM      BackRecordHistory c
					  WHERE     c.Back_ID = @HMain_ID
								AND c.IsBack = 3
					) b   
		 end
return
end


GO


