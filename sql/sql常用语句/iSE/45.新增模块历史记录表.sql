--模块历史记录表  用来记录   
--记录升降级前的所属类别  所属子类

--specms_ChangeRecord
--id主键
--verTreeCode  版本code
--smId  模块id
--smPid 模块父级id
--smName 名称
--smSort  1类别  2子类 3模块

create    table   specMs_SpecModuleHistory
(
	smHistoryId  int primary key identity(1,1),
	blId  int,
	smId  int,
	smPid int,
	smName nvarchar(200),
	smLvl int,
	mCode nvarchar(50),
	explain  nvarchar(200),
	fspecNum int,
	type int,
	verTreeCode nvarchar(50),
	mmanagerID nvarchar(1000),
	mmanager nvarchar(1000),
	orderNo float,
	createBy nvarchar(50),
	createTime datetime,
	smSort int
)


select  *  from  specMS_SpecModule   a;
--drop  table specMs_SpecModuleHistory