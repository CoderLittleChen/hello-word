use iSEDB;
--BusinessNode  ����  PDTȷ�ϻ���
insert into  BusinessNode 
select  NEWID(),'00000000-0000-0000-0000-000000000000'as pid,'Ӧ�ù���Ա�����汾','00000000-0000-0000-0000-000000000000','',1

--EmailTemplate  ����ģ������

insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='Ӧ�ù���Ա�����汾')
	,''
	,''
	,'[?���������?]'
	,'[?Ӧ�ù���Ա?]'
	,''
	,'iSEϵͳ[?PDT?]�����ֶ������汾��[?�汾����?],��֪Ϥ��'
	,'<p>ϵͳ���ƣ�H3C������ϵͳ��iSE��</p><p>������ӣ�[?����?]</p>','','ys2689',GETDATE(),'','',1,null;



		
