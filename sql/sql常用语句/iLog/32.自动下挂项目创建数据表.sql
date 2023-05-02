--配置主表
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
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'配置表主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'配置名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ConfigName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'配置类型(1:项目类型；2：关键字)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ConfigType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'配置逻辑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Logic'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'配置逻辑类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'LogicType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态（0：禁用；1：启用）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Status'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'初始层级（默认为3）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'InitLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'Modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfig', @level2type=N'COLUMN',@level2name=N'ModifyDate'
GO


--插入测试数据
--insert  into  ProductConfig
--select  '测试1',1,'项目类型逻辑',1,1,3,'liucaixuan 03806','2020-02-24',null,null
--union  
--select  '测试2',2,'关键字逻辑',2,0,3,'liucaixuan 03806','2020-02-24',null,null



--配置项目表
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目配置明细表主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'DetailId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目配置表id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目层级' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ProLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'父级Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ParentId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否为固定人员(0:否;1:是)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'IsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'角色类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'RoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目经理' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'Manager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'Modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigDetail', @level2type=N'COLUMN',@level2name=N'ModifyDate'
GO


--drop  table  ProductConfigImportData;

--配置导入数据表
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'标识每一次导入的id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'KeyId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'项目配置表id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'二级项目名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'二级项目经理（指定）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'二级项目经理角色类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondRoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'二级是否为固定人员（0：否;1：是）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'SecondIsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'三级项目名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'三级项目经理（指定）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'三级项目经理角色类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdRoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'三级是否为固定人员（0：否;1：是）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'ThirdIsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'四级项目名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthProName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'四级项目经理(指定)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthManager'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'四级项目经理角色类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthRoleType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'四级是否为固定人员(0:否;1:是)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'FourthIsFixedPerson'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigImportData', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

--drop table  ProductConfigLogic
--创建配置逻辑表
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'逻辑主键' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'LogicId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'配置主表id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'ConfigId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'逻辑' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'Logic'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否为项目大类（1:项目大类；2:项目小类）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'IPDProTypeLevel'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'Creator'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'Modifier'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'修改日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ProductConfigLogic', @level2type=N'COLUMN',@level2name=N'ModifyDate'
GO


