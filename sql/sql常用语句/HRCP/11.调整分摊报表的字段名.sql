
use hrcp;
--������̯���� �ֶ���
--OnSite/ʵϰ��  �����¼
select   *   from  V_OnsitePayReport   a;

--��ͨ��Ŀ�����¼
select   *   from  V_GeneralPayReport  a;

--������ͨ��Ŀ��û�е��ֶ� �����ͨ����ҵ���� 
--�������գ�  ������Ŀ�������Ʒ��   ���úϼƣ����Ѵ����ֶ�  ���� �ظ���
--PersonCount   BenefitproName   ExpenseTotal    

select   a.PersonCount,a.BenefitProName,a.ExpenseTotal,*   from  PayReport   a   
select   *   from  BenefitProDivide  a;


select   *   from   PayReport  a
left join  BenefitProDivide  b  on   a.PayReportId=b.PayReportId
inner join  PayStandingBook  c  on   a.PayReportId=c.PayReportId;


--OnSite/ʵϰ����ͼȱ�ٵ��ֶ�
--��Ŀ��������Ŀ����					��
--�ܽ��			�Ƿ�Ҫ�Ѹ���Ŀÿһ�ڵ�֧������ۼ�����?
--�����Ʒ     
--�����Ʒ����  
--������Ʒ��(������ͼ�ֶε�ֵ��Ϊ��)   
--��Ŀ������Ŀ���ڸ���  ��Ӧ����Ʒ�ߵ���Ŀ����   
--��ռ����  
--����  �����úϼ� �ظ���


select   *   from    ExpenseSettlementDetail   a
left  join   ExpensePersonDivide  b   on  a.ExpenseSettlementDetailId=b.SettlementDetailId
inner join  PayStandingBook  c   on  a.ExpenseSettlementDetailId=c.PayReportId; 


