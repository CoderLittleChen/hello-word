--ģ����ʷ��¼��  ������¼   
--��¼������ǰ���������  ��������

--specms_ChangeRecord
--id����
--verTreeCode  �汾code
--smId  ģ��id
--smPid ģ�鸸��id
--smName ����
--smSort  1���  2���� 3ģ��

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