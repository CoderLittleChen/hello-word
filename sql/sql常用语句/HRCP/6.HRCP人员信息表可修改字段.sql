--�����޸ĵ���  
--���˺�  ����ȫƴ  Ӣ����   �칫�ص�  ����  �绰���볤��   �̺�  �ֻ�   ����  ����    
--�������޸ĵ���
--����  ������
--��Ҫ��ӵ��ֶ�
--���˺�   DomainAccount
--ƴ��    PingYing
--Ӣ����  EnglishName
--�����  RoomNo
--�绰�̺�  Extension
--�绰����(�Ѵ���)     �����
--����  [Email]
--����   [Fax]
--ͬ��ʱ��  SyncTime  

--���ڵ�����    ����sql  ��Telephone��Ӧ���� �绰���ţ�����hrcp��Telephone��Ӧ���ǵ绰����   ��HRCP��Ϊ׼
use hrcp;
select   *   from  PersonInfo  a;

select  a.EmployeeName,a.OfficeLocation,a.WorkNum  from  PersonInfo  a where a.WorkPlace='����';

