--���û������ڵİ汾��ģ�����л��ߴ������ã��޷����ã�
--��ͻ�İ汾���£�
--ƽ̨����B�汾--ģ��01
--ƽ̨����B�汾

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