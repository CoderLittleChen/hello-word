create  table specms_ProColPermission
(
	Id int  primary  key identity(1,1),
	UserId nvarchar(50),
	ProColId int,
	rCode nvarchar(50),
	createBy nvarchar(50),
	createTime datetime
)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ա��id(��λ���Ż�xx1234)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ʒ��id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'ProColId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'rCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������(��λ���Ż�xx1234)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'createBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'createTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ӵ�в�Ʒ��Ȩ����Ա����Ӧ�Ľ�ɫ��Ϣ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission'
GO 

