--WrokFlow					���幤����
--WrokFlowNode			����ÿ���������ϵĽڵ�����
--WrokFlowTransition    ���幤�����ڵ�֮�����ת��ϵ
--WorkFlowRecord		��¼����ÿһ���ύ�������ļ�¼
--ProcessFlow				�������ÿһ�����ݵ�ǰ�ڵ��Լ���ǰ�ڵ�������
--WorkFlowTask			�����Ҳ�ǵ�ǰ�������Լ��������ڵ�ǰ�ڵ�  �о����ú�ProcessFlow����


--�����̱����ʱ��  ��Ҫ�漰��Щ��
--ProcessFlow   ProcessFlowId     CurrentNode   CurrentPerson
--WorkFlowInstance  WorkFlowInstance  WorkFlowId  States

--����Ϊupdate��������  
--ҵ���  ProcessFlow  WorkFlowInstance
--����Ϊinsert��������
--WrokFlowRecord   WorkFlowTask


--����ProcessFlow    
--pfEntity.ProcessFlowId = model.ProcessFlowId;
--pfEntity.CurrentNode = nextNode;
--pfEntity.CurrentPerson = nextApproval;
--����WorkFlowInstance
--wfiEntity.WorkFlowInstanceId = model.WorkFlowInstanceId;
--wfiEntity.WorkFlowId = wf.WorkFlowId;
--wfiEntity.States = tocode;
--����workflowrecord
--record.WorkFlowRecordId = Guid.NewGuid();
--record.WorkFlowTaskId = preTaskId;
--record.WorkFlowTransitionId = wftst.WorkFlowTransitionId;
--record.Approvaler = SiteSession.UserID;
--record.Remarks = "";
--record.ApprovalTime = DateTime.Now;
--record.CreateDate = DateTime.Now;
--record.CreateBy = SiteSession.UserID;
--����workflowtask
--task.WorkFlowTaskId = Guid.NewGuid();
--task.WorkFlowInstanceId = model.WorkFlowInstanceId;
--task.PreviousTaskId = preTaskId;
--task.NodeName = nextNode;
--task.NodeCode = tocode;
--task.Owner = nextApproval;
--task.CreateDate = DateTime.Now;