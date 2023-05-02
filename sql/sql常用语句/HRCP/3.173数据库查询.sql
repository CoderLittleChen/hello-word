--use hrcp;
--select  *  from  PersonInfo  a;
--select  *  from  V_MyToDo  a;  
--1、视图My_ToDo查询报错，从字符串转换日期/时间  转换失败   这是为什么？
--2、人员信息  V_PersonInfo     


select   *  from   V_PersonInfo  a;

select   *  from   PersonInfo  a;

select   *  from   V_MyToDo   a;

select   a.CreateDate,*  from   ProcessFlow  a;



SELECT   NEWID() AS Id, rra.ReqcruitReqApplyId AS ToDoId, rra.RecruitNo AS Content, 'OnSite需求申请' AS FlowType, 
                '需求申请详情||OnSite/RecruitReqDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, pf.CurrentNode, 
                pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                RecruitReqApply rra ON pf.ApprovalId = rra.ReqcruitReqApplyId
WHERE   rra.IsTrainee = 0 AND rra.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, rra.ReqcruitReqApplyId AS ToDoId, rra.RecruitNo AS Content, '实习生需求申请' AS FlowType, 
                '实习生需求申请详情||Trainee/TraineeRequireDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                RecruitReqApply rra ON pf.ApprovalId = rra.ReqcruitReqApplyId
WHERE   rra.IsTrainee = 1 AND rra.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pe.PersonEntryId AS ToDoId, pe.EmployeeName AS Content, 'OnSite人员入项' AS FlowType, 
                'OnSite入项流程||OnSite/PersonEntryDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonEntry pe ON pf.ApprovalId = pe.PersonEntryId
WHERE   pe.IsTrainee = 0 AND pe.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pe.PersonEntryId AS ToDoId, pe.EmployeeName AS Content, '实习生人员入项' AS FlowType, 
                '实习生入项流程||Trainee/TraineeEntryDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonEntry pe ON pf.ApprovalId = pe.PersonEntryId
WHERE   pe.IsTrainee = 1 AND pe.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pinfo.PersonInfoId AS ToDoId, pinfo.EmployeeName AS Content, 'OnSite人员离项' AS FlowType, 
                'OnSite离项流程||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, pf.CurrentNode, 
                pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonInfo pinfo ON pf.ApprovalId = pinfo.PersonInfoId
WHERE   pinfo.IsTrainee = 0 AND pinfo.DeleteFlag = 0 AND pinfo.OnJobStatus = 1 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pinfo.PersonInfoId AS ToDoId, pinfo.EmployeeName AS Content, '实习生人员离项' AS FlowType, 
                '实习生离项流程||Trainee/TraineeInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonInfo pinfo ON pf.ApprovalId = pinfo.PersonInfoId
WHERE   pinfo.IsTrainee = 1 AND pinfo.DeleteFlag = 0 AND pinfo.OnJobStatus = 1 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pet.PersonEvaluateId AS ToDoId, pet.EmployeeName AS Content, 'OnSite人员考评-'+pet.EmployeeName AS FlowType, 
                'OnSite考评流程||OnSite/PersonEvaluateDetail?id=hrcpid&operatetype=update' AS FlowUrl, pet.ProcessFlowId, 
                pet.CurrentNode, pet.CurrentPerson, pet.CreateDate
FROM      V_PersonEvaluate pet
WHERE   pet.IsTrainee = 0 AND pet.DeleteFlag = 0 
UNION
SELECT   NEWID() AS Id, pet.PersonEvaluateId AS ToDoId, pet.EmployeeName AS Content, '实习生人员考评' AS FlowType, 
                '实习生考评流程||Trainee/TraineeEvaluateDetail?id=hrcpid&operatetype=update' AS FlowUrl, pet.ProcessFlowId, 
                pet.CurrentNode, pet.CurrentPerson, pet.CreateDate
