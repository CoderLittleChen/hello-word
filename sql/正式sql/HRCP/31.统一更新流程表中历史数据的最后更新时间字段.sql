update   RecruitReqApply    set   ModificationDate=GETDATE()  where  ModificationDate  is  null  or  ModificationDate='1900-01-01';
update   PersonSubmitApproval    set   ModificationDate=GETDATE()  where  ModificationDate  is  null or  ModificationDate='1900-01-01';
update   ProjectSetup    set   ModificationDate=GETDATE()  where  ModificationDate  is  null  or  ModificationDate='1900-01-01';
update   PayReport    set   ModificationDate=GETDATE()  where  ModificationDate  is  null  or  ModificationDate='1900-01-01';
update   ExpenseSettlementDetail    set   ModificationDate=GETDATE()  where  ModificationDate  is  null  or  ModificationDate='1900-01-01';
