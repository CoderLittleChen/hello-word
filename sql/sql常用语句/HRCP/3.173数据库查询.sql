--use hrcp;
--select  *  from  PersonInfo  a;
--select  *  from  V_MyToDo  a;  
--1����ͼMy_ToDo��ѯ�������ַ���ת������/ʱ��  ת��ʧ��   ����Ϊʲô��
--2����Ա��Ϣ  V_PersonInfo     


select   *  from   V_PersonInfo  a;

select   *  from   PersonInfo  a;

select   *  from   V_MyToDo   a;

select   a.CreateDate,*  from   ProcessFlow  a;



SELECT   NEWID() AS Id, rra.ReqcruitReqApplyId AS ToDoId, rra.RecruitNo AS Content, 'OnSite��������' AS FlowType, 
                '������������||OnSite/RecruitReqDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, pf.CurrentNode, 
                pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                RecruitReqApply rra ON pf.ApprovalId = rra.ReqcruitReqApplyId
WHERE   rra.IsTrainee = 0 AND rra.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, rra.ReqcruitReqApplyId AS ToDoId, rra.RecruitNo AS Content, 'ʵϰ����������' AS FlowType, 
                'ʵϰ��������������||Trainee/TraineeRequireDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                RecruitReqApply rra ON pf.ApprovalId = rra.ReqcruitReqApplyId
WHERE   rra.IsTrainee = 1 AND rra.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pe.PersonEntryId AS ToDoId, pe.EmployeeName AS Content, 'OnSite��Ա����' AS FlowType, 
                'OnSite��������||OnSite/PersonEntryDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonEntry pe ON pf.ApprovalId = pe.PersonEntryId
WHERE   pe.IsTrainee = 0 AND pe.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pe.PersonEntryId AS ToDoId, pe.EmployeeName AS Content, 'ʵϰ����Ա����' AS FlowType, 
                'ʵϰ����������||Trainee/TraineeEntryDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonEntry pe ON pf.ApprovalId = pe.PersonEntryId
WHERE   pe.IsTrainee = 1 AND pe.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pinfo.PersonInfoId AS ToDoId, pinfo.EmployeeName AS Content, 'OnSite��Ա����' AS FlowType, 
                'OnSite��������||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, pf.CurrentNode, 
                pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonInfo pinfo ON pf.ApprovalId = pinfo.PersonInfoId
WHERE   pinfo.IsTrainee = 0 AND pinfo.DeleteFlag = 0 AND pinfo.OnJobStatus = 1 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pinfo.PersonInfoId AS ToDoId, pinfo.EmployeeName AS Content, 'ʵϰ����Ա����' AS FlowType, 
                'ʵϰ����������||Trainee/TraineeInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonInfo pinfo ON pf.ApprovalId = pinfo.PersonInfoId
WHERE   pinfo.IsTrainee = 1 AND pinfo.DeleteFlag = 0 AND pinfo.OnJobStatus = 1 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pet.PersonEvaluateId AS ToDoId, pet.EmployeeName AS Content, 'OnSite��Ա����-'+pet.EmployeeName AS FlowType, 
                'OnSite��������||OnSite/PersonEvaluateDetail?id=hrcpid&operatetype=update' AS FlowUrl, pet.ProcessFlowId, 
                pet.CurrentNode, pet.CurrentPerson, pet.CreateDate
FROM      V_PersonEvaluate pet
WHERE   pet.IsTrainee = 0 AND pet.DeleteFlag = 0 
UNION
SELECT   NEWID() AS Id, pet.PersonEvaluateId AS ToDoId, pet.EmployeeName AS Content, 'ʵϰ����Ա����' AS FlowType, 
                'ʵϰ����������||Trainee/TraineeEvaluateDetail?id=hrcpid&operatetype=update' AS FlowUrl, pet.ProcessFlowId, 
                pet.CurrentNode, pet.CurrentPerson, pet.CreateDate
FROM      V_PersonEvaluate pet
WHERE   pet.IsTrainee = 1 AND pet.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, tt.TraineeThesisId AS ToDoId, tt.EmployeeName AS Content, 'ʵϰ����������' AS FlowType, 
                'ʵϰ��������������||Trainee/TraineeThesisDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                TraineeThesis tt ON pf.ApprovalId = tt.TraineeThesisId
WHERE   tt.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, tb.TraineeBankInfoId AS ToDoId, tb.EmployeeName AS Content, 'ʵϰ��������Ϣ' AS FlowType, 
                'ʵϰ��������Ϣ����||Trainee/TraineeBankInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                TraineeBankInfo tb ON pf.ApprovalId = tb.TraineeBankInfoId
WHERE   tb.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, tc.TraineeCertificateId AS ToDoId, tc.EmployeeName AS Content, 'ʵϰ��֤������' AS FlowType, 
                'ʵϰ��֤����������||Trainee/TraineeCertificateDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                TraineeCertificate tc ON pf.ApprovalId = tc.TraineeCertificateId
