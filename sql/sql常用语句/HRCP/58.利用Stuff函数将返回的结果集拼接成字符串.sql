
 select  STUFF((SELECT DISTINCT(','+GroupName  ) FROM GroupInfo   FOR XML PATH('')),1, 1, '');


 --法学院,经济法学专业,经济法学专业二班,经济法学专业一班,某某大学,日语专业,日语专业二班,
 --日语专业一班,外语学院,刑法学专业,刑法学专业二班,刑法学专业一班,英语专业,英语专业二班,英语专业一班

 --在使用xml  form path的时候 需要注意 两点
 --1、for xml  path中的参数为 xml的节点名称  可以为空''  
 --2、在列名后面空字符串''   如果不加字符串   列名会作为标签名称显示   

 --如果有字段为Null，则该条数据对应的节点下 没有字段       
 select   a.GroupName+','   from  GroupInfo   a  for  xml   path('');   