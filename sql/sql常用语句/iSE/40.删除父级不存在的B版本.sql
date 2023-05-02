select  a.dataSetID  from  specMS_SpecDataIDSet a  where  a.srcPID not in (select  srcID from  specMS_SpecDataIDSet)
and  a.IDLevel>2;


--delete  specMS_SpecPermission  where dataSetID  in(select  a.dataSetID  from  specMS_SpecDataIDSet a  where  a.srcPID not in (select  srcID from  specMS_SpecDataIDSet)
--and  a.IDLevel>2)

--delete  specMS_SpecDataIDSet where  srcPID not in (select  srcID from  specMS_SpecDataIDSet)
--and  IDLevel>2;

select  * from specMS_SpecDataIDSet  where srcID in
(
	select  a.srcID  from  specMS_SpecDataIDSet    a
group  by  a.srcID  having(COUNT(a.srcID)>1)
)

--delete  specMS_SpecDataIDSet  where srcID='PR99990032' or srcPID='PR99990032';
--delete  specMS_SpecDataIDSet  where srcID='PR99990031' or srcPID='PR99990031';


