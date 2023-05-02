with  cte as 
(
	select  temp.Name from 
		(
		select  m.Name,ROW_NUMBER() over(partition by m.Name  order by m.ProdColID) as rankNum from   specMS_ProColContent  l  
		left join specMS_ProductColumn m on m.ProdColID=l.ProdColID 
		where l.blEntryID in (6849233,6849236)  
		)  temp where  temp.rankNum>1
)
--select  *  from cte;

select a.EntryId,a.BlEntryId,a.BlId,a.CurrBlId,d.EntryParam,d.standard as EntryStandard,ISNULL(c.ColName,'È±Ê¡ÁÐ') ColName,b.Param,b.Standard
	, isnull(d.EntryCName,'') as EntryCName,'VerTreeCode' = case
		when Exists (select 1 from  dbo.specMS_TemplateSpecBLRel tempRel where tempRel.blID =a.currBlid) then 
		(select top 1 tempName from specMS_TemplateSpecBLRel temprel,specMS_TemplateSpec temp
							where temp.tempID = temprel.tempID and  temprel.blID = a.blID)
		when  (Exists(select  1 from specMS_SpecList where blID = a.currBlid )) then 
		(
			select top 1 specIDset.srcName from specMS_SpecList specList ,specMS_SpecDataIDSet specIDset   
								where specList.blID =a.currBlid and speclist.verTreeCode = specIDset.srcID)
		else (
				select top 1 specIDset.srcName from dbo.specMS_SpecModuleBLRel moduleRel,specMS_SpecModule model,specMS_SpecDataIDSet specIDset
				where moduleRel.smID = model.smID and moduleRel.blID = a.currBlid and specIDset.srcID = model.verTreeCode)
			end
	,case when a.currBlid=15596 then 'v2.0' when a.currBlid= 15622 then 'v2.0.Draft' else '' end as BaseLineTitle
    ,d.remark as EntryRemark,d.funcDesc as EntryFunDesc
        ,b.supCase as ExtSupCase,b.implCase as ExtImplCase,b.mergVer as ExtMergVer,case when f.isRef =0 then (select top 1 pageName from specMS_TemplateSpec where tempName = f.tabTitile) else f.tabTitile  end as TabTitile
    ,g.dictValueCh ExtSupCaseCh,ISNULL(g.dictValueEn,'')    ExtSupCaseEn
    ,h.dictValueCh ExtImplCaseCh,ISNULL(h.dictValueEn,'')  ExtImplCaseEn
    , d.isShare,d.isPerform, a.lvl,a.tabId,c.extColID,j.entryItemID
    ,isnull(d.entryEName,'') as EntryEName,b.virtualSpec
    ,(select ConsCNName from  specMS_AppConstantValue  where AppConstantValueID=k.Importance) as Importance
	,(select ConsCNName from  specMS_AppConstantValue  where AppConstantValueID=k.Entrysource) as Entrysource
	,(select ConsCNName from  specMS_AppConstantValue  where AppConstantValueID=k.Verificationmode) as Verificationmode
    ,m.Name  as ProColName,l.ProCategoryValue,n.ConsCNName,m.ProdColID
from (select * from BlIdAndTabIdAndblEntryId a where a.blEntryID in (6849233,6849236) and a.currBlid in (15596,15622)) a left join specMS_SpecListExtColData b on a.currBlid = b.blID and a.blEntryID = b.blEntryID and b.status>-2
left join specMS_SpecListExtCol c on b.tecID = c.extColID
left join specMS_SpecEntryContent d on d.entryID = a.entryID 
left join specMS_SpecBaseLine e on a.currBlid = e.blID 
left join specMS_SpecListTab f on a.tabId =f.tabID 
left join (select *  from     dbo.specMS_Dict  where dictParentId =101000 ) g on g.dictKey = b.supCase
left join ( select * from specMS_Dict where dictParentId = 102000) h on h.dictKey = b.implCase
left join specMS_SpecBLEntryRel i on a.blEntryID = i.blEntryID
left join specMS_SpecEntry j on j.entryID = i.entryID
left join specMS_EntryContentExt k  on  a.entryID=k.EntryID
left join specMS_ProColContent  l  on  i.blEntryID=l.blEntryID
left join specMS_ProductColumn m on m.ProdColID=l.ProdColID
left join specMS_AppConstantValue n on l.ProCategory=n.AppConstantValueID
    where  
	--m.Name  in   (select * from  cte)  
	--and
	 ( 
		 ( 
			ISNULL((select TOP 1 tempRel.blID from  dbo.specMS_TemplateSpecBLRel tempRel where tempRel.blID =a.blId),2)=A.blID
			OR 
			ISNULL((select top 1 1 from specMS_SpecList where blID = a.currBlid and listType=1),2)=2  
			or c.extColID in (0) and b.status >-2
		  ) 
		or 
			( 
				ISNULL((select TOP 1 tempRel.blID from  dbo.specMS_TemplateSpecBLRel tempRel where tempRel.blID =a.blId),2)=A.blID
				OR 
				ISNULL((select top 1 1 from specMS_SpecList where blID = a.currBlid and listType=1),2)=2  
				or c.extColID in (0) AND B.status >-2
			) 
	)