WHERE   tc.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.ProjectSetupId AS ToDoId, ps.ProjectName AS Content, '������Ŀ��������' AS FlowType, 
                '������Ŀ������������||Project/ProjectSetupDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectSetup ps ON pf.ApprovalId = ps.ProjectSetupId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
--UNION
--SELECT   ps.PersonSubmitApprovalId AS ToDoId, ps.PersonApprovalNo AS Content, 'OnSite��Ա����' AS FlowType, 
--                'OnSite��Ա��������||OnSite/PersonApprovalDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
--                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
--FROM      ProcessFlow pf INNER JOIN
--                PersonSubmitApproval ps ON pf.ApprovalId = ps.PersonSubmitApprovalId
--WHERE   ps.DeleteFlag = 0 AND ps.IsTrainee = 0
UNION
SELECT  NEWID() AS Id,  ps.AskForLeaveId AS ToDoId, ps.ProposerCode AS Content, '�������' AS FlowType, 
                '�����������||Attendance/ShowAskForLeaveDetail?askforleaveId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AskForLeave ps ON pf.ApprovalId = ps.AskForLeaveId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.AskForOvertimeId AS ToDoId, ps.ProposerCode AS Content, '�Ӱ�����' AS FlowType, 
                '�Ӱ���������||Attendance/ShowAskForOvertimeDetail?overtimeId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AskForOvertime ps ON pf.ApprovalId = ps.AskForOvertimeId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.AddPointId AS ToDoId, ps.ProposerCode AS Content, '�ӵ�����' AS FlowType, 
                '�ӵ���������||Attendance/ShowAskForAddPointDetail?addpointId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AddPoint ps ON pf.ApprovalId = ps.AddPointId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.PersonSubmitApprovalId AS ToDoId, ps.PersonApprovalNo AS Content, 'ʵϰ����Ա����' AS FlowType, 
                'ʵϰ����Ա��������||Trainee/TraineeApprovalDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonSubmitApproval ps ON pf.ApprovalId = ps.PersonSubmitApprovalId
WHERE   ps.DeleteFlag = 0 AND ps.IsTrainee = 1
UNION
SELECT   NEWID() AS Id, ps.ProjectSummaryId AS ToDoId, pc.ProjectName AS Content, '��Ŀ�ܽᱨ��' AS FlowType, 
                '��Ŀ�ܽᱨ������||Project/ProjectSummaryDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectSummary ps ON pf.ApprovalId = ps.ProjectSummaryId INNER JOIN
                ProjectControl pc ON pc.ProjectControlId = ps.ProjectControlId
WHERE   ps.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pe.ProjectExceptionEndId AS ToDoId, pe.ProjectName AS Content, '��Ŀ�쳣��ֹ' AS FlowType, 
                '��Ŀ�쳣��ֹ����||Project/ProjectExceptionEndDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectExceptionEnd pe ON pf.ApprovalId = pe.ProjectExceptionEndId
WHERE   pe.DeleteFlag = 0
--UNION
--SELECT   ps.AbnormalRecordId AS ToDoId, ps.FeedbackPersonSign AS Content, '��Ϣ���쳣����' AS FlowType, 
--                '��Ϣ���쳣��������||Attendance/RestDayAbnormalDetail?abnormalId=hrcpid&operatetype=update' AS FlowUrl, 
--                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
--FROM      ProcessFlow pf INNER JOIN
--                AbnormalRecord ps ON pf.ApprovalId = ps.AbnormalRecordId
--WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0 AND  ps.DayType=0
UNION
SELECT DISTINCT NEWID() AS Id,  ab.AbnormalRecordId AS ToDoId, ab.CreateBy AS Content, '�������쳣����' AS FlowType, 
                '�������쳣��������||Attendance/AbnormalDetail?abnormalId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AbnormalRecord ab ON pf.ApprovalId = ab.AbnormalRecordId
				INNER JOIN AttendanceAbnormalDetail aa ON ab.AbnormalRecordId=aa.AbnormalRecordId
WHERE   ab.DeleteFlag = 0 AND pf.DeleteFlag = 0 AND  ab.DayType=1  AND aa.CancelStatus=0 
UNION
SELECT  NEWID() AS Id,  pe.ProjectPersonEntryId AS ToDoId, pc.ProjectName AS Content, '�����з�������' AS FlowType, 
                '�����з�����������||Project/ProPersonEntryDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectPersonEntry pe ON pf.ApprovalId = pe.ProjectPersonEntryId INNER JOIN
                ProjectControl pc ON pc.ProjectControlId = pe.ProjectControlId
WHERE   pe.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ppi.ProjectPersonInfoId AS ToDoId, ppi.Name AS Content, '��Ŀ��Ա����' AS FlowType, 
                '��Ŀ��Ա��������||Project/ProPersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectPersonInfo ppi ON pf.ApprovalId = ppi.ProjectPersonInfoId
