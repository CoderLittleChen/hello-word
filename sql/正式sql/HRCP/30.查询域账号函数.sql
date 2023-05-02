USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetRegionAccount]    Script Date: 2019/10/8 10:54:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[F_GetRegionAccount]
(@UserId varchar(100)
,@Type VARCHAR(100))
RETURNS varchar(200)
AS
BEGIN
	 IF(RIGHT(@UserId,1)!=',')SET @UserId+=',';
	 DECLARE @RegionAccount VARCHAR(500)='';
	 DECLARE @TempStr VARCHAR(100);
	 DECLARE @Index INT=CHARINDEX(',',@UserId);
	 WHILE @Index!=0
	 BEGIN
		SET @TempStr=SUBSTRING(@UserId,0,@Index)
		IF(@Type='Region')		SET @RegionAccount=@RegionAccount+(SELECT RegionAccount FROM dbo.VEmployee WHERE NotesAccount=SUBSTRING(@TempStr,CHARINDEX(' ',@TempStr)+1,LEN(@TempStr)))+','
		IF(@Type='Name')		SET @RegionAccount=@RegionAccount+(SELECT Name FROM dbo.VEmployee WHERE NotesAccount=SUBSTRING(@TempStr,CHARINDEX(' ',@TempStr)+1,LEN(@TempStr)))+','
		SET @UserId=SUBSTRING(@UserId,@Index+1,LEN(@userid));
		SET @Index =CHARINDEX(',',@UserId);	
	 END
	RETURN @RegionAccount;
END


GO


