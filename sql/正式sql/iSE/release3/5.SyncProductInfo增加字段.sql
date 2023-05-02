alter table  Sync_ProductInfo  add  BVersionCode  nvarchar(250);
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'B°æ±¾code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'BVersionCode';

alter table  Sync_ProductInfo  add  BVersionName  nvarchar(250);
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'B°æ±¾name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sync_ProductInfo', @level2type=N'COLUMN',@level2name=N'BVersionName'