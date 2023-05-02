USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetSerialProjectLeaveFileCode]    Script Date: 2019/8/20 17:31:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[F_GetSerialProjectLeaveFileCode](

)
RETURNS nvarchar(20)
AS
BEGIN
	DECLARE @LeaveFileCode nvarchar(20)
	DECLARE @tempLeaveFileCode  nvarchar(20)
	SELECT TOP 1  @tempLeaveFileCode=mf.MaterialLeaveFileNo FROM MaterialFile mf 
	inner join ProjectPersonInfo pf ON mf.PersonInfoId=pf.ProjectPersonInfoId WHERE convert(varchar(4),mf.CreateDate,112)=convert(varchar(4),Getdate(),112) AND pf.DeleteFlag=0  order by mf.MaterialLeaveFileNo desc
	IF(@tempLeaveFileCode  is not  null)
		BEGIN
            set @LeaveFileCode=cast(@tempLeaveFileCode as numeric(18,0))+1
		END
	ELSE
		BEGIN
			set @LeaveFileCode=(cast(convert(varchar(4),Getdate(),112) as nvarchar(20))+'0001')
		END
	return @LeaveFileCode
END
GO


