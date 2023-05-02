USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetApprovalNumber]    Script Date: 2019/9/27 17:54:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER Function [dbo].[F_GetApprovalNumber]
(
   @isTrainee int
)
RETURNS nvarchar(20)
AS
BEGIN    
 -- Declare the return variable here


declare @Serial int
    declare @SerialNumber nvarchar(20)
    declare @FlowNumber int
    if exists(select top 1 PersonApprovalNo from PersonSubmitApproval where convert(varchar(4),CreateDate,112)=convert(varchar(4),Getdate(),112) and IsTrainee=@isTrainee AND deleteflag=0)
        begin
            set @SerialNumber=(select top 1 PersonApprovalNo  from PersonSubmitApproval where convert(varchar(4),CreateDate,112)=convert(varchar(4),Getdate(),112) and IsTrainee=@isTrainee AND deleteflag=0 order by PersonApprovalNo desc)
            set @SerialNumber=cast(@SerialNumber as numeric(18,0))+1
        end
    else
        begin
            set @SerialNumber=(cast(convert(varchar(4),Getdate(),112) as nvarchar(20))+'0001')
        end

return @SerialNumber
END

GO


