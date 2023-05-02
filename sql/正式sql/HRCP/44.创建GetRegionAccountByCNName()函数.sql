USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetRegionAccountByCNName]    Script Date: 2019/12/3 18:37:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--Add  By:≥¬√Ù
--Description:∏˘æ›CNName≤È—Ø”Ú’À∫≈    
--Date:2019.12.03


CREATE FUNCTION [dbo].[F_GetRegionAccountByCNName]
(@UserName varchar(100))
RETURNS varchar(200)
AS
BEGIN
	 --DECLARE @RegionAccount VARCHAR(500)='';
	 --DECLARE @firstStr VARCHAR=SUBSTRING(@USERID,1,1);
	 --DECLARE @Index INT=CHARINDEX(' ',@UserId);
	 --DECLARE @TempStr VARCHAR(100)=SUBSTRING(@USERID,@INDEX+1,len(@USERID));
	 DECLARE @ReturnValue  varchar(100)='';
	 --SET @RegionAccount= @firstStr+@TempStr;
	 --IF @Index!=0
		-- BEGIN
		--	IF(@Type='Region')		SET @ReturnValue= @RegionAccount;
		--	IF(@Type='Name')		
		-- END

	select @ReturnValue=HUR_CODE   from   WEBDP.DBO.WEBDP_USER  a  where  a.HUR_NAME=@UserName;
	RETURN Lower(@ReturnValue)
END
GO


