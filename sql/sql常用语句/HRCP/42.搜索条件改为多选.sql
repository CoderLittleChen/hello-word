--������������Ϊ��ѡ  �����
--1�����������е������Ǵ����ݿ��в������  ��Ҫ��ҳ���ϵĳ��������н�������
--2����ν� �����޸�Ϊ��ѡ�Ĵ���  ԭ��Ϊ select   option ���͵�
--3������������ϣ�����Ҳ�޸���  ���ǻ��ǵ��û�е�������ѡ��ҳ�棬����Ϊû������ControlCommon.js  

--sql����ִ��˳��

--from  
--join   
--on    
--where   
--group  by 
--avg sum
--having
--select   
--distinct
--order by
--top


--AppConstant				�������   ���������
--AppConstantValue		����ֵ
select  *   from   AppConstantValue  a    where  a.Text='ICTί�п���';

select  *   from   AppConstant  a    where  a.Name   like  '%��Ŀ��Ա����%';

--9B50E82D-566E-4D7A-AA81-68173C4EC32F
select  *   from   AppConstantValue  a    where  a.AppConstantId='9B50E82D-566E-4D7A-AA81-68173C4EC32F';

--��Ŀ��Ա��¼  ��Ա״̬�еļ�������       
--�ڸ�-�ⳡ   
--�ڸ�-�ڳ�
--�볡������
--���������
--����    
--�ͷ�
  


select   *      from   ProjectPersonInfo   a;
select   a.*   from   V_ProjectPersonRecord   a    where  a.PersonStatus  like  '%ת%';

select   a.Name,a.MaterialFileNo,a.CreateDate      from   V_ProjectPersonRecord   a   order  by   a.CreateDate  desc;

--�ú����������ɲ��Ϲ鵵�±��  MaterialFileNo
select  dbo.F_GetSerialProjectFileCode();

select  dbo.F_GetSerialProjectLeaveFileCode();

select   convert(varchar(4),Getdate(),112);

select   a.MaterialFileNo,MaterialLeaveFileNo,a.MaterialFileId,a.*   from  MaterialFile  a   order  by   a.CreateDate desc;

select   *   from  ProjectPersonInfo   a  where  ProjectPersonInfoId='0EAAEFBA-D445-4C90-AF19-F6C72162D0E3';

--update  MaterialFile   set   MaterialLeaveFileNo='20190001'  where  MaterialFileId='91430E55-93F7-45EF-B1CA-8AD6049691DC';

select   *   from    MaterialFile  a  inner   join   ProjectPersonInfo   b   on  a.PersonInfoId=b.ProjectPersonInfoId 
where  (b.Name  like  '&��������&');
  
--�����쳣   

--�Ҳ�����Ŀ��Ա��   ��������������
select   *    from   ProjectPersonInfo   a;

--���ڼ�¼��
select   *    from   AttendanceRecord  a;

--�����쳣��
--����  AbnormalRecordId  ����ô���ģ�ʲô��˼��
--ͨ��AttendanceRecordId �����й��� 
select   *    from   AttendanceAbnormalDetail   a;         
         

--��Ŀ��Ա����  ��ѯ����  V_ProjectPersonInfo                                                                                                                                                                                                                                                                                                                                                                                                             





