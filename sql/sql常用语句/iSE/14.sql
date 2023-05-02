select  
t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParntCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,t1.dataSetID PRODataSetID,
t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParntCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,t2.dataSetID PDTDataSetID,
t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParntCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.dataSetID PRDataSetID,
t4.SrcID BCode,t4.SrcName BName,t4.SrcPID BParntCode,t4.orderNo BorderNo,t4.show Bshow,t4.status BStatus,t4.dataSetID PBDataSetID
                        from  specMS_SpecDataIDSet  t1
                        LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
                        where t1.IDLevel=1   
                        and  t1.show=1  and t2.show=1  and t3.show=1  and (t4.show=1 or t4.show  is null)
                        and  (t4.flag=1 or t4.flag is null)
						--and t3.srcID='PR990031'
                        and (t4.Status=1 or t4.Status is null)     and t1.flag=1 and t1.show=1 and t2.show=1 and t3.show=1 and (t3.Status=1 or t3.srcId in ('PR002193')) 
						order by PROCode,PDTCode,PRCode,BCode  