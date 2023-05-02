--查询当前数据库中的所有表民
select   name   from  sysobjects   a  where  a.xtype='U';

--查询指定表中的所有字段名
select   name   from  syscolumns  a  where  id=(select  id  from   sysobjects  a   where  a.xtype='U'  and  a.name='TraineeThesis');