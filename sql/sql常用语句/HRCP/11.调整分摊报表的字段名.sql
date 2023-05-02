
use hrcp;
--调整分摊报表 字段名
--OnSite/实习生  付款记录
select   *   from  V_OnsitePayReport   a;

--普通项目付款记录
select   *   from  V_GeneralPayReport  a;

--下面普通项目中没有的字段 添加普通付款业务中 
--人数（空）  费用项目（受益产品）   费用合计（和已存在字段  费用 重复）
--PersonCount   BenefitproName   ExpenseTotal    

select   a.PersonCount,a.BenefitProName,a.ExpenseTotal,*   from  PayReport   a   
select   *   from  BenefitProDivide  a;


select   *   from   PayReport  a
left join  BenefitProDivide  b  on   a.PayReportId=b.PayReportId
inner join  PayStandingBook  c  on   a.PayReportId=c.PayReportId;


--OnSite/实习生视图缺少的字段
--项目经理（总项目经理）					空
--总金额			是否要把该项目每一期的支付金额累加起来?
--受益产品     
--受益产品编码  
--所属产品线(两个视图字段的值都为空)   
--项目经理（项目分期付款  对应各产品线的项目经理）   
--所占比例  
--费用  （费用合计 重复）


select   *   from    ExpenseSettlementDetail   a
left  join   ExpensePersonDivide  b   on  a.ExpenseSettlementDetailId=b.SettlementDetailId
inner join  PayStandingBook  c   on  a.ExpenseSettlementDetailId=c.PayReportId; 


