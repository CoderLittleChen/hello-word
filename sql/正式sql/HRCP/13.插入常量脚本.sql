use hrcp;
insert into  AppConstant(AppConstantId,Code,Name)   values(NEWID(),'ProjectPersonStatus','项目人员管理-人员状态');
insert   into   AppConstantValue(ConstantValueListId,AppConstantId,ConstantValue,Text,EnglishText,DisplayOrder,CreateDate)   
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'OnJobOutside','在岗-外场','OnJobOutside','1',GETDATE()
union 
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'OnJobInside','在岗-内场','OnJobInside','2',GETDATE()
union
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Exit','离场办理中','Exit','3',GETDATE()
union 
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Leaving','离项办理中','Leaving','4',GETDATE()
union
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Leaved','离项','Leaved','5',GETDATE()
union
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Release','释放','Release','6',GETDATE()




