create table  Sol_Entry_NetWorking_Relation
(
	RelId	int primary key identity(1,1),
	EntryId	int,
	NetId int,
	Status int,
	CreateTime datetime,
	CreateBy nvarchar(50),
	ModifyTime datetime,
	Modifier nvarchar(50)
)

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'RelId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'规格Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'EntryId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'组网图Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'NetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'ModifyTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'Modifier'
GO