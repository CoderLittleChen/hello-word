--����Ҫ��ȡ���еļ�¼����ʱ��  ������Ҫ��Count(*)  ���������ȫ��ɨ��  Ӱ���ٶ�  
select  COUNT(*)  from  GroupInfo  a;

--�������  ��ִ��ȫ��ɨ��Ҳ�����õ���ļ�¼��    ����һ�㲻���õ�������ļ�¼���������Ƿ�ҳ��ѯ
select  rows   from  sysindexes   where  id=OBJECT_ID('dbo.GroupInfo')  and  indid<2;


