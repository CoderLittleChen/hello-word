SELECT t1.*, 
t2.srcName ProdName,t2.orderNo ProdOrder,t2.show ProdShow,
t3.srcName PDTName,t3.orderNo PDTOrder,t3.show PDTShow
FROM 
specMS_SpecDataIDSet t1
LEFT JOIN  specMS_SpecDataIDSet t2 ON t1.ProductLine_Code = t2.srcID 
LEFT JOIN  specMS_SpecDataIDSet t3 ON t1.PDT_Code = t3.srcID
WHERE  t1.IDLevel=3 and t1.flag=1 and t1.show=1 and t2.show=1 and t3.show=1 and t1.Status is not null
order by t1.dataSetID  desc;