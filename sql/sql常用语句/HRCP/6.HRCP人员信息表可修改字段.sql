--允许修改的有  
--域账号  中文全拼  英文名   办公地点  房间  电话号码长号   短号  手机   邮箱  传真    
--不允许修改的有
--工号  中文名
--需要添加的字段
--域账号   DomainAccount
--拼音    PingYing
--英文名  EnglishName
--房间号  RoomNo
--电话短号  Extension
--电话长号(已存在)     不添加
--邮箱  [Email]
--传真   [Fax]
--同步时间  SyncTime  

--现在的问题    发的sql  中Telephone对应的是 电话长号，但是hrcp中Telephone对应的是电话号码   以HRCP的为准
use hrcp;
select   *   from  PersonInfo  a;

select  a.EmployeeName,a.OfficeLocation,a.WorkNum  from  PersonInfo  a where a.WorkPlace='杭州';

