USE [PersonalInput]
GO

/****** Object:  UserDefinedFunction [dbo].[getMondayBtDate]    Script Date: 2019/12/9 10:40:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetMondayByDate](@date datetime)
RETURNS date
AS
begin
    DECLARE @week INT,@cnt INT
    select @week = DATEPART(dw,@date)
    SET @cnt = 2 - @week
    IF(@week = 1)
    BEGIN
        SET @cnt = -6
    END
    RETURN DATEADD(DAY, @cnt, @date)
end
GO


