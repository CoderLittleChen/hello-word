select  
                        t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
                        t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
                        t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
                        t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge
                        from  specMS_SpecDataIDSet  t1
                        LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
                        where t1.IDLevel=1     and (t4.flag=1  or t4.flag is null) and t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193')) and t3.dataSetID in 
                        (select a.dataSetID from specMS_SpecPermission a,specMS_ROLE b
                        where a.userType = 1 and a.userName = 'ys2689' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0 and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0  union select 3598  union 
                        select k.dataSetID from specMS_SpecModule p left join specMS_SpecDataIDSet k on
                        p.verTreeCode=k.srcID
                        where p.mmanagerID like '%ys2689%'
                        and '37'=(select RL_CODE from specMS_ROLE where RL_CODE = '37' and RL_ACTIVE = 0)
                        and (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION where RL_ID='37')>0
                        union
                        select dataSetID from specMS_SpecDataIDSet where PDT_Code in (
                        select srcID from specMS_SpecPermission a,specMS_ROLE b,specMS_SpecDataIDSet  s
                        where a.userType = 1 and a.userName = 'ys2689' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0 and s.dataSetID=a.dataSetID and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0)
                        union
                        select dataSetID from specMS_SpecDataIDSet where ProductLine_Code in (
                        select srcID from specMS_SpecPermission a,specMS_ROLE b,specMS_SpecDataIDSet  s
                        where a.userType = 1 and a.userName = 'ys2689' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0  and s.dataSetID=a.dataSetID and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0)
                        union
                        select dataSetID from specMS_SpecDataIDSet where srcID in (
                        select list.verTreeCode from dbo.specMS_SpecListTab tab, specMS_SpecList list
                        where  tab.listID = list.listID and tab.manager like '%ys2689%'
                        )
                    )
                    
                        union 
                        select  
                        t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
                        t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
                        t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
                        t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge
                        from  specMS_SpecDataIDSet  t1
                        LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
                        where t1.IDLevel=1     and (t4.flag=1  or t4.flag is null) and t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193')) and t4.dataSetID in 
                        (select a.dataSetID from specMS_SpecPermission a,specMS_ROLE b
                        where a.userType = 1 and a.userName = 'ys2689' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0 and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0  union select 3598  union 
                        select k.dataSetID from specMS_SpecModule p left join specMS_SpecDataIDSet k on
                        p.verTreeCode=k.srcID
                        where p.mmanagerID like '%ys2689%'
                        and '37'=(select RL_CODE from specMS_ROLE where RL_CODE = '37' and RL_ACTIVE = 0)
                        and (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION where RL_ID='37')>0
                        union
                        select dataSetID from specMS_SpecDataIDSet where PDT_Code in (
                        select srcID from specMS_SpecPermission a,specMS_ROLE b,specMS_SpecDataIDSet  s
                        where a.userType = 1 and a.userName = 'ys2689' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0 and s.dataSetID=a.dataSetID and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0)
                        union
                        select dataSetID from specMS_SpecDataIDSet where ProductLine_Code in (
                        select srcID from specMS_SpecPermission a,specMS_ROLE b,specMS_SpecDataIDSet  s
                        where a.userType = 1 and a.userName = 'ys2689' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0  and s.dataSetID=a.dataSetID and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0)
                        union
                        select dataSetID from specMS_SpecDataIDSet where srcID in (
                        select list.verTreeCode from dbo.specMS_SpecListTab tab, specMS_SpecList list
                        where  tab.listID = list.listID and tab.manager like '%ys2689%'
                        )
                    )
                    
                        order by PROCode,PDTCode,PRCode,PBCode  