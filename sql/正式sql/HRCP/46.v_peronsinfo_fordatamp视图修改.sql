USE [hrcp]
GO

/****** Object:  View [dbo].[V_PeronsInfo_ForDataMP]    Script Date: 2020/4/17 15:22:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[V_PeronsInfo_ForDataMP]	
AS
WITH CTE
AS (
	SELECT 
			a.AheadLeaveExpDate,
			a.AheadLeaveFile,
			a.AheadLeaveFileDate,
			a.AheadLeaveReMark,
			a.AheadLeaveSign,
			a.AheadLeaveSignDate,
			a.AttachLeaveUrl,
			a.AttachUrl,
			a.CooOpinion,
			a.CooSign,
			a.CooSignDate,
			a.CreateBy,
			a.CreateDate,
			a.CvCopyExpDate,
			a.CvCopyFile,
			a.CvCopyFileDate,
			a.CvCopyRemark,
			a.CvCopySign,
			a.CvCopySignDate,
			a.DeleteFlag,
			a.EntryCooSign,
			a.EntryCooSignDate,
			a.FileStatus,
			a.GraduateCopyExpDate,
			a.GraduateCopyFile,
			a.GraduateCopyFileDate,
			a.GraduateCopyRemark,
			a.GraduateCopySign,
			a.GraduateCopySignDate,
			a.IdCardCopyExpDate,
			a.IdCardCopyFile,
			a.IdCardCopyFileDate,
			a.IdCardCopyRemark,
			a.IdCardCopySign,
			a.IdCardCopySignDate,
			a.InterviewExpDate,
			a.InterviewFile,
			a.InterviewFileDate,
			a.InterviewRemark,
			a.InterviewSign,
			a.InterviewSignDate,
			a.ItAgreeExpDate,
			a.ItAgreeFile,
			a.ItAgreeFileDate,
			a.ItAgreeRemark,
			a.ItAgreeSign,
			a.ItAgreeSignDate,
			a.LeaveAgreeExpDate,
			a.LeaveAgreeFile,
			a.LeaveAgreeFileDate,
			a.LeaveAgreeRemark,
			a.LeaveAgreeSign,
			a.LeaveAgreeSignDate,
			a.LeaveConfirmOpinion,
			a.LeaveConfirmSign,
			a.LeaveConfirmSignDate,
			a.LeaveCooSign,
			a.LeaveCooSignDate,
			a.MaterialFileId,
			a.MaterialFileNo,
			a.ModificationDate,
			a.Modifier,
			a.Person,
			a.PersonalAgreeExpDate,
			a.PersonalAgreeFile,
			a.PersonalAgreeFileDate,
			a.PersonalAgreeRemark,
			a.PersonalAgreeSign,
			a.PersonalAgreeSignDate,
			a.PersonalSignDate,
			a.PersonEntryId,
			a.PersonInfoId,
			a.PhysicalCopyExpDate,
			a.PhysicalCopyFile,
			a.PhysicalCopyFileDate,
			a.PhysicalCopyRemark,
			a.PhysicalCopySign,
			a.PhysicalCopySignDate,
			a.ReNewAgreeExpDate,
			a.ReNewAgreeFile,
			a.ReNewAgreeFileDate,
			a.ReNewAgreeReMark,
			a.ReNewAgreeSign,
			a.ReNewAgreeSignDate,
			a.ThreeAgreeExpDate,
			a.ThreeAgreeFile,
			a.ThreeAgreeFileDate,
			a.ThreeAgreeReMark,
			a.ThreeAgreeSign,
			a.ThreeAgreeSignDate,
			a.WrittenExpDate,
			a.WrittenFile,
			a.WrittenFileDate,
			a.WrittenRemark,
			a.WrittenSign,
			a.WrittenSignDate
	,ROW_NUMBER() OVER(PARTITION BY PersonInfoid ORDER  by  createdate DESC) AS num FROM MaterialFile a WHERE DeleteFlag=0 
)
SELECT                                                                  
pinfo.PersonInfoId	                  --����               
,pinfo.EmployeeName	                  --����               
,pinfo.EntryDate	                    --��ְ����           
,pinfo.NativePlace	                  --����               
,pinfo.Nation	                        --����               
,PoliticalLandscape	            --������ò           
,MatricalStatus	                --����״��           
,TopEducation	                  --���ѧ��           
,Discipline	                    --רҵ   
,case when Sex='0' then '��'else 'Ů' end as sex	              --�Ա�               
,pinfo.IDCard	                          --���֤��           
,BirthDay	                        --����               
,GraduateSchool	                  --��ҵѧУ           
,pinfo.CooCompany	                      --������˾����       
,pinfo.WorkPlace	                      --������             
,pinfo.CooType	                        --�������           
,pinfo.PositionName	                    --��λ���           
,pinfo.WorkNum                          --5λ����            
,NotesId            --notesid            
,pinfo.Dept2Level	             	        --�������ű���       
,pinfo.Dept3Level	             	        --�������ű���       
,DirectorMgrName	            --ֱ����������       
,DirectorMgrId             --ֱ������id         
,EvaluateMgrId	              --��������id         
,EvaluateMgrName	            --������������       
,pinfo.TutorId	                    --��ʦid             
,pinfo.TutorName	                  --��ʦ����           
,Telephone	                    --�绰               
,OfficeLocation	              --�칫�ص�           
,pinfo.DeptSecretaryId	            --����id             
,DeptSecretaryName	          --��������           
,Remark	                      --��ע               
,OnJobStatus	                --�Ƿ���ְ           
,CurrentLevel	                --Ŀǰ�ڸڼ���       
,PositionType	                --����ʦ���         
,EntryType	                  --�������           
,ProEntryDate	              --��Ŀ��������       
,pinfo.DeptLevel1	                  --һ�����ű���       
,pinfo.DeptLevel4	                  --�ļ����ű���       
,FirstEducation	              --��һѧ��           
,MaterialFileId	              --����鵵���ϸ���   
,InterviewFile	              --�����Ŀ��Ա����   
,InterviewFileDate	          --�鵵ʱ��           
,InterviewExpDate	          --ʧЧʱ��           
,InterviewSign	              --ǩ��               
,InterviewSignDate	          --ʱ��               
,InterviewRemark	            --��ע               
,WrittenFile	                --���Դ���ֽ,�鵵��  
,WrittenFileDate	            --�鵵ʱ��           
,WrittenExpDate	                --ʧЧʱ��           
,WrittenSign	                --ǩ��               
,WrittenSignDate	            --ʱ��               
,WrittenRemark	              --��ע               
,PersonalAgreeFile	          --���˱��ܳ�ŵ��,��  
,PersonalAgreeFileDate		    --�鵵ʱ��           
,PersonalAgreeExpDate	      --ʧЧʱ��           
,PersonalAgreeSign	          --ǩ��               
,PersonalAgreeSignDate		    --ʱ��               
,PersonalAgreeRemark	        --��ע               
,ItAgreeFile	                --IT��Դ��ŵ��       
,ItAgreeFileDate	            --�鵵ʱ��           
,ItAgreeExpDate	                --ʧЧʱ��           
,ItAgreeSign	                --ǩ��               
,ItAgreeSignDate	          --ʱ��               
,ItAgreeRemark	              --��ע               
,PhysicalCopyFile	          --��챨�渴ӡ��     
,PhysicalCopyFileDate	      --�鵵ʱ��           
,PhysicalCopyExpDate	      --ʧЧʱ��           
,PhysicalCopySign	          --ǩ��               
,PhysicalCopySignDate	      --ʱ��               
,PhysicalCopyRemark	            --��ע               
,IdCardCopyFile	                --���֤��ӡ��       
,IdCardCopyFileDate	          --�鵵ʱ��           
,IdCardCopyExpDate	            --ʧЧʱ��           
,IdCardCopySign	                --ǩ��               
,IdCardCopySignDate	          --ʱ��               
,IdCardCopyRemark	          --��ע               
,CvCopyFile	                    --����/ʵϰ��������  
,CvCopyFileDate	                --�鵵ʱ��           
,CvCopyExpDate	                --ʧЧʱ��           
,CvCopySign	                    --ǩ��               
,CvCopySignDate	                --ʱ��               
,CvCopyRemark	              --��ע               
,GraduateCopyFile	          --��ҵ֤ѧλ֤��ӡ   
,GraduateCopyFileDate	      --�鵵ʱ��           
,GraduateCopyExpDate	      --ʧЧʱ��           
,GraduateCopySign	          --ǩ��               
,GraduateCopySignDate	      --ʱ��               
,GraduateCopyRemark	            --��ע               
,LeaveAgreeFile	                --�����ŵ��         
,LeaveAgreeFileDate	            --�鵵ʱ��           
,LeaveAgreeExpDate	            --ʧЧʱ��           
,LeaveAgreeSign	                --ǩ��               
,LeaveAgreeSignDate	            --ʱ��               
,LeaveAgreeRemark	          --��ע               
,AttachUrl	                  --�鵵���ϸ���url    
,MaterialFileNo	                --���Ϲ鵵���       
,FileStatus	                  --״̬               
,AttachLeaveUrl	                --����鵵���ϸ���   
,ThreeAgreeFile	                --����Э��/˫��Э��  
,ThreeAgreeFileDate	            --�鵵ʱ��           
,ThreeAgreeExpDate	            --ʧЧʱ��           
,ThreeAgreeSign	                --ǩ��               
,ThreeAgreeSignDate	            --ʱ��               
,ThreeAgreeReMark	          --��ע               
,ReNewAgreeFile	                --��ǩ����Э��/˫��  
,ReNewAgreeFileDate	          --�鵵ʱ��           
,ReNewAgreeExpDate	            --ʧЧʱ��           
,ReNewAgreeSign	                --ǩ��               
,ReNewAgreeSignDate	          --ʱ��               
,ReNewAgreeReMark	          --��ע               
,AheadLeaveFile	                --��ǰ����У��ȷ��   
,AheadLeaveFileDate	            --�鵵ʱ��           
,AheadLeaveExpDate	            --ʧЧʱ��           
,AheadLeaveSign	                --ǩ��               
,AheadLeaveSignDate	            --ʱ��               
,AheadLeaveReMark	          --��ע               
,d1.Name AS DeptLevel1Name	                --һ����������       
,dept.Name	                        --������������       
,d3.Name AS dept3Name	                  --������������       
,d4.Name AS DeptLevel4Name	                --�ļ���������       
,CompanyThesis	              --��˾�ṩ��ҵ����   
,ISNULL(d4.Name,ISNULL(d3.Name,ISNULL(dept.Name,d1.Name))) as  deptName  --deptName[��С��ְ��������]
,ISNULL(d4.Code,ISNULL(d3.Code,ISNULL(dept.Code,d1.Code))) as  deptCode--deptCode[��С��ְ����code]
,pinfo.IsTrainee  --onsite/ʵϰ�� 
,pinfo.PingYing
,pinfo.EnglishName
,pinfo.RoomNo
,pinfo.TelShortNum
,pinfo.TelLongNum
,pinfo.Fax
,pinfo.SyncTime
,pinfo.OfficePlace
,pinfo.AttendEndDate
,pf.CurrentNode
FROM PersonInfo pinfo 
LEFT JOIN (SELECT * FROM CTE WHERE num=1) mf ON pinfo.PersonInfoId=mf.PersonInfoId
--LEFT JOIN PersonEntry pe ON pinfo.PersonEntryId=pe.PersonEntryId
LEFT JOIN Department dept ON dept.Code=pinfo.Dept2Level
LEFT JOIN Department d1 ON d1.Code=pinfo.DeptLevel1
LEFT JOIN Department d3 ON d3.Code=pinfo.Dept3Level
LEFT JOIN Department d4 ON d4.Code=pinfo.DeptLevel4 
LEFT JOIN v_TraineeThesis  ON v_TraineeThesis.WorkNum=pinfo.WorkNum
INNER JOIN ProcessFlow pf ON pinfo.PersonInfoId=pf.ApprovalId 
INNER JOIN WorkFlowInstance wfi ON wfi.WorkFlowInstanceId=pf.WorkFlowInstanceId 
WHERE pinfo.DeleteFlag=0 AND pinfo.WorkNum!='00000'





GO


