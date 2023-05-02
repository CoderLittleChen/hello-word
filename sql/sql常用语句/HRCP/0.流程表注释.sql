--WrokFlow					定义工作流
--WrokFlowNode			定义每个工作流上的节点名称
--WrokFlowTransition    定义工作流节点之间的跳转关系
--WorkFlowRecord		记录流程每一次提交、审批的记录
--ProcessFlow				保存的是每一条数据当前节点以及当前节点审批人
--WorkFlowTask			保存的也是当前审批人以及流程所在当前节点  感觉作用和ProcessFlow类似


--当流程变更的时候  需要涉及哪些表
--ProcessFlow   ProcessFlowId     CurrentNode   CurrentPerson
--WorkFlowInstance  WorkFlowInstance  WorkFlowId  States

--其中为update操作的是  
--业务表  ProcessFlow  WorkFlowInstance
--其中为insert操作的是
--WrokFlowRecord   WorkFlowTask


--更新ProcessFlow    
--pfEntity.ProcessFlowId = model.ProcessFlowId;
--pfEntity.CurrentNode = nextNode;
--pfEntity.CurrentPerson = nextApproval;
--更新WorkFlowInstance
--wfiEntity.WorkFlowInstanceId = model.WorkFlowInstanceId;
--wfiEntity.WorkFlowId = wf.WorkFlowId;
--wfiEntity.States = tocode;
--新增workflowrecord
--record.WorkFlowRecordId = Guid.NewGuid();
--record.WorkFlowTaskId = preTaskId;
--record.WorkFlowTransitionId = wftst.WorkFlowTransitionId;
--record.Approvaler = SiteSession.UserID;
--record.Remarks = "";
--record.ApprovalTime = DateTime.Now;
--record.CreateDate = DateTime.Now;
--record.CreateBy = SiteSession.UserID;
--新增workflowtask
--task.WorkFlowTaskId = Guid.NewGuid();
--task.WorkFlowInstanceId = model.WorkFlowInstanceId;
--task.PreviousTaskId = preTaskId;
--task.NodeName = nextNode;
--task.NodeCode = tocode;
--task.Owner = nextApproval;
--task.CreateDate = DateTime.Now;