alter table  Sol_ProductInfo  add  Solution_Code  nvarchar(50);
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'Solution_Code';

alter table  Sol_ProductInfo  add  Solution_Name  nvarchar(200);
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_ProductInfo', @level2type=N'COLUMN',@level2name=N'Solution_Name';
