--��Ŀ��Ա��������û����, ��[dbo].[ProjectPersonInfo] ȴ�鲻����,   
--��[dbo].[ProjectPersonInfo_History] ������, ���ǲ��Կ��������, ��������ǲ������İ�  

use hrcp;
select  *  from  ProjectPersonInfo   a   where  a.DeleteFlag=0;

select  *  from  ProjectPersonInfo_History   a ;

select  *  from  ProjectPersonRecord   a ;


select top 1 *from [dbo].[ProjectPersonInfo_History] where ProjectPersonInfoId='68cbd428-f2e6-4b4b-9a03-e875c85a0ea8';
select top 1 *from [dbo].[ProjectPersonInfo] where ProjectPersonInfoId='2E673F9F-B30D-41F1-9328-66EBAD4C1484';

select  *  from  ProjectPersonInfo  a  where  a.IdCard='330102199012182717';

select  *  from  V_ProjectPersonInfo  a   where a.Name='�³�';

select  *  from  V_ProjectPersonInfo  a   where a.ProjectPersonInfoId='2E673F9F-B30D-41F1-9328-66EBAD4C1484'

select  *  from  ProjectPersonInfo  a  where  a.Name='�³�';

select  *  from  ProjectPersonInfo_History  a  where  a.Name='�³�';

--����id��ѯҪȷ��  �������ʽ������ʷ��  