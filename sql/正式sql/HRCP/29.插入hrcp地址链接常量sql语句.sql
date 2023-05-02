insert   into   AppConstant  
values(NEWID(),'HrcpUrl','Hrcpµÿ÷∑',GETDATE(),'liuyujing kf6850','','',0);

insert  into   AppConstantValue
select   NEWID(),AppConstantId,'HrcpUrl','http://10.18.192.250','HrcpUrl',1,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='HrcpUrl';

