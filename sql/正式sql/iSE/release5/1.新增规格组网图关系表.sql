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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'RelId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'EntryId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ͼId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'NetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'״̬' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'CreateBy'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸�ʱ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'ModifyTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_Entry_NetWorking_Relation', @level2type=N'COLUMN',@level2name=N'Modifier'
GO