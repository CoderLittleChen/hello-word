select  *  from  PersonInfo  a;
--���˺�   DomainAccount  nvarchar(150)
--ƴ��    PingYing   nvarchar(150)
--Ӣ����  EnglishName   nvarchar(150)
--�����  RoomNo    nvarchar(150)
--�绰�̺�  Extension   nvarchar(150)    ��ΪTelShortNum
--�绰����  TelLongNum  
--����  [Email]   nvarchar(100)
--����   [Fax]    nvarchar(150)
--ͬ��ʱ��  SyncTime   datetime
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

--ɾ��Լ��
--alter table  PersonInfo  drop  constraint  DF__PersonInf__Exten__69478F08;
--alter  table   PersonInfo   drop  column  Extension;

select   a.Telephone,a.SyncTime   from    PersonInfo  a;

select   *   from  V_PeronsInfo_ForDataMP  a;
select   *   from  PersonInfo  a;