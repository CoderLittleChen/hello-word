alter table  Sol_BaseLine  add  FlowStatus  int;
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 �ϴ�����ͼ  2  ά��������Ʒ  3 ά��ÿ�ڰ汾��  4 ����ģ�� 5 ����ģ�� 6 ���������ά�� ���ȷ�� ���߻���' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Sol_BaseLine', @level2type=N'COLUMN',@level2name=N'flowStatus'
