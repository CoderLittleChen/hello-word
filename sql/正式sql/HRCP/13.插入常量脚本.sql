use hrcp;
insert into  AppConstant(AppConstantId,Code,Name)   values(NEWID(),'ProjectPersonStatus','��Ŀ��Ա����-��Ա״̬');
insert   into   AppConstantValue(ConstantValueListId,AppConstantId,ConstantValue,Text,EnglishText,DisplayOrder,CreateDate)   
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'OnJobOutside','�ڸ�-�ⳡ','OnJobOutside','1',GETDATE()
union 
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'OnJobInside','�ڸ�-�ڳ�','OnJobInside','2',GETDATE()
union
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Exit','�볡������','Exit','3',GETDATE()
union 
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Leaving','���������','Leaving','4',GETDATE()
union
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Leaved','����','Leaved','5',GETDATE()
union
select  NEWID(),(select  a.AppConstantId  from  AppConstant   a  where  a.Code='ProjectPersonStatus'),'Release','�ͷ�','Release','6',GETDATE()




