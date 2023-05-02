USE [hrcp]
GO

/****** Object:  StoredProcedure [dbo].[AddReqcruitReqApply]    Script Date: 2019/8/14 16:15:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--ÐÞ¸Ä´æ´¢¹ý³Ì 

ALTER procedure [dbo].[AddReqcruitReqApply]
(
@recruitno varchar(50),
@cootype nvarchar(50),
@deptLevel1 nvarchar(50), 
@deptLevel2 nvarchar(50), 
@peopleNum int,
@addNeedNum int,
@positionNum int,
@ondutyDate date,
@jobRequire nvarchar(max),
@requireReason nvarchar(200),

@addReason nvarchar(4000),
@replacePerson nvarchar(200),
@turnPerson nvarchar(200),
@calledPerson nvarchar(200),

@cooCharge nvarchar(200),
@addPermission nvarchar(200),
@addView nvarchar(200),
@createTime datetime,
@createBy nvarchar(50),
@isTrainee int,

@currentPerson nvarchar(50),
@currentNode nvarchar(20),
@state varchar(20),
@workflowid uniqueidentifier,
@rraid uniqueidentifier,
@wfiid uniqueidentifier,
@pfid uniqueidentifier,
--workflowTask
@wftid uniqueidentifier,
@prewftid uniqueidentifier,
@wftowner nvarchar(50),
@otherreason nvarchar(4000),
@recruitreqapplyattach  nvarchar(max)
)

as

begin

--begin tran
insert into recruitreqapply(ReqcruitReqApplyId,RecruitNo,CooType,Deptlevel1,DeptLevel2,PeopleNum,AddNeedNum,PositionNum,OnDutyDate,JobRequire,PositionRequireReason,AddReason,ReplacePerson,TurnPerson,CalledPerson,CooChargePerson,AddPersonPermission,AddPersonView,CreateBy,CreateTime,DeleteFlag,IsTrainee,OtherReason,RecruitReqApplyAttach)
values(@rraid,dbo.[F_GetSerialNumber](@isTrainee),@cootype,@deptLevel1,@deptLevel2,@peopleNum,@addNeedNum,@positionNum,@ondutyDate,@jobRequire,@requireReason,@addReason,@replacePerson,@turnPerson,@calledPerson,@cooCharge,@addPermission,@addView,@createBy,@createTime,0,@isTrainee,@otherreason,@recruitreqapplyattach);

insert into WorkFlowInstance(WorkFlowInstanceId,WorkFlowId,States,CreateDate,DeleteFlag)values(@wfiid,@workflowid,@state,GETDATE(),0);

insert into ProcessFlow (ProcessFlowId,WorkFlowInstanceId,ApprovalId,CurrentPerson,CurrentNode,CreateDate,DeleteFlag) values(@pfid,@wfiid,@rraid,@currentPerson,@currentNode,GETDATE(),0);

insert into WorkFlowTask (WorkFlowTaskId,WorkFlowInstanceId,NodeCode,NodeName,[owner],PreviousTaskId,CreateDate,DeleteFlag)
values(@wftid,@wfiid,'1',@currentNode,@wftowner,@prewftid,GETDATE(),0);
--commit tran
end

GO


