SELECT 
sysobjects.name, 
syscolumns.name 
FROM sysobjects  
inner join syscolumns 
ON  sysobjects.id =syscolumns.id --表关联条件
where sysobjects.name='ProductConfigImportData'  order  by syscolumns.name  
