
--iPlan数据项目大类 小类  数据合并为一张表
select   *  into   IPDProjectTemp
from  IPDProjectSubType ;

insert into  IPDProjectTemp
select  a.IPDProjectTypeID,null,a.Name,a.Code,a.DisplayOrder,a.Description,
a.CreationDate,a.Creator,a.ModificationDate,a.Modifier,a.DeleteFlag
from  IPDProjectType  a;