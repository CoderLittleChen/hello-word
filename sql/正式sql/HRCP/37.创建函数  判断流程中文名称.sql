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
			when 'Overtime'					then  '�Ӱ�����'
			when 'AskForLeave'				then  '�������'
			when 'ProjectSetup'				then  '������Ŀ��������'
			when 'ProjectCheckReport'	then  '��Ŀ��鱨��'
			when 'TraineeThesis'				then  'ʵϰ����ҵ����'
			when 'recruitReqApply'			then  'OnSite/ʵϰ����������'
			when 'ProjectSummary'			then  '��Ŀ�ܽᱨ��'
			when 'ProjectPersonInfo'		then  '��Ŀ��Ա����'
			when 'PayConfirmDetail'		then  '��Ŀ��ͨ�������'
			when 'FeedbackAbnormal'		then  '�����쳣����'
			when 'ExpenseSettlement'		then  'OnSite/ʵϰ���������'
			when 'TraineeBankInfo'		    then  'ʵϰ��������Ϣ����'
			when 'PersonEntry'				then  'OnSite/ʵϰ����������'
			when 'PersonEvaluate'			then  'OnSite/ʵϰ������'
			when 'ProjectExceptionEnd'	then  '��Ŀ�쳣��ֹ'
			when 'PersonLeave'				then  'OnSite/ʵϰ������'
			when 'ProjectPersonEntry'		then  '��Ŀ��Ա�����з�������'
			when 'TraineeCertificate'		then  'ʵϰ��֤������'
			when 'PersonApproval'			then  '�������'
		else	'��������'
		end
	 )
	RETURN @WorkFlowCNName;
END




GO


