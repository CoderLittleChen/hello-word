use iSEDB;
---��������
begin tran
--������׽���ƣ�����Ƕ�ס�
begin try
--������ɫ
insert  into  specMS_ROLE
select '��Ʒ�ӿ���',52,0,GETDATE(),0,GETDATE(),0,'',62,0
union
select '��������ɲ鿴��',53,0,GETDATE(),0,GETDATE(),0,'',63,0
union
select '��������ɵ�����',54,0,GETDATE(),0,GETDATE(),0,'',64,0
union
select 'SDT����',55,0,GETDATE(),0,GETDATE(),0,'',65,0
union
select 'SDT�ܹ�ʦ',56,0,GETDATE(),0,GETDATE(),0,'',66,0
union
select '�������������������',57,0,GETDATE(),0,GETDATE(),0,'',67,0
union
select '�������������������',58,0,GETDATE(),0,GETDATE(),0,'',68,0

--������Դ
insert   into  specMS_RESOURCE
select   0,1,'���������Դ','',229000,'���������Դ',0,GETDATE(),0,NULL,1,'',0,1,0,0

insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'����ͼ','',228000,'����ͼ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'������Ʒ','',226000,'������Ʒ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'ÿ�ڰ汾��','',227000,'ÿ�ڰ汾��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'STR4֪ͨ��Ʒȷ��','',203010,'STR4֪ͨ��Ʒȷ��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'STR5֪ͨ��Ʒȷ��','',203011,'STR5֪ͨ��Ʒȷ��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'STR5���߻�','',203012,'STR5���߻�',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'����-����ҳ��','',230000,'����-����ҳ��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'����֪ͨ��Ʒȷ��','',230008,'����֪ͨ��Ʒȷ��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'������ϵͳ����ģ��','',230630,'������ϵͳ����ģ��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='229000'),1,'��ϵͳ����ģ�嵼��','',230830,'��ϵͳ����ģ�嵼��',0,GETDATE(),0,NULL,1,'',0,1,0,0

--����ͼ
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='228000'),1,'�ϴ�����ͼ','',228001,'�ϴ�����ͼ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a where a.RES_CODE='228000'),1,'��������ͼ','',228002,'��������ͼ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='228000'),1,'ɾ������ͼ','',228003,'ɾ������ͼ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='228000'),1,'��������ͼ','',228004,'��������ͼ',0,GETDATE(),0,NULL,1,'',0,1,0,0

--������Ʒ
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'����������Ʒ','',226001,'����������Ʒ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'�޸Ĳ�����Ʒ','',226002,'�޸Ĳ�����Ʒ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'ɾ��������Ʒ','',226003,'ɾ��������Ʒ',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='226000'),1,'����������Ʒ֧�����','',226004,'����������Ʒ֧�����',0,GETDATE(),0,NULL,1,'',0,1,0,0


--ÿ�ڰ汾��
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'�����汾��','',227001,'�����汾��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'�޸İ汾��','',227002,'�޸İ汾��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'ɾ���汾��','',227003,'ɾ���汾��',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='227000'),1,'����ÿ�ڰ汾֧�����','',227004,'����ÿ�ڰ汾֧�����',0,GETDATE(),0,NULL,1,'',0,1,0,0


--����-����ҳ��
insert   into  specMS_RESOURCE
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'����','',230001,'����',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'�鿴δ���������','',230006,'�鿴δ���������',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'����ȫ���޸�','',230007,'����ȫ���޸�',0,GETDATE(),0,NULL,1,'',0,1,0,0
union all
select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230000'),1,'����ȷ��','',230009,'����ȷ��',0,GETDATE(),0,NULL,1,'',0,1,0,0


----����
--insert   into  specMS_RESOURCE
--select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230002'),1,'ҳ�����ݵ���','',230001,'ҳ�����ݵ���',0,GETDATE(),0,NULL,1,'',0,1,0,0
--union all
--select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230002'),1,'���ص���ģ��','',230002,'���ص���ģ��',0,GETDATE(),0,NULL,1,'',0,1,0,0
--union all
--select   (select  a.RES_ID  from  specMS_RESOURCE  a  where a.RES_CODE='230002'),1,'���ɸ��ǵ����ʽ����','',230006,'���ɸ��ǵ����ʽ����',0,GETDATE(),0,NULL,1,'',0,1,0,0


--specms_ResourceLang���������
insert  into  specMS_RESOURCE_Lang
select    
	a.RES_ID,1,a.FULL_NAME,'','en-US',1
from specMS_RESOURCE  a  where a.RES_ID>=(select  b.RES_ID from  specMS_RESOURCE  b  where b.RES_CODE='229000')
union all
select    
	a.RES_ID,1,a.FULL_NAME,'','zh-US',1
from specMS_RESOURCE  a  where a.RES_ID>=(select  b.RES_ID from  specMS_RESOURCE  b  where b.RES_CODE='229000')


--specMS_ROLE_RESOURCE_RELATION���������


--Ӧ�ù���Ա
insert  into  specMS_ROLE_RESOURCE_RELATION

select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='229000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203010'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203011'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203012'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230007'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230008'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230630'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1001'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230830'),'',''
--���������
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='228004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='226004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='227004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203010'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203011'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203012'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230007'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230008'),'',''
--union
--select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='229000'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230630'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='1'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230830'),'',''
--PDT����
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='30'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='30'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203003'),'',''
union
--��Ʒ�ӿ���
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='52'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='230009'),'',''
union
-----��������ɲ鿴��
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='53'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
------��������ɵ�����
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='54'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
-------SDT����
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='55'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
--------SDT�ܹ�ʦ
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='56'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
-------�������������������
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='57'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''
union
-------�������������������
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='100006'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='104005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='200001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201002'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201003'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201004'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='201005'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='202001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='203001'),'',''
union
select  (select  a.RL_ID  from  specMS_ROLE a   where RL_CODE='58'),(select  RES_ID from specMS_RESOURCE a  where a.RES_CODE='218001'),'',''

end try
begin catch
   select Error_number() as ErrorNumber,  --�������
          Error_severity() as ErrorSeverity,  --�������ؼ��𣬼���С��10 try catch ���񲻵�
          Error_state() as ErrorState ,  --����״̬��
          Error_Procedure() as ErrorProcedure , --���ִ���Ĵ洢���̻򴥷��������ơ�
          Error_line() as ErrorLine,  --����������к�
          Error_message() as ErrorMessage  --����ľ�����Ϣ
   if(@@trancount>0) --ȫ�ֱ���@@trancount����������ֵ+1���������ж����п�������
      rollback tran  ---���ڳ�������ع�����ʼ����һ�����Ҳû�в���ɹ���
end catch
if(@@trancount>0)
commit tran  --


