use iSEDB;
alter table  specms_specDataIDSet  add  BaseVersionType  tinyint;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 PDT以R版本维护  2  PDT以B版本维护  3 其他' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_SpecDataIDSet', @level2type=N'COLUMN',@level2name=N'BaseVersionType'

alter table  specms_SpecDataIDSet  add  IsMerge  int;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 已经合并  0 未合并' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_SpecDataIDSet', @level2type=N'COLUMN',@level2name=N'IsMerge'

alter  table  specms_specDataIDSet  add   isSync  tinyint default 1;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 同步版本，0 手动新增版本' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specMS_SpecDataIDSet', @level2type=N'COLUMN',@level2name=N'isSync'

ALTER TABLE specMS_SpecDataIDSet ALTER COLUMN srcName NVARCHAR(200);

alter table  specms_SpecBaseLine  add  DeleteFlag  int;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'是否失效  0 正常  1删除' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'specms_SpecBaseLine', @level2type=N'COLUMN',@level2name=N'DeleteFlag'



