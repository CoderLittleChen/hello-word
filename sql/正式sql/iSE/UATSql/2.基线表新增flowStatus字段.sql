alter table  Sol_BaseLine  add  FlowStatus  int;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 上传组网图  2  维护部件产品  3 维护每期版本号  4 导出模板 5 导入模板 6 其他（规格维护 规格确认 基线化）' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'flowStatus'