FROM      V_PersonEvaluate pet
WHERE   pet.IsTrainee = 1 AND pet.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, tt.TraineeThesisId AS ToDoId, tt.EmployeeName AS Content, '实习生论文审批' AS FlowType, 
                '实习生论文审批流程||Trainee/TraineeThesisDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                TraineeThesis tt ON pf.ApprovalId = tt.TraineeThesisId
WHERE   tt.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, tb.TraineeBankInfoId AS ToDoId, tb.EmployeeName AS Content, '实习生银行信息' AS FlowType, 
                '实习生银行信息流程||Trainee/TraineeBankInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                TraineeBankInfo tb ON pf.ApprovalId = tb.TraineeBankInfoId
WHERE   tb.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, tc.TraineeCertificateId AS ToDoId, tc.EmployeeName AS Content, '实习生证明办理' AS FlowType, 
                '实习生证明办理流程||Trainee/TraineeCertificateDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                TraineeCertificate tc ON pf.ApprovalId = tc.TraineeCertificateId
WHERE   tc.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.ProjectSetupId AS ToDoId, ps.ProjectName AS Content, '合作项目立项申请' AS FlowType, 
                '合作项目立项申请流程||Project/ProjectSetupDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectSetup ps ON pf.ApprovalId = ps.ProjectSetupId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
--UNION
--SELECT   ps.PersonSubmitApprovalId AS ToDoId, ps.PersonApprovalNo AS Content, 'OnSite人员报批' AS FlowType, 
--                'OnSite人员报批流程||OnSite/PersonApprovalDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
--                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
--FROM      ProcessFlow pf INNER JOIN
--                PersonSubmitApproval ps ON pf.ApprovalId = ps.PersonSubmitApprovalId
--WHERE   ps.DeleteFlag = 0 AND ps.IsTrainee = 0
UNION
SELECT  NEWID() AS Id,  ps.AskForLeaveId AS ToDoId, ps.ProposerCode AS Content, '请假申请' AS FlowType, 
                '请假申请详情||Attendance/ShowAskForLeaveDetail?askforleaveId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AskForLeave ps ON pf.ApprovalId = ps.AskForLeaveId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.AskForOvertimeId AS ToDoId, ps.ProposerCode AS Content, '加班申请' AS FlowType, 
                '加班申请详情||Attendance/ShowAskForOvertimeDetail?overtimeId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AskForOvertime ps ON pf.ApprovalId = ps.AskForOvertimeId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.AddPointId AS ToDoId, ps.ProposerCode AS Content, '加点申请' AS FlowType, 
                '加点申请详情||Attendance/ShowAskForAddPointDetail?addpointId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AddPoint ps ON pf.ApprovalId = ps.AddPointId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ps.PersonSubmitApprovalId AS ToDoId, ps.PersonApprovalNo AS Content, '实习生人员报批' AS FlowType, 
                '实习生人员报批流程||Trainee/TraineeApprovalDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PersonSubmitApproval ps ON pf.ApprovalId = ps.PersonSubmitApprovalId
WHERE   ps.DeleteFlag = 0 AND ps.IsTrainee = 1
UNION
SELECT   NEWID() AS Id, ps.ProjectSummaryId AS ToDoId, pc.ProjectName AS Content, '项目总结报告' AS FlowType, 
                '项目总结报告流程||Project/ProjectSummaryDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectSummary ps ON pf.ApprovalId = ps.ProjectSummaryId INNER JOIN
                ProjectControl pc ON pc.ProjectControlId = ps.ProjectControlId
WHERE   ps.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, pe.ProjectExceptionEndId AS ToDoId, pe.ProjectName AS Content, '项目异常中止' AS FlowType, 
                '项目异常中止流程||Project/ProjectExceptionEndDetail?id=hrcpid&operatetype=update' AS FlowUrl, pf.ProcessFlowId, 
                pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectExceptionEnd pe ON pf.ApprovalId = pe.ProjectExceptionEndId
