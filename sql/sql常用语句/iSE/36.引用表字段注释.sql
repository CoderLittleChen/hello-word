select * from specMS_TabRefBaseLine where dataSrc!=2 and listblID=17094;

select  *  from  specMS_SpecListTab   a  where  a.tabID='101322';

select  *  from  specMS_SpecListTab   a  where  a.tabID='101320';

select  *  from   specMS_SpecBLEntryRel   a  where  a.blID=17095;



--specMS_SpecBLEntryRel    ���ֶκ���
--blEntryId    ����
--refID  ��ǰ�������TabId
--refBlId  
--entryId   ���id
--entryPid  ��񸸼�id
--blId  ����id
--lvl  ��񼶱�
--isLeaf  �Ƿ�ΪҶ�ӽڵ�


--specMS_TabRefBaseLine
--TabId  ��ǰ����TabId
--dataSrc  ����ʱ��  1��Ʒ  3ģ��
--

--specms_SpecList								blId	������id
--specms_SpecBlEntryRel						blId	�ӻ���id
--specms_SpecTabRefBaseLine				blId	�ӻ���id		listBlId	������id
--specms_SpecListExtColData				blId	������id
															
