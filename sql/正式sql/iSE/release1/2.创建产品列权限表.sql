create  table specms_ProColPermission
(
	Id int  primary  key identity(1,1),
	UserId nvarchar(50),
	ProColId int,
	rCode nvarchar(50),
	createBy nvarchar(50),
	createTime datetime
)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'员工id(五位工号或xx1234)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'UserId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'产品列id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'ProColId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'角色编码' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'rCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人(五位工号或xx1234)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'createBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission', @level2type=N'COLUMN',@level2name=N'createTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'保存拥有产品列权限人员所对应的角色信息' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_ProColPermission'
GO 

