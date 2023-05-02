--select  *   from   AppConstant   a;

--select  *   from   AppConstantValue  a;

--IsCallEIPInterface  


insert   into   AppConstant  
values(NEWID(),'IsCallEIPInterface','是否调用对接EIP',GETDATE(),'liuyujing kf6850','','',0);

insert  into   AppConstantValue
select   NEWID(),AppConstantId,'IsCallEIPInterface','1','IsCallEIPInterface',1,getdate(),'liuyujing kf6850','','',0,'',''   from  AppConstant  a  where  a.Code='IsCallEIPInterface';