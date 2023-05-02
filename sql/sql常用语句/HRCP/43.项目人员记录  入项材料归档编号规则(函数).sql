USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetSerialProjectFileCode]    Script Date: 2019/8/13 9:24:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[F_GetSerialProjectFileCode](

)
RETURNS nvarchar(20)
AS
BEGIN
	DECLARE @FileCode nvarchar(20)
	IF EXISTS(SELECT TOP 1 mf.MaterialFileNo FROM MaterialFile mf 
	inner join ProjectPersonInfo pf ON mf.PersonInfoId=pf.ProjectPersonInfoId WHERE convert(varchar(4),mf.CreateDate,112)=convert(varchar(4),Getdate(),112) AND pf.DeleteFlag=0)
		BEGIN
			set @FileCode=(SELECT TOP 1 mf.MaterialFileNo FROM MaterialFile mf 
	inner join ProjectPersonInfo pf ON mf.PersonInfoId=pf.ProjectPersonInfoId WHERE convert(varchar(4),mf.CreateDate,112)=convert(varchar(4),Getdate(),112) AND pf.DeleteFlag=0 order by mf.MaterialFileNo desc)
            set @FileCode=cast(@FileCode as numeric(18,0))+1
		END
	ELSE
		BEGIN
			set @FileCode=(cast(convert(varchar(4),Getdate(),112) as nvarchar(20))+'0001')
		END
	return @FileCode
END

GO


