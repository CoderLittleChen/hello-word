USE [hrcp]
GO

/****** Object:  StoredProcedure [dbo].[UpdateReqcruitReqApply]    Script Date: 2019/8/23 18:08:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER procedure [dbo].[UpdateReqcruitReqApply]
(
@rraid uniqueidentifier,
@recruitno varchar(50),
@cootype nvarchar(50),
@deptLevel2 nvarchar(50), 
@peopleNum int,
@addNeedNum int,
@positionNum int,
@ondutyDate date,
@jobRequire nvarchar(4000),
@requireReason nvarchar(200),

@addReason nvarchar(4000),
@replacePerson nvarchar(200),
@turnPerson nvarchar(200),
@calledPerson nvarchar(200),

@cooCharge nvarchar(200),
@addPermission nvarchar(200),
@addView nvarchar(200),
@proSign nvarchar(200),
@proMgrSignTime datetime,
@cooOpn nvarchar(4000),
@cooSign nvarchar(50),
@cooSignTime datetime,
@deptmgrOpn nvarchar(4000),
@deptmgrSign nvarchar(50),
@deptmgrSignTime datetime,
@cadreOpn nvarchar(4000),
@cadreApproDate date,
@cadreSign nvarchar(50),
@cadreSignTime datetime,
@dept1Opn nvarchar(4000),
@dept1ApproDate date,
@dept1Sign nvarchar(50),
@dept1SignTime datetime,
@recruitReqApplyAttach  nvarchar(4000),

@pfid uniqueidentifier,
@currentPerson nvarchar(50),
@currentNode nvarchar(20),


@wfiid uniqueidentifier,
@state varchar(20),
@workflowid uniqueidentifier,


@wftransid uniqueidentifier,
@approvaltime datetime,
@approvaler nvarchar(50),
@wftid uniqueidentifier,
@remarks nvarchar(200),
@createBy nvarchar(50),

--workflowTask
@wfinstanceid uniqueidentifier,
@prewftid uniqueidentifier,
@wftowner nvarchar(50),
@nodecode nvarchar(20),
@nodename nvarchar(50),

@otherreason nvarchar(4000),
@deptcc nvarchar(500),
@coocc nvarchar(500),
@cadrecc nvarchar(500),
@receiptcc nvarchar(4000)
)
as

begin
--更新RecruitReqApply
update RecruitReqApply set RecruitNo=@recruitno,CooType=@cootype,DeptLevel2=@deptLevel2,PeopleNum=@peopleNum,
AddNeedNum=@addNeedNum,PositionNum=@positionNum,OnDutyDate=@ondutyDate,JobRequire=@jobRequire,PositionRequireReason=@requireReason,
AddReason=@addReason,ReplacePerson=@replacePerson,TurnPerson=@turnPerson,CalledPerson=@calledPerson,CooChargePerson=@cooCharge,AddPersonPermission=@addPermission,
AddPersonView=@addView,ProMgrSign=@proSign,ProMgrSignTime=@proMgrSignTime,CooMgrOpinion=@cooOpn,CooMgrSign=@cooSign,CooMgrSignTime=@cooSignTime,
Dept2MgrOpinion=@deptmgrOpn,Dept2MgrSign=@deptmgrSign,Dept2MgrSignTime=@deptmgrSignTime,CadreOpinion=@cadreOpn,CadreApprDate=@cadreApproDate,
CadreSign=@cadreSign,CadreSignTime=@cadreSignTime,Dept1Opinion=@dept1Opn,Dept1ApprDate=@dept1ApproDate,Dept1Sign=@dept1Sign,Dept1SignTime=@dept1SignTime ,
OtherReason=@otherreason,Dept2MgrCc=@deptcc,CooMgrCc=@coocc,CadreCc=@cadrecc,ReceiptCc=@receiptcc,RecruitReqApplyAttach=@recruitReqApplyAttach
where ReqcruitReqApplyId=@rraid

--更新ProcessFlow
update ProcessFlow set CurrentNode=@currentNode,CurrentPerson=@currentPerson where ProcessFlowId=@pfid

--更新WorkFlowInstance
update WorkFlowInstance set States=@state where WorkFlowInstanceId=@wfiid

--新增WorkFlowRecord
insert into WorkFlowRecord(WorkFlowRecordId,WorkFlowTaskId,WorkFlowTransitionId,ApprovalTime,Approvaler,CreateDate,DeleteFlag,Remarks,CreateBy)
values(NEWID(),@wftid,@wftransid,@approvaltime,@approvaler,GETDATE(),0,@remarks,@createBy)

--新增WorkFlowTask
insert into WorkFlowTask(WorkFlowTaskId,WorkFlowInstanceId,NodeCode,NodeName,[owner],PreviousTaskId,CreateDate,DeleteFlag)
values(NEWID(),@wfinstanceid,@nodecode,@nodename,@wftowner,@prewftid,GETDATE(),0)

end







GO


