create  table  specMs_IsSendEmailWhenAddVersion
(
	SendEmailId int  primary  key identity(1,1),
	ReleaseCode varchar(50),
	IsSendEmail int
)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_IsSendEmailWhenAddVersion', @level2type=N'COLUMN',@level2name=N'SendEmailId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�汾Code(R/B)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_IsSendEmailWhenAddVersion', @level2type=N'COLUMN',@level2name=N'ReleaseCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�Ƿ����ʼ���0���� 1����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMs_IsSendEmailWhenAddVersion', @level2type=N'COLUMN',@level2name=N'IsSendEmail'
GO




