--ϵͳ������specms_Dict ����������������ȼ�
--select  *  from  specMS_Dict  a;
use iSEDB;
--���븸��
insert  into  specMS_Dict  
select  107000,1,1,'�������������ȼ�',null,1,null,'cys2689',null,GETDATE(),null;

--�����Ӽ�
insert  into  specMS_Dict  
select  107001,107000,1,'��',null,1,null,'cys2689',null,GETDATE(),null
union
select  107002,107000,2,'��',null,2,null,'cys2689',null,GETDATE(),null
union
select  107003,107000,3,'��',null,3,null,'cys2689',null,GETDATE(),null;