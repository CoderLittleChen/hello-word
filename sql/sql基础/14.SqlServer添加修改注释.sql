
execute sp_addextendedproperty 'MS_Description','add by liyc. 诊断类别码','user','dbo','table','DiagRecord','column','DiagTypeCode';
 
--修改字段注释 
execute sp_updateextendedproperty 'MS_Description','add by liyc.','user','dbo','table','DiagRecord','column','DiagTypeCode';
 
--删除字段注释
execute sp_dropextendedproperty 'MS_Description','user','dbo','table','DiagRecord','column','DiagTypeCode';
 
-- 添加表注释
execute sp_addextendedproperty 'MS_Description','诊断记录文件','user','dbo','table','DiagRecord',null,null;
 
-- 修改表注释
execute sp_updateextendedproperty 'MS_Description','诊断记录文件1','user','dbo','table','DiagRecord',null,null;
 
-- 删除表注释
execute sp_dropextendedproperty 'MS_Description','user','dbo','table','DiagRecord',null,null;