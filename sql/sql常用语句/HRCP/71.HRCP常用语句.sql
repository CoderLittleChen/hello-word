--项目人员离项流程没走完, 在[dbo].[ProjectPersonInfo] 却查不到了,   
--在[dbo].[ProjectPersonInfo_History] 表里有, 这是测试库里的数据, 这种情况是不正常的吧  

use hrcp;
select  *  from  ProjectPersonInfo   a   where  a.DeleteFlag=0;

select  *  from  ProjectPersonInfo_History   a ;

select  *  from  ProjectPersonRecord   a ;


select top 1 *from [dbo].[ProjectPersonInfo_History] where ProjectPersonInfoId='68cbd428-f2e6-4b4b-9a03-e875c85a0ea8';
select top 1 *from [dbo].[ProjectPersonInfo] where ProjectPersonInfoId='2E673F9F-B30D-41F1-9328-66EBAD4C1484';

select  *  from  ProjectPersonInfo  a  where  a.IdCard='330102199012182717';

select  *  from  V_ProjectPersonInfo  a   where a.Name='陈骋';

select  *  from  V_ProjectPersonInfo  a   where a.ProjectPersonInfoId='2E673F9F-B30D-41F1-9328-66EBAD4C1484'

select  *  from  ProjectPersonInfo  a  where  a.Name='陈骋';

select  *  from  ProjectPersonInfo_History  a  where  a.Name='陈骋';

--根据id查询要确定  查的是正式表还是历史表  