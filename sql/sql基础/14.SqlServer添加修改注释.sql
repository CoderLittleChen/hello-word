
execute sp_addextendedproperty 'MS_Description','add by liyc. ��������','user','dbo','table','DiagRecord','column','DiagTypeCode';
 
--�޸��ֶ�ע�� 
execute sp_updateextendedproperty 'MS_Description','add by liyc.','user','dbo','table','DiagRecord','column','DiagTypeCode';
 
--ɾ���ֶ�ע��
execute sp_dropextendedproperty 'MS_Description','user','dbo','table','DiagRecord','column','DiagTypeCode';
 
-- ��ӱ�ע��
execute sp_addextendedproperty 'MS_Description','��ϼ�¼�ļ�','user','dbo','table','DiagRecord',null,null;
 
-- �޸ı�ע��
execute sp_updateextendedproperty 'MS_Description','��ϼ�¼�ļ�1','user','dbo','table','DiagRecord',null,null;
 
-- ɾ����ע��
execute sp_dropextendedproperty 'MS_Description','user','dbo','table','DiagRecord',null,null;