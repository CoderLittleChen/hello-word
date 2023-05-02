USE [hrcp]
GO

/****** Object:  StoredProcedure [dbo].[CreatePayStandingBook]    Script Date: 2019/8/21 17:54:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[CreatePayStandingBook]
 @payReportIds varchar(1000),
 @submitDate date ,
 @EMSNumber varchar(100)
 as
 begin
	declare @i int
	set @payReportIds=rtrim(ltrim(@payReportIds))
	set @i=CHARINDEX(';',@payReportIds)
	while @i>=1
	begin
		insert into PayStandingBook(PayStandingBookId,PayReportId,SubmitDate,EMSNumber)
		values(NEWID(),convert(uniqueidentifier,left(@payReportIds,@i-1)),convert(date,@submitDate),@EMSNumber)

		update PayReport set IsPayStandingBook=ISNULL(IsPayStandingBook,0)+1 where PayReportId= convert(uniqueidentifier,left(@payReportIds,@i-1))

		set @payReportIds=substring(@payReportIds,@i+1,len(@payReportIds)-@i)
		set @i=CHARINDEX(';',@payReportIds)
	end
 end

GO


