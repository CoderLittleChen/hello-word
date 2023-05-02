--��������
--delete dbo.ProductConfig
create  table  ProductConfig
(
	ConfigId  SmallInt  primary key  identity(1,1),
	ConfigName nvarchar(100),
	ConfigType tinyint,
	Logic nvarchar(200),
	LogicType tinyint,
	[Status]  bit,
	InitLevel tinyint,
	Creator nvarchar(50),
	CreateDate  Date,
	Modifier nvarchar(50),
	ModifyDate Date
)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'���ñ�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ConfigName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������(1:��Ŀ���ͣ�2���ؼ���)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ConfigType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����߼�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Logic'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����߼�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'LogicType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'״̬��0�����ã�1�����ã�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ʼ�㼶��Ĭ��Ϊ3��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'InitLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ModifyDate'
GO


--�����������
--insert  into  ProductConfig
--select  '����1',1,'��Ŀ�����߼�',1,1,3,'liucaixuan 03806','2020-02-24',null,null
--union  
--select  '����2',2,'�ؼ����߼�',2,0,3,'liucaixuan 03806','2020-02-24',null,null



--������Ŀ��
create  table  ProductConfigDetail
(
	DetailId  int  primary key identity(1,1),
	ConfigId smallint foreign   key references ProductConfig(ConfigId),
	ProLevel tinyint ,
	ProName nvarchar(100),
	ParentId  int,
	IsFixedPerson  bit,
	RoleType tinyint,
	Manager nvarchar(50),
	Creator nvarchar(50),
	CreateDate  Date,
	Modifier nvarchar(50),
	ModifyDate Date
)

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ������ϸ������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'DetailId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ���ñ�id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ�㼶' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ProLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ParentId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�Ƿ�Ϊ�̶���Ա(0:��;1:��)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'IsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'RoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'Manager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'Modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ModifyDate'
GO


--drop  table  ProductConfigImportData;

--���õ������ݱ�
create  table   ProductConfigImportData
(
	Id  int primary key   identity(1,1),
	KeyId uniqueidentifier,
	ConfigId smallint  foreign  key  references ProductConfig(Configid),
	SecondProName nvarchar(100),
	SecondManager nvarchar(50),
	SecondRoleType nvarchar(50),
	SecondIsFixedPerson bit,
	ThirdProName nvarchar(100),
	ThirdManager nvarchar(50),
	ThirdRoleType nvarchar(50),
	ThirdIsFixedPerson bit,
	FourthProName nvarchar(100),
	FourthManager nvarchar(50),
	FourthRoleType nvarchar(50),
	FourthIsFixedPerson bit,
	Creator nvarchar(50),
	CreateDate Date
)

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��ʶÿһ�ε����id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'KeyId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��Ŀ���ñ�id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������Ŀ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������Ŀ����ָ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������Ŀ�����ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondRoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����Ƿ�Ϊ�̶���Ա��0����;1���ǣ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondIsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������Ŀ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������Ŀ����ָ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������Ŀ�����ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdRoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�����Ƿ�Ϊ�̶���Ա��0����;1���ǣ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdIsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ���Ŀ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ���Ŀ����(ָ��)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ���Ŀ�����ɫ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthRoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�ļ��Ƿ�Ϊ�̶���Ա(0:��;1:��)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthIsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

--drop table  ProductConfigLogic
--���������߼���
create  table ProductConfigLogic 
(
	LogicId  int primary key identity(1,1),
	ConfigId Smallint  foreign  key  references  ProductConfig(ConfigId),
	Logic  nvarchar(50),
	IPDProTypeLevel tinyint,
	Creator nvarchar(50),
	CreateDate  Date,
	Modifier nvarchar(50),
	ModifyDate Date
)

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�߼�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'LogicId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�߼�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'Logic'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�Ƿ�Ϊ��Ŀ���ࣨ1:��Ŀ���ࣻ2:��ĿС�ࣩ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'IPDProTypeLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'Modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�޸�����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'ModifyDate'
GO


