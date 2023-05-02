USE [hrcp]
GO

/****** Object:  UserDefinedFunction [dbo].[F_GetWorkFlowCNName]    Script Date: 2019/10/24 14:51:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER FUNCTION [dbo].[F_GetWorkFlowCNName]
(
	@WorkFlowENName VARCHAR(100)
)
RETURNS varchar(200)
AS
BEGIN
	 DECLARE @WorkFlowCNName VARCHAR(500)='';
	 set  @WorkFlowCNName=
	 (
		case @WorkFlowENName
			when 'Overtime'					then  '加班申请'
			when 'AskForLeave'				then  '请假申请'
			when 'ProjectSetup'				then  '合作项目立项申请'
			when 'ProjectCheckReport'	then  '项目检查报告'
			when 'TraineeThesis'				then  '实习生毕业论文'
			when 'recruitReqApply'			then  'OnSite/实习生需求申请'
			when 'ProjectSummary'			then  '项目总结报告'
			when 'ProjectPersonInfo'		then  '项目人员离项'
			when 'PayConfirmDetail'		then  '项目普通付款管理'
			when 'FeedbackAbnormal'		then  '工作异常反馈'
			when 'ExpenseSettlement'		then  'OnSite/实习生付款管理'
			when 'TraineeBankInfo'		    then  '实习生银行信息申请'
			when 'PersonEntry'				then  'OnSite/实习生入项申请'
			when 'PersonEvaluate'			then  'OnSite/实习生考评'
			when 'ProjectExceptionEnd'	then  '项目异常中止'
			when 'PersonLeave'				then  'OnSite/实习生离项'
			when 'ProjectPersonEntry'		then  '项目人员进入研发区申请'
			when 'TraineeCertificate'		then  '实习生证明申请'
			when 'PersonApproval'			then  '请假申请'
		else	'流程申请'
		end
	 )
	RETURN @WorkFlowCNName;
END




GO


