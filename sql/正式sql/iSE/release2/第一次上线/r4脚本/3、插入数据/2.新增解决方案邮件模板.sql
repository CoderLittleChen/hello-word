use iSEDB;
--BusinessNode  

--���������ȷ�Ϲ��
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='�������') as Pid,'���������ȷ�Ϲ��','00000000-0000-0000-0000-000000000000','',1;

--PDTȷ��
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='�������') as Pid,'PDTȷ��','00000000-0000-0000-0000-000000000000','',1;

--����֪ͨ��Ʒȷ��
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='�������') as Pid,'����֪ͨ��Ʒȷ��','00000000-0000-0000-0000-000000000000','',1;

--STR�׶�֪ͨ��Ʒȷ��
insert into  BusinessNode 
select  NEWID(),(select id  from  BusinessNode   where  Buss_Name='�������') as Pid,'STR�׶�֪ͨ��Ʒȷ��','00000000-0000-0000-0000-000000000000','',1;

--EmailTemplate  ����ģ������

--���������ȷ�Ϲ��
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='���������ȷ�Ϲ��')
	,''
	,''
	,'[?���������?]'
	,''
	,''
	,'��Ʒ�����˶���������ϣ���ȷ�Ͻ���������'
	,'<p>ϵͳ���ƣ�H3C������ϵͳ��iSE��</p>

<p>����ģ�飺����������</p>

<p>��ǰ״̬��[?״̬?]</p>

<p>������ӣ�[?����?]</p>','','ys2689',GETDATE(),'','',1,null;

----PDTȷ��
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='PDTȷ��')
	,''
	,''
	,'[?PDT����?]'
	,''
	,''
	,'������iSE�������ģ�飺[?PDT?]�еĲ�Ʒ�ӿ���'
	,'<p>ϵͳ���ƣ�H3C������ϵͳ��iSE��</p>

	<p>����ģ�飺����������</p>

	<p>��ǰ״̬��[?״̬?]</p>

	<p>������ӣ�[?����?]</p>

	<p>&nbsp;</p>','','ys2689',GETDATE(),'','',1,null;

--����֪ͨ��Ʒȷ��
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='����֪ͨ��Ʒȷ��')
	,''
	,''
	,'[?��Ʒ�ӿ���?]'
	,'[?���������?][?SDT����?]'
	,''
	,'��ȷ��iSE��������汾����[?D�汾?]�� �еĻ��ߣ� ��[?����?]��STR4���'
	,'<p>ϵͳ���ƣ�H3C������ϵͳ��iSE��</p>

<p>����ģ�飺����������</p>

<p>��ǰ״̬��[?״̬?]</p>

<p>��&nbsp; &nbsp; &nbsp; �ݣ���ȷ�����¹���Լ����ӹ��[?�������?]</p>

<p>������ӣ�[?����?]</p>

<p>&nbsp;</p>','','ys2689',GETDATE(),'','',1,null;

--STR�׶�֪ͨ��Ʒȷ��
insert  into  EmailTemplate 
select   
	NEWID(),
	(select  a.ID  from  BusinessNode  a  where  a.Buss_Name='STR�׶�֪ͨ��Ʒȷ��')
	,''
	,''
	,'[?��Ʒ�ӿ���?]'
	,'[?���������?][?SDT����?]'
	,''
	,'��ȷ��iSE��������汾����[?D�汾?]�� �еĻ��ߣ� ��[?����?]��STR4���'
	,'<p>ϵͳ���ƣ�H3C������ϵͳ��iSE��</p>

<p>����ģ�飺����������</p>

<p>��ǰ״̬��[?״̬?]</p>

<p>������ӣ�[?����?]</p>

<p>&nbsp;</p>
','','ys2689',GETDATE(),'','',1,null;




		
