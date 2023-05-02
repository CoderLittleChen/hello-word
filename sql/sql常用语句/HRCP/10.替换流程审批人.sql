--1、修改下一环节审批人
--update ProjectCheckReport    set  NextAuditors='zhangsan 12345'
--where  ProjectCheckReportId='A747221E-19F2-484D-9358-A6E9877BBD23';


--2、修改流程记录中的审批人
--update  WorkFlowRecord  set   Approvaler='zhangsan 12345'
--where  WorkFlowRecordId='C6D4AFF3-6D19-4621-9678-127CDC85913C'  
--or  WorkFlowRecordId='E59002AB-0E97-4D25-ABAD-DCB5E8EA1710' ;