WHERE   pe.DeleteFlag = 0
--UNION
--SELECT   ps.AbnormalRecordId AS ToDoId, ps.FeedbackPersonSign AS Content, '休息日异常反馈' AS FlowType, 
--                '休息日异常流程详情||Attendance/RestDayAbnormalDetail?abnormalId=hrcpid&operatetype=update' AS FlowUrl, 
--                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
--FROM      ProcessFlow pf INNER JOIN
--                AbnormalRecord ps ON pf.ApprovalId = ps.AbnormalRecordId
--WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0 AND  ps.DayType=0
UNION
SELECT DISTINCT NEWID() AS Id,  ab.AbnormalRecordId AS ToDoId, ab.CreateBy AS Content, '工作日异常反馈' AS FlowType, 
                '工作日异常流程详情||Attendance/AbnormalDetail?abnormalId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                AbnormalRecord ab ON pf.ApprovalId = ab.AbnormalRecordId
				INNER JOIN AttendanceAbnormalDetail aa ON ab.AbnormalRecordId=aa.AbnormalRecordId
WHERE   ab.DeleteFlag = 0 AND pf.DeleteFlag = 0 AND  ab.DayType=1  AND aa.CancelStatus=0 
UNION
SELECT  NEWID() AS Id,  pe.ProjectPersonEntryId AS ToDoId, pc.ProjectName AS Content, '进入研发区申请' AS FlowType, 
                '进入研发区申请流程||Project/ProPersonEntryDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectPersonEntry pe ON pf.ApprovalId = pe.ProjectPersonEntryId INNER JOIN
                ProjectControl pc ON pc.ProjectControlId = pe.ProjectControlId
WHERE   pe.DeleteFlag = 0
UNION
SELECT   NEWID() AS Id, ppi.ProjectPersonInfoId AS ToDoId, ppi.Name AS Content, '项目人员离项' AS FlowType, 
                '项目人员离项流程||Project/ProPersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectPersonInfo ppi ON pf.ApprovalId = ppi.ProjectPersonInfoId
WHERE   ppi.DeleteFlag = 0 AND ppi.IsOnDuty=0
UNION
SELECT   NEWID() AS Id, pe.ProjectPersonEvaluateId AS ToDoId, ppi.Name AS Content, '项目人员考评' AS FlowType, 
                '项目人员考评流程||Project/ProPersonEvaluateDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ProjectPersonEvaluate pe ON pf.ApprovalId = pe.ProjectPersonEvaluateId INNER JOIN
                ProjectPersonInfo ppi ON ppi.ProjectPersonInfoId = pe.ProjectPersonInfoId
WHERE   pe.DeleteFlag = 0 
UNION 
SELECT   NEWID() AS Id, ps.PayReportId AS ToDoId, ps.ProjectName AS Content, '对外付款报告' AS FlowType, 
                '对外付款确认报告||Expenses/PayConfirmDetail?payReportId=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                PayReport ps ON pf.ApprovalId = ps.PayReportId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION 
SELECT  NEWID() AS Id,  ps.ExpenseSettlementDetailId AS ToDoId, 'Onsite/实习生对外付款确认报告' AS Content, 'Onsite/实习生付款报告' AS FlowType, 
                'Onsite/实习生对外付款确认报告||Expenses/ExpenseSettlementDetail?settlementid=hrcpid&operatetype=update' AS FlowUrl, 
                pf.ProcessFlowId, pf.CurrentNode, pf.CurrentPerson, pf.CreateDate
FROM      ProcessFlow pf INNER JOIN
                ExpenseSettlementDetail ps ON pf.ApprovalId = ps.ExpenseSettlementDetailId