WHERE   ppi.DeleteFlag = 0 AND ppi.IsOnDuty=0
UNION
SELECT   NEWID() AS Id, pe.ProjectPersonEvaluateId AS ToDoId, ppi.Name AS Content, '��Ŀ��Ա����' AS FlowType, 
                '��Ŀ��Ա��������||Project/ProPersonEvaluateDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectPersonEvaluate pe ON pf.ApprovalId = pe.ProjectPersonEvaluateId INNER JOIN
                ProjectPersonInfo ppi ON ppi.ProjectPersonInfoId = pe.ProjectPersonInfoId
WHERE   pe.DeleteFlag = 0 
UNION 
SELECT   NEWID() AS Id, ps.PayReportId AS ToDoId, ps.ProjectName AS Content, '���⸶���' AS FlowType, 
                '���⸶��ȷ�ϱ���||Expenses/PayConfirmDetail?payReportId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PayReport ps ON pf.ApprovalId = ps.PayReportId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION 
SELECT  NEWID() AS Id,  ps.ExpenseSettlementDetailId AS ToDoId, 'Onsite/ʵϰ�����⸶��ȷ�ϱ���' AS Content, 'Onsite/ʵϰ�������' AS FlowType, 
                'Onsite/ʵϰ�����⸶��ȷ�ϱ���||Expenses/ExpenseSettlementDetail?settlementid=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ExpenseSettlementDetail ps ON pf.ApprovalId = ps.ExpenseSettlementDetailId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '��Ա����鵵ȷ��' AS FlowType, 
                'OnSite��������||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                info.ProcessFlowId, '��Ա����鵵ȷ��' AS CurrentNode,(SELECT OnSiteFileConfirm FROM AreaConfig WHERE WorkPlace=info.WorkPlace) AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����' and ISNULL(LeaveConfirmSign,'')='' and ISNULL(LeaveCooSign,'')!='' and IsTrainee=0

UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '��Ա����鵵' AS FlowType, 
                'OnSite��������||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                info.ProcessFlowId, '��Ա����鵵' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����' and ISNULL(LeaveAgreeSign,'')='' and IsTrainee=0
UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, 'ʵϰ������鵵' AS FlowType, 
                'ʵϰ�����Ϲ鵵||Trainee/TraineeDocumentDetail?id=hrcpid' AS FlowUrl, 
                info.ProcessFlowId, 'ʵϰ������鵵' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����'  and IsTrainee=1
UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, 'ʵϰ������鵵' AS FlowType, 
                'ʵϰ�����Ϲ鵵||Trainee/TraineeDocumentDetail?id=hrcpid' AS FlowUrl, 
                info.ProcessFlowId, 'ʵϰ������鵵' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='������-����'  and IsTrainee=1
UNION
SELECT   NEWID() AS Id, ProjectCheckReportId AS ToDoId,ProjectName  AS Content, '��Ŀ���ձ���' AS FlowType, 
                '��Ŀ���ձ���||Project/CooperateProjectCheck?checkreportId=hrcpid&operatetype=update' AS FlowUrl, 
                ProcessFlowId, CurrentNode, CurrentPerson, CreateDate
FROM  V_ProjectCheckReport
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'��Ŀ��Ա����鵵' AS FlowType,
				'��Ŀ��Ա��¼||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','��Ŀ��Ա����鵵' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where ISNULL(CooMgrUploadEntryDataSign,'')='' and (PersonStatus='�ڸ�-�ڳ�' or PersonStatus='�ڸ�-�ⳡ') and IsStopMaterial=0
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'��Ŀ��Ա����鵵ȷ��' AS FlowType,
				'��Ŀ��Ա��¼||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','��Ŀ��Ա����鵵ȷ��' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where ISNULL(CooMgrUploadEntryDataSign,'')!='' and (PersonStatus='�ڸ�-�ڳ�' or PersonStatus='�ڸ�-�ⳡ') and ISNULL(DocAdminSureEntryDataSign,'')='' and IsStopMaterial=0
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'��Ŀ��Ա����鵵' AS FlowType,
				'��Ŀ��Ա��¼||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','��Ŀ��Ա����鵵' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where IsOnDuty=0 and PersonStatus!='�볡' and PersonStatus!='�볡������' and ISNULL(CooMgrUploadReleaseDataSign,'')='' and IsStopMaterial=0
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'��Ŀ��Ա����鵵ȷ��' AS FlowType,
				'��Ŀ��Ա��¼||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','��Ŀ��Ա����鵵ȷ��' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where ISNULL(CooMgrUploadReleaseDataSign,'')!='' and IsOnDuty=0 and PersonStatus!='�볡' and PersonStatus!='�볡������' and ISNULL(DocAdminSureReleaseDataSign,'')='' and IsStopMaterial=0
UNION
SELECT  NEWID() AS Id,  CooperationToFormalId AS ToDoId,ApplyPerson  AS Content, '�������Ա��ת��' AS FlowType, 
                '����Ա��ת������||OnSite/OnSiteToFormalDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                ProcessFlowId, CurrentNode, CurrentPerson, CreateDate
FROM V_CooperationToFormal 