USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetRegionAccountByUserInfo]    Script Date: 2019/10/25 13:55:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--Author:陈敏
--Description:根据员工信息获取域账号     
--zhangsan kf1234  得到  zkf1234    
--lisi  19664   得到 l19644
ALTER FUNCTION [dbo].[F_GetRegionAccountByUserInfo]
(@UserId varchar(100)
,@Type VARCHAR(100))
RETURNS varchar(200)
AS
BEGIN
	 DECLARE @RegionAccount VARCHAR(500)='';
	 DECLARE @firstStr VARCHAR=SUBSTRING(@USERID,1,1);
	 DECLARE @Index INT=CHARINDEX(' ',@UserId);
	 DECLARE @TempStr VARCHAR(100)=SUBSTRING(@USERID,@INDEX+1,len(@USERID));
	 declare @ReturnValue  varchar(100)='';
	 SET @RegionAccount= @firstStr+@TempStr;
	 IF @Index!=0
		 BEGIN
			IF(@Type='Region')		SET @ReturnValue= @RegionAccount;
			IF(@Type='Name')		select @ReturnValue=HUR_NAME   from   WEBDP.DBO.WEBDP_USER  a  where  a.HUR_CODE=@RegionAccount;
		 END
	RETURN Lower(@ReturnValue)
END
GO


