SELECT 
	                           t1.SrcID BCode,t1.SrcName BName,t1.SrcPID BParntCode,t1.orderNo BorderNo,t1.show Bshow,t1.status BStatus,
	                           t2.SrcID PRCode,t2.SrcName PRName,t2.SrcPID PRParntCode,t2.orderNo PRorderNo,t2.show PRshow,
	                           t3.SrcID PDTCode,t3.SrcName PDTName,t3.SrcPID PDTParntCode,t3.orderNo PDTorderNo,t3.show PDTshow,
	                           t4.SrcID PROCode,t4.SrcName PROName,t4.SrcPID PROParntCode,t4.orderNo PROorderNo,t4.show PROshow
		                       FROM specMS_SpecDataIDSet t1 
                               LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.SrcPID = t2.srcID 
                               LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.SrcPID = t3.srcID 
                               LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.SrcPID = t4.srcID 
		                       WHERE  t1.IDLevel=4   and  t1.flag=1 and t1.show=1 and t2.show=1 and t3.show=1 
							   and t2.Status=1  
							    and (t1.Status=1 or t2.srcId in ('PR002193'));

--PR990031
select  *  from 
(

select  
t1.SrcID BCode,t1.SrcName BName,t1.SrcPID BParntCode,t1.orderNo BorderNo,t1.show Bshow,t1.status BStatus,
t2.SrcID PRCode,t2.SrcName PRName,t2.SrcPID PRParntCode,t2.orderNo PRorderNo,t2.show PRshow,t2.status PRStatus,
t3.SrcID PDTCode,t3.SrcName PDTName,t3.SrcPID PDTParntCode,t3.orderNo PDTorderNo,t3.show PDTshow,t3.status PDTStatus,
t4.SrcID PROCode,t4.SrcName PROName,t4.SrcPID PROParntCode,t4.orderNo PROorderNo,t4.show PROshow,t4.status PLStatus
from  specMS_SpecDataIDSet  t1
LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
where t1.IDLevel=1   
and  t1.show=1  and t2.show=1  and t3.show=1  and (t4.show=1 or t4.show  is null)
and  t1.flag=1  and t2.flag=1  and t3.flag=1  and (t4.flag=1 or t4.flag is null)
and (t4.Status=1 or t4.Status is null)
and (t3.Status=1  or t3.srcId in ('PR002193'))


)  temp  where temp.srcID='PR990031'


select  *  from  temp  a where  a.srcID='PR002193';