WHERE   ps.DeleteFlag = 0 AND pf.DeleteFlag = 0
UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '人员离项归档确认' AS FlowType, 
                'OnSite离项流程||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                info.ProcessFlowId, '人员离项归档确认' AS CurrentNode,(SELECT OnSiteFileConfirm FROM AreaConfig WHERE WorkPlace=info.WorkPlace) AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='进行中-离项' and ISNULL(LeaveConfirmSign,'')='' and ISNULL(LeaveCooSign,'')!='' and IsTrainee=0

UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '人员离项归档' AS FlowType, 
                'OnSite离项流程||OnSite/PersonInfoDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                info.ProcessFlowId, '人员离项归档' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='进行中-离项' and ISNULL(LeaveAgreeSign,'')='' and IsTrainee=0
UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '实习生入项归档' AS FlowType, 
                '实习生材料归档||Trainee/TraineeDocumentDetail?id=hrcpid' AS FlowUrl, 
                info.ProcessFlowId, '实习生入项归档' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='进行中-入项'  and IsTrainee=1
UNION
SELECT NEWID() AS Id, PersonInfoId AS ToDoId,info.EmployeeName AS Content, '实习生离项归档' AS FlowType, 
                '实习生材料归档||Trainee/TraineeDocumentDetail?id=hrcpid' AS FlowUrl, 
                info.ProcessFlowId, '实习生离项归档' AS CurrentNode,info.Person AS CurrentPerson,info.CreateDate FROM 
V_PersonInfo info where FileStatus='进行中-离项'  and IsTrainee=1
UNION
SELECT   NEWID() AS Id, ProjectCheckReportId AS ToDoId,ProjectName  AS Content, '项目验收报告' AS FlowType, 
                '项目验收报告||Project/CooperateProjectCheck?checkreportId=hrcpid&operatetype=update' AS FlowUrl, 
                ProcessFlowId, CurrentNode, CurrentPerson, CreateDate
FROM  V_ProjectCheckReport
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'项目人员入项归档' AS FlowType,
				'项目人员记录||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','项目人员入项归档' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where ISNULL(CooMgrUploadEntryDataSign,'')='' and (PersonStatus='在岗-内场' or PersonStatus='在岗-外场') and IsStopMaterial=0
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'项目人员入项归档确认' AS FlowType,
				'项目人员记录||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','项目人员入项归档确认' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where ISNULL(CooMgrUploadEntryDataSign,'')!='' and (PersonStatus='在岗-内场' or PersonStatus='在岗-外场') and ISNULL(DocAdminSureEntryDataSign,'')='' and IsStopMaterial=0
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'项目人员离项归档' AS FlowType,
				'项目人员记录||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','项目人员离项归档' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where IsOnDuty=0 and PersonStatus!='离场' and PersonStatus!='离场进行中' and ISNULL(CooMgrUploadReleaseDataSign,'')='' and IsStopMaterial=0
UNION
SELECT NEWID() AS Id, ProjectPersonInfoId AS ToDoId,Name AS Content,'项目人员离项归档确认' AS FlowType,
				'项目人员记录||DocumentManage/ProPersonRecordDetail?id=hrcpid&operateType=update' AS FlowUrl,
				'00000000-0000-0000-0000-000000000000','项目人员离项归档确认' AS CurrentNode,Person AS CurrentPerson,CreateDate
FROM V_ProjectPersonRecord where ISNULL(CooMgrUploadReleaseDataSign,'')!='' and IsOnDuty=0 and PersonStatus!='离场' and PersonStatus!='离场进行中' and ISNULL(DocAdminSureReleaseDataSign,'')='' and IsStopMaterial=0
UNION
SELECT  NEWID() AS Id,  CooperationToFormalId AS ToDoId,ApplyPerson  AS Content, '优秀合作员工转正' AS FlowType, 
                '合作员工转正流程||OnSite/OnSiteToFormalDetail?id=hrcpid&operatetype=update' AS FlowUrl, 
                ProcessFlowId, CurrentNode, CurrentPerson, CreateDate
FROM V_CooperationToFormal 