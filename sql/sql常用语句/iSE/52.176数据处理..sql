select  *  from  specMS_SpecDataIDSet  a  where srcID='PR003318';

select  *  from  specMS_SpecDataIDSet  a  where srcName='高端安全小特性开发项目';

select  *  from  specMS_SpecDataIDSet  a  where srcName='高端安全小特性开发项目B01';

select  *  from  specMS_SpecList  a  where  a.verTreeCode='PR003359';

select  *  from  specMS_SpecList a  where  a.blID=17389;

select  *  from  specMS_SpecList a  where  a.blID=17390;

--PR003359   对
--PR003318

select 
        b.blID as baseid, 
        b.preBlId as parentid,
        b.lTitle,
        s.fileaway ,
        b.description as explain ,
        s.listType ,
        b.createTime,
        e.Name + ' ' + e.Code as createBy,
        b.status as status,
        b.ApplyID,
        b.DeleteFlag
        from specMS_SpecList AS s WITH (NOLOCK) 
        INNER JOIN specMS_SpecBaseLine AS b WITH (NOLOCK) ON s.blID = b.blID
        left join Sync_Employee e WITH (NOLOCK) on b.createBy = e.Code
        where  s.verTreeCode='PR003635';

--update  specMS_SpecBaseLine  set  DeleteFlag=1 where blid=17612;


--delete  specMS_SpecList  where listID=7990;

select  *  from  specMS_SpecList  a   where  a.verTreeCode='PB003655';

select  *  from  specMS_SpecList  a   where  a.blID=17612;

select  *  from   specMS_SpecBaseLineLabel  a  where a.blID=17612

select  *  from  specMS_SpecBaseLine  a ;


--WFM V200R001B01 
--高端安全小特性开发项目		PR003635
--高端安全小特性开发项目B01		PB003655


select  *  from  RDMDS_V_PDT_TMP  a   where  a.Code='PT000227';

--w00739

select  *  from  specMS_SpecDataIDSet   a  where  a.srcPID='PR002836' 
and flag=1  and Status=1;

--UNIS SDN Controller V300R002
select  * from  specMS_SpecDataIDSet  a   where  srcName='UNIS SDN Controller V300R002'


select distinct  b.srcName,b.orderNo  from  specMS_SpecPermission  a
inner  join  specMS_SpecDataIDSet  b  on a.dataSetID=b.dataSetID
where  a.rCode=9  and  a.userName='00739'  and  b.IDLevel=3 and b.flag=1  and b.Status=1
order by  b.orderNo desc;

 WITH CTE(dataSetID) as
                        (select a.dataSetID from specMS_SpecPermission a,specMS_ROLE b
                        where a.userType = 1 and a.userName = '00739' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0 and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0  union select 2841  union select 3141  union select 3258  union select 3329  union select 3588  union select 3589  union select 3672  union select 3871  union select 3872  union select 3873  union 
                        select k.dataSetID from specMS_SpecModule p left join specMS_SpecDataIDSet k on
                        p.verTreeCode=k.srcID
                        where p.mmanagerID like '%00739%'
                        and '37'=(select RL_CODE from specMS_ROLE where RL_CODE = '37' and RL_ACTIVE = 0)
                        and (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION where RL_ID='37')>0
                        union
                        select dataSetID from specMS_SpecDataIDSet where PDT_Code in (
                        select srcID from specMS_SpecPermission a,specMS_ROLE b,specMS_SpecDataIDSet  s
                        where a.userType = 1 and a.userName = '00739' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0 and s.dataSetID=a.dataSetID and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0)
                        union
                        select dataSetID from specMS_SpecDataIDSet where ProductLine_Code in (
                        select srcID from specMS_SpecPermission a,specMS_ROLE b,specMS_SpecDataIDSet  s
                        where a.userType = 1 and a.userName = '00739' and
                        a.rCode = b.RL_CODE and b.RL_ACTIVE = 0  and s.dataSetID=a.dataSetID and 
                        (select COUNT(*) from specMS_ROLE_RESOURCE_RELATION c where c.RL_ID=b.RL_ID)>0)
                        union
                        select dataSetID from specMS_SpecDataIDSet where srcID in (
                        select list.verTreeCode from dbo.specMS_SpecListTab tab, specMS_SpecList list
                        where  tab.listID = list.listID and tab.manager like '%00739%'
                        )
                    )

					--select distinct  b.srcName,b.orderNo  from  specMS_SpecPermission  a
					--inner  join  specMS_SpecDataIDSet  b  on a.dataSetID=b.dataSetID
					--where  a.dataSetID  in (select  dataSetID from  CTE) 
					--and  b.IDLevel=3 and b.flag=1  and b.Status=1 and  a.userName='00739'  and  b.srcPID='PT000227'
					--where  a.rCode=9  and  a.userName='00739'  and  b.IDLevel=3 and b.flag=1  and b.Status=1
					--order by  b.orderNo desc;
					,  temp1 as
					(
                    select  
                        t1.SrcID PROCode,t1.SrcName PROName,t1.SrcPID PROParentCode,t1.orderNo PROorderNo,t1.show PROshow,t1.status PROStatus,
                        t2.SrcID PDTCode,t2.SrcName PDTName,t2.SrcPID PDTParentCode,t2.orderNo PDTorderNo,t2.show PDTshow,t2.status PDTStatus,
                        t3.SrcID PRCode,t3.SrcName PRName,t3.SrcPID PRParentCode,t3.orderNo PRorderNo,t3.show PRshow,t3.status PRStatus,t3.BlNumber PRBLNumber,t3.VerType PRVerType,t3.isSync PRIsSync,t3.isMerge  PRIsMerge,
                        t4.SrcID PBCode,t4.SrcName PBName,t4.SrcPID PBParentCode,t4.orderNo PBorderNo,t4.show PBshow,t4.status PBStatus,t4.BlNumber  PBBlNumber,t4.VerType  PBVerType,t4.isSync PBIsSync,t4.isMerge  PBIsMerge
                        from  specMS_SpecDataIDSet  t1
                        LEFT JOIN   specMS_SpecDataIDSet t2 ON t1.srcID = t2.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t3 ON t2.srcID = t3.srcPID 
                        LEFT JOIN   specMS_SpecDataIDSet t4 ON t3.srcID = t4.srcPID 
                        INNER JOIN CTE ON t3.dataSetID=CTE.dataSetID 
                        where t1.IDLevel=1     and  t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193')) and (t4.Status=1 OR t4.Status IS NULL) 
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
                        INNER JOIN CTE ON t4.dataSetID=CTE.dataSetID
                        where t1.IDLevel=1     and  t1.show=1 and t2.show=1 and t3.show=1  and (t3.Status=1 or t3.srcId in ('PR002193')) and (t4.Status=1 OR t4.Status IS NULL) 
                        --order by PROCode,PDTCode,PRCode,PBCode  
						)

						select   test.PRCode,test.PRName,test.PRorderNo,test.PRBLNumber,test.PRVerType,test.PRIsMerge,test.PRIsSync  from   temp1   test
						group by test.PRCode,test.PRName,test.PRorderNo,test.PRBLNumber,test.PRVerType,test.PRIsMerge,test.PRIsSync