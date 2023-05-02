create  table  specMs_IsSendEmailWhenAddVersion
(
	SendEmailId int  primary  key identity(1,1),
	ReleaseCode varchar(50),
	IsSendEmail int
)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_IsSendEmailWhenAddVersion', @level2type=N'COLUMN',@level2name=N'SendEmailId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'版本Code(R/B)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_IsSendEmailWhenAddVersion', @level2type=N'COLUMN',@level2name=N'ReleaseCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否发送邮件（0不发 1发）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_IsSendEmailWhenAddVersion', @level2type=N'COLUMN',@level2name=N'IsSendEmail'
GO




