select  * from  Sync_Employee  where  Name='��ΰ��'
--ģ���ͨ��ҳ�棩
SELECT * FROM dbo.specMS_TemplateSpec
--ģ������ߵĹ�ϵ��
SELECT * FROM dbo.specMS_TemplateSpecBLRel

select  *  from  specMS_PredefineParam  a;

--�鵵������
select  *  from  specMS_AppConstant  ;

--ϵͳ������
select  *  from  specMS_Dict;

select  *  from  specMS_AppConstantValue  order by CreationDate desc ;

--���߱�
select * from [dbo].[specMS_SpecBaseLine]
--���߱�ǩ
select * from [dbo].[specMS_SpecBaseLineLabel]
--���߹���ϵ��
select* from [dbo].[specMS_SpecBLEntryRel]
--����
select *from [dbo].[specMS_SpecEntry]
--������ݱ�
select * from [dbo].[specMS_SpecEntryContent]
--��չ�б�
--select top 100 * from [dbo].[specMS_SpecListExtColData]
--��������
select * from [dbo].[specMS_EntryParam]
--��׼Э���
select *  from [dbo].[specMS_Standard]
--��׼Э��������չ�ֵĹ�ϵ��
select * from [dbo].[specMS_StandardSupport]

---------------------һ�����ű�Ϊ������-----------------
--���������չ��
SELECT * FROM [dbo].[specMS_EntryContentExt]
--��Ʒ�м�ģ�����Ʒ�еĹ�ϵ��
SELECT * FROM [dbo].[specMS_ProductColumn]
--drop table [specMS_ProductColumn]
--��Ʒ�����ݱ�
SELECT * FROM [dbo].[specMS_ProColContent]
--drop table [specMS_ProColContent]
--���ò�Ʒ����ͼ��
SELECT * FROM [dbo].[specMS_TempBaselineRel]
--drop table [specMS_TempBaselineRel]

--Sol ��ͷΪ���������ر�  release2����


ALTER TABLE [dbo].[specMS_EntryContentExt]  ADD  verStatus  INT  DEFAULT(0)   NOT NULL;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1�ɳ���0�ݸ�1����-2��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_EntryContentExt', @level2type=N'COLUMN',@level2name=N'verStatus';

ALTER TABLE [dbo].[specMS_ProColContent]  ADD  verStatus  INT  DEFAULT(0)   NOT NULL;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-1�ɳ���0�ݸ�1����-2��������' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_ProColContent', @level2type=N'COLUMN',@level2name=N'verStatus'
