--引用基线所在的版本或模块已有基线存在引用，无法引用！
--冲突的版本如下：
--平台新增B版本--模块01
--平台新增B版本

select main.*,info.blID,info.smID,info.refBlid from specMS_TabRefBaseLine main 
inner join
(
		select a.blID,a.smID,b.blID as refBlid from specMS_SpecModuleBLRel a
		inner join 
			(
				select smID,blID from specMS_SpecModuleBLRel  where blID in
					(
						select blID from specMS_TabRefBaseLine where listblID=16947 and DataSrc != 2
					)
			) b on  a.smID=b.smID 
		 where a.smID not in
			                ( 
				                select smID from specMS_SpecModuleBLRel
					                where blID in (16939,16938) 
					                or  blID in 
					                (
						                select blID from specMS_TabRefBaseLine where listblID in (16939,16938) 
						                and status=2
					                )
			                )
) info on main.blid=info.blid where main.listblID = 17192;