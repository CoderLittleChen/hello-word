--��ѯ��ǰ���ݿ��е����б���
select   name   from  sysobjects   a  where  a.xtype='U';

--��ѯָ�����е������ֶ���
select   name   from  syscolumns  a  where  id=(select  id  from   sysobjects  a   where  a.xtype='U'  and  a.name='TraineeThesis');