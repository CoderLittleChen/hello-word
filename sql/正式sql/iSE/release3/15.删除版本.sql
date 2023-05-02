--PR990001	4172	C84F7A8B-1D50-41BC-B2BF-8A7C1FC9C8EA
--PR990002	4173	FB535F27-DC24-4793-A29D-42A8B3A46C8A
--PR990003	4180	F6A47BE1-DA58-432F-A816-D3FAB62D0869
--PR990004	4182	595ACF77-EFB3-4BD9-B169-55771E15EE85
select  srcId  from  specMS_SpecDataIDSet  a  
group  by  a.srcId  having(COUNT(srcID)>1);

select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR990001';
select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR990002';
select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR990003';
select  *  from   specMS_SpecDataIDSet  a  where  a.srcID='PR990004';



--delete  specMS_SpecPermission   where  dataSetID  in (4172,4173,4180,4182,4181,4185)

select  *  from   Sync_ProductInfo  a  where  a.Release_Code='PR990001';
select  *  from   Sync_ProductInfo  a  where  a.Release_Code='PR990002';
select  *  from   Sync_ProductInfo  a  where  a.Release_Code='PR990003';
select  *  from   Sync_ProductInfo  a  where  a.Release_Code='PR990004';

--PB990001

select  *  from   Sync_ProductInfo  a  where  a.Release_Code='PR003527';

--update  Sync_ProductInfo   set  BVersionCode='',BVersionName=''  where BVersionCode='PB990001';

--delete  Sync_ProductInfo  where ProductInfoID  in ('8023141D-BE84-4C45-B555-8771AF9FBE16')

--delete  specMS_SpecDataIDSet   where  dataSetID  in (4172,4173,4180,4182,4181,4185)


select  *  from   specMS_SpecDataIDSet   where IDLevel=4;

select  IsNull(Max(srcID),'PR990000')  from  specms_SpecDataIDSet  a where  (a.isSync=0  and a.srcId  like 'PR%') or a.srcId  like 'PR99%';