
--iPlan������Ŀ���� С��  ���ݺϲ�Ϊһ�ű�
select   *  into   IPDProjectTemp
from  IPDProjectSubType ;

insert into  IPDProjectTemp
select  a.IPDProjectTypeID,null,a.Name,a.Code,a.DisplayOrder,a.Description,
a.CreationDate,a.Creator,a.ModificationDate,a.Modifier,a.DeleteFlag
from  IPDProjectType  a;