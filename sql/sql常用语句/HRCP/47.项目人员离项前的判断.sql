--�����Ƿ����쳣  --���ϣ��������Ƿ�鵵���Ƿ��Ѵ��� ���Ը���ǩ������        ����鵵Ϊ��    ��������������

select   a.ID,*  from   ProjectPersonInfo   a   where  a.Name='�³�';

select   a.name   from   ProjectPersonInfo   a    group  by   a.name   having (COUNT(a.Name)<2);

select   *  from    AttendanceRecord   a   where  a.Code='huangyanyan KF7091'  order  by  a.DutyDate desc;

select   *  from    AttendanceAbnormalDetail  a;

select   *  from    V_AttendanceAbnormalList  a;

--DataType=1   ������    DataType=2   ��Ϣ��
select   *  from    HRSS_View_WorkSchedule  a   order  by   a.WorkDay desc;

select  b.*  from   AttendanceRecord  a   
inner  join  AttendanceAbnormalDetail  b  on   a.AttendanceRecordId=b.AttendanceRecordId
inner join  ProjectPersonInfo  c  on   a.Code=c.ID 
--where  a.Code='chencheng KF7871'
where  c.IdCard='130903199411062336';


select  *   from    ProjectPersonRecord  a;
 
 --IsFinishFile   0��ʾ  �� 
select  a.EntryFile,a.IsFinishFile,a.Name   from    V_ProjectPersonRecord  a;

select  a.Name  from  V_ProjectPersonRecord  a;

select  *   from   ProjectPersonRecord    a ;




