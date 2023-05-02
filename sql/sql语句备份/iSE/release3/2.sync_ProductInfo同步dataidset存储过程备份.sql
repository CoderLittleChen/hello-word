USE [iSEDB]
GO

/****** Object:  StoredProcedure [dbo].[sycProductInfoToPerm]    Script Date: 2020/9/7 17:23:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sycProductInfoToPerm]
	
AS
BEGIN
	
  
with productLine as(
 select	Code srcID, '0' srcPID,Name srcName,'' PDT_Code, Code ProductLine_Code,
 1 IDLevel,ROW_NUMBER() over (order by Name) orderno,null Status
 from RDMDS_ProductLine_TMP where Code is not NULL AND Code <>''
),
pdt as (
	select PDTCode_Code srcID,ProductLineCode_Code srcPID,PDTCode_Name srcName,
	PDTCode_Code PDT_Code,ProductLineCode_Code ProductLine_Code,2 IDLevel,ROW_NUMBER() over (order by PDTCode_Name) orderno ,null Status
	from RDMDS_ProductInfo_TMP where PDTCode_Code is not NULL AND PDTCode_Code<>'' group by PDTCode_Code,
	ProductLineCode_Code,PDTCode_Name
),
release as (
	select pr.Release_Code srcID,pr.PDTCode_Code srcPID,
	LEFT(pr.Release_Name,50) srcName,pr.PDTCode_Code PDT_Code,
	pr.ProductLineCode_Code ProductLine_Code,
	3 IDLevel,ROW_NUMBER() over (order by pr.Release_Name) orderno,
	re.ProjectStatus Status
	from RDMDS_ProductInfo_TMP pr left join RDMDS_ReleaseInfo_TMP re
	on pr.Release_Code=re.ReleaseCode
	where pr.Release_Code is not null and ProjectStatus is not NULL group by Release_Code,
	PDTCode_Code,Release_Name,ProductLineCode_Code,ProjectStatus
)

insert into dbo.specMS_SpecDataIDSet(srcID,srcPID,srcName,PDT_Code,ProductLine_Code,IDLevel,orderNo,Status)
select A.* from (select * from productLine union all select * from pdt union all select * from release) A
where A.srcID not in (select srcID from specMS_SpecDataIDSet);

--with productLine as(
-- select	Code srcID, '0' srcPID,Name srcName,'' PDT_Code, Code ProductLine_Code,
-- 1 IDLevel,ROW_NUMBER() over (order by Name) orderno,null Status
-- from RDMDS_ProductLine_TMP where Code is not null
--),
--pdt as (
--	select PDTCode_Code srcID,ProductLineCode_Code srcPID,PDTCode_Name srcName,
--	PDTCode_Code PDT_Code,ProductLineCode_Code ProductLine_Code,2 IDLevel,ROW_NUMBER() over (order by PDTCode_Name) orderno ,null Status
--	from RDMDS_ProductInfo_TMP where PDTCode_Code is not null group by PDTCode_Code,
--	ProductLineCode_Code,PDTCode_Name
--),
--release as (
--	select pr.Release_Code srcID,pr.PDTCode_Code srcPID,
--	LEFT(pr.Release_Name,50) srcName,pr.PDTCode_Code PDT_Code,
--	pr.ProductLineCode_Code ProductLine_Code,
--	3 IDLevel,ROW_NUMBER() over (order by pr.Release_Name) orderno,
--	re.ProjectStatus Status
--	from RDMDS_ProductInfo_TMP pr left join RDMDS_ReleaseInfo_TMP re
--	on pr.Release_Code=re.ReleaseCode
--	where pr.Release_Code is not null and ProjectStatus is not null group by Release_Code,
--	PDTCode_Code,Release_Name,ProductLineCode_Code,ProjectStatus
--)

--update specMS_SpecDataIDSet SET show=-1
--WHERE srcID not in (select productLine.srcID from productLine union all select pdt.srcID from pdt union all select release.srcID from release)
--	AND srcID NOT LIKE('%PR99%');

with productLine as(
 select	Code srcID, '0' srcPID,Name srcName,'' PDT_Code, Code ProductLine_Code,
 1 IDLevel,ROW_NUMBER() over (order by Name) orderno,null Status
 from RDMDS_ProductLine_TMP where Code is not null
),
pdt as (
	select PDTCode_Code srcID,ProductLineCode_Code srcPID,PDTCode_Name srcName,
	PDTCode_Code PDT_Code,ProductLineCode_Code ProductLine_Code,2 IDLevel,ROW_NUMBER() over (order by PDTCode_Name) orderno ,null Status
	from RDMDS_ProductInfo_TMP where PDTCode_Code is not null group by PDTCode_Code,
	ProductLineCode_Code,PDTCode_Name
),
release as (
	select pr.Release_Code srcID,pr.PDTCode_Code srcPID,
	LEFT(pr.Release_Name,50) srcName,pr.PDTCode_Code PDT_Code,
	pr.ProductLineCode_Code ProductLine_Code,
	3 IDLevel,ROW_NUMBER() over (order by pr.Release_Name) orderno,
	re.ProjectStatus Status
	from RDMDS_ProductInfo_TMP pr left join RDMDS_ReleaseInfo_TMP re
	on pr.Release_Code=re.ReleaseCode
	where pr.Release_Code is not null and ProjectStatus is not null group by Release_Code,
	PDTCode_Code,Release_Name,ProductLineCode_Code,ProjectStatus
)

update specMS_SpecDataIDSet set srcName=A.srcName,srcPID=A.srcPID,Status=a.Status
from (select * from productLine union all select * from pdt union all select * from release) A
where specMS_SpecDataIDSet.srcID = A.srcID;

update dbo.specMS_SpecDataIDSet set PDT_Code = srcID,ProductLine_Code=srcPID 
where IDLevel=2;
                        
update specMS_SpecDataIDSet set PDT_Code = srcPID
,ProductLine_Code=(select top 1 idset.srcPID from specMS_SpecDataIDSet idset 
where idset.srcID = specMS_SpecDataIDSet.srcPID ) 
where IDLevel=3;

END

GO


