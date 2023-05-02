select  *  from  PersonInfo  a;
--域账号   DomainAccount  nvarchar(150)
--拼音    PingYing   nvarchar(150)
--英文名  EnglishName   nvarchar(150)
--房间号  RoomNo    nvarchar(150)
--电话短号  Extension   nvarchar(150)    改为TelShortNum
--电话长号  TelLongNum  
--邮箱  [Email]   nvarchar(100)
--传真   [Fax]    nvarchar(150)
--同步时间  SyncTime   datetime
use  hrcp;

--alter  table  PersonInfo  add  DomainAccount   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  PingYing   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  EnglishName   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  RoomNo   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  TelShortNum   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  Email   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  Fax   nvarchar(150)  default  '';
--alter  table  PersonInfo  add  SyncTime   datetime  default  getdate();
--alter  table  PersonInfo  add  TelLongNum  nvarchar(150) default  '';

--删除约束
--alter table  PersonInfo  drop  constraint  DF__PersonInf__Exten__69478F08;
--alter  table   PersonInfo   drop  column  Extension;

select   a.Telephone,a.SyncTime   from    PersonInfo  a;

select   *   from  V_PeronsInfo_ForDataMP  a;
select   *   from  PersonInfo  a;