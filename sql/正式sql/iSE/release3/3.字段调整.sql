use iSEDB;
alter table  specms_specDataIDSet  add  BaseVersionType  tinyint;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 PDT��R�汾ά��  2  PDT��B�汾ά��  3 ����' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_SpecDataIDSet', @level2type=N'COLUMN',@level2name=N'BaseVersionType'

alter table  specms_SpecDataIDSet  add  IsMerge  int;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 �Ѿ��ϲ�  0 δ�ϲ�' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_SpecDataIDSet', @level2type=N'COLUMN',@level2name=N'IsMerge'

alter  table  specms_specDataIDSet  add   isSync  tinyint default 1;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 ͬ���汾��0 �ֶ������汾' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_SpecDataIDSet', @level2type=N'COLUMN',@level2name=N'isSync'

ALTER TABLE specMS_SpecDataIDSet ALTER COLUMN srcName NVARCHAR(200);

alter table  specms_SpecBaseLine  add  DeleteFlag  int;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'�Ƿ�ʧЧ  0 ����  1ɾ��' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_SpecBaseLine', @level2type=N'COLUMN',@level2name=N'DeleteFlag'



