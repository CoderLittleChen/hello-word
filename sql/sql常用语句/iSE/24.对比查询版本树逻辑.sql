declare @userId varchar(20);

                                set @userId = '{0}';
								set @userId='00428';
                                select * into #temp_specMS_ROLE_RESOURCE from (select role.RL_CODE, res.RES_CODE from dbo.specMS_ROLE role,
						                dbo.specMS_RESOURCE res,
						                dbo.specMS_ROLE_RESOURCE_RELATION rel
						                where role.rl_id = rel.rl_id and res.res_id=rel.res_id) t;
                                select * into #temp_specMS_SpecPermission from (select p.rCode, p.dataSetID from specMS_SpecPermission p,Sync_DomainGroupMember sync 
							                where p.username = sync.groupcode and p.userType=sync.PermissionType
							                and  right(sync.regionAccount,len(sync.regionAccount)-1) = @userId) t;
								create index IDX_temp_specMS_SpecPermission on #temp_specMS_SpecPermission (datasetID);
                                with cte as
                                (
                	                select distinct dataSet.* from specMS_SpecDataIDSet dataSet
                	                left join specMS_SpecPermission permission on dataSet.dataSetID = permission.dataSetID
                	                where exists(
                					               select 1 from #temp_specMS_ROLE_RESOURCE where RL_CODE in(
                							                ---个人
                							                select rCode from specMS_SpecPermission where datasetId = dataSet.dataSetID and userName = @userId
                							                union 
                							                ----群组
                							                select rCode from #temp_specMS_SpecPermission permission where dataSet.dataSetID = permission.dataSetID
                							                ----应用管理员
                							                union 
                							                select rCode from specMS_SpecPermission where userName = @userId and rcode='1001'
                							                --在产品线 、PDT上配置  公共角色 6个
                							                union 
                							                select rcode from specMS_SpecPermission where dataSetID =(select dataSetID from specMS_SpecDataIDSet a where a.srcID = dataSet.ProductLine_Code) and userName =@userId
                							                union 
                							                select rcode from specMS_SpecPermission where dataSetID =(select dataSetID from specMS_SpecDataIDSet a where a.srcID = dataSet.PDT_Code) and userName =@userId
                							                ----页面管理员
                							                union
                							                select 40  from dbo.specMS_SpecListTab tab,dbo.specMS_SpecList list
                								                left join specMS_SpecDataIDSet ds on list.verTreeCode = ds.srcID
                							                where
                							                tab.listID=list.listID and 
                							                tab.manager like '%'+@userId+'%'  and ds.dataSetID =dataSet.dataSetID
                							                union
                							                ---模块管理员
                							                select 37 from dbo.specMS_SpecModule module
                								                left join specMS_SpecDataIDSet ds on module.verTreeCode = ds.srcID
                							                 where smsort=3 and type=0 and mmanagerid like '%'+@userId+'%'
                							                 and ds.dataSetID =dataSet.dataSetID
                						                )
                						                and 
                                                            ---res.res_code in('202001','205001')
                                                        (
                												(res_code in('202001','205001') and dataSet.verType =2) or (res_code in('202001') and dataSet.verType =1)
                									    )
                                        
                	                )
                	                and show = 1
                	                and BLNumber >0
                	                union all
                	                select s.* from specMS_SpecDataIDSet s inner join cte ON s.srcId = cte.srcPID  --WHERE S.show =1 
                                )
                                select DISTINCT * from cte ORDER BY srcName;  
                                drop table #temp_specMS_ROLE_RESOURCE;
				                drop table #temp_specMS_SpecPermission;