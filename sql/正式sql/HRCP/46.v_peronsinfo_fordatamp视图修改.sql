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
pinfo.PersonInfoId	                  --主键               
,pinfo.EmployeeName	                  --姓名               
,pinfo.EntryDate	                    --入职日期           
,pinfo.NativePlace	                  --籍贯               
,pinfo.Nation	                        --民族               
,PoliticalLandscape	            --政治面貌           
,MatricalStatus	                --婚姻状况           
,TopEducation	                  --最高学历           
,Discipline	                    --专业   
,case when Sex='0' then '男'else '女' end as sex	              --性别               
,pinfo.IDCard	                          --身份证号           
,BirthDay	                        --生日               
,GraduateSchool	                  --毕业学校           
,pinfo.CooCompany	                      --合作公司名称       
,pinfo.WorkPlace	                      --工作地             
,pinfo.CooType	                        --合作类别           
,pinfo.PositionName	                    --岗位类别           
,pinfo.WorkNum                          --5位工号            
,NotesId            --notesid            
,pinfo.Dept2Level	             	        --二级部门编码       
,pinfo.Dept3Level	             	        --三级部门编码       
,DirectorMgrName	            --直接主管姓名       
,DirectorMgrId             --直接主管id         
,EvaluateMgrId	              --考评主管id         
,EvaluateMgrName	            --考评主管姓名       
,pinfo.TutorId	                    --导师id             
,pinfo.TutorName	                  --导师姓名           
,Telephone	                    --电话               
,OfficeLocation	              --办公地点           
,pinfo.DeptSecretaryId	            --秘书id             
,DeptSecretaryName	          --秘书姓名           
,Remark	                      --备注               
,OnJobStatus	                --是否在职           
,CurrentLevel	                --目前在岗级别       
,PositionType	                --工程师类别         
,EntryType	                  --入项类别           
,ProEntryDate	              --项目入项日期       
,pinfo.DeptLevel1	                  --一级部门编码       
,pinfo.DeptLevel4	                  --四级部门编码       
,FirstEducation	              --第一学历           
,MaterialFileId	              --离项归档材料附件   
,InterviewFile	              --外包项目人员测评   
,InterviewFileDate	          --归档时间           
,InterviewExpDate	          --失效时间           
,InterviewSign	              --签名               
,InterviewSignDate	          --时间               
,InterviewRemark	            --备注               
,WrittenFile	                --笔试答题纸,归档情  
,WrittenFileDate	            --归档时间           
,WrittenExpDate	                --失效时间           
,WrittenSign	                --签名               
,WrittenSignDate	            --时间               
,WrittenRemark	              --备注               
,PersonalAgreeFile	          --个人保密承诺书,归  
,PersonalAgreeFileDate		    --归档时间           
,PersonalAgreeExpDate	      --失效时间           
,PersonalAgreeSign	          --签名               
,PersonalAgreeSignDate		    --时间               
,PersonalAgreeRemark	        --备注               
,ItAgreeFile	                --IT资源承诺书       
,ItAgreeFileDate	            --归档时间           
,ItAgreeExpDate	                --失效时间           
,ItAgreeSign	                --签名               
,ItAgreeSignDate	          --时间               
,ItAgreeRemark	              --备注               
,PhysicalCopyFile	          --体检报告复印件     
,PhysicalCopyFileDate	      --归档时间           
,PhysicalCopyExpDate	      --失效时间           
,PhysicalCopySign	          --签名               
,PhysicalCopySignDate	      --时间               
,PhysicalCopyRemark	            --备注               
,IdCardCopyFile	                --身份证复印件       
,IdCardCopyFileDate	          --归档时间           
,IdCardCopyExpDate	            --失效时间           
,IdCardCopySign	                --签名               
,IdCardCopySignDate	          --时间               
,IdCardCopyRemark	          --备注               
,CvCopyFile	                    --简历/实习生报名表  
,CvCopyFileDate	                --归档时间           
,CvCopyExpDate	                --失效时间           
,CvCopySign	                    --签名               
,CvCopySignDate	                --时间               
,CvCopyRemark	              --备注               
,GraduateCopyFile	          --毕业证学位证复印   
,GraduateCopyFileDate	      --归档时间           
,GraduateCopyExpDate	      --失效时间           
,GraduateCopySign	          --签名               
,GraduateCopySignDate	      --时间               
,GraduateCopyRemark	            --备注               
,LeaveAgreeFile	                --离项承诺书         
,LeaveAgreeFileDate	            --归档时间           
,LeaveAgreeExpDate	            --失效时间           
,LeaveAgreeSign	                --签名               
,LeaveAgreeSignDate	            --时间               
,LeaveAgreeRemark	          --备注               
,AttachUrl	                  --归档材料附件url    
,MaterialFileNo	                --材料归档编号       
,FileStatus	                  --状态               
,AttachLeaveUrl	                --离项归档材料附件   
,ThreeAgreeFile	                --三方协议/双方协议  
,ThreeAgreeFileDate	            --归档时间           
,ThreeAgreeExpDate	            --失效时间           
,ThreeAgreeSign	                --签名               
,ThreeAgreeSignDate	            --时间               
,ThreeAgreeReMark	          --备注               
,ReNewAgreeFile	                --续签三方协议/双方  
,ReNewAgreeFileDate	          --归档时间           
,ReNewAgreeExpDate	            --失效时间           
,ReNewAgreeSign	                --签名               
,ReNewAgreeSignDate	          --时间               
,ReNewAgreeReMark	          --备注               
,AheadLeaveFile	                --提前离项校方确认   
,AheadLeaveFileDate	            --归档时间           
,AheadLeaveExpDate	            --失效时间           
,AheadLeaveSign	                --签名               
,AheadLeaveSignDate	            --时间               
,AheadLeaveReMark	          --备注               
,d1.Name AS DeptLevel1Name	                --一级部门名称       
,dept.Name	                        --二级部门名称       
,d3.Name AS dept3Name	                  --三级部门名称       
,d4.Name AS DeptLevel4Name	                --四级部门名称       
,CompanyThesis	              --公司提供毕业论文   
,ISNULL(d4.Name,ISNULL(d3.Name,ISNULL(dept.Name,d1.Name))) as  deptName  --deptName[最小任职部门名称]
,ISNULL(d4.Code,ISNULL(d3.Code,ISNULL(dept.Code,d1.Code))) as  deptCode--deptCode[最小任职部门code]
,pinfo.IsTrainee  --onsite/实习生 
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


